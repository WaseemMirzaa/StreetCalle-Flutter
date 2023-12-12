import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_calle/services/base_service.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/models/category.dart';

class CategoryService extends BaseService<Category>{

  CategoryService() {
    ref = sl.get<FirebaseFirestore>().collection(Collections.CATEGORY).withConverter<Category>(
        fromFirestore: (snapshot, options) => Category.fromJson(snapshot.data()!),
        toFirestore: (value, options) => value.toJson(),
    );
  }

  Future<List<dynamic>?> fetchCategories() async {
    final result = await ref!.doc(Collections.CATEGORY).get();
    return result.data()?.categories;
  }
}