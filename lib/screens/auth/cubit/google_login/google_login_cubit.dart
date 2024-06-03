import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/services/auth_service.dart';
import 'package:street_calle/services/user_service.dart';

import 'package:street_calle/generated/locale_keys.g.dart';

part 'google_login_state.dart';

class GoogleLoginCubit extends Cubit<GoogleLoginState> {
  GoogleLoginCubit(this.authService, this.userService) : super(GoogleLoginInitial());

  final AuthService authService;
  final UserService userService;

  Future<void> googleSignIn() async {
    emit(GoogleLoginLoading());
    final googleUser = await authService.signInWithGoogle();
    googleUser.fold(
            (l) => emit(GoogleLoginFailure(l)),
            (r) async {
          if (r != null) {
            try {
              final result = await userService.userByUid(r.uid);
              final isEmailVerified = await authService.isUserEmailVerified();
              emit(GoogleLoginSuccess(result, isEmailVerified));
            } catch (e) {
              emit(GoogleLoginFailure(LocaleKeys.signUpFailed.tr()));
            }
          } else {
            emit(GoogleLoginFailure(LocaleKeys.signUpFailed.tr()));
          }
        }
    );
  }
}