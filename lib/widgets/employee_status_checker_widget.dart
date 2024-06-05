import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/services/shared_preferences_service.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/generated/locale_keys.g.dart';

class EmployeeStatusCheckerWidget extends StatelessWidget {
  const EmployeeStatusCheckerWidget({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    final userService = sl.get<UserService>();

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: StreamBuilder<DocumentSnapshot<User>>(
          stream: userService.getUser(userCubit.state.userId),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final status = snapshot.data!;
              if (status.data()?.isEmployeeBlocked ?? false) {
                return const EmployeeBlockWidget();
              } else {
                return child;
              }
            }
            return const Center(child: CircularProgressIndicator()); // Loading indicator while waiting for data.
          },
        ),
      ),
    );
  }
}


class EmployeeBlockWidget extends StatelessWidget {
  const EmployeeBlockWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sharedPreferencesService = sl.get<SharedPreferencesService>();
    final firebaseAuth = sl.get<FirebaseAuth>();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                AppAssets.logo,
                // scale: 4,
                height: 300,
                fit: BoxFit.fitHeight,
              ),
              Text(
                LocaleKeys.youHaveBennBlockedByAdmin.tr(),
                textAlign: TextAlign.center,
                style: context.currentTextTheme.labelLarge,
              ),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 44.0),
                child: SizedBox(
                  width: context.width,
                  height: defaultButtonSize,
                  child: AppButton(
                    text: LocaleKeys.signOut.tr(),
                    elevation: 0.0,
                    onTap: () async {
                      await firebaseAuth.signOut();
                      await sharedPreferencesService.clearSharedPref();
                      if (context.mounted) {
                        context.goNamed(AppRoutingName.authScreen);
                      }
                    },
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    ),
                    textStyle: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
