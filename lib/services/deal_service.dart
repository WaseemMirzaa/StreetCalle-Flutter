import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:street_calle/services/base_service.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/models/deal.dart';
import 'package:street_calle/dependency_injection.dart';


class DealService extends BaseService<Deal> {

  DealService() {
    ref = sl.get<FirebaseFirestore>().collection(Collections.deals).withConverter<Deal>(
      fromFirestore: (snapshot, options) =>
          Deal.fromJson(snapshot.data()!, snapshot.id),
      toFirestore: (value, options) => value.toJson(),
    );
  }

  Future<Either<String, Deal?>> addDeal(Deal deal, String image) async {
    try {
      final url = await _uploadImageToFirebase(image, deal.uid ?? '');
      if (url == null) {
        return const Left('Something went wrong. Try again later.');
      }

      deal = deal.copyWith(image: url);
      final result = await ref!.add(deal);
      await ref!.doc(result.id).update({ItemKey.id: result.id});
      deal = deal.copyWith(id: result.id);

      return Right(deal);
    } catch (e) {
      return const Left('Something went wrong. Try again later.');
    }
  }

  Future<Either<String, Deal?>> updateDeal(Deal deal, {required bool isUpdated, required String image}) async {
    try {

      if (isUpdated) {
        final url = await _uploadImageToFirebase(image, deal.uid ?? '');
        if (url == null) {
          return const Left('Something went wrong. Try again later.');
        }
        deal = deal.copyWith(image: url);
        await ref!.doc(deal.id).update(deal.toJson());
        return Right(deal);
      }

      deal = deal.copyWith(image: image);
      await ref!.doc(deal.id).update(deal.toJson());
      return Right(deal);
    } catch (e) {
      return const Left('Something went wrong. Try again later.');
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
    } catch (error) {
      return null;
    }
  }

  Stream<List<Deal>> getDeals(String userId) {
    return ref!.where(ItemKey.uid, isEqualTo: userId)
        .orderBy(ItemKey.updatedAt, descending: true)
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
      return false;
    }
  }

}