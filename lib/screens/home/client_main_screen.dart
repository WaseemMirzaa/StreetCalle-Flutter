import 'package:flutter/material.dart';
import 'package:street_calle/screens/home/client_tabs/client_favourites/client_favourite.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/client_home_tab.dart';
import 'package:street_calle/screens/home/settings/settings_tab.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/vendor_menu_tab.dart';
import 'package:street_calle/screens/home/widgets/custom_bottom_nav_item.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';

class ClientMainScreen extends StatefulWidget {
  const ClientMainScreen({Key? key, required this.user}) : super(key: key);
  final String user;

  @override
  State<ClientMainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<ClientMainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _clientWidgets = <Widget>[
    ClientHomeTab(),
    VendorMenuTab(),
    ClientFavourite(),
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
      body: _clientWidgets.elementAt(_selectedIndex),
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
              icon: CustomBottomNavItem(iconAsset: AppAssets.bottomSearch, text: 'Search', isSelected: _selectedIndex == 1,),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: CustomBottomNavItem(iconAsset: AppAssets.favourite, text: 'Favourites', isSelected: _selectedIndex == 2,),
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