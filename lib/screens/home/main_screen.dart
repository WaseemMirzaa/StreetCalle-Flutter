import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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




var auth = FirebaseAuth.instance.currentUser;
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.userName}) : super(key: key);
  final String userName;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // init();
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
    return Scaffold(
      // TODO: Maybe there is better solution for it
      // body: LocationService(
      //   child: widget.userName == UserType.client.name
      //       ? _clientWidgets.elementAt(_selectedIndex)
      //       : _vendorWidgets.elementAt(_selectedIndex),
      // ),
      body: _vendorWidgets.elementAt(_selectedIndex),
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
