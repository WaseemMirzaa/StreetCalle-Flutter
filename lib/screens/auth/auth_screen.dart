import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          const Spacer(),
          const SizedBox(height: 20,),
          SvgPicture.asset(AppAssets.logo, width: defaultLogoSize, height: defaultLogoSize,),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Text(
              TempLanguage().lblQuote,
              textAlign: TextAlign.center,
              style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.secondaryFontColor),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 44.0),
                  child: SizedBox(
                    width: context.width,
                    height: defaultButtonSize,
                    child: AppButton(
                      text: TempLanguage().lblLogin,
                      elevation: 0.0,
                      onTap: () {
                        context.pushNamed(AppRoutingName.loginScreen);
                      },
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                      ),
                      textStyle: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 44.0),
                  child: SizedBox(
                    width: context.width,
                    height: defaultButtonSize,
                    child: AppButton(
                      text: TempLanguage().lblCreateAccount,
                      elevation: 0.0,
                      onTap: () {
                        context.pushNamed(AppRoutingName.signUpScreen);
                      },
                      shapeBorder: RoundedRectangleBorder(
                          side: const BorderSide(color: AppColors.primaryColor),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      textStyle: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.primaryColor),
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
