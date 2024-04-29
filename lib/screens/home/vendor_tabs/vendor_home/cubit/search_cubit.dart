import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<String> {
  SearchCubit() : super('');

  void updateQuery(String query) {
    emit(query.toLowerCase());
  }
}

class ClientMenuSearchCubit extends Cubit<String> {
  ClientMenuSearchCubit() : super('');

  void updateQuery(String query) {
    emit(query.toLowerCase());
  }
}

class FoodSearchCubit extends Cubit<String> {
  FoodSearchCubit() : super('');

  void updateQuery(String query) {
    emit(query.toLowerCase());
  }
}

class AllDealsSearchCubit extends Cubit<String> {
  AllDealsSearchCubit() : super('');

  void updateQuery(String query) {
    emit(query.toLowerCase());
  }
}

class AllItemsSearchCubit extends Cubit<String> {
  AllItemsSearchCubit() : super('');

  void updateQuery(String query) {
    emit(query.toLowerCase());
  }
}


class SearchItemsCubit extends Cubit<String> {
  SearchItemsCubit() : super('');

  void updateQuery(String query) {
    emit(query.toLowerCase());
  }
}

class SearchDealsCubit extends Cubit<String> {
  SearchDealsCubit() : super('');

  void updateQuery(String query) {
    emit(query.toLowerCase());
  }
}