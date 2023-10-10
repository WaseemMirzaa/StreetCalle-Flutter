import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/services/shared_preferences_service.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/constants.dart';

class ProfileStatusCubit extends Cubit<bool> {
  ProfileStatusCubit(this.userService, this.sharedPref) : super(true);
  final UserService userService;
  final SharedPreferencesService sharedPref;

  void goOnline() {
    emit(true);
    userService.setUserStatus(true, sharedPref.getStringAsync(SharePreferencesKey.USER_ID));
  }

  void goOffline() {
    emit(false);
    userService.setUserStatus(false, sharedPref.getStringAsync(SharePreferencesKey.USER_ID));
  }

  void defaultStatus(bool isOnline)=> emit(isOnline);
}