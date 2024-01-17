import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/home/settings/widgets/subscription_plan_item.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/dependency_injection.dart';

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
              amount: '\$40',
              description: TempLanguage().lblNewAgencyStarterDes,
              subtitle: TempLanguage().lblOneMonth,
              isSubscribed: state.isSubscribed && state.planLookUpKey == AgencyPlan.new_agency_starter.name,
              buttonText: (state.isSubscribed && state.planLookUpKey == AgencyPlan.new_agency_starter.name) ? 'Cancel' : 'Subscribe',
              onTap: () async {},
            );
          },
        ),
        const SizedBox(height: 18,),
        BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            return SubscriptionPlanItem(
              title: TempLanguage().lblNewAgencyGrowthPlan,
              amount: '\$384',
              description: TempLanguage().lblNewAgencyGrowthDes,
              subtitle: TempLanguage().lblOneYear,
              isSubscribed: state.isSubscribed && state.planLookUpKey == AgencyPlan.new_agency_growth.name,
              buttonText: (state.isSubscribed && state.planLookUpKey == AgencyPlan.new_agency_growth.name) ? 'Cancel' : 'Subscribe',
              onTap: () async {},
            );
          },
        ),
        const SizedBox(height: 18,),
        BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            return SubscriptionPlanItem(
              title: TempLanguage().lblEstablishAgencyStarter,
              amount: '\$60',
              description: TempLanguage().lblEstablishAgencyStarterDes,
              subtitle: TempLanguage().lblOneMonth,
              isSubscribed: state.isSubscribed && state.planLookUpKey == AgencyPlan.establish_agency_starter.name,
              buttonText: (state.isSubscribed && state.planLookUpKey == AgencyPlan.establish_agency_starter.name) ? 'Cancel' : 'Subscribe',
              onTap: () async {},
            );
          },
        ),
        const SizedBox(height: 18,),
        BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            return SubscriptionPlanItem(
              title: TempLanguage().lblEstablishAgencyGrowthPlan,
              amount: '\$576',
              description: TempLanguage().lblEstablishAgencyGrowthDes,
              subtitle: TempLanguage().lblOneYear,
              isSubscribed: state.isSubscribed && state.planLookUpKey == AgencyPlan.establish_agency_growth.name,
              buttonText: (state.isSubscribed && state.planLookUpKey == AgencyPlan.establish_agency_growth.name) ? 'Cancel' : 'Subscribe',
              onTap: () async {},
            );
          },
        ),
      ],
    );
  }
}