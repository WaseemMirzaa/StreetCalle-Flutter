// import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/screens/home/client_tabs/client_favourites/client_favourite.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/client_home_tab.dart';
import 'package:street_calle/screens/home/client_tabs/client_search/client_search_tab.dart';
import 'package:street_calle/screens/home/settings/settings_tab.dart';
import 'package:street_calle/screens/home/widgets/custom_bottom_nav_item.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/permission_utils.dart';
import 'package:street_calle/widgets/connectivity_checker.dart';
import 'package:street_calle/widgets/location_service.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/filter_cubit.dart';
import 'package:street_calle/generated/locale_keys.g.dart';



class ClientMainScreen extends StatefulWidget {
  const ClientMainScreen({Key? key}) : super(key: key);

  @override
  State<ClientMainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<ClientMainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _clientWidgets = <Widget>[
    ClientHomeTab(),
    ClientSearchTab(),
    ClientFavourite(),
    SettingsTab()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  void initState() {
    super.initState();

    PermissionUtils.checkLocationPermissionsAndNavigateToScreen(context).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapFilterCubit(),
      child: Scaffold(
        body: LocationService(
          child: ConnectivityChecker(child: _clientWidgets.elementAt(_selectedIndex)),
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
                  isSelected: _selectedIndex == 0,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: CustomBottomNavItem(
                  iconAsset: AppAssets.bottomSearch,
                  //text: TempLanguage().lblSearch,
                  text: LocaleKeys.search.tr(),
                  isSelected: _selectedIndex == 1,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: CustomBottomNavItem(
                  iconAsset: AppAssets.favourite,
                  //text: TempLanguage().lblLiked,
                  text: LocaleKeys.liked.tr(),
                  isSelected: _selectedIndex == 2,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: CustomBottomNavItem(
                  iconAsset: AppAssets.more,
                  //text: TempLanguage().lblMore,
                  text: LocaleKeys.more.tr(),
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
      ),
    );
  }
}
