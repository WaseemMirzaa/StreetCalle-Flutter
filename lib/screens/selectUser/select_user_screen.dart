import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/models/category.dart';
import 'package:street_calle/screens/selectUser/widgets/build_selected_image.dart';
import 'package:street_calle/services/category_service.dart';
import 'package:street_calle/services/user_service.dart';
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
import 'package:street_calle/dependency_injection.dart';

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
        TempLanguage().lblIndividual,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: SvgPicture.asset(AppAssets.phone),
        )
    ),
    DropDownItem(
      TempLanguage().lblAgency,
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: SvgPicture.asset(AppAssets.people),
      ),
    ),
  ];

  // List<DropDownItem> category = [
  //   DropDownItem(
  //       TempLanguage().lblFoodTruck,
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 6),
  //         child: SvgPicture.asset(AppAssets.phone),
  //       )
  //   ),
  //   DropDownItem(
  //     TempLanguage().lblFlowerTruck,
  //     Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 6),
  //       child: SvgPicture.asset(AppAssets.people),
  //     ),
  //   ),
  // ];

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
                    title: TempLanguage().lblClient,
                    onTap: () {
                      setState(() {
                        _userType = UserType.client;
                      });
                    },
                  ),
                  BuildSelectableImage(
                    assetPath: AppAssets.vendorIcon,
                    isSelected: _userType == UserType.vendor,
                    title: TempLanguage().lblVendor,
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
                                blurRadius: 18, // Blur radius
                                offset: const Offset(0, 2), // Offset in the Y direction
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
                                _vendorType = VendorType.individual;
                              } else {
                                _vendorType = VendorType.agency;
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
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
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
              : Expanded(child: Container()),
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
      showYourDialog(context);
    }

    // if (_userType.name == UserType.vendor.name) {
    //   userCubit.setUserType(_userType.name);
    //   userCubit.setVendorType(_vendorType.name);
    //   userCubit.setIsVendor(true);
    //   userService.setVendorType(userCubit.state.userId, _vendorType.name, _userType.name);
    // } else {
    //   userCubit.setUserType(_userType.name);
    //   userCubit.setIsVendor(false);
    //   userService.setUserType(userCubit.state.userId, _userType.name);
    // }
    //
    // context.goNamed(
    //     _userType.name == UserType.client.name
    //         ? AppRoutingName.clientMainScreen
    //         : AppRoutingName.mainScreen);
  }

  // void showYourDialog(BuildContext context) {
  //   DropDownItem? _selectedItem;
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: AppColors.whiteColor,
  //         content: SizedBox(
  //           // width: double.maxFinite,
  //           height: 250,
  //           child: Column(
  //             children: [
  //               Text(
  //                 TempLanguage().lblSelectCategory,
  //                 style: context.currentTextTheme.labelMedium,
  //               ),
  //               const SizedBox(height: 15),
  //               Text(
  //                 TempLanguage().lblSelectCategoryList,
  //                 textAlign: TextAlign.center,
  //                 style: context.currentTextTheme.displaySmall,
  //               ),
  //               const SizedBox(height: 15),
  //
  //               Container(
  //                 decoration: BoxDecoration(
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: AppColors.blackColor.withOpacity(0.15),
  //                       spreadRadius: 3, // Spread radius
  //                       blurRadius: 18, // Blur radius
  //                       offset: const Offset(0, 2), // Offset in the Y direction
  //                     ),
  //                   ],
  //                 ),
  //                 child: DropdownButtonFormField<DropDownItem>(
  //                   icon: const Icon(Icons.keyboard_arrow_down),
  //                   iconEnabledColor: AppColors.primaryColor,
  //                   value: _selectedItem ?? category.first,
  //                   onChanged: (value) {
  //                     setState(() {
  //                       _selectedItem = value;
  //                     });
  //                   },
  //                   selectedItemBuilder: (BuildContext context) {
  //                     return category.map<Widget>((DropDownItem category) {
  //                       return Row(
  //                         children: <Widget>[
  //                           Container(
  //                             width: 30,
  //                             height: 30,
  //                             decoration: const BoxDecoration(
  //                               color: AppColors.primaryLightColor,
  //                               shape: BoxShape.circle,
  //                             ),
  //                             child: category.icon,
  //                           ),
  //                           const SizedBox(width: 10),
  //                           Text(category.title),
  //                         ],
  //                       );
  //                     }).toList();
  //                   },
  //                   borderRadius: BorderRadius.circular(40),
  //                   items: category.map((item) {
  //                     return DropdownMenuItem<DropDownItem>(
  //                       value: item,
  //                       child: Row(
  //                         children: [
  //                           Container(
  //                             padding: const EdgeInsets.all(8),
  //                             decoration: const BoxDecoration(
  //                               color: AppColors.primaryLightColor,
  //                               shape: BoxShape.circle,
  //                             ),
  //                             child: item.icon,
  //                           ),
  //                           Text(item.title),
  //                         ],
  //                       ),
  //                     );
  //                   }).toList(),
  //                   style: context.currentTextTheme.labelSmall
  //                       ?.copyWith(
  //                       fontSize: 18,
  //                       color: AppColors.primaryFontColor),
  //                   decoration: InputDecoration(
  //                     contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
  //                     //isDense: true,
  //                     filled: true,
  //                     fillColor: AppColors.whiteColor,
  //                     border: vendorSelectionBorder,
  //                     enabledBorder: vendorSelectionBorder,
  //                     focusedBorder: vendorSelectionBorder,
  //                     disabledBorder: vendorSelectionBorder,
  //                   ),
  //                 ),
  //               ),
  //
  //               const SizedBox(height: 30),
  //               SizedBox(
  //                 width: context.width,
  //                 height: defaultButtonSize,
  //                 child: AppButton(
  //                   text: TempLanguage().lblDone,
  //                   elevation: 0.0,
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                   },
  //                   shapeBorder: RoundedRectangleBorder(
  //                       side: const BorderSide(color: AppColors.primaryColor),
  //                       borderRadius: BorderRadius.circular(30)),
  //                   textStyle: context.currentTextTheme.labelLarge
  //                       ?.copyWith(color: AppColors.whiteColor),
  //                   color: AppColors.primaryColor,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }


  void showYourDialog(BuildContext context) {
    DropDownItem? _selectedItem;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.whiteColor,
          content: SizedBox(
            // width: double.maxFinite,
            height: 250,
            child: FutureBuilder<List<dynamic>?>(
              future: sl.get<CategoryService>().fetchCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
                } else if (snapshot.hasData && snapshot.data != null) {
                  List<DropDownItem> category = [];
                  snapshot.data?.forEach((element) {
                    final dropDown = DropDownItem(element[CategoryKey.TITLE], Image.network(element[CategoryKey.ICON], width: 18, height: 18,));
                    category.add(dropDown);
                  });

                  _selectedItem = category[0];

                  return Column(
                    children: [
                      Text(
                        TempLanguage().lblSelectCategory,
                        style: context.currentTextTheme.labelMedium,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        TempLanguage().lblSelectCategoryList,
                        textAlign: TextAlign.center,
                        style: context.currentTextTheme.displaySmall,
                      ),
                      const SizedBox(height: 15),

                      Container(
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
                        child: DropdownButtonFormField<DropDownItem>(
                          icon: const Icon(Icons.keyboard_arrow_down),
                          iconEnabledColor: AppColors.primaryColor,
                          value: _selectedItem,
                          onChanged: (value) {
                            setState(() {
                              _selectedItem = value;
                            });
                          },
                          selectedItemBuilder: (BuildContext context) {
                            return category.map<Widget>((DropDownItem category) {
                              return Row(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryLightColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: category.icon,
                                  ),
                                  const SizedBox(width: 10),
                                  FittedBox(child: Text(category.title)),
                                ],
                              );
                            }).toList();
                          },
                          borderRadius: BorderRadius.circular(40),
                          items: category.map((item) {
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
                                  const SizedBox(width: 20),
                                  FittedBox(child: Text(item.title)),
                                ],
                              ),
                            );
                          }).toList(),
                          style: context.currentTextTheme.labelSmall
                              ?.copyWith(
                              fontSize: 18,
                              color: AppColors.primaryFontColor),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
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

                      const SizedBox(height: 30),
                      SizedBox(
                        width: context.width,
                        height: defaultButtonSize,
                        child: AppButton(
                          text: TempLanguage().lblDone,
                          elevation: 0.0,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          shapeBorder: RoundedRectangleBorder(
                              side: const BorderSide(color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(30)),
                          textStyle: context.currentTextTheme.labelLarge
                              ?.copyWith(color: AppColors.whiteColor),
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(TempLanguage().lblSomethingWentWrong),
                  );
                }
                return Center(
                  child: Text(TempLanguage().lblSomethingWentWrong),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class DropDownItem {
  final String title;
  final Widget icon;

  DropDownItem(this.title, this.icon);
}
