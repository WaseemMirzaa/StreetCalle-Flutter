import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/generated/locale_keys.g.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 20,),
          const SizedBox(),
          SvgPicture.asset(AppAssets.logo, width: defaultLogoSize, height: defaultLogoSize,),
          // const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Text(
              //TempLanguage().lblQuote,
              LocaleKeys.quote.tr(),
              textAlign: TextAlign.center,
              style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.secondaryFontColor),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 44.0),
                child: SizedBox(
                  width: context.width,
                  height: defaultButtonSize,
                  child: AppButton(
                    text: LocaleKeys.login.tr(),
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
                    text: LocaleKeys.createAccount.tr(),
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
        ],
      ),
    );
  }
}
