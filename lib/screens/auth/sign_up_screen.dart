import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/auth/widgets/custom_text_field.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/screens/auth/cubit/sign_up/sign_up_cubit.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/home/profile/cubit/profile_status_cubit.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultVerticalPadding),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20,),
                Text(
                  TempLanguage().lblSignUp,
                  style: context.currentTextTheme.titleMedium,
                ),
                const SizedBox(height: 10,),
                Text(
                  TempLanguage().lblAddYourSignDetails,
                  style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 15, color: AppColors.secondaryFontColor),
                ),

                const SizedBox(height: 24,),
                BlocBuilder<ImageCubit, ImageState>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () async {
                        context.read<ImageCubit>().selectImage();
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor,
                        ),
                        child: state.selectedImage.path.isNotEmpty
                        ? ClipOval(
                          child: Image.file(File(state.selectedImage.path), fit: BoxFit.cover),
                        )
                        : const Icon(Icons.image_outlined, color: AppColors.whiteColor,),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                  child: CustomTextField(
                    hintText: TempLanguage().lblName,
                    keyboardType: TextInputType.name,
                    asset: AppAssets.person,
                    controller: context.read<SignUpCubit>().nameController,
                    isPassword: true,
                  ),
                ),
                const SizedBox(height: 24,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                  child: CustomTextField(
                    hintText: TempLanguage().lblEmail,
                    keyboardType: TextInputType.emailAddress,
                    asset: AppAssets.emailIcon,
                    controller: context.read<SignUpCubit>().emailController,
                    isPassword: false,
                  ),
                ),
                const SizedBox(height: 24,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                  child: CustomTextField(
                    hintText: TempLanguage().lblPhone,
                    keyboardType: TextInputType.phone,
                    asset: AppAssets.phone,
                    controller: context.read<SignUpCubit>().phoneController,
                    isPassword: false,
                  ),
                ),
                const SizedBox(height: 24,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                  child: CustomTextField(
                    hintText: TempLanguage().lblPassword,
                    keyboardType: TextInputType.visiblePassword,
                    asset: AppAssets.passwordIcon,
                    controller: context.read<SignUpCubit>().passwordController,
                    isPassword: true,
                    isObscure: true,
                  ),
                ),
                const SizedBox(height: 24,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                  child: CustomTextField(
                    hintText: TempLanguage().lblConfirmPassword,
                    keyboardType: TextInputType.visiblePassword,
                    asset: AppAssets.passwordIcon,
                    controller: context.read<SignUpCubit>().confirmPasswordController,
                    isPassword: true,
                    isObscure: true,
                  ),
                ),
                const SizedBox(height: 24,),

                BlocConsumer<SignUpCubit, SignUpState>(
                  listener: (context, state) {
                    if (state is SignUpSuccess) {
                      context.read<UserCubit>().setUserModel(state.user);
                      context.read<ProfileStatusCubit>().defaultStatus(true);
                      context.pushNamed(AppRoutingName.emailVerificationScreen, pathParameters: {EMAIL: context.read<SignUpCubit>().emailController.text});
                    } else if (state is SignUpFailure) {
                      showToast(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    return state is SignUpLoading
                        ? const CircularProgressIndicator(color: AppColors.primaryColor,)
                        : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                          child: SizedBox(
                      width: context.width,
                      height: defaultButtonSize,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                          ),
                          onPressed: () => signUp(context),
                          child: Text(
                            TempLanguage().lblSignUp,
                            style: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                          ),
                      ),
                    ),
                        );
                  },
                ),

                const SizedBox(height: 24,),

                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: TempLanguage().lblAlreadyhaveAccount,
                          style: context.currentTextTheme.labelSmall
                      ),
                      TextSpan(
                          text: TempLanguage().lblLogin,
                          style: context.currentTextTheme.labelSmall?.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = () => context.pushNamed(AppRoutingName.loginScreen),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signUp(BuildContext context) async {
    final imageCubit = context.read<ImageCubit>();
    final signUpCubit = context.read<SignUpCubit>();
    final image = imageCubit.state.selectedImage.path;
    final name = signUpCubit.nameController.text;
    final email = signUpCubit.emailController.text;
    final phone = signUpCubit.phoneController.text;
    final password = signUpCubit.passwordController.text;
    final confirmPassword = signUpCubit.confirmPasswordController.text;

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
    } else if (phone.isEmpty || !phone.validatePhone()) {
      showToast(context, TempLanguage().lblEnterYourPhone);
    } else if (password.isEmpty || password.length < 6) {
      showToast(context, TempLanguage().lblPasswordMustBeGreater);
    } else if (confirmPassword.isEmpty || confirmPassword.length < 6) {
      showToast(context, TempLanguage().lblPasswordMustBeGreater);
    } else if (password != confirmPassword) {
      showToast(context, TempLanguage().lblPasswordMismatch);
    } else {
      signUpCubit.signUp(image);
    }
  }
}