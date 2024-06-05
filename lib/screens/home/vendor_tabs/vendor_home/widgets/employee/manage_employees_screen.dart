import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/widgets/no_data_found_widget.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/employee/employee_widget.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/generated/locale_keys.g.dart';

class ManageEmployeesScreen extends StatelessWidget {
  const ManageEmployeesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = sl.get<UserService>();
    final userCubit = context.read<UserCubit>();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                AppAssets.backIcon,
                width: 20,
                height: 20,
              )
            ],
          ),
        ),
        title: Text(
          LocaleKeys.manage.tr(),
          style: context.currentTextTheme.titleMedium
              ?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          StreamBuilder<List<User>>(
              stream: userService.getEmployees(userCubit.state.userId),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                  return const NoDataFoundWidget();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(LocaleKeys.somethingWentWrong.tr()),
                      ],
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                    child: ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        var userData = snapshot.data![index];
                        return EmployeeWidget(
                          index: index,
                          userData: userData,
                          onTap: (){
                            context.pushNamed(AppRoutingName.employeeDetail, extra: userData);
                          },
                        );
                      },
                    ),
                  );
                }
              }),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44.0),
              child: SizedBox(
                width: context.width,
                height: defaultButtonSize,
                child: AppButton(
                  text: LocaleKeys.createNewLocation.tr(),
                  elevation: 0.0,
                  onTap: () async {
                    final imageCubit = context.read<ImageCubit>();
                    imageCubit.resetImage();

                    if (userCubit.state.planLookUpKey == AgencyPlan.new_agency_starter_v1.name
                        || userCubit.state.planLookUpKey == AgencyPlan.new_agency_growth_v1.name) {

                      int employeeCount = await userService.getEmployeeCount(userCubit.state.userId);
                      if (employeeCount < 3) {
                        if (!context.mounted) return;
                        context.pushNamed(AppRoutingName.createEmployeeProfileScreen);
                      } else {
                        if (!context.mounted) return;
                        showToast(context, LocaleKeys.forMoreEmployeesUpdatePlan.tr());
                      }

                    } else if (userCubit.state.planLookUpKey == AgencyPlan.intermediate_agency_starter_v1.name
                        || userCubit.state.planLookUpKey == AgencyPlan.intermediate_agency_growth_v1.name) {

                      int employeeCount = await userService.getEmployeeCount(userCubit.state.userId);
                      if (employeeCount < 9) {
                        if (!context.mounted) return;
                        context.pushNamed(AppRoutingName.createEmployeeProfileScreen);
                      } else {
                        if (!context.mounted) return;
                        showToast(context, LocaleKeys.forMoreEmployeesUpdatePlan.tr());
                      }

                    } else if (userCubit.state.planLookUpKey == AgencyPlan.establish_agency_starter_v1.name
                        || userCubit.state.planLookUpKey == AgencyPlan.establish_agency_growth_v1.name) {
                      context.pushNamed(AppRoutingName.createEmployeeProfileScreen);
                    }
                  },
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  textStyle: context.currentTextTheme.labelLarge
                      ?.copyWith(color: AppColors.whiteColor),
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
