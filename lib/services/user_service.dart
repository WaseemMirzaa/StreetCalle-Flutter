import 'dart:io';
import 'package:street_calle/services/base_service.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/main.dart';
import 'package:street_calle/utils/constant/constants.dart';


class UserService extends BaseService<User> {
  UserService() {
    ref = fireStore.collection(Collections.user).withConverter<User>(
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
      final storageReference = storage
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

}