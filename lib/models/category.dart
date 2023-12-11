import 'package:street_calle/utils/constant/constants.dart';

class Category {
  final List<dynamic>? categories;

  Category({
   this.categories
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categories: json[CategoryKey.CATEGORIES],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[CategoryKey.CATEGORIES] = categories;
    return data;
  }
}