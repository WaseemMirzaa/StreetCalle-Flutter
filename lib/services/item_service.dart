import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:street_calle/services/base_service.dart';
import 'package:street_calle/main.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/models/item.dart';


class ItemService extends BaseService<Item> {

  ItemService() {
    ref = fireStore.collection(Collections.item).withConverter<Item>(
      fromFirestore: (snapshot, options) =>
          Item.fromJson(snapshot.data()!, snapshot.id),
      toFirestore: (value, options) => value.toJson(),
    );
  }

  Future<Either<String, Item?>> addItem(Item item, String image) async {
    try {
      final url = await _uploadImageToFirebase(image, item.uid ?? '');
      if (url == null) {
        return const Left('Something went wrong. Try again later.');
      }

      item = item.copyWith(image: url);
      final result = await ref!.add(item);
      await ref!.doc(result.id).update({ItemKey.id: result.id});
      item = item.copyWith(id: result.id);

      return Right(item);
    } catch (e) {
      return const Left('Something went wrong. Try again later.');
    }
  }

  Future<Either<String, Item?>> updateItem(Item item, {required bool isUpdated, required String image}) async {
    try {

      if (isUpdated) {
        final url = await _uploadImageToFirebase(image, item.uid ?? '');
        if (url == null) {
          return const Left('Something went wrong. Try again later.');
        }
        item = item.copyWith(image: url);
        await ref!.doc(item.id).update(item.toJson());
        return Right(item);
      }

      item = item.copyWith(image: image);
      await ref!.doc(item.id).update(item.toJson());
      return Right(item);
    } catch (e) {
      return const Left('Something went wrong. Try again later.');
    }
  }

  Future<String?> _uploadImageToFirebase(String image, String userId) async {
    try {
      final storageReference = storage
          .ref()
          .child('images/$userId/${Timestamp.now().millisecondsSinceEpoch}.jpg');

      await storageReference.putFile(File(image));
      final downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } catch (error) {
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
        await storage.refFromURL(item.image!).delete();
      }
      ref!.doc(item.id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

}