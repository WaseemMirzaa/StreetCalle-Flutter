import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/services/auth_service.dart';
import 'package:street_calle/main.dart';
part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final AuthService authService;
  XFile? image = XFile('');

  SignUpCubit(this.authService) : super(SignUpInitial());

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }

  Future<void> signUp(String image) async {
    emit(SignUpLoading());
    final firebaseUser = await authService.signUpWithEmailAndPassword(emailController.text, passwordController.text);
    firebaseUser.fold(
     (l) => emit(SignUpFailure(l)),
      (r) async {
        if (r != null) {

          final user = User(
            uid: r.uid,
            name: nameController.text,
            email: emailController.text,
            phone: phoneController.text,
            isVendor: false,
            createdAt: Timestamp.now(),
            updatedAt: Timestamp.now(),
          );

          final result = await userService.saveUserData(user, image);
          if (result) {
            emit(SignUpSuccess(user));
          } else {
            emit(SignUpFailure('Sign-up failed. Please try again.'));
          }
        } else {
          emit(SignUpFailure('Sign-up failed. Please try again.'));
        }
      }
    );
  }
}