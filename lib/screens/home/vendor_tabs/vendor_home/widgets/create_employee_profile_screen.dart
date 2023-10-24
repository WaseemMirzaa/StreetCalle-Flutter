import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/screens/auth/widgets/custom_text_field.dart';

class CreateEmployeeProfileScreen extends StatelessWidget {
  const CreateEmployeeProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          TempLanguage().lblCreateEmployeeProfile,
          style: context.currentTextTheme.titleMedium
              ?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultHorizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 24,
                ),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blackColor.withOpacity(0.35),
                        spreadRadius: 0.5, // Spread radius
                        blurRadius: 4, // Blur radius
                        offset: const Offset(1, 4), // Offset in the Y direction
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      AppAssets.camera,
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
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
                  controller: TextEditingController(),
                  isPassword: false,
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomTextField(
                  hintText: TempLanguage().lblEmail,
                  keyboardType: TextInputType.emailAddress,
                  asset: AppAssets.emailIcon,
                  controller: TextEditingController(),
                  isPassword: false,
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomTextField(
                  hintText: TempLanguage().lblPassword,
                  keyboardType: TextInputType.visiblePassword,
                  asset: AppAssets.passwordIcon,
                  controller: TextEditingController(),
                  isPassword: true,
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
                  text: TempLanguage().lblAddNewEmployee,
                  elevation: 0.0,
                  onTap: () async {
                    //context.pushNamed(AppRoutingName.loginScreen);
                    //context.pushNamed(AppRoutingName.createEmployeeProfileScreen);
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
