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
    ref = sl.get<FirebaseFirestore>().collection(Collections.USERS).withConverter<User>(
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
    return ref!.limit(1).where(UserKey.UID, isEqualTo: uid).get().then((value) {
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
        UserKey.IS_ONLINE: isOnline
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateUserLocation(double latitude, double longitude, String userId) async {
    try {
      await ref!.doc(userId).update({
        UserKey.LATITUDE: latitude,
        UserKey.LONGITUDE: longitude
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
          UserKey.IMAGE: url,
          UserKey.NAME: name,
          UserKey.PHONE: phone,
          UserKey.COUNTRY_CODE: countryCode,
          UserKey.ABOUT: about
        });
        return Right(user);
      }

      User user = User(image: image, name: name, phone: phone, countryCode: countryCode, about: about);
      await ref!.doc(userId).update({
        UserKey.IMAGE: image,
        UserKey.NAME: name,
        UserKey.PHONE: phone,
        UserKey.COUNTRY_CODE: countryCode,
        UserKey.ABOUT: about
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
        .where(UserKey.IS_VENDOR, isEqualTo: true)
        .where(UserKey.IS_ONLINE, isEqualTo: true)
        .orderBy(UserKey.UPDATED_AT, descending: true)
        .get();

    List<User> userList = [];
    userList = querySnapshot.docs.map((user) => user.data()).toList();

    return userList;
  }

  Future<List<User>> getVendorsAndEmployees() async {
    final vendorQuerySnapshot = await ref!
        .where(UserKey.IS_VENDOR, isEqualTo: true)
        .where(UserKey.IS_EMPLOYEE, isEqualTo: false)
        .where(UserKey.IS_ONLINE, isEqualTo: true)
        .where(UserKey.IS_SUBSCRIBED, isEqualTo: true)
        .orderBy(UserKey.UPDATED_AT, descending: true)
        .get();

    final employeeQuerySnapshot = await ref!
        .where(UserKey.IS_VENDOR, isEqualTo: false)
        .where(UserKey.IS_EMPLOYEE, isEqualTo: true)
        .where(UserKey.IS_EMPLOYEE_BLOCKED, isEqualTo: false)
        .where(UserKey.IS_ONLINE, isEqualTo: true)
        .orderBy(UserKey.UPDATED_AT, descending: true)
        .get();

    List<User> userList = [];
    userList.addAll(vendorQuerySnapshot.docs.where((element) => element.data().latitude != null && element.data().longitude != null).map((user) => user.data()));
    userList.addAll(employeeQuerySnapshot.docs.where((element) => element.data().latitude != null && element.data().longitude != null).map((user) => user.data()));

    return userList;
  }

  Stream<List<User>> getEmployees(String userId) {
    return ref!.where(UserKey.VENDOR_ID, isEqualTo: userId)
        .orderBy(UserKey.UPDATED_AT, descending: true)
        .snapshots()
        .map((value) => value.docs.map((e) => e.data()).toList());
  }

  Future<int> getEmployeeCount(String userId) async {
    try {
      QuerySnapshot<User> querySnapshot = await ref!
          .where(UserKey.VENDOR_ID, isEqualTo: userId)
          .get();

      return querySnapshot.size;
    } catch (e) {
      return 0;
    }
  }

  Future<List<User>> getOnlineEmployees(String userId) async {
    try {
      final result = await ref!
          .where(UserKey.VENDOR_ID, isEqualTo: userId)
          .where(UserKey.IS_EMPLOYEE, isEqualTo: true)
          .where(UserKey.IS_EMPLOYEE_BLOCKED, isEqualTo: false)
          .orderBy(UserKey.UPDATED_AT, descending: true)
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
        UserKey.FAVOURITE_VENDORS: addToFav ? FieldValue.arrayUnion([vendorId]) : FieldValue.arrayRemove([vendorId])
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
        UserKey.EMPLOYEE_ITEM_LIST: selectedItemIds,
      });
    }catch(e){
      log(e.toString());
    }
}

  Future<void> setUserType(String userId, String userType) async {
    try{
      await ref!.doc(userId).update({
        UserKey.USER_TYPE: userType,
        UserKey.IS_VENDOR: false,
        UserKey.IS_EMPLOYEE: false
      });
    }catch(e){
      log(e.toString());
    }
  }

  Future<void> setVendorType(String userId, String vendorType, String userType) async {
    try{
      await ref!.doc(userId).update({
        UserKey.VENDOR_TYPE: vendorType,
        UserKey.USER_TYPE: userType,
        UserKey.IS_VENDOR: true,
        UserKey.IS_EMPLOYEE: false
      });
    }catch(e){
      log(e.toString());
    }
  }

  Stream<DocumentSnapshot<User>> getUser(String userId) {
    return ref!.doc(userId).snapshots();
  }

  Future<bool> updateUserSubscription(bool isSubscribed, String subscriptionType, String userId, String planLookUpKey) async {
     try {
       await ref!.doc(userId).update({
         UserKey.IS_SUBSCRIBED: isSubscribed,
         UserKey.SUBSCRIPTION_TYPE: subscriptionType,
         UserKey.PLAN_LOOK_UP_KEY: planLookUpKey
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
        UserKey.EMPLOYEE_DEAL_LIST: selectedItemIds,
      });
    }catch(e){
      print('Error: ${e.toString()}');
    }
  }

  Future<bool> updateEmployeeBlockStatus(String id, bool isBlocked) async {
    try {
      await ref!.doc(id).update({UserKey.IS_EMPLOYEE_BLOCKED: isBlocked});
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<bool> updateCategory(String category, String image, String userId) async {
    try {
      await ref!.doc(userId).update({
        UserKey.CATEGORY: category,
        UserKey.CATEGORY_IMAGE: image
      });
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<void> updateUserStripeDetails(String stripeId, String subscriptionId, String sessionId, String userId) async {
    try {
      await ref!.doc(userId).update({
        UserKey.STRIPE_ID: stripeId,
        UserKey.SUBSCRIPTION_ID: subscriptionId,
        UserKey.SESSION_ID: sessionId
      });
    } catch (e) {
      log(e.toString());
    }
  }
}