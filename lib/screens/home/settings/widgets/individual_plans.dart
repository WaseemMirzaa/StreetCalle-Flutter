import 'dart:io';

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
    final userService = sl.get<UserService>();
    final userCubit = context.read<UserCubit>();

    if (userCubit.state.isSubscribed) {
      if(Platform.isIOS){
        if (appData.entitlement != 'ind_starter_v2' && AppData().entitlement != 'ind_growth_v2') {
          appData.entitlement = '';
          appData.entitlementIsActive = false;
        }
      }else{
        if (AppData().entitlement != 'ind_starter_v1' && AppData().entitlement != 'ind_growth_v1') {
          AppData().entitlement = '';
          AppData().entitlementIsActive = false;
        }
      }
    } else {
      appData.entitlement = '';
      appData.entitlementIsActive = false;
    }

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
                          title: myProducts![index].storeProduct.title,
                          amount: myProducts[index].storeProduct.priceString,
                          description: myProducts[index].storeProduct.description,
                          subtitle: myProducts[index]
                              .storeProduct
                              .subscriptionPeriod!.toString() == 'P1M'? TempLanguage().lblOneMonth:TempLanguage().lblOneYear, //TempLanguage().lblOneMonth,
                          isSubscribed: isSubscribed(index),
                          buttonText: getButtonText(index),
                          onTap: () {
                            try {
                              if (appData.entitlementIsActive) {
                                if (AppData().entitlement == myProducts[index].storeProduct.identifier.split(':')[0]) {
                                  showConfirmDialogCustom(
                                    context,
                                    title: TempLanguage().lblCancelSubscription,
                                    subTitle: TempLanguage().lblCancelSubscriptionInfo,
                                    cancelable: false,
                                    dialogType: DialogType.CONFIRMATION,
                                    primaryColor: AppColors.primaryColor,
                                    barrierDismissible: false,
                                    onAccept: (ctx){
                                      Navigator.pop(ctx);
                                      RevenuCatAPI.cancelSubscription();
                                      context.pushNamed(AppRoutingName.mainScreen);
                                    },
                                    onCancel: (context) {
                                      Navigator.pop(context);
                                    }
                                  );
                                } else {
                                  ownShowConfirmDialogCustom(context,
                                      title: TempLanguage().lblSubscribe,
                                      subTitle: TempLanguage().lblSubscribeInfo,
                                      positiveText: TempLanguage().lblOk,
                                      price: myProducts[index].storeProduct.priceString,
                                      des: myProducts[index].storeProduct.presentedOfferingIdentifier,
                                      duration: myProducts[index]
                                          .storeProduct
                                          .subscriptionPeriod!.toString() == 'P1M'? TempLanguage().lblOneMonth:TempLanguage().lblOneYear,
                                      cancelable: false,
                                      isUpdateSubscription: true,
                                      dialogType: CustomDialogType.CONFIRMATION,
                                      primaryColor: AppColors.primaryColor,
                                      barrierDismissible: false, onAccept: (ctx) async {
                                        Navigator.pop(ctx);
                                        showLoadingDialog(context, null);
                                        RevenuCatAPI.updatePackage(myProducts[index], entitlementIDInd, context).then((value) async {
                                          syncUserSubscriptionStatus(userService, userCubit, AppData().entitlementIsActive, SubscriptionType.individual.name,AppData().entitlement );
                                          Navigator.pop(context);
                                          context.pushNamed(AppRoutingName.mainScreen);
                                        });
                                      }, onCancel: (context) {
                                        Navigator.pop(context);
                                      });
                                }
                              }
                              else {
                                ownShowConfirmDialogCustom(context,
                                    title: TempLanguage().lblSubscribe,
                                    subTitle: TempLanguage().lblSubscribeInfo,
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
                                      showLoadingDialog(context, null);
                                      RevenuCatAPI.purchasePackage(myProducts[index], entitlementIDInd, context)
                                          .then((value) async {
                                        syncUserSubscriptionStatus(userService, userCubit, AppData().entitlementIsActive, SubscriptionType.individual.name,AppData().entitlement );
                                        Navigator.pop(context);
                                        context.pushNamed(AppRoutingName.mainScreen);
                                      }).onError((error, stackTrace) {
                                        Navigator.pop(context);
                                      });
                                    }, onCancel: (context) {
                                      Navigator.pop(context);
                                    });
                              }
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
            : Center(child: Text(TempLanguage().lblNoSubscriptionFound),)
      ],
    );
  }

  Future<void> syncUserSubscriptionStatus(
      UserService userService,
      UserCubit userCubit,
      bool isSubscribed,
      String subscriptionType,
      String planLookUpKey
  ) async {

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

  String getButtonText(int index,) {
    return index == 0
        ? AppData().entitlementIsActive
        ? Platform.isIOS
        ? AppData().entitlement == 'ind_starter_v2'
        ? TempLanguage().lblCancel
        : TempLanguage().lblUpdate
        : AppData().entitlement == 'ind_starter_v1'
        ? TempLanguage().lblCancel
        : TempLanguage().lblUpdate
        : TempLanguage().lblSubscribe
        : AppData().entitlementIsActive
        ? Platform.isIOS
        ? AppData().entitlement == 'ind_growth_v2'
        ? TempLanguage().lblCancel
        : TempLanguage().lblUpdate
        : AppData().entitlement == 'ind_growth_v1'
        ? TempLanguage().lblCancel
        : TempLanguage().lblUpdate
        : TempLanguage().lblSubscribe;
  }


  bool isSubscribed(int index, ) {
    return index == 0
        ? AppData().entitlementIsActive
        ? Platform.isIOS
        ? 'ind_starter_v2' == AppData().entitlement
        : 'ind_starter_v1' == AppData().entitlement
        : false
        : AppData().entitlementIsActive
        ? Platform.isIOS
        ? 'ind_growth_v2' == AppData().entitlement
        : 'ind_growth_v1' == AppData().entitlement
        : false;
  }


  /// Stripe implementation for future use ///
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
  ///

}