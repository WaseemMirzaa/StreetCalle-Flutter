import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:purchases_flutter/models/offering_wrapper.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/revenucat/revenuecar_constants.dart';
import 'package:street_calle/revenucat/singleton_data.dart';
import 'package:street_calle/screens/home/settings/widgets/subscription_plan_item.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/custom_widgets/own_show_confirm_dialog.dart';

import 'package:street_calle/revenucat/revenu_cat_api.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';

class AgencyPlans extends StatelessWidget {
  final Offering? newAgencyOffers;
  final Offering? intermediateAgencyOffers;
  final Offering? establishedAgencyOffers;

  const AgencyPlans({Key? key,
    required this.newAgencyOffers,
    required this.intermediateAgencyOffers,
    required this.establishedAgencyOffers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = sl.get<UserService>();
    final userCubit = context.read<UserCubit>();

    if(Platform.isIOS){
      if (AppData().entitlement == 'ind_starter_v2' || AppData().entitlement == 'ind_growth_v2') {
        AppData().entitlement = '';
        AppData().entitlementIsActive = false;
      }
    }else{
      if (AppData().entitlement == 'ind_starter_v1' || AppData().entitlement == 'ind_growth_v1') {
        AppData().entitlement = '';
        AppData().entitlementIsActive = false;
      }
    }



    return Column(
      children: [
        newAgencyOffers != null
            ? ListView.builder(
            itemCount: newAgencyOffers?.availablePackages.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var myProducts = newAgencyOffers?.availablePackages;
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
                      isSubscribed: index == 0
                              ? AppData().entitlementIsActive
                                  ? 'new_agency_starter_v1' ==
                                      AppData().entitlement
                                  : false
                              : AppData().entitlementIsActive
                                  ? 'new_agency_growth_v1' ==
                                      AppData().entitlement
                                  : false,
                          buttonText: index == 0
                              ? AppData().entitlementIsActive
                                  ? AppData().entitlement == 'new_agency_starter_v1'
                                      ? TempLanguage().lblCancel
                                      : TempLanguage().lblUpdate
                                  : TempLanguage().lblSubscribe
                              : AppData().entitlementIsActive
                                  ? AppData().entitlement == 'new_agency_growth_v1'
                                      ? TempLanguage().lblCancel
                                      : TempLanguage().lblUpdate
                                  : TempLanguage().lblSubscribe,
                          onTap: () async {
                        try {
                          if (AppData().entitlementIsActive) {
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
                                    RevenuCatAPI.updatePackage(myProducts[index], entitlementIDNew, context).then((value) async {
                                      syncUserSubscriptionStatus(userService, userCubit, AppData().entitlementIsActive, SubscriptionType.agency.name,AppData().entitlement );
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
                                  RevenuCatAPI.purchasePackage(myProducts[index], entitlementIDNew, context)
                                      .then((value) async {
                                    syncUserSubscriptionStatus(userService, userCubit, AppData().entitlementIsActive, SubscriptionType.agency.name,AppData().entitlement );
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
            : Center(child: Text(TempLanguage().lblNoSubscriptionFound),),

        const SizedBox(
          height: 18,
        ),

        intermediateAgencyOffers != null
            ? ListView.builder(
            itemCount: intermediateAgencyOffers?.availablePackages.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var myProducts = intermediateAgencyOffers?.availablePackages;
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
                      isSubscribed: index == 0
                          ? AppData().entitlementIsActive
                          ? 'intermediate_agency_starter_v1' ==
                          AppData().entitlement
                          : false
                          : AppData().entitlementIsActive
                          ? 'intermediate_agency_growth_v1' ==
                          AppData().entitlement
                          : false,
                      buttonText: index == 0
                          ? AppData().entitlementIsActive
                          ? AppData().entitlement == 'intermediate_agency_starter_v1'
                          ? TempLanguage().lblCancel
                          : TempLanguage().lblUpdate
                          : TempLanguage().lblSubscribe
                          : AppData().entitlementIsActive
                          ? AppData().entitlement == 'intermediate_agency_growth_v1'
                          ? TempLanguage().lblCancel
                          : TempLanguage().lblUpdate
                          : TempLanguage().lblSubscribe,
                      onTap: () async {
                        try {
                          if (AppData().entitlementIsActive) {
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
                                    RevenuCatAPI.updatePackage(myProducts[index], entitlementIDInter, context).then((value) async {
                                      syncUserSubscriptionStatus(userService, userCubit, AppData().entitlementIsActive, SubscriptionType.agency.name,AppData().entitlement );
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
                                  RevenuCatAPI.purchasePackage(myProducts[index], entitlementIDInter, context)
                                      .then((value) async {
                                    syncUserSubscriptionStatus(userService, userCubit, AppData().entitlementIsActive, SubscriptionType.agency.name,AppData().entitlement );
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
            : const SizedBox.shrink(),

        const SizedBox(
          height: 18,
        ),

        establishedAgencyOffers != null
            ? ListView.builder(
            itemCount: establishedAgencyOffers?.availablePackages.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var myProducts = establishedAgencyOffers?.availablePackages;
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
                      isSubscribed: index == 0
                          ? AppData().entitlementIsActive
                          ? 'establish_agency_starter_v1' ==
                          AppData().entitlement
                          : false
                          : AppData().entitlementIsActive
                          ? 'establish_agency_growth_v1' ==
                          AppData().entitlement
                          : false,
                      buttonText: index == 0
                          ? AppData().entitlementIsActive
                          ? AppData().entitlement == 'establish_agency_starter_v1'
                          ? TempLanguage().lblCancel
                          : TempLanguage().lblUpdate
                          : TempLanguage().lblSubscribe
                          : AppData().entitlementIsActive
                          ? AppData().entitlement == 'establish_agency_growth_v1'
                          ? TempLanguage().lblCancel
                          : TempLanguage().lblUpdate
                          : TempLanguage().lblSubscribe,
                      onTap: () async {
                        print(myProducts[index].storeProduct.title);

                        try {

                          if (AppData().entitlementIsActive) {
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
                                    RevenuCatAPI.updatePackage(myProducts[index], entitlementIDEstab, context).then((value) async {
                                      syncUserSubscriptionStatus(userService, userCubit, AppData().entitlementIsActive, SubscriptionType.agency.name,AppData().entitlement );
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
                                  RevenuCatAPI.purchasePackage(myProducts[index], entitlementIDEstab, context)
                                      .then((value) async {
                                    syncUserSubscriptionStatus(userService, userCubit, AppData().entitlementIsActive, SubscriptionType.agency.name,AppData().entitlement );
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
            : const SizedBox.shrink(),
      ],
    );
  }


  Future<void> syncUserSubscriptionStatus(
      UserService userService,
      UserCubit userCubit,
      bool isSubscribed,
      String subscriptionType,
      String planLookUpKey)
  async {

    final result = await userService.updateUserSubscription(
        isSubscribed, subscriptionType, userCubit.state.userId, planLookUpKey);
    print(result);

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
}