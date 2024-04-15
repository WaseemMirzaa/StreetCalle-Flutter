import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:street_calle/revenucat/revenu_cat_api.dart';
import 'package:street_calle/revenucat/revenuecar_constants.dart';
import 'package:street_calle/revenucat/singleton_data.dart';
// import 'package:street_calle/screens/home/vendor_main_screen.dart';
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

import 'package:street_calle/utils/routing/app_routing_name.dart';

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
                                  myProducts[index].storeProduct.identifier,
                          buttonText: index == 0?
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
                                  title:
                                  AppData().entitlementIsActive ==true && AppData().entitlement == myProducts[index].storeProduct.identifier
                                      ? TempLanguage().lblCancelSubscription
                                      : TempLanguage().lblSubscribe,
                                  subTitle:
                                  AppData().entitlementIsActive && AppData().entitlement == myProducts[index].storeProduct.identifier
                                      ? TempLanguage().lblCancelSubscriptionInfo
                                      : TempLanguage().lblSubscribeInfo,
                                  positiveText: TempLanguage().lblOk,
                                  price: myProducts[index].storeProduct.priceString,
                                  des: myProducts[index].storeProduct.presentedOfferingIdentifier,
                                  duration: myProducts[index]
                                      .storeProduct
                                      .subscriptionPeriod!.toString() == 'P1M'? TempLanguage().lblOneMonth:TempLanguage().lblOneYear,
                                  cancelable: false,
                                  dialogType: CustomDialogType.CONFIRMATION,
                                  primaryColor: AppColors.primaryColor,
                                  barrierDismissible: false, onAccept: (ctx) async {
                                Navigator.pop(ctx);
                                if (AppData().entitlementIsActive) {
                                  if (AppData().entitlement == myProducts[index].storeProduct.identifier) {
                                    RevenuCatAPI.cancelSubscription();

                                  } else {
                                    showLoadingDialog(context, null);
                                   await RevenuCatAPI.purchasePackage(myProducts[index], entitlementIDInd, context).then((value) async {
                                    await  RevenuCatAPI.checkAllSubscriptions().then((value) {
                                        print(AppData().entitlementIsActive,);
                                        print(AppData().entitlement,);
                                        print(SubscriptionType.individual.name);
                                        print('===============');
                                        syncUserSubscriptionStatus(userService, userCubit, AppData().entitlementIsActive, SubscriptionType.individual.name,AppData().entitlement );
                                        print('===============');

                                        Navigator.pop(context);
                                        context.pushNamed(AppRoutingName.mainScreen);

                                      });
                                    });
                                  }
                                } else {

                                  showLoadingDialog(context, null);
                                  await RevenuCatAPI.purchasePackage(myProducts[index], entitlementIDInd, context)
                                      .then((value) async {
                                    await RevenuCatAPI.checkAllSubscriptions().then((value) {
                                      print(AppData().entitlementIsActive,);
                                      print(AppData().entitlement,);
                                      print(SubscriptionType.individual.name);

                                      syncUserSubscriptionStatus(userService, userCubit, AppData().entitlementIsActive, SubscriptionType.individual.name,AppData().entitlement );
                                      Navigator.pop(context);
                                      context.pushNamed(AppRoutingName.mainScreen);


                                    }).onError((error, stackTrace) {
                                      Navigator.pop(context);

                                      print('Errorrrrrr is hereee ${error.toString()}');
                                    });
                                  })
                                      .onError((error, stackTrace) {
                                  Navigator.pop(context);

                                  print('Errorrrrrr is hereee 2222${error.toString()}');

                                  });
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
                                IndivisualPlan.ind_starter_v1.name,
                        buttonText: (state.isSubscribed &&
                                state.planLookUpKey ==
                                    IndivisualPlan.ind_growth_v1.name)
                            ? TempLanguage().lblCancel
                            : TempLanguage().lblSubscribe,
                        onTap: (){},
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
                                    IndivisualPlan.ind_starter_v1.name)
                            ? TempLanguage().lblCancel
                            : TempLanguage().lblSubscribe,
                        isSubscribed: state.isSubscribed &&
                            state.planLookUpKey ==
                                IndivisualPlan.ind_growth_v1.name,
                        subtitle: TempLanguage().lblOneYear,
                        onTap: (){},
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
      String planLookUpKey
      ) async {

    print('in syncUserSubscriptionStatus function');
    print(isSubscribed);
    print(subscriptionType);
    print(planLookUpKey);
    print(isSubscribed);

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





}

