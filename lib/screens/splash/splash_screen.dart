import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/home/profile/cubit/profile_status_cubit.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';

import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/services/shared_preferences_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    final sharedPreferencesService = sl.get<SharedPreferencesService>();
    final isLoggedIn = sharedPreferencesService.getBoolAsync(SharePreferencesKey.IS_LOGGED_IN);
    Timer(const Duration(milliseconds: 3000), () {
      if (isLoggedIn) {
        final userCubit = context.read<UserCubit>();
        userCubit.setUserImage(sharedPreferencesService.getStringAsync(SharePreferencesKey.USER_IMAGE));
        userCubit.setUserId(sharedPreferencesService.getStringAsync(SharePreferencesKey.USER_ID));
        userCubit.setUsername(sharedPreferencesService.getStringAsync(SharePreferencesKey.USER_NAME));
        userCubit.setUserPhone(sharedPreferencesService.getStringAsync(SharePreferencesKey.USER_NUMBER));
        userCubit.setUserEmail(sharedPreferencesService.getStringAsync(SharePreferencesKey.USER_EMAIL));
        userCubit.setIsOnline(sharedPreferencesService.getBoolAsync(SharePreferencesKey.IS_ONLINE));
        userCubit.setUserCountryCode(sharedPreferencesService.getStringAsync(SharePreferencesKey.COUNTRY_CODE));
        context.read<ProfileStatusCubit>().defaultStatus(userCubit.state.isOnline);
        context.goNamed(AppRoutingName.selectUserScreen);
      } else {
        context.goNamed(AppRoutingName.authScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Center(
          child: SvgPicture.asset(AppAssets.logo, width: defaultLogoSize, height: defaultLogoSize,),
        ),
      ),
    );
  }
}
