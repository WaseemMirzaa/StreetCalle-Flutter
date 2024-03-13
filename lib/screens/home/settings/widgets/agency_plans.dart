import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:street_calle/services/stripe_service.dart';
import 'package:street_calle/screens/home/settings/widgets/check_out_page.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/custom_widgets/own_show_confirm_dialog.dart';

import 'package:street_calle/revenucat/revenu_cat_api.dart';

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
                      isSubscribed: state.isSubscribed &&
                          state.planLookUpKey ==
                              IndivisualPlan.ind_one_month.name,
                      buttonText:
                      // (state.isSubscribed &&
                      //     state.planLookUpKey ==
                      //         IndivisualPlan.ind_one_month.name)
                      AppData().entitlementIsActive
                          ? AppData().entitlement == myProducts[index].storeProduct.identifier?
                           TempLanguage().lblCancel:
                      TempLanguage().lblUpdate
                          : TempLanguage().lblSubscribe,
                      onTap: () async {
                        try {
                          ownShowConfirmDialogCustom(context,
                              title:
                              // (state.isSubscribed &&
                              //     state.planLookUpKey ==
                              //         IndivisualPlan.ind_one_month.name)
                              AppData().entitlementIsActive ==true && AppData().entitlement == myProducts[index].storeProduct.identifier

                                  ? TempLanguage().lblCancelSubscription
                                  : TempLanguage().lblSubscribe,
                              subTitle:
                              // (state.isSubscribed &&
                              //     state.planLookUpKey ==
                              //         IndivisualPlan.ind_one_month.name)
                              AppData().entitlementIsActive ==true && AppData().entitlement == myProducts[index].storeProduct.identifier

                                  ? TempLanguage().lblCancelSubscriptionInfo
                                  : TempLanguage().lblSubscribeInfo,
                              positiveText: TempLanguage().lblOk,
                              cancelable: false,
                              dialogType: CustomDialogType.CONFIRMATION,
                              primaryColor: AppColors.primaryColor,
                              barrierDismissible: false, onAccept: (ctx) {
                                Navigator.pop(ctx);
                                if (
                                // state.isSubscribed
                                AppData().entitlementIsActive

                                ) {
                                  if (
                                  AppData().entitlement == myProducts[index].storeProduct.identifier

                                  // state.planLookUpKey ==
                                  //     IndivisualPlan.ind_one_month.name
                                  ) {
                                    RevenuCatAPI.cancelSubscription();

                                    // showLoadingDialog(context, null);
                                    // cancelSubscription(
                                    //     userCubit,
                                    //     userService,
                                    //     state.subscriptionId,
                                    //     IndivisualPlan.ind_one_month.name,
                                    //     context);
                                  } else {
                                    showLoadingDialog(context, null);
                                    // updateSubscription(
                                    //     userCubit,
                                    //     userService,
                                    //     state.subscriptionId,
                                    //     IndivisualPlan.ind_one_month.name,
                                    //     context);
                                    RevenuCatAPI.purchasePackage(myProducts[index], entitlementIDNew, context).then((value){
                                      RevenuCatAPI.checkAllSubscriptions().then((value) {
                                        Navigator.pop(context);

                                      });

                                    });
                                  }
                                } else {
                                  // showLoadingDialog(context, null);
                                  showLoadingDialog(context, null);
                                  RevenuCatAPI.purchasePackage(myProducts[index], entitlementIDNew, context).then((value) {
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
            }):
        Column(
          children: [
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                return SubscriptionPlanItem(
                  title: TempLanguage().lblNewAgencyStarter,
                  amount: '\$20.00',
                  description: TempLanguage().lblNewAgencyStarterDes,
                  subtitle: TempLanguage().lblOneMonth,
                  isSubscribed: state.isSubscribed &&
                      state.planLookUpKey == AgencyPlan.new_agency_starter.name,
                  buttonText: (state.isSubscribed &&
                          state.planLookUpKey == AgencyPlan.new_agency_starter.name)
                      ? TempLanguage().lblCancel
                      : TempLanguage().lblSubscribe,
                  onTap: () async {
                    try {
                      ownShowConfirmDialogCustom(context,
                          title: (state.isSubscribed &&
                                  state.planLookUpKey ==
                                      AgencyPlan.new_agency_starter.name)
                              ? TempLanguage().lblCancelSubscription
                              : TempLanguage().lblSubscribe,
                          subTitle: (state.isSubscribed &&
                                  state.planLookUpKey ==
                                      AgencyPlan.new_agency_starter.name)
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
                              AgencyPlan.new_agency_starter.name) {
                            showLoadingDialog(context, null);
                            cancelSubscription(
                                userCubit,
                                userService,
                                state.subscriptionId,
                                AgencyPlan.new_agency_starter.name,
                                context);
                          } else {
                            showLoadingDialog(context, null);
                            updateSubscription(
                                userCubit,
                                userService,
                                state.subscriptionId,
                                AgencyPlan.new_agency_starter.name,
                                context);
                          }
                        } else {
                          showLoadingDialog(context, null);
                          subscribe(userService, userCubit, context,
                              AgencyPlan.new_agency_starter.name);
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
                  title: TempLanguage().lblNewAgencyGrowthPlan,
                  amount: '\$204.00',
                  description: TempLanguage().lblNewAgencyGrowthDes,
                  subtitle: TempLanguage().lblOneYear,
                  isSubscribed: state.isSubscribed &&
                      state.planLookUpKey == AgencyPlan.new_agency_growth.name,
                  buttonText: (state.isSubscribed &&
                          state.planLookUpKey == AgencyPlan.new_agency_growth.name)
                      ? TempLanguage().lblCancel
                      : TempLanguage().lblSubscribe,
                  onTap: () async {
                    try {
                      ownShowConfirmDialogCustom(context,
                          title: (state.isSubscribed &&
                                  state.planLookUpKey ==
                                      AgencyPlan.new_agency_growth.name)
                              ? TempLanguage().lblCancelSubscription
                              : TempLanguage().lblSubscribe,
                          subTitle: (state.isSubscribed &&
                                  state.planLookUpKey ==
                                      AgencyPlan.new_agency_growth.name)
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
                              AgencyPlan.new_agency_growth.name) {
                            showLoadingDialog(context, null);
                            cancelSubscription(
                                userCubit,
                                userService,
                                state.subscriptionId,
                                AgencyPlan.new_agency_growth.name,
                                context);
                          } else {
                            showLoadingDialog(context, null);
                            updateSubscription(
                                userCubit,
                                userService,
                                state.subscriptionId,
                                AgencyPlan.new_agency_growth.name,
                                context);
                          }
                        } else {
                          showLoadingDialog(context, null);
                          subscribe(userService, userCubit, context,
                              AgencyPlan.new_agency_growth.name);
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
        ),
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
                      isSubscribed: state.isSubscribed &&
                          state.planLookUpKey ==
                              IndivisualPlan.ind_one_month.name,
                      buttonText:
                      // (state.isSubscribed &&
                      //     state.planLookUpKey ==
                      //         IndivisualPlan.ind_one_month.name)
                      AppData().entitlementIsActive
                          ? AppData().entitlement == myProducts[index].storeProduct.identifier?
                      TempLanguage().lblCancel:
                      TempLanguage().lblUpdate
                          : TempLanguage().lblSubscribe,
                      onTap: () async {
                        try {
                          ownShowConfirmDialogCustom(context,
                              title:
                              // (state.isSubscribed &&
                              //     state.planLookUpKey ==
                              //         IndivisualPlan.ind_one_month.name)
                              AppData().entitlementIsActive ==true && AppData().entitlement == myProducts[index].storeProduct.identifier

                                  ? TempLanguage().lblCancelSubscription
                                  : TempLanguage().lblSubscribe,
                              subTitle:
                              // (state.isSubscribed &&
                              //     state.planLookUpKey ==
                              //         IndivisualPlan.ind_one_month.name)
                              AppData().entitlementIsActive ==true && AppData().entitlement == myProducts[index].storeProduct.identifier

                                  ? TempLanguage().lblCancelSubscriptionInfo
                                  : TempLanguage().lblSubscribeInfo,
                              positiveText: TempLanguage().lblOk,
                              cancelable: false,
                              dialogType: CustomDialogType.CONFIRMATION,
                              primaryColor: AppColors.primaryColor,
                              barrierDismissible: false, onAccept: (ctx) {
                                Navigator.pop(ctx);
                                if (
                                // state.isSubscribed
                                AppData().entitlementIsActive

                                ) {
                                  if (
                                  AppData().entitlement == myProducts[index].storeProduct.identifier

                                  // state.planLookUpKey ==
                                  //     IndivisualPlan.ind_one_month.name
                                  ) {
                                    RevenuCatAPI.cancelSubscription();

                                    // showLoadingDialog(context, null);
                                    // cancelSubscription(
                                    //     userCubit,
                                    //     userService,
                                    //     state.subscriptionId,
                                    //     IndivisualPlan.ind_one_month.name,
                                    //     context);
                                  } else {
                                    showLoadingDialog(context, null);
                                    // updateSubscription(
                                    //     userCubit,
                                    //     userService,
                                    //     state.subscriptionId,
                                    //     IndivisualPlan.ind_one_month.name,
                                    //     context);
                                    RevenuCatAPI.purchasePackage(myProducts[index], entitlementIDInter, context).then((value){
                                      RevenuCatAPI.checkAllSubscriptions().then((value) {
                                        Navigator.pop(context);

                                      });
                                    });
                                  }
                                } else {
                                  // showLoadingDialog(context, null);
                                  showLoadingDialog(context, null);
                                  RevenuCatAPI.purchasePackage(myProducts[index], entitlementIDInter, context).then((value) {
                                    RevenuCatAPI.checkAllSubscriptions().then((value) {
                                      Navigator.pop(context);

                                    });                                  });
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
            }):

        Column(
          children: [
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                return SubscriptionPlanItem(
                  title: TempLanguage().lblIntermediateAgencyStarter,
                  amount: '\$40.00',
                  description: TempLanguage().lblNewAgencyStarter2Des,
                  subtitle: TempLanguage().lblOneMonth,
                  isSubscribed: state.isSubscribed &&
                      state.planLookUpKey ==
                          AgencyPlan.establish_agency_starter.name,
                  buttonText: (state.isSubscribed &&
                          state.planLookUpKey ==
                              AgencyPlan.establish_agency_starter.name)
                      ? TempLanguage().lblCancel
                      : TempLanguage().lblSubscribe,
                  onTap: () async {
                    try {
                      ownShowConfirmDialogCustom(context,
                          title: (state.isSubscribed &&
                                  state.planLookUpKey ==
                                      AgencyPlan.establish_agency_starter.name)
                              ? TempLanguage().lblCancelSubscription
                              : TempLanguage().lblSubscribe,
                          subTitle: (state.isSubscribed &&
                                  state.planLookUpKey ==
                                      AgencyPlan.establish_agency_starter.name)
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
                              AgencyPlan.establish_agency_starter.name) {
                            showLoadingDialog(context, null);
                            cancelSubscription(
                                userCubit,
                                userService,
                                state.subscriptionId,
                                AgencyPlan.establish_agency_starter.name,
                                context);
                          } else {
                            showLoadingDialog(context, null);
                            updateSubscription(
                                userCubit,
                                userService,
                                state.subscriptionId,
                                AgencyPlan.establish_agency_starter.name,
                                context);
                          }
                        } else {
                          showLoadingDialog(context, null);
                          subscribe(userService, userCubit, context,
                              AgencyPlan.establish_agency_starter.name);
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
                  title: TempLanguage().lblIntermediateAgencyGrowthPlan,
                  amount: '\$336.00',
                  description: TempLanguage().lblNewAgencyGrowth2Des,
                  subtitle: TempLanguage().lblOneYear,
                  isSubscribed: state.isSubscribed &&
                      state.planLookUpKey == AgencyPlan.new_agency_growth.name,
                  buttonText: (state.isSubscribed &&
                          state.planLookUpKey == AgencyPlan.new_agency_growth.name)
                      ? TempLanguage().lblCancel
                      : TempLanguage().lblSubscribe,
                  onTap: () async {
                    try {
                      ownShowConfirmDialogCustom(context,
                          title: (state.isSubscribed &&
                                  state.planLookUpKey ==
                                      AgencyPlan.new_agency_growth.name)
                              ? TempLanguage().lblCancelSubscription
                              : TempLanguage().lblSubscribe,
                          subTitle: (state.isSubscribed &&
                                  state.planLookUpKey ==
                                      AgencyPlan.new_agency_growth.name)
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
                              AgencyPlan.new_agency_growth.name) {
                            showLoadingDialog(context, null);
                            cancelSubscription(
                                userCubit,
                                userService,
                                state.subscriptionId,
                                AgencyPlan.new_agency_growth.name,
                                context);
                          } else {
                            showLoadingDialog(context, null);
                            updateSubscription(
                                userCubit,
                                userService,
                                state.subscriptionId,
                                AgencyPlan.new_agency_growth.name,
                                context);
                          }
                        } else {
                          showLoadingDialog(context, null);
                          subscribe(userService, userCubit, context,
                              AgencyPlan.new_agency_growth.name);
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
        ),
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
                      isSubscribed: state.isSubscribed &&
                          state.planLookUpKey ==
                              IndivisualPlan.ind_one_month.name,
                      buttonText:
                      // (state.isSubscribed &&
                      //     state.planLookUpKey ==
                      //         IndivisualPlan.ind_one_month.name)
                      AppData().entitlementIsActive
                          ? AppData().entitlement == myProducts[index].storeProduct.identifier?
                      TempLanguage().lblCancel:
                      TempLanguage().lblUpdate
                          : TempLanguage().lblSubscribe,
                      onTap: () async {
                        print(myProducts[index].storeProduct.title);

                        try {
                          ownShowConfirmDialogCustom(context,
                              title:
                              // (state.isSubscribed &&
                              //     state.planLookUpKey ==
                              //         IndivisualPlan.ind_one_month.name)
                              AppData().entitlementIsActive ==true && AppData().entitlement == myProducts[index].storeProduct.identifier

                                  ? TempLanguage().lblCancelSubscription
                                  : TempLanguage().lblSubscribe,
                              subTitle:
                              // (state.isSubscribed &&
                              //     state.planLookUpKey ==
                              //         IndivisualPlan.ind_one_month.name)
                              AppData().entitlementIsActive ==true && AppData().entitlement == myProducts[index].storeProduct.identifier

                                  ? TempLanguage().lblCancelSubscriptionInfo
                                  : TempLanguage().lblSubscribeInfo,
                              positiveText: TempLanguage().lblOk,
                              cancelable: false,
                              dialogType: CustomDialogType.CONFIRMATION,
                              primaryColor: AppColors.primaryColor,
                              barrierDismissible: false, onAccept: (ctx) {
                                Navigator.pop(ctx);
                                print(myProducts[index].storeProduct.title);
                                if (
                                // state.isSubscribed
                                AppData().entitlementIsActive

                                ) {
                                  if (
                                  AppData().entitlement == myProducts[index].storeProduct.identifier

                                  // state.planLookUpKey ==
                                  //     IndivisualPlan.ind_one_month.name
                                  ) {
                                    RevenuCatAPI.cancelSubscription();

                                    // showLoadingDialog(context, null);
                                    // cancelSubscription(
                                    //     userCubit,
                                    //     userService,
                                    //     state.subscriptionId,
                                    //     IndivisualPlan.ind_one_month.name,
                                    //     context);
                                  } else {
                                    showLoadingDialog(context, null);
                                    // updateSubscription(
                                    //     userCubit,
                                    //     userService,
                                    //     state.subscriptionId,
                                    //     IndivisualPlan.ind_one_month.name,
                                    //     context);
                                    RevenuCatAPI.purchasePackage(myProducts[index], entitlementIDEstab, context).then((value){
                                      RevenuCatAPI.checkAllSubscriptions().then((value) {
                                        Navigator.pop(context);

                                      });
                                    });
                                  }
                                } else {
                                  // showLoadingDialog(context, null);
                                  showLoadingDialog(context, null);
                                  RevenuCatAPI.purchasePackage(myProducts[index], entitlementIDEstab, context).then((value) {
                                    RevenuCatAPI.checkAllSubscriptions().then((value) {
                                      Navigator.pop(context);

                                    });                                  });
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
            }):

        Column(
          children: [
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                return SubscriptionPlanItem(
                  title: TempLanguage().lblEstablishAgencyStarter,
                  amount: '\$60.00',
                  description: TempLanguage().lblEstablishAgencyStarterDes,
                  subtitle: TempLanguage().lblOneMonth,
                  isSubscribed: state.isSubscribed &&
                      state.planLookUpKey == AgencyPlan.new_agency_starter.name,
                  buttonText: (state.isSubscribed &&
                          state.planLookUpKey == AgencyPlan.new_agency_starter.name)
                      ? TempLanguage().lblCancel
                      : TempLanguage().lblSubscribe,
                  onTap: () async {
                    try {
                      ownShowConfirmDialogCustom(context,
                          title: (state.isSubscribed &&
                                  state.planLookUpKey ==
                                      AgencyPlan.new_agency_starter.name)
                              ? TempLanguage().lblCancelSubscription
                              : TempLanguage().lblSubscribe,
                          subTitle: (state.isSubscribed &&
                                  state.planLookUpKey ==
                                      AgencyPlan.new_agency_starter.name)
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
                              AgencyPlan.new_agency_starter.name) {
                            showLoadingDialog(context, null);
                            cancelSubscription(
                                userCubit,
                                userService,
                                state.subscriptionId,
                                AgencyPlan.new_agency_starter.name,
                                context);
                          } else {
                            showLoadingDialog(context, null);
                            updateSubscription(
                                userCubit,
                                userService,
                                state.subscriptionId,
                                AgencyPlan.new_agency_starter.name,
                                context);
                          }
                        } else {
                          showLoadingDialog(context, null);
                          subscribe(userService, userCubit, context,
                              AgencyPlan.new_agency_starter.name);
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
                  title: TempLanguage().lblEstablishAgencyGrowthPlan,
                  amount: '\$400.00',
                  description: TempLanguage().lblEstablishAgencyGrowthDes,
                  subtitle: TempLanguage().lblOneYear,
                  isSubscribed: state.isSubscribed &&
                      state.planLookUpKey ==
                          AgencyPlan.establish_agency_growth.name,
                  buttonText: (state.isSubscribed &&
                          state.planLookUpKey ==
                              AgencyPlan.establish_agency_growth.name)
                      ? TempLanguage().lblCancel
                      : TempLanguage().lblSubscribe,
                  onTap: () async {
                    try {
                      ownShowConfirmDialogCustom(context,
                          title: (state.isSubscribed &&
                                  state.planLookUpKey ==
                                      AgencyPlan.establish_agency_growth.name)
                              ? TempLanguage().lblCancelSubscription
                              : TempLanguage().lblSubscribe,
                          subTitle: (state.isSubscribed &&
                                  state.planLookUpKey ==
                                      AgencyPlan.establish_agency_growth.name)
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
                              AgencyPlan.establish_agency_growth.name) {
                            showLoadingDialog(context, null);
                            cancelSubscription(
                                userCubit,
                                userService,
                                state.subscriptionId,
                                AgencyPlan.establish_agency_growth.name,
                                context);
                          } else {
                            showLoadingDialog(context, null);
                            updateSubscription(
                                userCubit,
                                userService,
                                state.subscriptionId,
                                AgencyPlan.establish_agency_growth.name,
                                context);
                          }
                        } else {
                          showLoadingDialog(context, null);
                          subscribe(userService, userCubit, context,
                              AgencyPlan.establish_agency_growth.name);
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
        ),
      ],
    );
  }

  Future<void> subscribe(UserService userService, UserCubit userCubit,
      BuildContext context, String planLookUpKey) async {
    try {
      final sessionId =
          await StripeService.createCheckoutSession(planLookUpKey);
      String id = sessionId['session']['id'] ?? '';
      String url = sessionId['session']['url'] ?? '';
      if (!context.mounted) return;
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => CheckOutPage(
                sessionId: id,
                planLookUpKey: planLookUpKey,
                url: url,
                userCubit: userCubit,
                userService: userService,
                subscriptionType: SubscriptionType.agency.name,
              )));
    } catch (e) {
      showToast(context, '$e');
    }
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
            SubscriptionType.agency.name, planLookUpKey);
        toast(TempLanguage().lblSubscribedSuccessfully);
        break;
      case 'active':
        syncUserSubscriptionStatus(userService, userCubit, true,
            SubscriptionType.agency.name, planLookUpKey);
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
}
