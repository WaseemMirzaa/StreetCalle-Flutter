import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:street_calle/services/base_service.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';

/// This service use for all (Users, Vendors, Employees)
class UserService extends BaseService<User> {
  UserService() {
    ref = sl.get<FirebaseFirestore>().collection(Collections.users).withConverter<User>(
      fromFirestore: (snapshot, options) =>
          User.fromJson(snapshot.data()!, snapshot.id),
      toFirestore: (value, options) => value.toJson(),
    );
  }

  Future<bool> saveUserData(User user, String image) async {
    try {
      String? url = await _uploadImageToFirebase(image, user.uid ?? '');
      if (url == null) {
        return false;
      }
      user = user.copyWith(image: url);
      await ref!.doc(user.uid).set(user);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<String?> _uploadImageToFirebase(String image, String userId) async {
    try {
      final storageReference = sl.get<FirebaseStorage>()
          .ref()
          .child('images/$userId.jpg');

      await storageReference.putFile(File(image));
      final downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<User> userByUid(String? uid) async {
    return ref!.limit(1).where(UserKey.uid, isEqualTo: uid).get().then((value) {
      if (value.docs.isNotEmpty) return value.docs.first.data();
      throw TempLanguage().lblUserNotFound;
    }).catchError((e) {
      log(e.toString());
      throw TempLanguage().lblUserNotFound;
    });
  }

  Future<void> setUserStatus(bool isOnline, String userId) async {
    try {
      await ref!.doc(userId).update({
        UserKey.isOnline: isOnline
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateUserLocation(double latitude, double longitude, String userId) async {
    try {
      await ref!.doc(userId).update({
        UserKey.latitude: latitude,
        UserKey.longitude: longitude
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Either<String, User>> updateProfile(String userId, {required bool isUpdated, required String image, required String name, required String phone, required String countryCode, required String about}) async{
    try {
      if (isUpdated) {
        final url = await _uploadImageToFirebase(image, userId ?? '');
        if (url == null) {
          return Left(TempLanguage().lblSomethingWentWrong);
        }
        User user = User(image: url, name: name, phone: phone, countryCode: countryCode, about: about);
        await ref!.doc(userId).update({
          UserKey.image: url,
          UserKey.name: name,
          UserKey.phone: phone,
          UserKey.countryCode: countryCode,
          UserKey.about: about
        });
        return Right(user);
      }

      User user = User(image: image, name: name, phone: phone, countryCode: countryCode, about: about);
      await ref!.doc(userId).update({
        UserKey.image: image,
        UserKey.name: name,
        UserKey.phone: phone,
        UserKey.countryCode: countryCode,
        UserKey.about: about
      });
      return Right(user);

    } catch (e) {
      log(e.toString());
      return Left(TempLanguage().lblSomethingWentWrong);
    }
  }

  // Stream<List<User>> getVendors() {
  //   return ref!
  //       .where(UserKey.isVendor, isEqualTo: true)
  //       .where(UserKey.isOnline, isEqualTo: true)
  //       .orderBy(UserKey.updatedAt, descending: true)
  //       .snapshots()
  //       .map((value) => value.docs.map((e) => e.data()).toList());
  // }

  Future<List<User>> getVendors() async {
    final querySnapshot = await ref!
        .where(UserKey.isVendor, isEqualTo: true)
        .where(UserKey.isOnline, isEqualTo: true)
        .orderBy(UserKey.updatedAt, descending: true)
        .get();

    List<User> userList = [];
    userList = querySnapshot.docs.map((user) => user.data()).toList();

    return userList;
  }

  Future<List<User>> getVendorsAndEmployees() async {
    final vendorQuerySnapshot = await ref!
        .where(UserKey.isVendor, isEqualTo: true)
        .where(UserKey.isEmployee, isEqualTo: false)
        .where(UserKey.isOnline, isEqualTo: true)
        .where(UserKey.isSubscribed, isEqualTo: true)
        .orderBy(UserKey.updatedAt, descending: true)
        .get();

    final employeeQuerySnapshot = await ref!
        .where(UserKey.isVendor, isEqualTo: false)
        .where(UserKey.isEmployee, isEqualTo: true)
        .where(UserKey.isEmployeeBlocked, isEqualTo: false)
        .where(UserKey.isOnline, isEqualTo: true)
        .orderBy(UserKey.updatedAt, descending: true)
        .get();

    List<User> userList = [];
    userList.addAll(vendorQuerySnapshot.docs.where((element) => element.data().latitude != null && element.data().longitude != null).map((user) => user.data()));
    userList.addAll(employeeQuerySnapshot.docs.where((element) => element.data().latitude != null && element.data().longitude != null).map((user) => user.data()));

    return userList;
  }

  Stream<List<User>> getEmployees(String userId) {
    return ref!.where(UserKey.vendorId, isEqualTo: userId)
        .orderBy(UserKey.updatedAt, descending: true)
        .snapshots()
        .map((value) => value.docs.map((e) => e.data()).toList());
  }

  Future<List<User>> getOnlineEmployees(String userId) async {
    try {
      final result = await ref!
          .where(UserKey.vendorId, isEqualTo: userId)
          .where(UserKey.isEmployee, isEqualTo: true)
          .where(UserKey.isEmployeeBlocked, isEqualTo: false)
          .orderBy(UserKey.updatedAt, descending: true)
          .get();

      List<User> users = result.docs.map((e) => e.data()).toList();
      return users;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<bool> updateFavourites(String vendorId, String userId, bool addToFav) async {
    try {
      await ref!.doc(userId).update({
        UserKey.favouriteVendors: addToFav ? FieldValue.arrayUnion([vendorId]) : FieldValue.arrayRemove([vendorId])
      });
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> isVendorInFavorites(String userId, String vendorId) async {
    try {
      final userDoc = await ref!.doc(userId).get();
      if (userDoc.exists) {
        final user = userDoc.data();
        final favouriteVendors = user?.favouriteVendors ?? [];

        if (favouriteVendors.isNotEmpty && favouriteVendors.contains(vendorId)) {
          return true;
        }
      }
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<List<User>> getFavouriteVendors(String userId) async {
    try {
      final userDoc = await ref!.doc(userId).get();
      if (userDoc.exists) {
        final user = userDoc.data();
        final favouriteVendorIds = user?.favouriteVendors ?? [];
        final favoriteUsers = await getVendorsForIds(favouriteVendorIds.reversed.toList());
        return favoriteUsers;
      }
      return [];
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<User>> getVendorsForIds(List<dynamic> vendorIds) async {
    try {
      final List<User> favoriteUsers = [];

      for (String vendorId in vendorIds) {
        final vendorDoc = await ref!.doc(vendorId).get();
        if (vendorDoc.exists) {
          final userData = vendorDoc.data();
          if (userData != null) {
            favoriteUsers.add(userData);
          }
        }
      }

      return favoriteUsers;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<void> updateUserMenuItems(String userId, List<dynamic> selectedItemIds)async{
    try{
      await ref!.doc(userId).update({
        UserKey.employeeItemList: selectedItemIds,
      });
    }catch(e){
      log(e.toString());
    }
}

  Future<void> setUserType(String userId, String userType) async {
    try{
      await ref!.doc(userId).update({
        UserKey.userType: userType,
        UserKey.isVendor: false,
        UserKey.isEmployee: false
      });
    }catch(e){
      log(e.toString());
    }
  }

  Future<void> setVendorType(String userId, String vendorType, String userType) async {
    try{
      await ref!.doc(userId).update({
        UserKey.vendorType: vendorType,
        UserKey.userType: userType,
        UserKey.isVendor: true,
        UserKey.isEmployee: false
      });
    }catch(e){
      log(e.toString());
    }
  }

  Stream<DocumentSnapshot<User>> getUser(String userId) {
    return ref!.doc(userId).snapshots();
  }

  Future<bool> updateUserSubscription(bool isSubscribed, String subscriptionType, String userId) async {
     try {
       await ref!.doc(userId).update({
         UserKey.isSubscribed: isSubscribed,
         UserKey.subscriptionType: subscriptionType,
       });
       return true;
     } catch (e) {
       log(e.toString());
       return false;
     }
  }

  Future<void> updateUserMenuDeals(String userId, List<dynamic> selectedItemIds)async{
    try{
      await ref!.doc(userId).update({
        UserKey.employeeDealList: selectedItemIds,
      });
    }catch(e){
      print('Error: ${e.toString()}');
    }
  }

  Future<bool> updateEmployeeBlockStatus(String id, bool isBlocked) async {
    try {
      await ref!.doc(id).update({UserKey.isEmployeeBlocked: isBlocked});
      return true;
    } catch(e) {
      return false;
    }
  }
}