import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/screens/auth/cubit/google_login/google_login_cubit.dart';
import 'package:street_calle/screens/auth/cubit/login/login_cubit.dart';
import 'package:street_calle/screens/auth/widgets/custom_text_field.dart';
import 'package:street_calle/screens/home/profile/cubit/profile_status_cubit.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/screens/auth/cubit/guest/guest_cubit.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/utils/constant/app_enum.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
                  TempLanguage().lblLogin,
                  style: context.currentTextTheme.titleMedium,
                ),
                const SizedBox(height: 5,),
                Text(
                  TempLanguage().lblAddYourLoginDetails,
                  style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 15, color: AppColors.secondaryFontColor),
                ),
                const SizedBox(
                  height: 150,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                  child: CustomTextField(
                      hintText: TempLanguage().lblEmail,
                      keyboardType: TextInputType.emailAddress,
                      asset: AppAssets.emailIcon,
                      controller: context.read<LoginCubit>().emailController,
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
                    controller: context.read<LoginCubit>().passwordController,
                    isPassword: true,
                    isObscure: true,
                  ),
                ),
                const SizedBox(height: 24,),
                GestureDetector(
                  onTap: (){
                    context.pushNamed(AppRoutingName.passwordResetScreen);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        TempLanguage().lblForgetPassword,
                        style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24,),
                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                     if (state is LoginSuccess) {
                       context.read<UserCubit>().setUserModel(state.user, isLoggedIn: true);
                       context.read<ProfileStatusCubit>().defaultStatus(true);
                       //context.pushNamed(AppRoutingName.selectUserScreen);

                       if (state.user.isVendor || state.user.isEmployee) {
                         context.goNamed(AppRoutingName.mainScreen, pathParameters: {USER: UserType.vendor.name});
                       } else {
                         context.goNamed(AppRoutingName.clientMainScreen, pathParameters: {USER: UserType.client.name});
                       }

                     } else if (state is LoginFailure) {
                      showToast(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    return state is LoginLoading
                        ? const CircularProgressIndicator(color: AppColors.primaryColor,)
                        : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                          child: SizedBox(
                      width: context.width,
                      height: defaultButtonSize,
                      child: AppButton(
                        text: TempLanguage().lblLogin,
                        elevation: 0.0,
                        onTap: () {
                          login(context);
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
                      //     onPressed: ()=> login(context),
                      //     child: Text(
                      //       TempLanguage().lblLogin,
                      //       style: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                      //     ),
                      // ),
                    ),
                        );
                  },
                ),
                const SizedBox(height: 24,),

                BlocConsumer<GuestCubit, GuestState>(
                  builder: (context, state) {
                    return state is GuestLoginLoading
                        ? const CircularProgressIndicator(color: AppColors.guestColor,)
                        : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                          child: SizedBox(
                      width: context.width,
                      height: defaultButtonSize,
                      child: AppButton(
                        text: TempLanguage().lblGuest,
                        elevation: 0.0,
                        onTap: () {
                          context.read<GuestCubit>().signInAsGuest();
                        },
                        shapeBorder: RoundedRectangleBorder(
                            side: const BorderSide(color: AppColors.primaryColor),
                            borderRadius: BorderRadius.circular(30)
                        ),
                        textStyle: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                        color: AppColors.guestColor,
                      ),
                      // child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: AppColors.guestColor,
                      //     ),
                      //     onPressed: ()=> context.read<GuestCubit>().signInAsGuest(),
                      //     child: Text(
                      //       TempLanguage().lblGuest,
                      //       style: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                      //     ),
                      // ),
                    ),
                        );
                  },
                  listener: (context, state) {
                    if (state is GuestLoginFailure) {
                      showToast(context, state.error);
                    } else if (state is GuestLoginSuccess) {
                      context.goNamed(AppRoutingName.selectUserScreen);
                    }
                  },
                ),
                const SizedBox(height: 24,),
                Text(
                TempLanguage().lblLoginWith, style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 15),),
                const SizedBox(height: 24,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 78.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocConsumer<GoogleLoginCubit, GoogleLoginState>(
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () {
                              showLoadingDialog(context, null);
                              context.read<GoogleLoginCubit>().googleSignIn();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.placeholderColor),
                              ),
                              child: Image.asset(AppAssets.google, width: 20, height: 20,),
                            ),
                          );
                        },
                        listener: (context, state) {
                          if (state is GoogleLoginFailure) {
                            Navigator.pop(context);
                            showToast(context, state.error);
                          } else if (state is GoogleLoginSuccess) {
                            Navigator.pop(context);
                            context.goNamed(AppRoutingName.selectUserScreen);
                          }
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.placeholderColor)
                        ),
                        child: Image.asset(AppAssets.facebook, width: 20, height: 20,),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.placeholderColor)
                        ),
                        child: Image.asset(AppAssets.twitter, width: 20, height: 20,),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24,),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: TempLanguage().lblDonthaveAccount,
                        style: context.currentTextTheme.labelSmall
                      ),
                      TextSpan(
                          text: TempLanguage().lblSignUp,
                          style: context.currentTextTheme.labelSmall?.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()..onTap = () => context.pushNamed(AppRoutingName.signUpScreen),
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

  Future<void> login(BuildContext context) async {
    final loginCubit = context.read<LoginCubit>();
    final email = loginCubit.emailController.text;
    final password = loginCubit.passwordController.text;

    if (email.isEmpty || !email.validateEmailEnhanced()) {
      showToast(context, TempLanguage().lblEnterYourEmail);
    } else if (password.isEmpty || password.length < 6) {
      showToast(context, TempLanguage().lblPasswordMustBeGreater);
    }  else {
      loginCubit.login();
    }
  }
}
