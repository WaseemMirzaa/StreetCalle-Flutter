import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/home/profile/cubit/profile_status_cubit.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
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
    init();
  }

  void init() {
    final sharedPreferencesService = sl.get<SharedPreferencesService>();
    final isLoggedIn = sharedPreferencesService.getBoolAsync(SharePreferencesKey.IS_LOGGED_IN);

    Timer(const Duration(milliseconds: 3000), () {
      if (isLoggedIn) {
        final userCubit = context.read<UserCubit>();

        final isOnline = sharedPreferencesService.getBoolAsync(SharePreferencesKey.IS_ONLINE);
        final isVendor = sharedPreferencesService.getBoolAsync(SharePreferencesKey.IS_VENDOR);
        final isEmployee = sharedPreferencesService.getBoolAsync(SharePreferencesKey.IS_EMPLOYEE);
        final isEmployeeBlocked = sharedPreferencesService.getBoolAsync(SharePreferencesKey.IS_EMPLOYEE_BLOCKED);
        final isSubscribed = sharedPreferencesService.getBoolAsync(SharePreferencesKey.IS_SUBSCRIBED);
        final userType = sharedPreferencesService.getStringAsync(SharePreferencesKey.USER_TYPE);


        userCubit.setUserId(sharedPreferencesService.getStringAsync(SharePreferencesKey.USER_ID));
        userCubit.setVendorId(sharedPreferencesService.getStringAsync(SharePreferencesKey.VENDOR_ID));

        userCubit.setUsername(sharedPreferencesService.getStringAsync(SharePreferencesKey.USER_NAME));
        userCubit.setUserImage(sharedPreferencesService.getStringAsync(SharePreferencesKey.USER_IMAGE));
        userCubit.setUserPhone(sharedPreferencesService.getStringAsync(SharePreferencesKey.USER_NUMBER));
        userCubit.setUserEmail(sharedPreferencesService.getStringAsync(SharePreferencesKey.USER_EMAIL));
        userCubit.setUserAbout(sharedPreferencesService.getStringAsync(SharePreferencesKey.USER_ABOUT));
        userCubit.setUserCountryCode(sharedPreferencesService.getStringAsync(SharePreferencesKey.COUNTRY_CODE));
        userCubit.setVendorType(sharedPreferencesService.getStringAsync(SharePreferencesKey.VENDOR_TYPE));
        userCubit.setSubscriptionType(sharedPreferencesService.getStringAsync(SharePreferencesKey.SUBSCRIPTION_TYPE));


        userCubit.setIsOnline(isOnline);
        userCubit.setIsLoggedIn(isLoggedIn);
        userCubit.setIsVendor(isVendor);
        userCubit.setIsEmployee(isEmployee);
        userCubit.setIsEmployeeBlocked(isEmployeeBlocked);
        userCubit.setIsSubscribed(isSubscribed);

        userCubit.setEmployeeOwnerName(sharedPreferencesService.getStringAsync(SharePreferencesKey.EMPLOYEE_OWNER_NAME));
        userCubit.setEmployeeOwnerImage(sharedPreferencesService.getStringAsync(SharePreferencesKey.EMPLOYEE_OWNER_IMAGE));

        context.read<ProfileStatusCubit>().defaultStatus(userCubit.state.isOnline);

        if (userType.isEmpty) {
            context.goNamed(AppRoutingName.selectUserScreen);
        } else {
          if (isVendor || isEmployee || userType == UserType.vendor.name) {
            context.goNamed(AppRoutingName.mainScreen);
          } else {
            context.goNamed(AppRoutingName.clientMainScreen);
          }
        }

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
