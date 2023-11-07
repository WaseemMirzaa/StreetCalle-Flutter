import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/services/auth_service.dart';
import 'package:street_calle/utils/constant/temp_language.dart';

part 'forget_password_state.dart';

class PasswordResetCubit extends Cubit<PasswordResetState> {
  PasswordResetCubit(this.authService) : super(PasswordResetInitial());
  final TextEditingController emailController = TextEditingController();
  final AuthService authService;

  @override
  Future<void> close() {
    emailController.dispose();
    return super.close();
  }

  Future<void> resetPassword() async {
    try {
      emit(PasswordResetLoading());
      final result = await authService.resetPassword(emailController.text);
      result.fold(
       (l) => emit(PasswordResetFailure(l)),
       (r) => emit(PasswordResetSuccess())
      );
    }  catch (e) {
      emit(PasswordResetFailure(TempLanguage().lblSomethingWentWrong));
    }
  }
}