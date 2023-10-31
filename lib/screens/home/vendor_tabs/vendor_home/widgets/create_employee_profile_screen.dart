
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/auth/cubit/create_employee/create_employee_cubit.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/screens/auth/widgets/custom_text_field.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';


class CreateEmployeeProfileScreen extends StatefulWidget {
   CreateEmployeeProfileScreen({Key? key}) : super(key: key);

  @override
  State<CreateEmployeeProfileScreen> createState() => _CreateEmployeeProfileScreenState();
}

class _CreateEmployeeProfileScreenState extends State<CreateEmployeeProfileScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                AppAssets.backIcon,
                width: 20,
                height: 20,
              )
            ],
          ),
        ),
        title: Text(
          TempLanguage().lblCreateEmployeeProfile,
          style: context.currentTextTheme.titleMedium
              ?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultHorizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 24,
                ),


                BlocBuilder<ImageCubit, ImageState>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () async {
                        context.read<ImageCubit>().selectImage();
                      },
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blackColor.withOpacity(0.35),
                              spreadRadius: 0.5, // Spread radius
                              blurRadius: 4, // Blur radius
                              offset: const Offset(1, 4), // Offset in the Y direction
                            ),
                          ],
                        ),
                        child: state.selectedImage.path.isNotEmpty
                            ?

                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(File(state.selectedImage.path), fit: BoxFit.cover,
                              width: 120,
                              height: 120,),
                          ),
                        )

                            :
                        Center(
                          child: Image.asset(
                            AppAssets.camera,
                            width: 60,
                            height: 60,
                          ),
                        ),
                      ),
                    );
                  },
                ),


                const SizedBox(
                  height: 24,
                ),
                const Divider(
                  color: AppColors.dividerColor,
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomTextField(
                  hintText: TempLanguage().lblUserName,
                  keyboardType: TextInputType.name,
                  asset: AppAssets.person,
                  controller: context.read<CreateEmployeeCubit>().nameController,
                  isPassword: false,
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomTextField(
                  hintText: TempLanguage().lblEmail,
                  keyboardType: TextInputType.emailAddress,
                  asset: AppAssets.emailIcon,
                  controller: context.read<CreateEmployeeCubit>().emailController,
                  isPassword: false,
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomTextField(
                  hintText: TempLanguage().lblPassword,
                  keyboardType: TextInputType.visiblePassword,
                  asset: AppAssets.passwordIcon,
                  controller: context.read<CreateEmployeeCubit>().passwordController,
                  isPassword: true,
                  isObscure: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: AppColors.primaryFontColor),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: Text(
                        TempLanguage().lblSetEmployeeCredentials,
                        style: context.currentTextTheme.displaySmall
                            ?.copyWith(color: AppColors.primaryFontColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
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
                          text: TempLanguage().lblAddNewEmployee,
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
                        // child: ElevatedButton(
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: AppColors.primaryColor,
                        //     ),
                        //     onPressed: () => signUp(context),
                        //     child: Text(
                        //       TempLanguage().lblSignUp,
                        //       style: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                        //     ),
                        // ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Future<void> signUp(BuildContext context) async {
    final imageCubit = context.read<ImageCubit>();
    final createEmployeeCubit = context.read<CreateEmployeeCubit>();
    final image = imageCubit.state.selectedImage.path;
    final name = createEmployeeCubit.nameController.text;
    final email = createEmployeeCubit.emailController.text;
    final password = createEmployeeCubit.passwordController.text;
    final vendorId = context.read<UserCubit>().state.userId;

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
      createEmployeeCubit.signUp(image,vendorId).then((value) {
        context.pushNamed(AppRoutingName.manageEmployee);
      });
    }
  }

}