import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/services/auth_service.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/constant/temp_language.dart';


part 'create_employee_state.dart';

class CreateEmployeeCubit extends Cubit<CreateEmployeeState> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final AuthService authService;
  final UserService userService;
  XFile? image = XFile('');

  CreateEmployeeCubit(this.authService, this.userService) : super(SignUpInitial());

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    return super.close();
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
  }

  Future<void> signUp(String image, String vendorId, String employeeOwnerName, String employeeOwnerImage) async {
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
              vendorId: vendorId,
              isVendor: false,
              isEmployee: true,
              isEmployeeBlocked: false,
              isOnline: true,
              isSubscribed: false,
              userType: UserType.employee.name,
              subscriptionType: SubscriptionType.none.name,
              createdAt: Timestamp.now(),
              updatedAt: Timestamp.now(),
              employeeItemsList: const[],
              employeeDealsList: const[],
              employeeOwnerName: employeeOwnerName,
              employeeOwnerImage: employeeOwnerImage
            );
            final result = await userService.saveUserData(user, image);
            if (result) {
              try {
                final user = await userService.userByUid(r.uid);
                emit(SignUpSuccess(user));
              } catch(e) {
                emit(SignUpFailure(TempLanguage().lblSignUpFailed));
              }
            } else {
              emit(SignUpFailure(TempLanguage().lblSignUpFailed));
            }
          } else {
            emit(SignUpFailure(TempLanguage().lblSignUpFailed));
          }
        }
    );
  }
}