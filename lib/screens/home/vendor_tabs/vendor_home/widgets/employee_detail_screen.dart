import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:street_calle/utils/routing/app_routing_name.dart';


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
                  Row(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        clipBehavior: Clip.hardEdge,
                        child:
                        CachedNetworkImage(
                          imageUrl: widget.user?.image ?? '',
                          fit: BoxFit.cover,
                        ),
                        // Image.asset(
                        //   AppAssets.burgerImage,
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${widget.user?.name}',
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontFamily: METROPOLIS_BOLD,
                                        color: AppColors.primaryFontColor),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  AppAssets.marker,
                                  width: 12,
                                  height: 12,
                                  color: AppColors.primaryColor,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: Text('No 03, 4th Lane, Newyork',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: context.currentTextTheme.displaySmall
                                          ?.copyWith(
                                              color: AppColors.placeholderColor,
                                              fontSize: 14)),
                                ),
                              ],
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
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     SvgPicture.asset(AppAssets.itemListIcon),
                  //     const SizedBox(
                  //       width: 8,
                  //     ),
                  //     Text(
                  //       TempLanguage().lblItemList,
                  //       style: context.currentTextTheme.labelLarge
                  //           ?.copyWith(color: AppColors.primaryFontColor),
                  //     ),
                  //   ],
                  // ),
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
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {


                              List<Item> items = snapshot.data ?? [];


                              if (items.isEmpty) {
                                return const Center(
                                  child: Text(
                                      'No items found with the provided IDs'),
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
                                          Container(
                                              width: 90,
                                              height: 90,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      10)),
                                              clipBehavior: Clip.hardEdge,
                                              child: Image.network(
                                                itemData.image!,
                                                fit: BoxFit.cover,
                                              )
                                            // Image.asset(
                                            //   AppAssets.burgerImage,
                                            //   fit: BoxFit.cover,
                                            // ),
                                          ),
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
                                                        itemData.title!,
                                                        // 'Shehzad',
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
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      AppAssets.marker,
                                                      width: 12,
                                                      height: 12,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                        'No 03, 4th Lane, Newyork',
                                                        style: context
                                                            .currentTextTheme
                                                            .displaySmall
                                                            ?.copyWith(
                                                            color: AppColors
                                                                .placeholderColor,
                                                            fontSize: 14)),
                                                  ],
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
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {


                              List<Deal> deals = snapshot.data ?? [];


                              if (deals.isEmpty) {
                                return const Center(
                                  child: Text(
                                      'No items found with the provided IDs'),
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
                                          Container(
                                              width: 90,
                                              height: 90,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      10)),
                                              clipBehavior: Clip.hardEdge,
                                              child: Image.network(
                                                dealData.image!,
                                                fit: BoxFit.cover,
                                              )
                                            // Image.asset(
                                            //   AppAssets.burgerImage,
                                            //   fit: BoxFit.cover,
                                            // ),
                                          ),
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
                                                        dealData.title!,
                                                        // 'Shehzad',
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
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      AppAssets.marker,
                                                      width: 12,
                                                      height: 12,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                        'No 03, 4th Lane, Newyork',
                                                        style: context
                                                            .currentTextTheme
                                                            .displaySmall
                                                            ?.copyWith(
                                                            color: AppColors
                                                                .placeholderColor,
                                                            fontSize: 14)),
                                                  ],
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
                          text: 'Unblock',
                          textColor: AppColors.whiteColor,
                          onTap:(){
                            setState(() {
                              isLoading = true;
                            });

                            FirebaseFirestore.instance.collection('users').doc(widget.user!.uid).set(
                                {
                                  'isEmployeeBlocked': false,
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
                        FirebaseFirestore.instance.collection('users').doc(widget.user!.uid).set(
                            {
                              'isEmployeeBlocked': true,
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
