import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/home/settings/widgets/settings_item.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/services/shared_preferences_service.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sharedPreferencesService = sl.get<SharedPreferencesService>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          TempLanguage().lblSettings,
          style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryFontColor, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            SettingItem(title: TempLanguage().lblProfile, onTap: (){}),
            BlocSelector<UserCubit, UserState, bool>(
                selector: (userState) => userState.isVendor,
                builder: (context, isVendor) {
                  return isVendor
                      ? SettingItem(title: TempLanguage().lblSubscription, onTap: (){context.push(AppRoutingName.vendorSubscriptions);})
                      : const SizedBox.shrink();
                }
            ),
            SettingItem(title: TempLanguage().lblPrivacyPolicy, onTap: (){
              context.push(AppRoutingName.privacyPolicy);
            }),
            SettingItem(title: TempLanguage().lblTermsAndConditions, onTap: (){
              context.push(AppRoutingName.termsAndConditions);
            }),
            SettingItem(title: TempLanguage().lblSignOut, onTap: () async {
              await FirebaseAuth.instance.signOut();
              await sharedPreferencesService.clearSharedPref();
              if (context.mounted) {
                context.goNamed(AppRoutingName.authScreen);
              }
            }),
          ],
        ),
      ),
    );
  }
}
