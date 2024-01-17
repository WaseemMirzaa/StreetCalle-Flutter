import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/services/stripe_service.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/home/settings/widgets/subscription_plan_item.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/dependency_injection.dart';

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
                  showLoadingDialog(context, null);
                  final stripeId = await getStripeId(userCubit, userService, context, userCubit.state.userId);
                  if (stripeId.isEmpty) {
                    toast('Something went wrong.');
                  }

                  if (userCubit.state.isSubscribed) {
                    cancelSubscription(userCubit, userService, stripeId, IndivisualPlan.ind_one_month.name);
                  } else {
                    if (!context.mounted) return;
                    String amount = (20 * 100) as String;
                    subscribe(stripeId, userService, userCubit, amount, context, IndivisualPlan.ind_one_month.name);
                  }


                  // final result = await userService.updateUserSubscription(true, SubscriptionType.individual.name, userCubit.state.userId);
                  // if (result) {
                  //   if (state.isSubscribed) {
                  //     if (state.planLookUpKey == IndivisualPlan.ind_one_month.name) {
                  //       userCubit.setIsSubscribed(false);
                  //       userCubit.setSubscriptionType(SubscriptionType.none.name);
                  //       userCubit.setPlanLookUpKey('');
                  //     } else {
                  //       userCubit.setIsSubscribed(true);
                  //       userCubit.setSubscriptionType(SubscriptionType.individual.name);
                  //       userCubit.setPlanLookUpKey(IndivisualPlan.ind_one_month.name);
                  //     }
                  //   } else {
                  //     userCubit.setIsSubscribed(true);
                  //     userCubit.setSubscriptionType(SubscriptionType.individual.name);
                  //     userCubit.setPlanLookUpKey(IndivisualPlan.ind_one_month.name);
                  //   }
                  // }

                } catch (e) {
                  if (!context.mounted) return;
                  Navigator.pop(context);
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

                  if (state.isSubscribed) {
                    if (state.planLookUpKey == IndivisualPlan.ind_one_year.name) {
                      userCubit.setIsSubscribed(false);
                      userCubit.setSubscriptionType(SubscriptionType.none.name);
                      userCubit.setPlanLookUpKey('');
                    } else {
                      userCubit.setIsSubscribed(true);
                      userCubit.setSubscriptionType(SubscriptionType.individual.name);
                      userCubit.setPlanLookUpKey(IndivisualPlan.ind_one_year.name);
                    }
                  } else {
                    userCubit.setIsSubscribed(true);
                    userCubit.setSubscriptionType(SubscriptionType.individual.name);
                    userCubit.setPlanLookUpKey(IndivisualPlan.ind_one_year.name);
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

  Future<String> getStripeId(UserCubit userCubit, UserService userService, BuildContext context, String userId) async {
    try {
      String? stripeId;
      if (userCubit.state.stripeId.isEmptyOrNull) {
            final result = await StripeService.createCustomer(userCubit.state.userEmail);
            stripeId = result['customer'];
            await userService.updateStripeId(stripeId ?? '', userCubit.state.userId);
            if (!context.mounted) return '';
            context.read<UserCubit>().setStripeId(stripeId ?? '');
          } else {
            stripeId = userCubit.state.stripeId;
          }
      return stripeId ?? '';
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<void> subscribe(String stripeId, UserService userService, UserCubit userCubit, String amount, BuildContext context, String planLookUpKey) async {
    try {
      final ephemeralKey = await StripeService.createEphemeralKey(stripeId);
      final paymentIntent = await StripeService.createPaymentIntent(amount, stripeId);

      if (!context.mounted) return;
      Navigator.pop(context);

      await StripeService.createCreditCard(stripeId ?? '', paymentIntent['paymentIntent'], ephemeralKey['ephemeralKey']);
      final customerPaymentMethod = await StripeService.getCustomerPaymentMethods(stripeId ?? '');
      final subscription = await StripeService.createSubscription(stripeId ?? '', customerPaymentMethod['paymentMethod']['data'][0]['id'], planLookUpKey);
      subscriptionStatus(subscription['subscription']['status'], userService, userCubit, stripeId, planLookUpKey);

    } catch (e) {
      toast('$e');
      print(e);
    }

  }

  Future<void> cancelSubscription(UserCubit userCubit, UserService userService, String stripeId, String planLookUpKey) async {
    final subscriptionId = await StripeService.getSubscriptionId(stripeId);
    final cancelSubscription = await StripeService.cancelSubscription(subscriptionId['subscriptionId']);
    subscriptionStatus(cancelSubscription['subscription']['status'], userService, userCubit, stripeId, planLookUpKey);
  }

  Future<void> subscriptionStatus(String status, UserService userService, UserCubit userCubit, String stripeId, String planLookUpKey) async {
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