import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/current_location_cubit.dart';
import 'package:street_calle/services/base_service.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/location_utils.dart';
import 'package:street_calle/models/user.dart';


class ItemService extends BaseService<Item> {

  ItemService() {
    ref = sl.get<FirebaseFirestore>().collection(Collections.items).withConverter<Item>(
      fromFirestore: (snapshot, options) =>
          Item.fromJson(snapshot.data()!, snapshot.id),
      toFirestore: (value, options) => value.toJson(),
    );
  }

  Future<Either<String, Item?>> addItem(Item item, String image) async {
    try {
      final url = await _uploadImageToFirebase(image, item.uid ?? '');
      if (url == null) {
        return Left(TempLanguage().lblSomethingWentWrong);
      }

      item = item.copyWith(image: url);
      final result = await ref!.add(item);
      await ref!.doc(result.id).update({ItemKey.id: result.id});
      item = item.copyWith(id: result.id);

      return Right(item);
    } catch (e) {
      log(e.toString());
      return Left(TempLanguage().lblSomethingWentWrong);
    }
  }

  Future<Either<String, Item?>> updateItem(Item item, {required bool isUpdated, required String image}) async {
    try {

      if (isUpdated) {
        final url = await _uploadImageToFirebase(image, item.uid ?? '');
        if (url == null) {
          return Left(TempLanguage().lblSomethingWentWrong);
        }
        item = item.copyWith(image: url);
        await ref!.doc(item.id).update(item.toJson());
        return Right(item);
      }

      item = item.copyWith(image: image);
      await ref!.doc(item.id).update(item.toJson());
      return Right(item);
    } catch (e) {
      log(e.toString());
      return Left(TempLanguage().lblSomethingWentWrong);
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

  Stream<List<Item>> getItems(String userId) {
    return ref!.where(ItemKey.uid, isEqualTo: userId)
        .orderBy(ItemKey.updatedAt, descending: true)
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
        .where(ItemKey.uid, isEqualTo: userId)
        .orderBy(ItemKey.updatedAt, descending: true)
        .get();

    return querySnapshot.docs.map((e) => e.data()).toList();
  }

  Stream<List<Item>> getEmployeeItems(List<dynamic>? employeeItemList) {
    return ref!.where(FieldPath.documentId, whereIn: employeeItemList)
        .snapshots()
        .map((value) => value.docs.map((e) => e.data()).toList());
  }

  Stream<List<Item>> getVendorItems(String vendorId) {
    return ref!.where(ItemKey.uid, isEqualTo: vendorId)
        .snapshots()
        .map((value) => value.docs.map((e) => e.data()).toList());
  }

  Stream<List<Item>> getAllItems() {
    return ref!
        .orderBy(ItemKey.updatedAt, descending: true)
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

}