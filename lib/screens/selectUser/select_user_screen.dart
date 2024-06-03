import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/screens/selectUser/widgets/build_selected_image.dart';
import 'package:street_calle/screens/selectUser/widgets/drop_down_widget.dart';
import 'package:street_calle/screens/selectUser/widgets/select_category.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/utils/permission_utils.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/models/drop_down_item.dart';
import 'package:street_calle/generated/locale_keys.g.dart';

class SelectUserScreen extends StatefulWidget {
  const SelectUserScreen({Key? key}) : super(key: key);

  @override
  State<SelectUserScreen> createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  UserType _userType = UserType.client;
  VendorType _vendorType = VendorType.individual;

  List<DropDownItem> items = [
    DropDownItem(
        //title: TempLanguage().lblIndividual,
        title: LocaleKeys.individual.tr(),
        icon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: SvgPicture.asset(AppAssets.phone),
        )
    ),
    DropDownItem(
      //title: TempLanguage().lblAgency,
      title: LocaleKeys.agency.tr(),
      icon: Padding(
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
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 70,
          ),
          SizedBox(
            width: 200,
            height: 200,
            child: SvgPicture.asset(
              AppAssets.logo,
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
                    isSelected: _userType == UserType.client,
                    //title: TempLanguage().lblClient,
                    title: LocaleKeys.client.tr(),
                    onTap: () {
                      setState(() {
                        _userType = UserType.client;
                      });
                    },
                  ),
                  BuildSelectableImage(
                    assetPath: AppAssets.vendorIcon,
                    isSelected: _userType == UserType.vendor,
                    //title: TempLanguage().lblVendor,
                    title: LocaleKeys.vendor.tr(),
                    onTap: () {
                      setState(() {
                        _userType = UserType.vendor;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _userType.name == UserType.vendor.name
              ? Expanded(
                  child: Column(
                    children: [
                      Text(
                        //TempLanguage().lblPleaseSelectVendorType,
                        LocaleKeys.pleaseSelectVendorType.tr(),
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
                                blurRadius: 18, // Blur radius
                                offset: const Offset(0, 2), // Offset in the Y direction
                              ),
                            ],
                          ),
                          child: DropDownWidget(
                            initialValue: items.first,
                            items: items,
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              if (value.title.toLowerCase() ==
                                  VendorType.individual.name.toLowerCase()) {
                                _vendorType = VendorType.individual;
                              } else {
                                _vendorType = VendorType.agency;
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Expanded(child: Container()),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 54.0),
                child: SizedBox(
                  width: context.width,
                  height: defaultButtonSize,
                  child: AppButton(
                    //text: TempLanguage().lblNext,
                    text: LocaleKeys.next.tr(),
                    elevation: 0.0,
                    onTap: () => gotoNextScreen(),
                    shapeBorder: RoundedRectangleBorder(
                        side: const BorderSide(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(30)),
                    textStyle: context.currentTextTheme.labelLarge
                        ?.copyWith(color: AppColors.whiteColor),
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void gotoNextScreen() {
    final userCubit = context.read<UserCubit>();
    final userService = sl.get<UserService>();

    if (_userType.name == UserType.vendor.name) {
      showYourDialog(context, _vendorType.name, _userType.name);
    } else {
      userCubit.setUserType(_userType.name);
      userCubit.setIsVendor(false);
      userService.setUserType(userCubit.state.userId, _userType.name);
      context.goNamed(AppRoutingName.clientMainScreen);
    }
  }

  void showYourDialog(BuildContext context, String vendorName, String userName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.whiteColor,
          content: SelectCategory(
            vendorName: vendorName,
            userName: userName
          ),
        );
      },
    );
  }
}