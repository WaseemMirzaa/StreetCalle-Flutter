import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/screens/auth/widgets/language_drop_down.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/generated/locale_keys.g.dart';
import 'package:street_calle/models/drop_down_item.dart';
import 'package:street_calle/services/shared_preferences_service.dart';
import 'package:street_calle/main.dart';
import 'package:street_calle/dependency_injection.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  DropDownItem? _selectedItem;
  final List<DropDownItem> _languages = [
    DropDownItem(
        title: 'English',
        translatedTitle: '',
        icon: Image.asset(AppAssets.english,),
        url: ''
    ),
    DropDownItem(
        title: 'Español',
        translatedTitle: '',
        icon: Image.asset(AppAssets.spanish),
        url: ''
    )
  ];

  @override
  void initState() {
    super.initState();
    if (LANGUAGE == 'en') {
      _selectedItem = _languages[0];
    } else {
      _selectedItem = _languages[1];
    }
  }


  @override
  Widget build(BuildContext context) {
    final sharedPreferencesService = sl.get<SharedPreferencesService>();
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        actions: [
          SizedBox(
            width: 150,
            height: 100,
            child: LanguageDropDownWidget(
              initialValue: _selectedItem,
              items: _languages,
              onChanged: (value) {
                _selectedItem = value;
                if (_selectedItem?.title != null && _selectedItem!.title == 'English') {
                  EasyLocalization.of(context)?.setLocale(const Locale('en', ''));
                  sharedPreferencesService.setValue(SharePreferencesKey.LANGUAGE_VALUE, 'en');
                  LANGUAGE = 'en';
                } else {
                  EasyLocalization.of(context)?.setLocale(const Locale('es', ''));
                  sharedPreferencesService.setValue(SharePreferencesKey.LANGUAGE_VALUE, 'es');
                  LANGUAGE = 'es';
                }
              },
            ),
          ),
        ],
      ),
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
