import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/revenucat/revenu_cat_api.dart';
import 'package:street_calle/screens/home/profile/user_profile_tab.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/vendor_home_tab.dart';
import 'package:street_calle/screens/home/settings/settings_tab.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/vendor_menu_tab.dart';
import 'package:street_calle/screens/home/widgets/custom_bottom_nav_item.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/location_utils.dart';
import 'package:street_calle/utils/permission_utils.dart';
import 'package:street_calle/widgets/connectivity_checker.dart';
import 'package:street_calle/widgets/employee_status_checker_widget.dart';
import 'package:street_calle/widgets/location_service.dart';

import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/generated/locale_keys.g.dart';

class VendorMainScreen extends StatefulWidget {
  const VendorMainScreen({Key? key}) : super(key: key);

  @override
  State<VendorMainScreen> createState() => _VendorMainScreenState();
}

class _VendorMainScreenState extends State<VendorMainScreen> with WidgetsBindingObserver {
  BottomNavPosition _navPosition = BottomNavPosition.home;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    init();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      // went to Background
    } else if(state == AppLifecycleState.resumed) {
      // went to Foreground
      final userCubit = context.read<UserCubit>();
      final userService = sl.get<UserService>();

      final isSubscribed = await RevenuCatAPI.checkSubscriptionStatus();
      if (!isSubscribed && userCubit.state.isSubscribed) {
        await userService.updateUserSubscription(false, SubscriptionType.none.name, userCubit.state.userId, '');
        userCubit.setPlanLookUpKey('');
        userCubit.setIsSubscribed(false);
        userCubit.setSubscriptionId('');
      }
    }
  }

  Future<void> init() async {
    PermissionUtils.checkPermissionsAndNavigateToScreen(context).then((value) {
      LocationUtils.getBackgroundLocation().then((value) {});
    });

    final userCubit = context.read<UserCubit>();
    final userService = sl.get<UserService>();

    await RevenuCatAPI().initPlatformState(FirebaseAuth.instance.currentUser!.uid, userCubit.state.vendorType);
    final isSubscribed = await RevenuCatAPI.checkSubscriptionStatus();
    if (!isSubscribed && userCubit.state.isSubscribed) {
      await userService.updateUserSubscription(false, SubscriptionType.none.name, userCubit.state.userId, '');
      userCubit.setPlanLookUpKey('');
      userCubit.setIsSubscribed(false);
      userCubit.setSubscriptionId('');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    LocationUtils.stopBackgroundLocation();
    super.dispose();
  }

  static const List<Widget> _vendorWidgets = <Widget>[
    VendorHomeTab(),
    VendorMenuTab(),
    UserprofileTab(),
    SettingsTab()
  ];

  final Map<BottomNavPosition, int> _navMap = {
    BottomNavPosition.home: 0,
    BottomNavPosition.menu: 1,
    BottomNavPosition.profile: 2,
    BottomNavPosition.settings: 3,
  };

  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          _navPosition = BottomNavPosition.home;
          return;
        case 1:
          _navPosition = BottomNavPosition.menu;
          return;
        case 2:
          _navPosition = BottomNavPosition.profile;
          return;
        case 3:
          _navPosition = BottomNavPosition.settings;
          return;

        default:
          _navPosition = BottomNavPosition.home;
          return;
      }
      //_selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();

    return Scaffold(
      // TODO: Maybe there is better solution for it
      // body: LocationService(
      //   child: widget.userName == UserType.client.name
      //       ? _clientWidgets.elementAt(_selectedIndex)
      //       : _vendorWidgets.elementAt(_selectedIndex),
      // ),
      body: LocationService(
        child: userCubit.state.isEmployee
            ? EmployeeStatusCheckerWidget(
                child: ConnectivityChecker(
                child: _vendorWidgets.elementAt(_navMap[_navPosition]!),
              ))
            : ConnectivityChecker(child: _vendorWidgets.elementAt(_navMap[_navPosition]!)),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: CustomBottomNavItem(
                iconAsset: AppAssets.home,
                //text: TempLanguage().lblHome,
                text: LocaleKeys.home.tr(),
                isSelected: _navPosition == BottomNavPosition.home,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: CustomBottomNavItem(
                iconAsset: AppAssets.menu,
                //text: TempLanguage().lblMenu,
                text: LocaleKeys.menu.tr(),
                isSelected: _navPosition == BottomNavPosition.menu,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: CustomBottomNavItem(
                iconAsset: AppAssets.user,
                //text: TempLanguage().lblProfile,
                text: LocaleKeys.profile.tr(),
                isSelected: _navPosition == BottomNavPosition.profile,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: CustomBottomNavItem(
                iconAsset: AppAssets.more,
                //text: TempLanguage().lblMore,
                text: LocaleKeys.more.tr(),
                isSelected: _navPosition == BottomNavPosition.settings,
              ),
              label: '',
            ),
          ],
          currentIndex: _navMap[_navPosition]!,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          enableFeedback: false,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          backgroundColor: AppColors.whiteColor,
        ),
      ),
    );
  }
}
