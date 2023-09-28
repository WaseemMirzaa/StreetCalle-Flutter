import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/auth/widgets/custom_text_field.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


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
                      controller: _emailController,
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
                    controller: _passwordController,
                    isPassword: true,
                  ),
                ),
                const SizedBox(height: 24,),
                GestureDetector(
                  onTap: (){
                    context.goNamed(AppRoutingName.forgetPasswordScreen);
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
                SizedBox(
                  width: context.width,
                  height: defaultButtonSize,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    onPressed: (){

                    },
                    child: Text(
                      TempLanguage().lblLogin,
                      style: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                    ),
                  ),
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
                TempLanguage().lblLoginWith,
                style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 14),
               ),
                const SizedBox(height: 24,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 78.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.placeholderColor),
                        ),
                        child: Image.asset(AppAssets.google, width: 20, height: 20,),
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
                          style: context.currentTextTheme.labelSmall?.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold)
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
}
