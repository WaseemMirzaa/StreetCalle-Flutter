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
import 'package:street_calle/models/item.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/utils/location_utils.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/generated/locale_keys.g.dart';
import 'package:http/http.dart' as http;
import 'package:street_calle/main.dart';


class ItemService extends BaseService<Item> {

  ItemService() {
    ref = sl.get<FirebaseFirestore>().collection(Collections.ITEMS).withConverter<Item>(
      fromFirestore: (snapshot, options) =>
          Item.fromJson(snapshot.data()!, snapshot.id),
      toFirestore: (value, options) => value.toJson(),
    );
  }

  Future<Either<String, Item?>> addItem(Item item, String image) async {
    try {
      final url = await _uploadImageToFirebase(image, item.uid ?? '');
      if (url == null) {
        return Left(LocaleKeys.somethingWentWrong.tr());
      }

      item = item.copyWith(image: url);
      final result = await ref!.add(item);
      await ref!.doc(result.id).update({ItemKey.ID: result.id});
      item = item.copyWith(id: result.id);

      final isolate = await Isolate.spawn(generateSearchParams, [item.id ?? '', 'items']);

      return Right(item);
    } catch (e) {
      log(e.toString());
      return Left(LocaleKeys.somethingWentWrong.tr());
    }
  }

  Future<Either<String, Item?>> updateItem(Item item, {required bool isUpdated, required String image}) async {
    try {

      if (isUpdated) {
        final url = await _uploadImageToFirebase(image, item.uid ?? '');
        if (url == null) {
          return Left(LocaleKeys.somethingWentWrong.tr());
        }
        item = item.copyWith(image: url);
        await ref!.doc(item.id).update(item.toJson());
        return Right(item);
      }

      item = item.copyWith(image: image);
      await ref!.doc(item.id).update(item.toJson());
      await Future.delayed(const Duration(seconds: 2));
     // await generateSearchParams(item.id ?? '', 'items');

      final isolate = await Isolate.spawn(generateSearchParams, [item.id ?? '', 'items']);

      final updatedItem = await getItemUsingId(item.id ?? '');
      return Right(updatedItem);
    } catch (e) {
      log(e.toString());
      return Left(LocaleKeys.somethingWentWrong.tr());
    }
  }

  Future<Item?> getItemUsingId(String docId) async {
    final result = await ref!.doc(docId).get();
    return result.data();
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

  Stream<List<Item>> getItems(String userId) {
    return ref!.where(ItemKey.UID, isEqualTo: userId)
        .orderBy(ItemKey.UPDATED_AT, descending: true)
        .snapshots()
        .map((value) => value.docs.map((e) => e.data()).toList());
  }

  Future<bool> deleteItem(Item item) async {
    try{
      if (item.image != null) {
        await sl.get<FirebaseStorage>().refFromURL(item.image!).delete();
      }
      ref!.doc(item.id).delete();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<List<Item>> getMenuItems(String userId) async {
    final querySnapshot = await ref!
        .where(ItemKey.UID, isEqualTo: userId)
        .orderBy(ItemKey.UPDATED_AT, descending: true)
        .get();

    return querySnapshot.docs.map((e) => e.data()).toList();
  }

  Stream<List<Item>> getEmployeeItems(List<dynamic>? employeeItemList) {
    return ref!.where(FieldPath.documentId, whereIn: employeeItemList)
        .snapshots()
        .map((value) => value.docs.map((e) => e.data()).toList());
  }

  Stream<List<Item>> getVendorItems(String vendorId) {
    return ref!.where(ItemKey.UID, isEqualTo: vendorId)
        .snapshots()
        .map((value) => value.docs.map((e) => e.data()).toList());
  }

  Stream<List<Item>> getAllItems() {
    return ref!
        .orderBy(ItemKey.UPDATED_AT, descending: true)
        .snapshots()
        .map((value) => value.docs.map((e) => e.data()).toList());
  }

  Stream<List<Item>> getEmployeeItemsStream(String userId) async* {
    try {
      final userDoc = await UserService().userByUid(userId);
      yield* getEmployeeItems(userDoc.employeeItemsList);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Item>> getEmployeeItemList(List<dynamic>? employeeItemList) async {
     final result = await ref!.where(FieldPath.documentId, whereIn: employeeItemList).get();
     return result.docs.map((e) => e.data()).toList();
  }

  Future<Map<Item, User>> getNearestItemsWithUsers(CurrentLocationCubit cubit) async {
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
    final itemsWithUsers = <Item, User>{};
    final addedItemIds = <String>{};

    users.sort((a, b) =>
        LocationUtils.distanceInMiles(position?.latitude ?? 0.0, position?.longitude ?? 0.0, a.latitude!, a.longitude!)
            .compareTo(LocationUtils.distanceInMiles(position?.latitude ?? 0.0, position?.longitude ?? 0.0, b.latitude!, b.longitude!)));

    for (User user in users) {
      if (user.latitude != null && user.longitude != null) {
        final distance = LocationUtils.distanceInMiles(position.latitude, position.longitude, user.latitude!, user.longitude!);
        if (distance <= 10) {
          user = user.copyWith(clientVendorDistance: distance.toStringAsFixed(2));
          if (user.isVendor) {
            final vendorItems = await getMenuItems(user.uid ?? '');
            for (Item item in vendorItems) {
              if (!addedItemIds.contains(item.id!)) {
                itemsWithUsers[item] = user;
                addedItemIds.add(item.id!);
              }
            }
          } else {
            if (user.employeeItemsList != null) {
              final itemIds = user.employeeItemsList ?? [];
              final employeeItems = await getEmployeeItemList(itemIds);
              for (Item item in employeeItems) {
                if (!addedItemIds.contains(item.id)) {
                  itemsWithUsers[item] = user;
                  addedItemIds.add(item.id!);
                }
              }
            }
          }
        }
      }
    }
    return itemsWithUsers;
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