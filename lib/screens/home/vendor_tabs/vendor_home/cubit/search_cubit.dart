import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<String> {
  SearchCubit() : super('');

  void updateQuery(String query) {
    emit(query);
  }
}

class ClientMenuSearchCubit extends Cubit<String> {
  ClientMenuSearchCubit() : super('');

  void updateQuery(String query) {
    emit(query);
  }
}

class FoodSearchCubit extends Cubit<String> {
  FoodSearchCubit() : super('');

  void updateQuery(String query) {
    emit(query);
  }
}

class AllDealsSearchCubit extends Cubit<String> {
  AllDealsSearchCubit() : super('');

  void updateQuery(String query) {
    emit(query);
  }
}

class AllItemsSearchCubit extends Cubit<String> {
  AllItemsSearchCubit() : super('');

  void updateQuery(String query) {
    emit(query);
  }
}