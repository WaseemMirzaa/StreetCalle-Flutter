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

  Future<Either<String, User>> updateProfile(String userId, {required bool isUpdated, required String image}) async{
    try {
      final url = await _uploadImageToFirebase(image, userId ?? '');
      if (url == null) {
        return const Left('Something went wrong. Try again later.');
      }
      User user = User(image: url);
      await ref!.doc(userId).update({
        UserKey.image: url,
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

}