import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/screens/auth/cubit/create_employee/create_employee_cubit.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';

class CreateLocationButton extends StatelessWidget {
  const CreateLocationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 0,
      left: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 44.0),
        child: SizedBox(
          width: context.width,
          height: defaultButtonSize,
          child:
          BlocConsumer<CreateEmployeeCubit, CreateEmployeeState>(
            listener: (context, state) {
              if (state is SignUpSuccess) {
                context.read<CreateEmployeeCubit>().clearControllers();
                context.read<ImageCubit>().resetImage();
              } else if (state is SignUpFailure) {
                showToast(context, state.error);
              }
            },
            builder: (context, state) {
              return state is SignUpLoading
                  ? const Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primaryColor,),
                ],
              )
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                child: SizedBox(
                  width: context.width,
                  height: defaultButtonSize,
                  child: AppButton(
                    text: TempLanguage().lblAddNewLocation,
                    elevation: 0.0,
                    onTap: () {
                      signUp(context);
                    },
                    shapeBorder: RoundedRectangleBorder(
                        side: const BorderSide(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    textStyle: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                    color: AppColors.primaryColor,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> signUp(BuildContext context) async {
    final imageCubit = context.read<ImageCubit>();
    final createEmployeeCubit = context.read<CreateEmployeeCubit>();
    final userCubit = context.read<UserCubit>();

    final employeeOwnerImage = userCubit.state.userImage;
    final employeeOwnerName = userCubit.state.userName;
    final image = imageCubit.state.selectedImage.path;
    final name = createEmployeeCubit.nameController.text;
    final email = createEmployeeCubit.emailController.text;
    final password = createEmployeeCubit.passwordController.text;
    final vendorId = context.read<UserCubit>().state.userId;
    final category = userCubit.state.category;
    final categoryImage = userCubit.state.categoryImage;

    if (image.isEmpty) {
      showToast(context, TempLanguage().lblSelectImage);
    } else if (name.isEmpty) {
      if (name.length < 3) {
        showToast(context, TempLanguage().lblEnterYourName);
      } else {
        showToast(context, TempLanguage().lblNameMustBeGrater);
      }
    } else if (email.isEmpty || !email.validateEmailEnhanced()) {
      showToast(context, TempLanguage().lblEnterYourEmail);
    }  else if (password.isEmpty || password.length < 6) {
      showToast(context, TempLanguage().lblPasswordMustBeGreater);
    } else {
      createEmployeeCubit.signUp(image, vendorId, employeeOwnerName, employeeOwnerImage, category, categoryImage).then((value) {
        //context.pushNamed(AppRoutingName.manageEmployee);
        context.pop();
      });
    }
  }
}