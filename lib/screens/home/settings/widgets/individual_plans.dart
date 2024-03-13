import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:street_calle/revenucat/revenu_cat_api.dart';
import 'package:street_calle/revenucat/revenuecar_constants.dart';
import 'package:street_calle/revenucat/singleton_data.dart';
// import 'package:street_calle/revenucat/revenu_cat_api.dart';
// import 'package:street_calle/screens/home/settings/widgets/check_out_page.dart';
import 'package:street_calle/services/stripe_service.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/home/settings/widgets/subscription_plan_item.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/utils/custom_widgets/own_show_confirm_dialog.dart';
import 'package:street_calle/utils/constant/app_colors.dart';

class IndividualPlans extends StatelessWidget {
  // final Offering? offering;
  final Offering? offers;
  const IndividualPlans({Key? key,
    // required this.offering,
    required this.offers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(offers?.availablePackages[0].storeProduct.price);
    print('storeProduct here');
    print(offers?.availablePackages[0].packageType.name);
    print('package type name here');
    print(offers?.availablePackages[0]);
    print(offers?.availablePackages[1]);
    print(offers?.availablePackages[0].storeProduct.title);



    print(offers?.availablePackages[0].storeProduct.identifier);

    // print(offering?.availablePackages);
    final userService = sl.get<UserService>();
    final userCubit = context.read<UserCubit>();

    return Column(
      children: [
        offers != null
            ? ListView.builder(
                itemCount: offers?.availablePackages.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var myProducts = offers?.availablePackages;
                  print('))))))))+++++++++++++11');
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        return SubscriptionPlanItem(
                          title: myProducts![index]
                              .storeProduct
                              .title, //TempLanguage().lblIndividualStarter,
                          amount: myProducts[index].storeProduct.priceString,
                          description: myProducts[index]
                              .storeProduct
                              .description, //TempLanguage().lblIndividualStarterDes,
                          subtitle: myProducts[index]
                              .storeProduct
                              .subscriptionPeriod!.toString() == 'P1M'? TempLanguage().lblOneMonth:TempLanguage().lblOneYear, //TempLanguage().lblOneMonth,
                          isSubscribed: state.isSubscribed &&
                              state.planLookUpKey ==
                                  IndivisualPlan.ind_one_month.name,
                          buttonText:

                         // (    // state.isSubscribed &&
                              //     state.planLookUpKey ==
                              //         IndivisualPlan.ind_one_month.name
                          //)
                          index == 0?
                        AppData().entitlementIsActive
                              ? AppData().entitlement == 'ind_starter_v1'?
                        TempLanguage().lblCancel: TempLanguage().lblUpdate
                              : TempLanguage().lblSubscribe
                          :
                          AppData().entitlementIsActive
                              ? AppData().entitlement == 'ind_growth_v1'?
                          TempLanguage().lblCancel: TempLanguage().lblUpdate
                              : TempLanguage().lblSubscribe,
                          onTap: () async {
                            print(AppData().entitlement);
                            print(AppData().entitlementIsActive);
                            print(myProducts[0].storeProduct.identifier);
                            print(myProducts[1].identifier);

                            try {
                              ownShowConfirmDialogCustom(context,
                                  title: //(
                                      // state.isSubscribed &&
                                      //     state.planLookUpKey ==
                                      //         IndivisualPlan.ind_one_month.name)
                                  AppData().entitlementIsActive ==true && AppData().entitlement == myProducts[index].storeProduct.identifier
                                      ? TempLanguage().lblCancelSubscription
                                      : TempLanguage().lblSubscribe,
                                  subTitle:
                                  // (state.isSubscribed &&
                                  //         state.planLookUpKey ==
                                  //             IndivisualPlan.ind_one_month.name)
                                  AppData().entitlementIsActive && AppData().entitlement == myProducts[index].storeProduct.identifier
                                      ? TempLanguage().lblCancelSubscriptionInfo
                                      : TempLanguage().lblSubscribeInfo,
                                  positiveText: TempLanguage().lblOk,
                                  cancelable: false,
                                  dialogType: CustomDialogType.CONFIRMATION,
                                  primaryColor: AppColors.primaryColor,
                                  barrierDismissible: false, onAccept: (ctx) async {
                                Navigator.pop(ctx);
                                if (
                                AppData().entitlementIsActive
                                // state.isSubscribed
                                ) {
                                  if (
                                  AppData().entitlement == myProducts[index].storeProduct.identifier
                                  // state.planLookUpKey ==
                                  //     IndivisualPlan.ind_one_month.name
                                  ) {
                                    // showLoadingDialog(context, null);

                                    RevenuCatAPI.cancelSubscription();
                                        // .then((value) {
                                    //   // Navigator.pop(context);
                                    //
                                    // });
                                    // cancelSubscription(
                                    //     userCubit,
                                    //     userService,
                                    //     state.subscriptionId,
                                    //     IndivisualPlan.ind_one_month.name,
                                    //     context);
                                  } else {
                                    showLoadingDialog(context, null);
                                    RevenuCatAPI.purchasePackage(myProducts[index], entitlementIDInd, context).then((value){
                                      RevenuCatAPI.checkAllSubscriptions().then((value) {
                                        Navigator.pop(context);

                                      });
                                    });

                                    // updateSubscription(
                                    //     userCubit,
                                    //     userService,
                                    //     state.subscriptionId,
                                    //     IndivisualPlan.ind_one_month.name,
                                    //     context);
                                  }
                                } else {

                                  showLoadingDialog(context, null);
                                  RevenuCatAPI.purchasePackage(myProducts[index], entitlementIDInd, context).then((value) {
                                    RevenuCatAPI.checkAllSubscriptions().then((value) {
                                      Navigator.pop(context);
                                    });
                                  });
                                  // subscribe(userService, userCubit, context,
                                  //     IndivisualPlan.ind_one_month.name, myProducts[index],);
                                }
                              }, onCancel: (context) {
                                Navigator.pop(context);
                              });
                            } catch (e) {
                              Navigator.pop(context);
                              showToast(context, '$e');
                            }
                          },
                        );
                      },
                    ),
                  );
                })
            : Column(
                children: [
                  BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      return SubscriptionPlanItem(
                        title: TempLanguage().lblIndividualStarter,
                        amount: '\$20.00',
                        description: TempLanguage().lblIndividualStarterDes,
                        subtitle: TempLanguage().lblOneMonth,
                        isSubscribed: state.isSubscribed &&
                            state.planLookUpKey ==
                                IndivisualPlan.ind_one_month.name,
                        buttonText: (state.isSubscribed &&
                                state.planLookUpKey ==
                                    IndivisualPlan.ind_one_month.name)
                            ? TempLanguage().lblCancel
                            : TempLanguage().lblSubscribe,
                        onTap: () async {
                          try {
                            ownShowConfirmDialogCustom(context,
                                title: (state.isSubscribed &&
                                        state.planLookUpKey ==
                                            IndivisualPlan.ind_one_month.name)
                                    ? TempLanguage().lblCancelSubscription
                                    : TempLanguage().lblSubscribe,
                                subTitle: (state.isSubscribed &&
                                        state.planLookUpKey ==
                                            IndivisualPlan.ind_one_month.name)
                                    ? TempLanguage().lblCancelSubscriptionInfo
                                    : TempLanguage().lblSubscribeInfo,
                                positiveText: TempLanguage().lblOk,
                                cancelable: false,
                                dialogType: CustomDialogType.CONFIRMATION,
                                primaryColor: AppColors.primaryColor,
                                barrierDismissible: false, onAccept: (ctx) {
                              Navigator.pop(ctx);
                              if (state.isSubscribed) {
                                if (state.planLookUpKey ==
                                    IndivisualPlan.ind_one_month.name) {
                                  showLoadingDialog(context, null);
                                  cancelSubscription(
                                      userCubit,
                                      userService,
                                      state.subscriptionId,
                                      IndivisualPlan.ind_one_month.name,
                                      context);
                                } else {
                                  showLoadingDialog(context, null);
                                  updateSubscription(
                                      userCubit,
                                      userService,
                                      state.subscriptionId,
                                      IndivisualPlan.ind_one_month.name,
                                      context);
                                }
                              } else {
                                showLoadingDialog(context, null);
                                subscribe(userService, userCubit, context,
                                    IndivisualPlan.ind_one_month.name, '');
                              }
                            }, onCancel: (context) {
                              Navigator.pop(context);
                            });
                          } catch (e) {
                            Navigator.pop(context);
                            showToast(context, '$e');
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      return SubscriptionPlanItem(
                        title: TempLanguage().lblIndividualGrowthPlan,
                        amount: '\$192.00',
                        description: TempLanguage().lblIndividualGrowthDes,
                        buttonText: (state.isSubscribed &&
                                state.planLookUpKey ==
                                    IndivisualPlan.ind_one_year.name)
                            ? TempLanguage().lblCancel
                            : TempLanguage().lblSubscribe,
                        isSubscribed: state.isSubscribed &&
                            state.planLookUpKey ==
                                IndivisualPlan.ind_one_year.name,
                        subtitle: TempLanguage().lblOneYear,
                        onTap: () async {
                          try {
                            // final stripeId = await getStripeId(userCubit, userService, context, userCubit.state.userId);
                            //
                            // if (userCubit.state.isSubscribed) {
                            //   cancelSubscription(userCubit, userService, stripeId);
                            // } else {
                            //   subscribe(stripeId, userService, userCubit);
                            // }

                            // if (state.isSubscribed) {
                            //   if (state.planLookUpKey == IndivisualPlan.ind_one_year.name) {
                            //     userCubit.setIsSubscribed(false);
                            //     userCubit.setSubscriptionType(SubscriptionType.none.name);
                            //     userCubit.setPlanLookUpKey('');
                            //   } else {
                            //     userCubit.setIsSubscribed(true);
                            //     userCubit.setSubscriptionType(SubscriptionType.individual.name);
                            //     userCubit.setPlanLookUpKey(IndivisualPlan.ind_one_year.name);
                            //   }
                            // } else {
                            //   userCubit.setIsSubscribed(true);
                            //   userCubit.setSubscriptionType(SubscriptionType.individual.name);
                            //   userCubit.setPlanLookUpKey(IndivisualPlan.ind_one_year.name);
                            // }

                            ownShowConfirmDialogCustom(context,
                                title: (state.isSubscribed &&
                                        state.planLookUpKey ==
                                            IndivisualPlan.ind_one_year.name)
                                    ? TempLanguage().lblCancelSubscription
                                    : TempLanguage().lblSubscribe,
                                subTitle: (state.isSubscribed &&
                                        state.planLookUpKey ==
                                            IndivisualPlan.ind_one_year.name)
                                    ? TempLanguage().lblCancelSubscriptionInfo
                                    : TempLanguage().lblSubscribeInfo,
                                positiveText: TempLanguage().lblOk,
                                cancelable: false,
                                dialogType: CustomDialogType.CONFIRMATION,
                                primaryColor: AppColors.primaryColor,
                                barrierDismissible: false, onAccept: (ctx) {
                              Navigator.pop(ctx);
                              if (state.isSubscribed) {
                                if (state.planLookUpKey ==
                                    IndivisualPlan.ind_one_year.name) {
                                  showLoadingDialog(context, null);
                                  cancelSubscription(
                                      userCubit,
                                      userService,
                                      state.subscriptionId,
                                      IndivisualPlan.ind_one_year.name,
                                      context);
                                } else {
                                  showLoadingDialog(context, null);
                                  updateSubscription(
                                      userCubit,
                                      userService,
                                      state.subscriptionId,
                                      IndivisualPlan.ind_one_year.name,
                                      context);
                                }
                              } else {
                                showLoadingDialog(context, null);
                                subscribe(userService, userCubit, context,
                                    IndivisualPlan.ind_one_year.name, '');
                              }
                            }, onCancel: (context) {
                              Navigator.pop(context);
                            });
                          } catch (e) {
                            Navigator.pop(context);
                            showToast(context, '$e');
                          }
                        },
                      );
                    },
                  ),
                ],
              )
      ],
    );
  }

  Future<void> subscribe(UserService userService, UserCubit userCubit,
      BuildContext context, String planLookUpKey, String package) async {
    // RevenuCatAPI.purchasePackage('', entitleIdentifier, context);
  }
  // {
  //   CustomerInfo customerInfo = await Purchases.getCustomerInfo();
  //
  //   if (customerInfo.entitlements.all[planLookUpKey] != null &&
  //       customerInfo.entitlements.all[planLookUpKey]?.isActive == true) {
  //   } else {
  //     Offerings? offerings;
  //     try {
  //       offerings = await Purchases.getOfferings();
  //     } on PlatformException catch (e) {
  //       toast(e.toString());
  //     }
  //
  //     if (offerings == null || offerings.current == null) {
  //       // offerings are empty, show a message to your user
  //     } else {
  //       // current offering is available, show paywall
  //       await showModalBottomSheet(
  //         useRootNavigator: true,
  //         isDismissible: true,
  //         isScrollControlled: true,
  //         backgroundColor: Colors.blue,
  //         shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
  //         ),
  //         context: context,
  //         builder: (BuildContext context) {
  //           return StatefulBuilder(
  //               builder: (BuildContext context, StateSetter setModalState) {
  //             return Paywall(
  //               offering: offerings!.current!,
  //               planLookUp: planLookUpKey,
  //             );
  //           });
  //         },
  //       );
  //     }
  //   }
  // }

  Future<void> cancelSubscription(UserCubit userCubit, UserService userService,
      String subscriptionId, String planLookUpKey, BuildContext context) async {
    final cancelSubscription =
        await StripeService.cancelSubscription(subscriptionId);
    if (!context.mounted) return;
    Navigator.pop(context);
    subscriptionStatus(cancelSubscription['subscription']['status'],
        userService, userCubit, planLookUpKey);
  }

  Future<void> updateSubscription(UserCubit userCubit, UserService userService,
      String subscriptionId, String planLookUpKey, BuildContext context) async {
    final updateSubscription =
        await StripeService.updateSubscription(subscriptionId, planLookUpKey);
    if (!context.mounted) return;
    Navigator.pop(context);
    subscriptionStatus(updateSubscription['subscription']['status'],
        userService, userCubit, planLookUpKey);
  }

  Future<void> subscriptionStatus(String status, UserService userService,
      UserCubit userCubit, String planLookUpKey) async {
    switch (status) {
      case 'incomplete':
        break;
      case 'incomplete_expired':
        break;
      case 'trialing':
        syncUserSubscriptionStatus(userService, userCubit, true,
            SubscriptionType.individual.name, planLookUpKey);
        toast(TempLanguage().lblSubscribedSuccessfully);
        break;
      case 'active':
        syncUserSubscriptionStatus(userService, userCubit, true,
            SubscriptionType.individual.name, planLookUpKey);
        break;
      case 'past_due':
        break;
      case 'canceled':
        syncUserSubscriptionStatus(
            userService, userCubit, false, SubscriptionType.none.name, '');
        toast(TempLanguage().lblSubscriptionCancelledSuccessfully);
        break;
      case 'unpaid':
        break;
    }
  }

  Future<void> syncUserSubscriptionStatus(
      UserService userService,
      UserCubit userCubit,
      bool isSubscribed,
      String subscriptionType,
      String planLookUpKey) async {
    final result = await userService.updateUserSubscription(
        isSubscribed, subscriptionType, userCubit.state.userId, planLookUpKey);
    if (result) {
      userCubit.setIsSubscribed(isSubscribed);
      userCubit.setSubscriptionType(subscriptionType);
      userCubit.setPlanLookUpKey(planLookUpKey);
    }
    if (!isSubscribed) {
      await userService.updateUserStripeDetails(
          '', '', '', userCubit.state.userId);
      userCubit.setSubscriptionId('');
      userCubit.setStripeId('');
      userCubit.setSessionId('');
    }
  }

  // Future<void> subscribe(UserService userService, UserCubit userCubit,
  //     BuildContext context, String planLookUpKey) async {
  //   try {
  //     final sessionId =
  //         await StripeService.createCheckoutSession(planLookUpKey);
  //     String id = sessionId['session']['id'] ?? '';
  //     String url = sessionId['session']['url'] ?? '';
  //     if (!context.mounted) return;
  //     Navigator.pop(context);
  //     Navigator.of(context).push(MaterialPageRoute(
  //         builder: (_) => CheckOutPage(
  //               sessionId: id,
  //               planLookUpKey: planLookUpKey,
  //               url: url,
  //               userCubit: userCubit,
  //               userService: userService,
  //               subscriptionType: SubscriptionType.individual.name,
  //             )));
  //   } catch (e) {
  //     showToast(context, '$e');
  //   }
  // }

  // Future<void> cancelSubscription(UserCubit userCubit, UserService userService, String subscriptionId, String planLookUpKey, BuildContext context) async {
  //   final cancelSubscription = await StripeService.cancelSubscription(subscriptionId);
  //   if (!context.mounted) return;
  //   Navigator.pop(context);
  //   subscriptionStatus(cancelSubscription['subscription']['status'], userService, userCubit, planLookUpKey);
  // }
  //
  // Future<void> updateSubscription(UserCubit userCubit, UserService userService, String subscriptionId, String planLookUpKey, BuildContext context) async {
  //   final updateSubscription = await StripeService.updateSubscription(subscriptionId, planLookUpKey);
  //   if (!context.mounted) return;
  //   Navigator.pop(context);
  //   subscriptionStatus(updateSubscription['subscription']['status'], userService, userCubit, planLookUpKey);
  // }
  //
  // Future<void> subscriptionStatus(String status, UserService userService, UserCubit userCubit, String planLookUpKey) async {
  //   switch(status) {
  //     case 'incomplete':
  //       break;
  //     case 'incomplete_expired':
  //       break;
  //     case 'trialing':
  //       syncUserSubscriptionStatus(userService, userCubit, true, SubscriptionType.individual.name, planLookUpKey);
  //       toast(TempLanguage().lblSubscribedSuccessfully);
  //       break;
  //     case 'active':
  //       syncUserSubscriptionStatus(userService, userCubit, true, SubscriptionType.individual.name, planLookUpKey);
  //       break;
  //     case 'past_due':
  //       break;
  //     case 'canceled':
  //       syncUserSubscriptionStatus(userService, userCubit, false, SubscriptionType.none.name, '');
  //       toast(TempLanguage().lblSubscriptionCancelledSuccessfully);
  //       break;
  //     case 'unpaid':
  //       break;
  //   }
  // }
  //
  // Future<void> syncUserSubscriptionStatus(UserService userService, UserCubit userCubit, bool isSubscribed, String subscriptionType, String planLookUpKey) async {
  //   final result = await userService.updateUserSubscription(isSubscribed, subscriptionType, userCubit.state.userId, planLookUpKey);
  //   if (result) {
  //     userCubit.setIsSubscribed(isSubscribed);
  //     userCubit.setSubscriptionType(subscriptionType);
  //     userCubit.setPlanLookUpKey(planLookUpKey);
  //   }
  //   if (!isSubscribed) {
  //     await userService.updateUserStripeDetails('', '', '', userCubit.state.userId);
  //     userCubit.setSubscriptionId('');
  //     userCubit.setStripeId('');
  //     userCubit.setSessionId('');
  //   }
  // }
}
//
// class Paywall extends StatefulWidget {
//   final Offering offering;
//   final String planLookUp;
//
//   const Paywall({Key? key, required this.offering, required this.planLookUp})
//       : super(key: key);
//
//   @override
//   _PaywallState createState() => _PaywallState();
// }
//
// class _PaywallState extends State<Paywall> {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: SafeArea(
//         child: Wrap(
//           children: <Widget>[
//             Container(
//               height: 70.0,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                   borderRadius:
//                       BorderRadius.vertical(top: Radius.circular(25.0))),
//               child: const Center(
//                   child: Text(
//                 '✨ Magic Weather Premium',
//               )),
//             ),
//             const Padding(
//               padding:
//                   EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: Text(
//                   'MAGIC WEATHER PREMIUM',
//                 ),
//               ),
//             ),
//             ListView.builder(
//               itemCount: widget.offering.availablePackages.length,
//               itemBuilder: (BuildContext context, int index) {
//                 var myProductList = widget.offering.availablePackages;
//                 return Card(
//                     color: Colors.grey,
//                     child: ListTile(
//                         onTap: () async {
//                           try {
//                             final userService = sl.get<UserService>();
//                             final userCubit = context.read<UserCubit>();
//                             CustomerInfo customerInfo =
//                                 await Purchases.purchasePackage(
//                                     myProductList[index]);
//                             EntitlementInfo? entitlement = customerInfo
//                                 .entitlements.all[widget.planLookUp];
//                             userCubit.setIsSubscribed(
//                                 entitlement?.isActive ?? false);
//                           } catch (e) {
//                             print(e);
//                           }
//
//                           setState(() {});
//                           Navigator.pop(context);
//                         },
//                         title: Text(
//                           myProductList[index].storeProduct.title,
//                         ),
//                         subtitle: Text(
//                           myProductList[index].storeProduct.description,
//                         ),
//                         trailing: Text(
//                           myProductList[index].storeProduct.priceString,
//                         )));
//               },
//               shrinkWrap: true,
//               physics: const ClampingScrollPhysics(),
//             ),
//             const Padding(
//               padding:
//                   EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: Text(
//                   'footerText',
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
