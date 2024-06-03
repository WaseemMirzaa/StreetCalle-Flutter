import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/services/auth_service.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/generated/locale_keys.g.dart';
part 'apple_login_state.dart';

class AppleeLoginCubit extends Cubit<AppleeLoginState> {
  AppleeLoginCubit(this.authService, this.userService) : super(AppleeLoginInitial());

  final AuthService authService;
  final UserService userService;

  Future<void> appleeSignIn() async {
    emit(AppleeLoginLoading());
    final appleeUser = await authService.signInWithApple();
    appleeUser.fold(
            (l) => emit(AppleeLoginFailure(l)),
            (r) async {
          if (r != null) {
            try {
              final result = await userService.userByUid(r.uid);
              final isEmailVerified = await authService.isUserEmailVerified();
              emit(AppleeLoginSuccess(result, isEmailVerified));
            } catch (e) {
              emit(AppleeLoginFailure(LocaleKeys.signUpFailed.tr()));
            }
          } else {
            emit(AppleeLoginFailure(LocaleKeys.signUpFailed.tr()));
          }
        }
    );
  }
}