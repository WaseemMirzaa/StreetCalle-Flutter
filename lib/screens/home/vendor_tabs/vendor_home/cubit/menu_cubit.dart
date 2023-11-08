import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/services/user_service.dart';

enum MenuState { initial, loading, loaded, error }

class MenuCubit extends Cubit<MenuState> {
  final userService = sl.get<UserService>();
  MenuCubit() : super(MenuState.initial);

  Future<void> updateUserMenu(String uid, List<dynamic> selectedDealsIds, List<dynamic> selectedItemIds) async {
    try {
      emit(MenuState.loading);
      await userService.updateUserMenuDeals(uid, selectedDealsIds);
      await userService.updateUserMenuItems(uid, selectedItemIds);
      emit(MenuState.loaded);
    } catch (error) {
      emit(MenuState.error);
    }
  }
}
