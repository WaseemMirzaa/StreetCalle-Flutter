import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/generated/locale_keys.g.dart';

class ManageVendorLocations extends StatelessWidget {
  const ManageVendorLocations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return (state.vendorType.isEmpty ||
                state.vendorType.toLowerCase() == VendorType.individual.name)
            ? const SizedBox.shrink()
            : InkWell(
                onTap: () {
                  if (state.isSubscribed && state.subscriptionType.toLowerCase() ==
                          SubscriptionType.agency.name.toLowerCase()) {
                    context.pushNamed(AppRoutingName.manageEmployee);
                  } else {
                    showToast(
                        context, LocaleKeys.pleaseSubscribedAgencyFirst.tr());
                  }
                },
                child: Text(
                  LocaleKeys.manageLocations.tr(),
                  style: context.currentTextTheme.titleMedium?.copyWith(
                      color: AppColors.primaryColor,
                      fontSize: 24,
                      decoration: TextDecoration.underline),
                ),
              );
      },
    );
  }
}