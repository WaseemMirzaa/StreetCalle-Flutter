import 'package:flutter/material.dart';
import 'package:street_calle/screens/home/vendor_tabs/profile/user_profile_tab.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/vendor_home_tab.dart';
import 'package:street_calle/screens/home/settings/settings_tab.dart';
import 'package:street_calle/screens/home/widgets/custom_bottom_nav_item.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.user}) : super(key: key);
  final String user;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    VendorHomeTab(),
    Text(
      'Index 1: Menu',
      style: optionStyle,
    ),
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
      body: _widgetOptions.elementAt(_selectedIndex),
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