import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:street_calle/services/base_service.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/utils/constant/constants.dart';

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
    } catch (error) {
      return null;
    }
  }

  Future<User> userByUid(String? uid) async {
    return ref!.limit(1).where(UserKey.uid, isEqualTo: uid).get().then((value) {
      if (value.docs.isNotEmpty) return value.docs.first.data();
      throw 'User Not Found';
    }).catchError((e) {
      throw 'User Not Found';
    });
  }

  Future<void> setUserStatus(bool isOnline, String userId) async {
    try {
      await ref!.doc(userId).update({
        UserKey.isOnline: isOnline
      });
    } catch (e) {

    }
  }

  Future<void> updateUserLocation(double latitude, double longitude, String userId) async {
    try {
      await ref!.doc(userId).update({
        UserKey.latitude: latitude,
        UserKey.longitude: longitude
      });
    } catch (e) {

    }
  }

  Future<Either<String, User>> updateProfile(String userId, {required bool isUpdated, required String image, required String name, required String phone, required String countryCode}) async{
    try {
      if (isUpdated) {
        final url = await _uploadImageToFirebase(image, userId ?? '');
        if (url == null) {
          return const Left('Something went wrong. Try again later.');
        }
        User user = User(image: url, name: name, phone: phone, countryCode: countryCode);
        await ref!.doc(userId).update({
          UserKey.image: url,
          UserKey.name: name,
          UserKey.phone: phone,
          UserKey.countryCode: countryCode
        });
        return Right(user);
      }

      User user = User(image: image, name: name, phone: phone, countryCode: countryCode);
      await ref!.doc(userId).update({
        UserKey.image: image,
        UserKey.name: name,
        UserKey.phone: phone,
        UserKey.countryCode: countryCode
      });
      return Right(user);

    } catch (e) {
      return const Left('Something went wrong. Try again later.');
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
    userList.addAll(vendorQuerySnapshot.docs.map((user) => user.data()));
    userList.addAll(employeeQuerySnapshot.docs.map((user) => user.data()));

    return userList;
  }

  Stream<List<User>> getEmployees(String userId) {
    return ref!.where(UserKey.vendorId, isEqualTo: userId)
        .orderBy(UserKey.updatedAt, descending: true)
        .snapshots()
        .map((value) => value.docs.map((e) => e.data()).toList());
  }

  Future<bool> updateFavourites(String vendorId, String userId, bool addToFav) async {
    try {
      await ref!.doc(userId).update({
        UserKey.favouriteVendors: addToFav ? FieldValue.arrayUnion([vendorId]) : FieldValue.arrayRemove([vendorId])
      });
      return true;
    } catch (e) {
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
      return false;
    }
  }

  Future<List<User>> getFavouriteVendors(String userId) async {
    try {
      final userDoc = await ref!.doc(userId).get();
      if (userDoc.exists) {
        final user = userDoc.data();
        final favouriteVendorIds = user?.favouriteVendors ?? [];
        final favoriteUsers = await getVendorsForIds(favouriteVendorIds);
        return favoriteUsers;
      }
      return [];
    } catch (e) {
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
      return [];
    }
  }

  Future<void> updateUserMenuItems(String userId, List<dynamic> selectedItemIds)async{
    try{
      await ref!.doc(userId).update({
        UserKey.employeeItemList: selectedItemIds,
      });
    }catch(e){
        print('Error: ${e.toString()}');
    }
}

  Future<void> setUserType(String userId, String vendorType) async {
    try{
      await ref!.doc(userId).update({
        UserKey.vendorType: vendorType,
        UserKey.isVendor: true,
        UserKey.isEmployee: false
      });
    }catch(e){
      print('Error: ${e.toString()}');
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
}