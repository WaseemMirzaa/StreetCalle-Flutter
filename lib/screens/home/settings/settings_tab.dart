import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/main.dart';
import 'package:street_calle/screens/home/settings/widgets/settings_item.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          TempLanguage().lblSettings,
          style: context.currentTextTheme.titleMedium?.copyWith(color: AppColors.primaryFontColor, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            SettingItem(title: 'Profile', onTap: (){}),
            SettingItem(title: 'Subscription', onTap: (){
              context.push(AppRoutingName.vendorSubscriptions);
            }),
            SettingItem(title: 'Privacy Policy', onTap: (){
              context.push(AppRoutingName.privacyPolicy);
            }),
            SettingItem(title: 'Terms & Conditions', onTap: (){
              context.push(AppRoutingName.termsAndConditions);
            }),
            SettingItem(title: 'Sign Out', onTap: () async {
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
