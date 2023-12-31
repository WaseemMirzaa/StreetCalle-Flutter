import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/screens/selectUser/widgets/build_selected_image.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/utils/permission_utils.dart';
import 'package:street_calle/utils/common.dart';

class SelectUserScreen extends StatefulWidget {
  const SelectUserScreen({Key? key}) : super(key: key);

  @override
  State<SelectUserScreen> createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  UserType _user = UserType.client;
  VendorType _vendor = VendorType.individual;

  List<DropDownItem> items = [
    DropDownItem(
        TempLanguage().lblIndividual,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: SvgPicture.asset(AppAssets.phone),
        )),
    DropDownItem(
      TempLanguage().lblAgency,
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: SvgPicture.asset(AppAssets.people),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    PermissionUtils.requestCustomPermissions(
      scaffoldContext: context,
      onLocationDenied: () {},
      onLocationGranted: () {},
      onNotificationGranted: () {},
      onNotificationDenied: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    //TODO: User can select these options one time only
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 70,
          ),
          Expanded(
            child: SvgPicture.asset(
              AppAssets.logo,
              width: 230,
              height: 230,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BuildSelectableImage(
                    assetPath: AppAssets.clientIcon,
                    isSelected: _user == UserType.client,
                    title: TempLanguage().lblClient,
                    onTap: () {
                      context.read<UserCubit>().setIsVendor(false);
                      setState(() {
                        _user = UserType.client;
                      });
                    },
                  ),
                  BuildSelectableImage(
                    assetPath: AppAssets.vendorIcon,
                    isSelected: _user == UserType.vendor,
                    title: TempLanguage().lblVendor,
                    onTap: () {
                      context.read<UserCubit>().setIsVendor(true);
                      setState(() {
                        _user = UserType.vendor;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          _user.name == UserType.vendor.name
              ? Expanded(
                  child: Column(
                    children: [
                      Text(
                        TempLanguage().lblPleaseSelectVendorType,
                        style: context.currentTextTheme.displaySmall!.copyWith(
                            color: AppColors.primaryFontColor, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60.0),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.blackColor.withOpacity(0.15),
                                spreadRadius: 3, // Spread radius
                                blurRadius: 15, // Blur radius
                                offset: const Offset(
                                    1, 3), // Offset in the Y direction
                              ),
                            ],
                          ),
                          child: DropdownButtonFormField<DropDownItem>(
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconEnabledColor: AppColors.primaryColor,
                            value: items.first,
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              if (value.title.toLowerCase() ==
                                  VendorType.individual.name.toLowerCase()) {
                                _vendor = VendorType.individual;
                              } else {
                                _vendor = VendorType.agency;
                              }
                            },
                            selectedItemBuilder: (BuildContext context) {
                              return items.map<Widget>((DropDownItem item) {
                                return Row(
                                  children: <Widget>[
                                    Container(
                                      width: 30,
                                      height: 30,
                                      //padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primaryLightColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: item.icon,
                                    ),
                                    const SizedBox(width: 10),
                                    // Space between image and text
                                    Text(item.title),
                                  ],
                                );
                              }).toList();
                            },
                            borderRadius: BorderRadius.circular(40),
                            items: items.map((item) {
                              return DropdownMenuItem<DropDownItem>(
                                value: item,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primaryLightColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: item.icon,
                                    ),
                                    Text(item.title),
                                  ],
                                ),
                              );
                            }).toList(),
                            style: context.currentTextTheme.labelSmall
                                ?.copyWith(
                                    fontSize: 18,
                                    color: AppColors.primaryFontColor),
                            decoration: InputDecoration(
                              //contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                              //isDense: true,
                              filled: true,
                              fillColor: AppColors.whiteColor,
                              border: vendorSelectionBorder,
                              enabledBorder: vendorSelectionBorder,
                              focusedBorder: vendorSelectionBorder,
                              disabledBorder: vendorSelectionBorder,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 54.0),
                child: SizedBox(
                  width: context.width,
                  height: defaultButtonSize,
                  child: AppButton(
                    text: TempLanguage().lblNext,
                    elevation: 0.0,
                    onTap: () {
                      if (_user.name == UserType.vendor.name) {
                        context.read<UserCubit>().setVendorType(_vendor.name);
                      }

                      context.pushNamed(
                          _user.name == UserType.client.name
                              ? AppRoutingName.clientMainScreen
                              : AppRoutingName.mainScreen,
                          pathParameters: {USER: _user.name});
                    },
                    shapeBorder: RoundedRectangleBorder(
                        side: const BorderSide(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(30)),
                    textStyle: context.currentTextTheme.labelLarge
                        ?.copyWith(color: AppColors.whiteColor),
                    color: AppColors.primaryColor,
                  ),
                  // child: ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: AppColors.primaryColor,
                  //   ),
                  //   onPressed: (){
                  //     context.pushNamed(_user.name == UserType.client.name ? AppRoutingName.clientMainScreen : AppRoutingName.mainScreen, pathParameters: {USER: _user.name});
                  //   },
                  //   child: Text(
                  //     TempLanguage().lblNext,
                  //     style: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                  //   ),
                  // ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DropDownItem {
  final String title;
  final Widget icon;

  DropDownItem(this.title, this.icon);
}
