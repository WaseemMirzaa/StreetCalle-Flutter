import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/models/deal.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/services/deal_service.dart';
import 'package:street_calle/services/item_service.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/employee/employee_detail_header.dart';
import 'package:street_calle/widgets/image_widget.dart';


class EmployeeDetailScreen extends StatefulWidget {
  final User? user;
  const EmployeeDetailScreen({Key? key,this.user}) : super(key: key);

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final itemService = sl.get<ItemService>();
    final dealService = sl.get<DealService>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  AppAssets.backIcon,
                  width: 20,
                  height: 20,
                )
              ],
            ),
          ),
          title: Text(
            TempLanguage().lblEmployeeDetails,
            style: context.currentTextTheme.titleMedium
                ?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultHorizontalPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  EmployeeDetailHeader(user: widget.user),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    color: AppColors.dividerColor,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  /// the tab bar with two items
                  SizedBox(
                    height: 50,
                    child: AppBar(
                      bottom: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle: context.currentTextTheme.displaySmall,
                        unselectedLabelStyle: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryFontColor),
                        tabs:  [
                          Tab(text: TempLanguage().lblItems),
                          Tab(text: TempLanguage().lblDeals),
                        ],
                      ),
                    ),
                  ),
                  /// create widgets for each tab bar here
                  Expanded(
                    child: TabBarView(
                      children: [
                        /// Items tab bar
                        widget.user?.employeeItemsList?.isNotEmpty ?? false ?
                        StreamBuilder<List<Item>>(
                          stream: itemService.getEmployeeItems(widget.user?.employeeItemsList),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(TempLanguage().lblSomethingWentWrong),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {


                              List<Item> items = snapshot.data ?? [];


                              if (items.isEmpty) {
                                return Center(
                                  child: Text(TempLanguage().lblNoItemsFound),
                                );
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  var itemData = items[index];
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        children: [
                                          ImageWidget(image: itemData.image!,),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        itemData.title!.capitalizeEachFirstLetter(),
                                                        style: const TextStyle(
                                                            fontSize: 24,
                                                            fontFamily:
                                                            METROPOLIS_BOLD,
                                                            color: AppColors
                                                                .primaryFontColor),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 6,
                                                ),
                                                itemData.foodType == null
                                                    ? const SizedBox.shrink()
                                                    : Text(itemData.foodType.capitalizeEachFirstLetter(),
                                                  style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor, fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Divider(
                                        color: AppColors.dividerColor,
                                      ),
                                      SizedBox(
                                        height: index == 9 ? 60 : 0,
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        )
                            : Center(child: Text(TempLanguage().lblNoDataFound),),

                        /// Deals tab bar
                        widget.user?.employeeDealsList?.isNotEmpty ?? false ?
                        StreamBuilder<List<Deal>>(
                          stream: dealService.getEmployeeDeals(widget.user?.employeeDealsList),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(TempLanguage().lblSomethingWentWrong),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {


                              List<Deal> deals = snapshot.data ?? [];


                              if (deals.isEmpty) {
                                return Center(
                                  child: Text(TempLanguage().lblNoDealsFound),
                                );
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: deals.length,
                                itemBuilder: (context, index) {
                                  var dealData = deals[index];
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        children: [
                                          ImageWidget(image: dealData.image!,),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        dealData.title!.capitalizeEachFirstLetter(),
                                                        style: const TextStyle(
                                                            fontSize: 24,
                                                            fontFamily:
                                                            METROPOLIS_BOLD,
                                                            color: AppColors
                                                                .primaryFontColor),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 6,
                                                ),
                                                dealData.foodType == null
                                                    ? const SizedBox.shrink()
                                                    : Text(dealData.foodType.capitalizeEachFirstLetter(),
                                                      style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor, fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Divider(
                                        color: AppColors.dividerColor,
                                      ),
                                      SizedBox(
                                        height: index == 9 ? 60 : 0,
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        )
                            : Center(child: Text(TempLanguage().lblNoDataFound),),
                      ],
                    ),
                  ),
               ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child:
                    widget.user?.isEmployeeBlocked ?? false ?
                    isLoading ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                         CircularProgressIndicator(),
                      ],
                    ) :    AppButton(
                          text: TempLanguage().lblUnblock,
                          textColor: AppColors.whiteColor,
                          onTap:(){
                            setState(() {
                              isLoading = true;
                            });

                            FirebaseFirestore.instance.collection(Collections.users).doc(widget.user!.uid).set(
                                {
                                  UserKey.isEmployeeBlocked: false,
                                },SetOptions(merge: true))
                                .then((value) {
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pop(context);
                            }).onError((error, stackTrace) {
                              print('Error $error');
                              setState(() {
                                isLoading = false;
                              });
                            });

                          },
                          width: context.width,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          color: AppColors.redColor,
                        ):
                Row(
                  children: [
                  isLoading ? const CircularProgressIndicator() :   GestureDetector(

                      onTap:(){


                        setState(() {
                          isLoading = true;
                        });
                        FirebaseFirestore.instance.collection(Collections.users).doc(widget.user!.uid).set(
                            {
                              UserKey.isEmployeeBlocked: true,
                            },SetOptions(merge: true)).then((value) {
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context);
                        }).onError((error, stackTrace) {
                          print('Error $error');
                          setState(() {
                            isLoading = false;
                          });
                        });

                      },

                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppColors.redColor,
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          AppAssets.block,
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),


                    Expanded(
                      child:  SizedBox(
                        width: context.width,
                        height: defaultButtonSize,
                        child: AppButton(
                          elevation: 0.0,
                          onTap: () {

                            context.pushNamed(AppRoutingName.addEmployeeMenuItems, extra: widget.user);
                            },
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          color: AppColors.primaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(AppAssets.pencil),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                TempLanguage().lblEditAddMenuItems,
                                style: context.currentTextTheme.labelLarge
                                    ?.copyWith(color: AppColors.whiteColor,fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}