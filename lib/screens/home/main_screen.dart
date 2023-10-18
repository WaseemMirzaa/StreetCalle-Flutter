import 'package:flutter/material.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/client_home_tab.dart';
import 'package:street_calle/screens/home/profile/user_profile_tab.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/vendor_home_tab.dart';
import 'package:street_calle/screens/home/settings/settings_tab.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/vendor_menu_tab.dart';
import 'package:street_calle/screens/home/widgets/custom_bottom_nav_item.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/app_enum.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.user}) : super(key: key);
  final String user;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  //
  //
  // @override
  // void initState() {
  //   super.initState();
  //   getLocationUpdates();
  // }
  //
  // void getCurrentLocation() {
  //   BackgroundLocation().getCurrentLocation().then((location) {
  //     print('This is current Location ${location.toMap()}');
  //   });
  // }
  //
  // Future<void> getLocationUpdates() async {
  //   var status = await Permission.notification.status;
  //   if (status.isDenied) {
  //     final result = await Permission.notification.request();
  //     if (result.isGranted) {
  //       await BackgroundLocation.setAndroidNotification(
  //         title: 'Background service is running',
  //         message: 'Background location in progress',
  //         icon: '@mipmap/ic_launcher',
  //       );
  //     }
  //   } else {
  //     await BackgroundLocation.setAndroidNotification(
  //       title: 'Background service is running',
  //       message: 'Background location in progress',
  //       icon: '@mipmap/ic_launcher',
  //     );
  //   }
  //
  //   final userService = sl.get<UserService>();
  //   //await BackgroundLocation.setAndroidConfiguration(1000);
  //   await BackgroundLocation.startLocationService(distanceFilter: 10);
  //   BackgroundLocation.getLocationUpdates((location) {
  //
  //     if (location.longitude != null && location.latitude != null) {
  //       final sharedPref = sl.get<SharedPreferencesService>();
  //       userService.updateUserLocation(location.latitude!, location.longitude!, sharedPref.getStringAsync(SharePreferencesKey.USER_ID));
  //      }
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   BackgroundLocation.stopLocationService();
  //   super.dispose();
  // }


  static const List<Widget> _vendorWidgets = <Widget>[
    VendorHomeTab(),
    VendorMenuTab(),
    UserprofileTab(),
    SettingsTab()
  ];

  static const List<Widget> _clientWidgets = <Widget>[
    ClientHomeTab(),
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
      body: widget.user == UserType.client.name
          ?  _clientWidgets.elementAt(_selectedIndex)
          : _vendorWidgets.elementAt(_selectedIndex),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: CustomBottomNavItem(iconAsset: AppAssets.home, text: 'Home', isSelected: _selectedIndex == 0,),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: CustomBottomNavItem(iconAsset: AppAssets.menu, text: 'Menu', isSelected: _selectedIndex == 1,),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: CustomBottomNavItem(iconAsset: AppAssets.user, text: 'Profile', isSelected: _selectedIndex == 2,),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: CustomBottomNavItem(iconAsset: AppAssets.more, text: 'More', isSelected: _selectedIndex == 3,),
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