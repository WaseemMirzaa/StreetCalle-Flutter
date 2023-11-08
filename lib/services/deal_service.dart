import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:street_calle/services/base_service.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/models/deal.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/utils/constant/temp_language.dart';


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
        return Left(TempLanguage().lblSomethingWentWrong);
      }

      deal = deal.copyWith(image: url);
      final result = await ref!.add(deal);
      await ref!.doc(result.id).update({ItemKey.id: result.id});
      deal = deal.copyWith(id: result.id);

      return Right(deal);
    } catch (e) {
      log(e.toString());
      return Left(TempLanguage().lblSomethingWentWrong);
    }
  }

  Future<Either<String, Deal?>> updateDeal(Deal deal, {required bool isUpdated, required String image}) async {
    try {

      if (isUpdated) {
        final url = await _uploadImageToFirebase(image, deal.uid ?? '');
        if (url == null) {
          return Left(TempLanguage().lblSomethingWentWrong);
        }
        deal = deal.copyWith(image: url);
        await ref!.doc(deal.id).update(deal.toJson());
        return Right(deal);
      }

      deal = deal.copyWith(image: image);
      await ref!.doc(deal.id).update(deal.toJson());
      return Right(deal);
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
      log(e.toString());
      return false;
    }
  }

  Stream<List<Deal>> getAllDeals() {
    return ref!
        .orderBy(ItemKey.updatedAt, descending: true)
        .snapshots()
        .map((value) => value.docs.map((e) => e.data()).toList());
  }

  Stream<List<Deal>> getEmployeeDeals(List<dynamic>? employeeItemList) {
    return ref!.where(FieldPath.documentId, whereIn: employeeItemList)
        .snapshots()
        .map((value) => value.docs.map((e) => e.data()).toList());
  }

  Stream<List<Deal>> getEmployeeDealsStream(String userId) async* {
    try {
      final userDoc = await UserService().userByUid(userId);
      yield* getEmployeeDeals(userDoc.employeeItemsList);
    }catch(e){
      log(e.toString());
    }
  }

}