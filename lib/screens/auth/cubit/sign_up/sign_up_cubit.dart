import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/services/auth_service.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/constant/constants.dart';
part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController customPhoneController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final AuthService authService;
  final UserService userService;
  XFile? image = XFile('');

  SignUpCubit(this.authService, this.userService) : super(SignUpInitial());

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    confirmPasswordController.dispose();
    customPhoneController.dispose();
    return super.close();
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    phoneController.clear();
    customPhoneController.clear();
    confirmPasswordController.clear();
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
            countryCode: countryCodeController.text.isEmpty ? initialCountyCode : countryCodeController.text,
            isVendor: false,
            isEmployee: false,
            isEmployeeBlocked: false,
            isOnline: true,
            isSubscribed: false,
            subscriptionType: SubscriptionType.none.name,
            createdAt: Timestamp.now(),
            updatedAt: Timestamp.now(),
          );

          final result = await userService.saveUserData(user, image);
          if (result) {
            final user = await userService.userByUid(r.uid);
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