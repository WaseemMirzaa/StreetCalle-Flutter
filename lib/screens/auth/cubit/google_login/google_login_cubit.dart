import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/services/auth_service.dart';
import 'package:street_calle/services/user_service.dart';
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
              emit(GoogleLoginSuccess(result));
            } catch (e) {
              emit(GoogleLoginFailure('Login failed. Please try again later.'));
            }
          } else {
            emit(GoogleLoginFailure('Login failed. Please try again later.'));
          }
        }
    );
  }
}