import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/models/deal.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/utils/constant/constants.dart';


class FilterItemsCubit extends Cubit<List<Item>> {
  FilterItemsCubit() : super([]);

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

class RemoteUserItems extends Cubit<Map<Item, User>> {
  RemoteUserItems() : super({});

  void addRemoteUserItems(Map<Item, User> map) => emit(map);
  void resetRemoteUserItems() => emit({});
}

class LocalItemsStorage extends Cubit<Map<Item, User>> {
  LocalItemsStorage() : super({});

  void addLocalItems(Map<Item, User> map) => emit(map);
  void resetLocalItem() => emit({});
}



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

class RemoteUserDeals extends Cubit<Map<Deal, User>> {
  RemoteUserDeals() : super({});

  void addRemoteUserDeals(Map<Deal, User> map) => emit(map);
  void resetRemoteUserDeals() => emit({});
}

class LocalDealsStorage extends Cubit<Map<Deal, User>> {
  LocalDealsStorage() : super({});

  void addLocalDeals(Map<Deal, User> map) => emit(map);
  void resetLocalDeal() => emit({});
}


enum SearchTab { item, deal, none }

class NavPositionCubit extends Cubit<SearchTab>{
  NavPositionCubit() : super(SearchTab.none);

  void visitedItemTab()=> emit(SearchTab.item);
  void visitedDealTab()=> emit(SearchTab.deal);
  void resetTab()=> emit(SearchTab.none);
}