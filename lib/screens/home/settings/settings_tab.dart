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
import 'package:street_calle/utils/common.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sharedPreferencesService = sl.get<SharedPreferencesService>();
    final userCubit = context.read<UserCubit>();
    final firebaseAuth = sl.get<FirebaseAuth>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          TempLanguage().lblSettings,
          style: context.currentTextTheme.titleMedium?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            userCubit.state.isEmployee
                ? const SizedBox.shrink()
                : SettingItem(title: TempLanguage().lblProfile, onTap: userCubit.state.isGuest ? (){
              showGuestLoginDialog(context);
            } : (){
                  if (userCubit.state.isVendor ) {
                    context.pushNamed(AppRoutingName.vendorProfile);
                  } else {
                    context.pushNamed(AppRoutingName.profile);
                  }
            }),
            userCubit.state.isVendor
                ? SettingItem(title: TempLanguage().lblSubscription, onTap: userCubit.state.isGuest ? (){} :  (){context.push(AppRoutingName.vendorSubscriptions);})
                : const SizedBox.shrink(),
            SettingItem(title: TempLanguage().lblPrivacyPolicy, onTap: (){
              context.push(AppRoutingName.privacyPolicy);
            }),
            SettingItem(title: TempLanguage().lblTermsAndConditions, onTap: (){
              context.push(AppRoutingName.termsAndConditions);
            }),

            // SettingItem(title: TempLanguage().lblDeleteAccount, onTap: () async {
            //   bool? result = await context.push(AppRoutingName.deleteAccount);
            //   if (result ?? false) {
            //     await sharedPreferencesService.clearSharedPref();
            //     if (context.mounted) {
            //       context.goNamed(AppRoutingName.authScreen);
            //     }
            //   }
            // }),

            SettingItem(title: TempLanguage().lblSignOut, onTap: () async {
              await firebaseAuth.signOut();
              await sharedPreferencesService.clearSharedPref();
              userCubit.setDefaultState();
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
