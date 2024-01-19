import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/services/stripe_service.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/home/settings/widgets/subscription_plan_item.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/screens/home/settings/widgets/check_out_page.dart';

class IndividualPlans extends StatelessWidget {
  const IndividualPlans({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = sl.get<UserService>();
    final userCubit = context.read<UserCubit>();

    return Column(
      children: [
        BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            return SubscriptionPlanItem(
              title: TempLanguage().lblIndividualStarter,
              amount: '\$20',
              description: TempLanguage().lblIndividualStarterDes,
              subtitle: TempLanguage().lblOneMonth,
              isSubscribed: state.isSubscribed && state.planLookUpKey == IndivisualPlan.ind_one_month.name,
              buttonText: (state.isSubscribed && state.planLookUpKey == IndivisualPlan.ind_one_month.name) ? TempLanguage().lblCancel : TempLanguage().lblSubscribe,
              onTap: () async {
                try {
                  if (state.isSubscribed) {
                    if (state.planLookUpKey == IndivisualPlan.ind_one_month.name) {
                      cancelSubscription(userCubit, userService, state.subscriptionId, IndivisualPlan.ind_one_month.name);
                    } else {
                      updateSubscription(userCubit, userService, state.subscriptionId, IndivisualPlan.ind_one_month.name);
                    }
                  } else {
                    subscribe(userService, userCubit, context, IndivisualPlan.ind_one_month.name);
                  }
                } catch (e) {
                  toast('$e');
                }
              },
            );
          },
        ),
        const SizedBox(height: 18,),
        BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            return SubscriptionPlanItem(
              title: TempLanguage().lblIndividualGrowthPlan,
              amount: '\$192',
              description: TempLanguage().lblIndividualGrowthDes,
              buttonText: (state.isSubscribed && state.planLookUpKey == IndivisualPlan.ind_one_year.name) ? TempLanguage().lblCancel : TempLanguage().lblSubscribe,
              isSubscribed: state.isSubscribed && state.planLookUpKey == IndivisualPlan.ind_one_year.name,
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

                  if (state.isSubscribed) {
                    if (state.planLookUpKey == IndivisualPlan.ind_one_year.name) {
                      cancelSubscription(userCubit, userService, state.subscriptionId, IndivisualPlan.ind_one_year.name);
                    } else {
                      updateSubscription(userCubit, userService, state.subscriptionId, IndivisualPlan.ind_one_year.name);
                    }
                  } else {
                    subscribe(userService, userCubit, context, IndivisualPlan.ind_one_year.name);
                  }

                } catch (e) {
                  toast('$e');
                }
              },
            );
          },
        ),
      ],
    );
  }

  Future<void> subscribe(UserService userService, UserCubit userCubit, BuildContext context, String planLookUpKey) async {
    try {
      final sessionId = await StripeService.createCheckoutSession(planLookUpKey);
      String id = sessionId['session']['id'] ?? '';
      String url = sessionId['session']['url'] ?? '';
      if (!context.mounted) return;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => CheckOutPage(
            sessionId: id,
            planLookUpKey: planLookUpKey,
            url: url,
            userCubit: userCubit,
            userService: userService,
            subscriptionType: SubscriptionType.individual.name,
          )
       )
      );
    } catch (e) {
      toast('$e');
    }
  }

  Future<void> cancelSubscription(UserCubit userCubit, UserService userService, String subscriptionId, String planLookUpKey) async {
    final cancelSubscription = await StripeService.cancelSubscription(subscriptionId);
    subscriptionStatus(cancelSubscription['subscription']['status'], userService, userCubit, planLookUpKey);
  }

  Future<void> updateSubscription(UserCubit userCubit, UserService userService, String subscriptionId, String planLookUpKey) async {
    final updateSubscription = await StripeService.updateSubscription(subscriptionId, planLookUpKey);
    subscriptionStatus(updateSubscription['subscription']['status'], userService, userCubit, planLookUpKey);
  }

  Future<void> subscriptionStatus(String status, UserService userService, UserCubit userCubit, String planLookUpKey) async {
    switch(status) {
      case 'incomplete':
        break;
      case 'incomplete_expired':
        break;
      case 'trialing':
        syncUserSubscriptionStatus(userService, userCubit, true, SubscriptionType.individual.name, planLookUpKey);
        toast('Subscribed successfully');
        break;
      case 'active':
        syncUserSubscriptionStatus(userService, userCubit, true, SubscriptionType.individual.name, planLookUpKey);
        break;
      case 'past_due':
        break;
      case 'canceled':
        syncUserSubscriptionStatus(userService, userCubit, false, SubscriptionType.none.name, '');
        toast('Canceled successfully');
        break;
      case 'unpaid':
        break;
    }
  }

  Future<void> syncUserSubscriptionStatus(UserService userService, UserCubit userCubit, bool isSubscribed, String subscriptionType, String planLookUpKey) async {
    final result = await userService.updateUserSubscription(isSubscribed, subscriptionType, userCubit.state.userId, planLookUpKey);
    if (result) {
      userCubit.setIsSubscribed(isSubscribed);
      userCubit.setSubscriptionType(subscriptionType);
      userCubit.setPlanLookUpKey(planLookUpKey);
    }
  }
}