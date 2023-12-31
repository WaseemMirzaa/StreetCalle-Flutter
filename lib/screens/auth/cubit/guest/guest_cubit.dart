import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_calle/services/auth_service.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
part 'guest_state.dart';

class GuestCubit extends Cubit<GuestState> {
  GuestCubit(this.authService) : super(GuestLoginInitial());

  AuthService authService;

  Future<void> signInAsGuest() async {
    emit(GuestLoginLoading());
    try {
      final result = await authService.guestSignIn();
      result.fold(
        (l) =>  emit(GuestLoginFailure(l)),
        (r) => emit(GuestLoginSuccess(r!)),
      );
    } catch (e) {
      emit(GuestLoginFailure(TempLanguage().lblLoginFailed));
    }
  }

}
