import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/services/auth_service.dart';
import 'package:street_calle/main.dart';
part 'login_state.dart';


class LoginCubit extends Cubit<LoginState>{

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService;

  LoginCubit(this.authService) : super(LoginInitial());

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }

  Future<void> login() async {
    emit(LoginLoading());
    final firebaseUser = await authService.logInWithEmailAndPassword(emailController.text, passwordController.text);
    firebaseUser.fold(
     (l) => emit(LoginFailure(l)),
     (r) async {
       if (r != null) {
         try {
           final result = await userService.userByUid(r.uid);
           emailController.text = '';
           passwordController.text = '';
           emit(LoginSuccess(result));
         } catch (e) {
           emit(LoginFailure('User not found'));
         }
       } else {
         emit(LoginFailure('Login failed. Please try again later.'));
       }
     }
    );
  }
}