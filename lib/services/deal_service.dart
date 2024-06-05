import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/current_location_cubit.dart';
import 'package:street_calle/services/base_service.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/models/deal.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/utils/location_utils.dart';
import 'package:street_calle/generated/locale_keys.g.dart';
import 'package:http/http.dart' as http;
import 'package:street_calle/main.dart';


class DealService extends BaseService<Deal> {

  DealService() {
    ref = sl.get<FirebaseFirestore>().collection(Collections.DEALS).withConverter<Deal>(
      fromFirestore: (snapshot, options) =>
          Deal.fromJson(snapshot.data()!, snapshot.id),
      toFirestore: (value, options) => value.toJson(),
    );
  }

  Future<Either<String, Deal?>> addDeal(Deal deal, String image) async {
    try {
      final url = await _uploadImageToFirebase(image, deal.uid ?? '');
      if (url == null) {
        return Left(LocaleKeys.somethingWentWrong.tr());
      }

      deal = deal.copyWith(image: url);
      final result = await ref!.add(deal);
      await ref!.doc(result.id).update({DealKey.ID: result.id});
      deal = deal.copyWith(id: result.id);

      final isolate = await Isolate.spawn(generateSearchParams, [deal.id ?? '', 'deals']);

      return Right(deal);
    } catch (e) {
      log(e.toString());
      return Left(LocaleKeys.somethingWentWrong.tr());
    }
  }

  Future<Either<String, Deal?>> updateDeal(Deal deal, {required bool isUpdated, required String image}) async {
    try {

      if (isUpdated) {
        final url = await _uploadImageToFirebase(image, deal.uid ?? '');
        if (url == null) {
          return Left(LocaleKeys.somethingWentWrong.tr());
        }
        deal = deal.copyWith(image: url);
        await ref!.doc(deal.id).update(deal.toJson());
        return Right(deal);
      }

      deal = deal.copyWith(image: image);
      await ref!.doc(deal.id).update(deal.toJson());

      await Future.delayed(const Duration(seconds: 2));
      final isolate = await Isolate.spawn(generateSearchParams, [deal.id ?? '', 'deals']);

      final updatedDeal = await getDealUsingId(deal.id ?? '');
      return Right(updatedDeal);
    } catch (e) {
      log(e.toString());
      return Left(LocaleKeys.somethingWentWrong.tr());
    }
  }

  Future<String?> _uploadImageToFirebase(String image, String userId) async {
    try {
      final storageReference = sl.get<FirebaseStorage>()
          .ref()
          .child('images/$userId/${Timestamp.now().millisecondsSinceEpoch}.jpg');

      await storageReference.putFile(File(image));
      final downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Stream<List<Deal>> getDeals(String userId) {
    return ref!.where(DealKey.UID, isEqualTo: userId)
        .orderBy(DealKey.UPDATED_AT, descending: true)
        .snapshots()
        .map((value) => value.docs.map((e) => e.data()).toList());
  }

  Future<bool> deleteDeal(Deal deal) async {
    try{
      if (deal.image != null) {
        await sl.get<FirebaseStorage>().refFromURL(deal.image!).delete();
      }
      ref!.doc(deal.id).delete();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Stream<List<Deal>> getAllDeals() {
    return ref!
        .orderBy(DealKey.UPDATED_AT, descending: true)
        .snapshots()
        .map((value) => value.docs.map((e) => e.data()).toList());
  }

  Future<Deal?> getDealUsingId(String docId) async {
    final result = await ref!.doc(docId).get();
    return result.data();
  }


  Stream<List<Deal>> getEmployeeDeals(List<dynamic>? employeeItemList) {
    return ref!.where(FieldPath.documentId, whereIn: employeeItemList)
        .snapshots()
        .map((value) => value.docs.map((e) => e.data()).toList());
  }

  Stream<List<Deal>> getEmployeeDealsStream(String userId) async* {
    try {
      final userDoc = await UserService().userByUid(userId);
      yield* getEmployeeDeals(userDoc.employeeDealsList);
    }catch(e){
      log(e.toString());
    }
  }

  Future<List<Deal>?> getEmployeeDealsFuture(String userId) async {
    try {
      final userDoc = await UserService().userByUid(userId);
      return getEmployeeDealList(userDoc.employeeDealsList);
    }catch(e){
      log(e.toString());
      return null;
    }
  }

  Future<List<Deal>> getEmployeeDealList(List<dynamic>? employeeItemList) async {
    final result = await ref!.where(FieldPath.documentId, whereIn: employeeItemList).get();
    return result.docs.map((e) => e.data()).toList();
  }

  Future<List<Deal>> getDealsUsingId(String userId) async {
    final querySnapshot = await ref!
        .where(DealKey.UID, isEqualTo: userId)
        .orderBy(DealKey.UPDATED_AT, descending: true)
        .get();

    return querySnapshot.docs.map((e) => e.data()).toList();
  }

  Future<Map<Deal, User>> getNearestDealsWithUsers(CurrentLocationCubit cubit) async {
    Position? position;
    if (cubit.state.updatedLatitude == null) {
      position = await LocationUtils.fetchLocation();
    } else {
      position = Position(
          longitude: cubit.state.updatedLongitude!,
          latitude: cubit.state.updatedLatitude!,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0, altitudeAccuracy: 100,headingAccuracy: 100);
    }
    final users = await sl.get<UserService>().getVendorsAndEmployees();
    final dealsWithUsers = <Deal, User>{};
    final addedDealIds = <String>{};

    users.sort((a, b) =>
        LocationUtils.distanceInMiles(position?.latitude ?? 0.0, position?.longitude ?? 0.0, a.latitude!, a.longitude!)
            .compareTo(LocationUtils.distanceInMiles(position?.latitude ?? 0.0, position?.longitude ?? 0.0, b.latitude!, b.longitude!)));

    for (User user in users) {
      if (user.latitude != null && user.longitude != null) {
        final distance = LocationUtils.distanceInMiles(position.latitude, position.longitude, user.latitude!, user.longitude!);
        if (distance <= 10) {
          user = user.copyWith(clientVendorDistance: distance.toStringAsFixed(2));
          if (user.isVendor) {
            final vendorDeals = await getDealsUsingId(user.uid ?? '');
            for (Deal deal in vendorDeals) {
              if (!addedDealIds.contains(deal.id)) {
                dealsWithUsers[deal] = user;
                addedDealIds.add(deal.id!);
              }
            }
          } else {
            if (user.employeeDealsList != null) {
              final itemIds = Set<String>.from(user.employeeDealsList ?? []);
              final employeeDeals = await getEmployeeDealList(itemIds.toList());
              for (Deal deal in employeeDeals) {
                if (!addedDealIds.contains(deal.id)) {
                  dealsWithUsers[deal] = user;
                  addedDealIds.add(deal.id!);
                }
              }
            }
          }
        }
      }
    }
    return dealsWithUsers;
  }

  Future<void> generateSearchParams(List<String> list) async {
    final url = Uri.parse('https://us-central1-street-calle-72cff.cloudfunctions.net/generateSearchParams');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {
              'docId': list[0],
              'collectionName': list[1],
              'type': LANGUAGE == 'en' ? 'es' : 'en',
            }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
      } else {
      }
    } catch (e) {
    }
  }


}