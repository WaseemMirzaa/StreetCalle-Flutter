import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/services/auth_service.dart';

class EmailVerificationCubit extends Cubit<bool>{
  EmailVerificationCubit(this.authService) : super(false);

  AuthService authService;

  void isUserEmailVerified() {
    //emit(authService.isUserEmailVerified());
  }

  void sendEmailVerificationAgain() async {
    await authService.sendEmailVerificationAgain();
  }
}