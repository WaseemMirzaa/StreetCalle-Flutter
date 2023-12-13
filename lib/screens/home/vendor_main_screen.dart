import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/home/profile/user_profile_tab.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/vendor_home_tab.dart';
import 'package:street_calle/screens/home/settings/settings_tab.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/vendor_menu_tab.dart';
import 'package:street_calle/screens/home/widgets/custom_bottom_nav_item.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/location_utils.dart';
import 'package:street_calle/utils/permission_utils.dart';
import 'package:street_calle/widgets/connectivity_checker.dart';
import 'package:street_calle/widgets/employee_status_checker_widget.dart';
import 'package:street_calle/widgets/location_service.dart';

class VendorMainScreen extends StatefulWidget {
  const VendorMainScreen({Key? key}) : super(key: key);

  @override
  State<VendorMainScreen> createState() => _VendorMainScreenState();
}

class _VendorMainScreenState extends State<VendorMainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    PermissionUtils.checkPermissionsAndNavigateToScreen(context).then((value) {
      LocationUtils.getBackgroundLocation().then((value) {});
    });
  }

  @override
  void dispose() {
    LocationUtils.stopBackgroundLocation();
    super.dispose();
  }

  static const List<Widget> _vendorWidgets = <Widget>[
    VendorHomeTab(),
    VendorMenuTab(),
    UserprofileTab(),
    SettingsTab()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
      body: ConnectivityChecker(
        child: LocationService(
          child: userCubit.state.isEmployee
              ? EmployeeStatusCheckerWidget(child: _vendorWidgets.elementAt(_selectedIndex))
              : _vendorWidgets.elementAt(_selectedIndex),
        ),
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
                text: TempLanguage().lblHome,
                isSelected: _selectedIndex == 0,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: CustomBottomNavItem(
                iconAsset: AppAssets.menu,
                text: TempLanguage().lblMenu,
                isSelected: _selectedIndex == 1,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: CustomBottomNavItem(
                iconAsset: AppAssets.user,
                text: TempLanguage().lblProfile,
                isSelected: _selectedIndex == 2,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: CustomBottomNavItem(
                iconAsset: AppAssets.more,
                text: TempLanguage().lblMore,
                isSelected: _selectedIndex == 3,
              ),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
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
