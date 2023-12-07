import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/auth/cubit/create_employee/create_employee_cubit.dart';
import 'package:street_calle/screens/auth/widgets/custom_text_field.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/employee/create_location_button.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/employee/location_image_widget.dart';

class CreateEmployeeProfileScreen extends StatelessWidget {
   CreateEmployeeProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          TempLanguage().lblCreateLocationProfile,
          style: context.currentTextTheme.titleMedium
              ?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 24,
                ),
                const LocationImageWidget(),
                const SizedBox(
                  height: 24,
                ),
                const Divider(
                  color: AppColors.dividerColor,
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomTextField(
                  hintText: TempLanguage().lblUserName,
                  keyboardType: TextInputType.name,
                  asset: AppAssets.person,
                  controller: context.read<CreateEmployeeCubit>().nameController,
                  isSmall: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomTextField(
                  hintText: TempLanguage().lblEmail,
                  keyboardType: TextInputType.emailAddress,
                  asset: AppAssets.emailIcon,
                  controller: context.read<CreateEmployeeCubit>().emailController,
                  isSmall: false,
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomTextField(
                  hintText: TempLanguage().lblPassword,
                  keyboardType: TextInputType.visiblePassword,
                  asset: AppAssets.passwordIcon,
                  controller: context.read<CreateEmployeeCubit>().passwordController,
                  isSmall: true,
                  isObscure: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: AppColors.primaryFontColor),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: Text(
                        TempLanguage().lblSetEmployeeCredentials,
                        style: context.currentTextTheme.displaySmall
                            ?.copyWith(color: AppColors.primaryFontColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const CreateLocationButton(),
        ],
      ),
    );
  }
}