import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/services/auth_service.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
part 'facebook_login_state.dart';

class FacebookLoginCubit extends Cubit<FacebookLoginState> {
  FacebookLoginCubit(this.authService, this.userService) : super(FacebookLoginInitial());

  final AuthService authService;
  final UserService userService;

  Future<void> facebookSignIn() async {
    emit(FacebookLoginLoading());
    final facebookUser = await authService.signInWithFacebook();
    facebookUser.fold(
            (l) => emit(FacebookLoginFailure(l)),
            (r) async {
          if (r != null) {
            try {
              final result = await userService.userByUid(r.uid);
              final isEmailVerified = await authService.isUserEmailVerified();
              emit(FacebookLoginSuccess(result, isEmailVerified));
            } catch (e) {
              emit(FacebookLoginFailure(TempLanguage().lblSignUpFailed));
            }
          } else {
            emit(FacebookLoginFailure(TempLanguage().lblSignUpFailed));
          }
        }
    );
  }
}