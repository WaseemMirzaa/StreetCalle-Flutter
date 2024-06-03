import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/screens/auth/cubit/checkbox/checkbox_cubit.dart';
import 'package:street_calle/screens/auth/cubit/checkbox/checkbox_state.dart';
import 'package:street_calle/screens/auth/widgets/custom_text_field.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/custom_widgets/custom_intl_phone_field.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/screens/auth/cubit/sign_up/sign_up_cubit.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/home/profile/cubit/profile_status_cubit.dart';
import 'package:street_calle/utils/my_sizer.dart';
import 'package:street_calle/generated/locale_keys.g.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MySizer().init(context);
    return Scaffold(
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 36,),
              Text(
                //TempLanguage().lblSignUp,
                LocaleKeys.signUp.tr(),
                style: context.currentTextTheme.titleMedium,
              ),
              const SizedBox(height: 10,),
              Text(
                //TempLanguage().lblAddYourSignDetails,
                LocaleKeys.addYourSignDetails.tr(),
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
                  //hintText: TempLanguage().lblName,
                  hintText: LocaleKeys.name.tr(),
                  keyboardType: TextInputType.name,
                  asset: AppAssets.person,
                  controller: context.read<SignUpCubit>().nameController,
                  isSmall: true,
                ),
              ),
              const SizedBox(height: 24,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                child: CustomTextField(
                  //hintText: TempLanguage().lblEmail,
                  hintText: LocaleKeys.email.tr(),
                  keyboardType: TextInputType.emailAddress,
                  asset: AppAssets.emailIcon,
                  controller: context.read<SignUpCubit>().emailController,
                  isSmall: false,
                ),
              ),
              const SizedBox(height: 24,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blackColor.withOpacity(0.15),
                        spreadRadius: 1, // Spread radius
                        blurRadius: 15, // Blur radius
                        offset: const Offset(1, 3), // Offset in the Y direction
                      ),
                    ],
                  ),
                  child: CustomIntlPhoneField(
                    dropdownTextStyle: const TextStyle(
                      fontSize: 16
                    ),
                    flagsButtonPadding: const EdgeInsets.all(5.0),
                    controller: context.read<SignUpCubit>().phoneController,
                    disableLengthCheck: true,
                    decoration: InputDecoration(
                      fillColor: AppColors.whiteColor,
                      filled: true,
                      //hintText: TempLanguage().lblPhoneNumber,
                      hintText: LocaleKeys.phoneNumber.tr(),
                      hintStyle: context.currentTextTheme.displaySmall?.copyWith(fontSize: 16, color: AppColors.secondaryFontColor),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(40)
                      ),
                    ),
                    initialCountryCode: initialCountyCode,
                    onChanged: (phone) {
                      //context.read<SignUpCubit>().phoneController.text = phone.completeNumber;
                    },
                    onCountryChanged: (Country? country) {
                      context.read<SignUpCubit>().countryCodeController.text = country?.code ?? initialCountyCode;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                child: CustomTextField(
                  //hintText: TempLanguage().lblPassword,
                  hintText: LocaleKeys.password.tr(),
                  keyboardType: TextInputType.visiblePassword,
                  asset: AppAssets.passwordIcon,
                  controller: context.read<SignUpCubit>().passwordController,
                  isSmall: true,
                  isObscure: true,
                ),
              ),

              const SizedBox(height: 24,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                child: CustomTextField(
                  //hintText: TempLanguage().lblConfirmPassword,
                  hintText: LocaleKeys.confirmPassword.tr(),
                  keyboardType: TextInputType.visiblePassword,
                  asset: AppAssets.passwordIcon,
                  controller: context.read<SignUpCubit>().confirmPasswordController,
                  isSmall: true,
                  isObscure: true,
                ),
              ),
              const SizedBox(height: 15,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    BlocBuilder<CheckBoxCubit, CheckBoxStates>(
                      buildWhen: (previous, current) => previous.isSwitch != current.isSwitch,
                      builder: (context, state) {
                        return Checkbox(
                          value: state.isSwitch,
                          onChanged: (newValue) {
                            context.read<CheckBoxCubit>().enableOrDisableCheckBox(); // Dispatch the event

                            // Access the updated state directly
                            bool updatedValue = context.read<CheckBoxCubit>().state.isSwitch;
                            print(updatedValue);
                          },
                        );
                      },
                    ),

                     Flexible(child: RichText(
                      text: TextSpan(
                        text: LocaleKeys.readAndAgree.tr(),
                          style: context.currentTextTheme.labelSmall,
                        children: [
                          TextSpan(
                            text: LocaleKeys.terms.tr(),
                              style: context.currentTextTheme.labelSmall?.copyWith(color: AppColors.primaryColor,decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap =(){
                                context.push(AppRoutingName.termsAndConditions);
                              }
                          ),
                          TextSpan(
                             text: LocaleKeys.and.tr(),
                           style: context.currentTextTheme.labelSmall,
                         ),
                           TextSpan(
                            text: LocaleKeys.privacyPolicy2.tr(),
                               style: context.currentTextTheme.labelSmall?.copyWith(color: AppColors.primaryColor,decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap =(){
                                  context.push(AppRoutingName.privacyPolicy);
                                }
                          ),
                           TextSpan(
                            text: '.',
                            style: context.currentTextTheme.labelSmall,
                          ),
                        ]


                      )))
                  ],
                ),
              ),
              const SizedBox(height: 24,),
              BlocConsumer<SignUpCubit, SignUpState>(
                listener: (context, state) {
                  if (state is SignUpSuccess) {
                    context.read<UserCubit>().setUserModel(state.user);
                    context.read<ProfileStatusCubit>().defaultStatus(true);
                    context.read<ImageCubit>().resetImage();
                    context.goNamed(AppRoutingName.emailVerificationScreen, pathParameters: {EMAIL: state.user.email ?? ''});
                    context.read<SignUpCubit>().clearControllers();
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
                    child: AppButton(
                      //text: TempLanguage().lblSignUp,
                      text: LocaleKeys.signUp.tr(),
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
              const SizedBox(height: 24,),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        //text: TempLanguage().lblAlreadyhaveAccount,
                        text: LocaleKeys.alreadyhaveAccount.tr(),
                        style: context.currentTextTheme.labelSmall
                    ),
                    TextSpan(
                        //text: TempLanguage().lblLogin,
                        text: LocaleKeys.login.tr(),
                        style: context.currentTextTheme.labelSmall?.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()..onTap = () => context.pushNamed(AppRoutingName.loginScreen),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),

            ],
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
    var phone = signUpCubit.phoneController.text;
    final countryCode = signUpCubit.countryCodeController.text;
    final password = signUpCubit.passwordController.text;
    final confirmPassword = signUpCubit.confirmPasswordController.text;
    bool isCheckBoxChecked = context.read<CheckBoxCubit>().state.isSwitch;

    Country country = countries.where((element) => element.code == (countryCode.isEmpty ? initialCountyCode : countryCode)).first;

    if (image.isEmpty) {
      //showToast(context, TempLanguage().lblSelectImage);
      showToast(context, LocaleKeys.selectImage.tr());
    } else if (name.isEmpty) {
      if (name.length < 3) {
        //showToast(context, TempLanguage().lblEnterYourName);
        showToast(context, LocaleKeys.enterYourName.tr());
      } else {
        //showToast(context, TempLanguage().lblNameMustBeGrater);
        showToast(context, LocaleKeys.nameMustBeGrater.tr());
      }
    } else if (email.isEmpty || !email.validateEmailEnhanced()) {
      //showToast(context, TempLanguage().lblEnterYourEmail);
      showToast(context, LocaleKeys.enterYourEmail.tr());
    } else if (phone.isEmpty || phone.length != country.minLength || !phone.validatePhone()) {
      //showToast(context, TempLanguage().lblEnterYourPhone);
      showToast(context, LocaleKeys.enterYourPhone.tr());
    } else if (password.isEmpty || password.length < 6) {
      //showToast(context, TempLanguage().lblPasswordMustBeGreater);
      showToast(context, LocaleKeys.passwordMustBeGreater.tr());
    } else if (confirmPassword.isEmpty || confirmPassword.length < 6) {
      //showToast(context, TempLanguage().lblPasswordMustBeGreater);
      showToast(context, LocaleKeys.passwordMustBeGreater.tr());
    } else if (password != confirmPassword) {
      //showToast(context, TempLanguage().lblPasswordMismatch);
      showToast(context, LocaleKeys.passwordMismatch.tr());
    } else if (!isCheckBoxChecked) {
      //showToast(context, 'Please Accept the Terms of Use and Privacy Policy to sign up');
      showToast(context, LocaleKeys.acceptTermOfUse.tr());
    } else {
      signUpCubit.signUp(image);
    }
  }
}