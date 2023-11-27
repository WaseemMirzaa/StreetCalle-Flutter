import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/models/deal.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/utils/constant/constants.dart';

/// ***** Items Filter Section Start ******** ////
///
///

class FilterItemsCubit extends Cubit<List<Item>> {
  FilterItemsCubit() : super([]);

  // void filterItems(double minPrice, double maxPrice, List<Item> items, List<User> users, double distance) {
  //   final filteredList = items.where((item) {
  //     int index = items.indexOf(item);
  //     final user = users[index];
  //     return (item.actualPrice != null && item.actualPrice! >= minPrice && item.actualPrice! <= maxPrice && (double.parse(user.clientVendorDistance ?? '0.0') == 0.0  ? (0.0 <= distance) : (double.parse(user.clientVendorDistance!) <= distance)));
  //   }).toList();
  //   emit(filteredList);
  // }
  void filterItems(double minPrice, double maxPrice, List<Item> items, List<User> users, double? distance) {
    final filteredList = items.where((item) {
      int index = items.indexOf(item);
      final user = users[index];

      // Set default values for min and max distance
      double minDistance = 0.0;
      double maxDistance = distance ?? 10.0;

      // Check if actualPrice is not null and within the specified range
      bool isPriceInRange = false;

      if (item.actualPrice != null && item.actualPrice != defaultPrice) {
        isPriceInRange = (maxPrice == 0 || (item.actualPrice! >= minPrice && item.actualPrice! <= maxPrice));
      } else {
        isPriceInRange = (maxPrice == 0 || (item.smallItemActualPrice != null && item.smallItemActualPrice! >= minPrice && item.smallItemActualPrice! <= maxPrice));
      }

      // Check if the distance is within the specified range
      bool isDistanceInRange = double.parse(user.clientVendorDistance ?? '0.0') >= minDistance &&
          double.parse(user.clientVendorDistance ?? '0.0') <= maxDistance;

      return isPriceInRange && isDistanceInRange;
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

class AvailableItemList extends Cubit<List<Item>> {
  AvailableItemList() : super([]);

  void resetItems()=> emit([]);
  void addItems(List<Item> items)=> emit(items);
}

/// List of users that will be used to filter items distance wise
class ItemUserList extends Cubit<List<User>> {
  ItemUserList() : super([]);

  void resetUsers()=> emit([]);
  void addUsers(List<User> users)=> emit(users);
}

class AvailableItemUserList extends Cubit<List<User>> {
  AvailableItemUserList() : super([]);

  void resetUsers()=> emit([]);
  void addUsers(List<User> users)=> emit(users);
}

///
///
/// **************************************** ////


/// ***** Deals Filter Section Start ******** ////
///
///

class FilterDealsCubit extends Cubit<List<Deal>> {
  FilterDealsCubit() : super([]);

  void filterDeals(double minPrice, double maxPrice, List<Deal> deals, List<User> users, double? distance) {
    final filteredList = deals.where((deal) {
      int index = deals.indexOf(deal);
      final user = users[index];

      // Set default values for min and max distance
      double minDistance = 0.0;
      double maxDistance = distance ?? 10.0;

      // Set default value for minimum price
      double minItemPrice = 1.0;

      // Check if actualPrice is not null and within the specified range
      bool isPriceInRange = deal.actualPrice != null &&
          (maxPrice == 0 || (deal.actualPrice! >= minPrice && deal.actualPrice! <= maxPrice));

      // Check if the distance is within the specified range
      bool isDistanceInRange = double.parse(user.clientVendorDistance ?? '0.0') >= minDistance &&
          double.parse(user.clientVendorDistance ?? '0.0') <= maxDistance;

      return isPriceInRange && isDistanceInRange;
    }).toList();

    emit(filteredList);
  }

  void resetFilterDeals()=> emit([]);
  void addFilterDeals(List<Deal> deals)=> emit(deals);
}

class DealList extends Cubit<List<Deal>> {
  DealList() : super([]);

  void resetDeals()=> emit([]);
  void addDeals(List<Deal> deals)=> emit(deals);
}

class AvailableDealList extends Cubit<List<Deal>> {
  AvailableDealList() : super([]);

  void resetDeals()=> emit([]);
  void addDeals(List<Deal> deals)=> emit(deals);
}

/// List of users that will be used to filter deals distance wise
class DealUserList extends Cubit<List<User>> {
  DealUserList() : super([]);

  void resetUsers()=> emit([]);
  void addUsers(List<User> users)=> emit(users);
}

class AvailableDealUserList extends Cubit<List<User>> {
  AvailableDealUserList() : super([]);

  void resetUsers()=> emit([]);
  void addUsers(List<User> users)=> emit(users);
}

///
///
/// **************************************** ////



enum SearchTab { item, deal, none }

class NavPositionCubit extends Cubit<SearchTab>{
  NavPositionCubit() : super(SearchTab.none);

  void visitedItemTab()=> emit(SearchTab.item);
  void visitedDealTab()=> emit(SearchTab.deal);
  void resetTab()=> emit(SearchTab.none);
}