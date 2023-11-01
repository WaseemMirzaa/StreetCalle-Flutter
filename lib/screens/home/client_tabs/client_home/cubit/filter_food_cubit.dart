import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/models/item.dart';

class FilterFoodCubit extends Cubit<List<Item>> {
  FilterFoodCubit() : super([]);

  void filterItems(double minPrice, double maxPrice, String foodType, List<Item> items) {
    final filteredList = items.where((item) {
      return (item.actualPrice != null && item.actualPrice! >= minPrice && item.actualPrice! <= maxPrice) && item.foodType?.toLowerCase() == foodType.toLowerCase();
    }).toList();
    emit(filteredList);
  }

  void resetFilterItems()=> emit([]);
  void addFilterItems(List<Item> items)=> emit(items);
}

class ItemList extends Cubit<List<Item>> {
  ItemList() : super([]);

  void resetItems()=> emit([]);
  void addItems(List<Item> items)=> emit(items);
}