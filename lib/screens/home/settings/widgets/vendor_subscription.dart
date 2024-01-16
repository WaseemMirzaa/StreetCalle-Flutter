import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/home/settings/cubit/subscription_cubit.dart';
import 'package:street_calle/screens/home/settings/widgets/subscription_plan_item.dart';
import 'package:street_calle/services/stripe_service.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/utils/common.dart';

class VendorSubscription extends StatelessWidget {
  const VendorSubscription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = sl.get<UserService>();
    final userCubit = context.read<UserCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          TempLanguage().lblSubscriptionPlans,
          style: context.currentTextTheme.titleMedium?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () => ContextExtensions(context).pop(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(AppAssets.backIcon, width: 20, height: 20,)
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text(
                TempLanguage().lblChooseAPlane,
                style: context.currentTextTheme.titleMedium?.copyWith(fontSize: 32, color: AppColors.primaryFontColor),
              ),
              const SizedBox(height: 18,),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding:  const EdgeInsets.symmetric(horizontal: 24),
                height: 150,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image.asset(AppAssets.checkMarkIcon, width: 15, height: 15,),
                        const SizedBox(width: 16,),
                        Flexible(
                          child: Text(
                            TempLanguage().lblAddUnlimitedMenuItems,
                            style: const TextStyle(
                                fontFamily: METROPOLIS_BOLD,
                                fontSize: 16,
                                color: AppColors.whiteColor
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12,),
                    Row(
                      children: [
                        Image.asset(AppAssets.checkMarkIcon, width: 15, height: 15,),
                        const SizedBox(width: 16,),
                        Flexible(
                          child: Text(
                            TempLanguage().lblMakeYourTruckVisible,
                            style: const TextStyle(
                                fontFamily: METROPOLIS_BOLD,
                                fontSize: 16,
                                color: AppColors.whiteColor
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18,),

              BlocConsumer<SubscriptionCubit, SubscriptionState>(
                listener: (context, state) {

                  if (state is SubscriptionSuccess) {

                  } else if (state is SubscriptionFailure) {
                    showToast(context, state.error);
                  } else if (state is SubscriptionLoading) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Alert'),
                          content: const Text('This is a simple alert dialog.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Close the alert dialog
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }

                },
                builder: (context, state) {
                  return SubscriptionPlanItem(
                    title: TempLanguage().lblOneMonth,
                    amount: '\$20',
                    subtitle: TempLanguage().lblForStarter,
                    onTap: () async {
                      try {
                        final stripeId = await getStripeId(userCubit, userService, context, userCubit.state.userId);

                        if (userCubit.state.isSubscribed) {
                          cancelSubscription(userCubit, userService, stripeId);
                        } else {
                          subscribe(stripeId, userService, userCubit);
                        }

                      } catch (e) {
                        toast('$e');
                      }
                    },
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
  
  Future<String> getStripeId(UserCubit userCubit, UserService userService, BuildContext context, String userId) async {
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
  }

  Future<void> subscribe(String stripeId, UserService userService, UserCubit userCubit) async {
    final ephemeralKey = await StripeService.createEphemeralKey(stripeId);
    final paymentIntent = await StripeService.createPaymentIntent('2000', stripeId);
    await StripeService.createCreditCard(stripeId ?? '', paymentIntent['paymentIntent'], ephemeralKey['ephemeralKey']);
    final customerPaymentMethod = await StripeService.getCustomerPaymentMethods(stripeId ?? '');
    final subscription = await StripeService.createSubscription(stripeId ?? '', customerPaymentMethod['paymentMethod']['data'][0]['id'], IndivisualPlan.ind_one_month.name);

    switch(subscription['subscription']['status']) {
      case 'incomplete':
        break;
      case 'incomplete_expired':
        break;
      case 'trialing':
        final result = await userService.updateUserSubscription(true, SubscriptionType.individual.name, userCubit.state.userId);
        if (result) {
          userCubit.setIsSubscribed(true);
          userCubit.setSubscriptionType(SubscriptionType.individual.name);
        }
        toast('Subscribed successfully');
        break;
      case 'active':
        final result = await userService.updateUserSubscription(true, SubscriptionType.individual.name, userCubit.state.userId);
        if (result) {
          userCubit.setIsSubscribed(true);
          userCubit.setSubscriptionType(SubscriptionType.individual.name);
        }
        break;
      case 'past_due':
        break;
      case 'canceled':
        final result = await userService.updateUserSubscription(false, SubscriptionType.none.name, userCubit.state.userId);
        if (result) {
          userCubit.setIsSubscribed(false);
          userCubit.setSubscriptionType(SubscriptionType.none.name);
        }
        break;
      case 'unpaid':
        break;
    }
  }

  Future<void> cancelSubscription(UserCubit userCubit, UserService userService, String stripeId) async {
    final subscriptionId = await StripeService.getSubscriptionId(stripeId);
    final cancelSubscription = await StripeService.cancelSubscription(subscriptionId['subscriptionId']);
    switch(cancelSubscription['subscription']['status']) {
      case 'incomplete':
        break;
      case 'incomplete_expired':
        break;
      case 'trialing':
        final result = await userService.updateUserSubscription(true, SubscriptionType.individual.name, userCubit.state.userId);
        if (result) {
          userCubit.setIsSubscribed(true);
          userCubit.setSubscriptionType(SubscriptionType.individual.name);
        }
        break;
      case 'active':
        final result = await userService.updateUserSubscription(true, SubscriptionType.individual.name, userCubit.state.userId);
        if (result) {
          userCubit.setIsSubscribed(true);
          userCubit.setSubscriptionType(SubscriptionType.individual.name);
        }
        break;
      case 'past_due':
        break;
      case 'canceled':
        final result = await userService.updateUserSubscription(false, SubscriptionType.none.name, userCubit.state.userId);
        if (result) {
          userCubit.setIsSubscribed(false);
          userCubit.setSubscriptionType(SubscriptionType.none.name);
        }
        toast('Cancelled successfully');
        break;
      case 'unpaid':
        break;
    }
  }
}
