import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/services/shared_preferences_service.dart';
import 'package:street_calle/utils/constant/constants.dart';

class UserState {
  final String userId;
  final String userName;
  final String userEmail;
  final String userImage;
  final String userPhone;
  final bool isLoggedIn;
  final bool isVendor;
  final bool isOnline;

  UserState({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userImage,
    required this.userPhone,
    required this.isLoggedIn,
    required this.isVendor,
    required this.isOnline
  });

  UserState copyWith({
    String? userId,
    String? userName,
    String? userEmail,
    String? userImage,
    String? userPhone,
    bool? isLoggedIn,
    bool? isVendor,
    bool? isOnline
  }) {
    return UserState(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userImage: userImage ?? this.userImage,
      userPhone: userPhone ?? this.userPhone,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isVendor: isVendor ?? this.isVendor,
      isOnline: isOnline ?? this.isOnline
    );
  }
}

class UserCubit extends Cubit<UserState> {
  UserCubit(this.sharedPreferencesService)
      : super(
    UserState(
      userId: '',
      userName: '',
      userEmail: '',
      userImage: '',
      userPhone: '',
      isLoggedIn: false,
      isVendor: false,
      isOnline: true
    ),
  );

  final SharedPreferencesService sharedPreferencesService;

  // Setters
  void setUsername(String value) {
    emit(state.copyWith(userName: value));
    sharedPreferencesService.setValue(SharePreferencesKey.USER_NAME, value);
  }

  void setUserEmail(String value) {
    emit(state.copyWith(userEmail: value));
    sharedPreferencesService.setValue(SharePreferencesKey.USER_EMAIL, value);
  }

  void setUserId(String value) {
    emit(state.copyWith(userId: value));
    sharedPreferencesService.setValue(SharePreferencesKey.USER_ID, value);
  }

  void setUserImage(String value) {
    emit(state.copyWith(userImage: value));
    sharedPreferencesService.setValue(SharePreferencesKey.USER_IMAGE, value);
  }

  void setUserPhone(String value) {
    emit(state.copyWith(userPhone: value));
    sharedPreferencesService.setValue(SharePreferencesKey.USER_NUMBER, value);
  }

  void setIsLoggedIn(bool value) {
    emit(state.copyWith(isLoggedIn: value));
    sharedPreferencesService.setValue(SharePreferencesKey.IS_LOGGED_IN, value);
  }

  void setIsVendor(bool value) {
    emit(state.copyWith(isVendor: value));
    sharedPreferencesService.setValue(SharePreferencesKey.IS_VENDOR, value);
  }

  void setIsOnline(bool value) {
    emit(state.copyWith(isOnline: value));
    sharedPreferencesService.setValue(SharePreferencesKey.IS_ONLINE, value);
  }

  void setUserModel(User user, {bool isLoggedIn = false, bool isVendor = false, bool isOnline = true}) {
    setUsername(user.name ?? '');
    setUserEmail(user.email ?? '');
    setUserImage(user.image ?? '');
    setUserId(user.uid ?? '');
    setUserPhone(user.phone ?? '');
    setIsLoggedIn(isLoggedIn);
    setIsVendor(isVendor);
    setIsOnline(true);
  }
}
