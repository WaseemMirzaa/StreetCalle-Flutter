import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/cubit/user_state.dart';
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

class AgencyPlans extends StatelessWidget {
  const AgencyPlans({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = sl.get<UserService>();
    final userCubit = context.read<UserCubit>();

    return Column(
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
        const SizedBox(
          height: 18,
        ),
        BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            return SubscriptionPlanItem(
              title: TempLanguage().lblNewAgencyStarter,
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
              title: TempLanguage().lblNewAgencyGrowthPlan,
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
        const SizedBox(
          height: 18,
        ),
        BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            return SubscriptionPlanItem(
              title: TempLanguage().lblNewAgencyStarter,
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
