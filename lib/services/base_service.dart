import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseService<T> {
  CollectionReference<T>? ref;

  BaseService({this.ref});

  Future<DocumentReference> addDocument(T data) async {
    var doc = await ref!.add(data);
    doc.update({'uid': doc.id});
    return doc;
  }

  Future<DocumentReference> addDocumentWithCustomId(String id, T data) async {
    print('here in addDocumentWithCustomId');
    print(data);
    var doc = ref!.doc(id);

    return await doc.set(data).then((value) {
      return doc;
    }).catchError((e) {
      print('catch erorrrrr $e');
      throw e;
    });
  }

  Future<void> updateDocument(Map<String, dynamic> data, String? id) => ref!.doc(id).update(data);

  Future<void> removeDocument(String id) => ref!.doc(id).delete();

}