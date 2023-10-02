import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/auth/cubit/login/login_cubit.dart';
import 'package:street_calle/screens/auth/widgets/custom_text_field.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/utils/common.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 40,),
                Text(
                  TempLanguage().lblLogin,
                  style: context.currentTextTheme.titleMedium?.copyWith(fontFamily: METROPOLIS_MEDIUM),
                ),
                const SizedBox(height: 10,),
                Text(
                  TempLanguage().lblAddYourLoginDetails,
                  style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 14),
                ),
                const SizedBox(
                  height: 150,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CustomTextField(
                    hintText: TempLanguage().lblPassword,
                    keyboardType: TextInputType.visiblePassword,
                    asset: AppAssets.passwordIcon,
                    controller: context.read<LoginCubit>().passwordController,
                    isPassword: true,
                  ),
                ),
                const SizedBox(height: 24,),
                GestureDetector(
                  onTap: (){
                    context.pushNamed(AppRoutingName.forgetPasswordScreen);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        TempLanguage().lblForgetPassword,
                        style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24,),
                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                     if (state is LoginSuccess) {
                      context.pushNamed(AppRoutingName.forgetPasswordScreen);
                    } else if (state is LoginFailure) {
                      showToast(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    return state is LoginLoading
                        ? const CircularProgressIndicator(color: AppColors.primaryColor,)
                        : SizedBox(
                      width: context.width,
                      height: defaultButtonSize,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                        onPressed: ()=> login(context),
                        child: Text(
                          TempLanguage().lblLogin,
                          style: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24,),
                SizedBox(
                  width: context.width,
                  height: defaultButtonSize,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.guestColor,
                    ),
                    onPressed: (){

                    },
                    child: Text(
                      TempLanguage().lblGuest,
                      style: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                    ),
                  ),
                ),
                const SizedBox(height: 24,),
                Text(
                TempLanguage().lblLoginWith, style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 14),),
                const SizedBox(height: 24,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 78.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          //await AuthService.signInWithGoogle();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.placeholderColor),
                          ),
                          child: Image.asset(AppAssets.google, width: 20, height: 20,),
                        ),
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