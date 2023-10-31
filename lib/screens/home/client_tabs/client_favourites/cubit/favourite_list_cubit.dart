import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/models/user.dart';

class FavouriteListCubit extends Cubit<List<User>> {
  FavouriteListCubit() : super([]);

  void clearList() => emit([]);

  void addUsers(List<User> users) {
    emit(users);
  }

  void removeUser(String userIdToRemove) {
    final currentState = state;
    final updatedList = List<User>.from(currentState);
    updatedList.removeWhere((user) => user.uid == userIdToRemove);
    emit(updatedList);
  }

}