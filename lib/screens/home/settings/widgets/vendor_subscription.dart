import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/home/settings/widgets/subscription_plan_item.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/dependency_injection.dart';

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
          onTap: () => context.pop(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(AppAssets.backIcon, width: 20, height: 20,)
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                        Text(
                          TempLanguage().lblAddUnlimitedMenuItems,
                          style: const TextStyle(
                            fontFamily: METROPOLIS_BOLD,
                            fontSize: 16,
                            color: AppColors.whiteColor
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12,),
                    Row(
                      children: [
                        Image.asset(AppAssets.checkMarkIcon, width: 15, height: 15,),
                        const SizedBox(width: 16,),
                        Text(
                          TempLanguage().lblMakeYourTruckVisible,
                          style: const TextStyle(
                              fontFamily: METROPOLIS_BOLD,
                              fontSize: 16,
                              color: AppColors.whiteColor
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18,),
              SubscriptionPlanItem(
                title: TempLanguage().lblOneMonth,
                amount: '\$24',
                subtitle: TempLanguage().lblForStarter,
                onTap: () async {
                  final result = await userService.updateUserSubscription(true, SubscriptionType.individual.name, userCubit.state.userId);
                  if (result) {
                    userCubit.setIsSubscribed(true);
                    userCubit.setSubscriptionType(SubscriptionType.individual.name);
                  }
                },
              ),

              const SizedBox(height: 18,),
              SubscriptionPlanItem(
                title: TempLanguage().lblSixMonths,
                amount: '\$50',
                subtitle: TempLanguage().lblForStarter,
                onTap: () async {
                  final result = await userService.updateUserSubscription(true, SubscriptionType.individual.name, userCubit.state.userId);
                  if (result) {
                    userCubit.setIsSubscribed(true);
                    userCubit.setSubscriptionType(SubscriptionType.individual.name);
                  }
                },
              ),

              const SizedBox(height: 18,),
              SubscriptionPlanItem(
                title: TempLanguage().lblTwelveMonths,
                amount: '\$100',
                subtitle: TempLanguage().lblForStarter,
                onTap: () async {
                  final result = await userService.updateUserSubscription(true, SubscriptionType.agency.name, userCubit.state.userId);
                  if (result) {
                    userCubit.setIsSubscribed(true);
                    userCubit.setSubscriptionType(SubscriptionType.agency.name);
                  }
                },
              ),
              const SizedBox(height: 18,),
            ],
          ),
        ),
      ),
    );
  }
}
