import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';

class EmployeeDetailScreen extends StatelessWidget {
  const EmployeeDetailScreen({Key? key}) : super(key: key);

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
          TempLanguage().lblEmployeeDetails,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        AppAssets.burgerImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Shehzad',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: METROPOLIS_BOLD,
                                      color: AppColors.primaryFontColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                AppAssets.marker,
                                width: 12,
                                height: 12,
                                color: AppColors.primaryColor,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text('No 03, 4th Lane, Newyork',
                                  style: context.currentTextTheme.displaySmall
                                      ?.copyWith(
                                          color: AppColors.placeholderColor,
                                          fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  color: AppColors.dividerColor,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(AppAssets.itemListIcon),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      TempLanguage().lblItemList,
                      style: context.currentTextTheme.labelLarge
                          ?.copyWith(color: AppColors.primaryFontColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                clipBehavior: Clip.hardEdge,
                                child: Image.asset(
                                  AppAssets.burgerImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            'Shehzad',
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontFamily: METROPOLIS_BOLD,
                                                color:
                                                    AppColors.primaryFontColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          AppAssets.marker,
                                          width: 12,
                                          height: 12,
                                          color: AppColors.primaryColor,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text('No 03, 4th Lane, Newyork',
                                            style: context
                                                .currentTextTheme.displaySmall
                                                ?.copyWith(
                                                    color: AppColors
                                                        .placeholderColor,
                                                    fontSize: 14)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Divider(
                            color: AppColors.dividerColor,
                          ),
                          SizedBox(
                            height: index == 9 ? 60 : 0,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppColors.redColor,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      AppAssets.block,
                      width: 30,
                      height: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: SizedBox(
                      width: context.width,
                      height: defaultButtonSize,
                      child: AppButton(
                        elevation: 0.0,
                        onTap: () {
                          context
                              .pushNamed(AppRoutingName.addEmployeeMenuItems);
                        },
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        color: AppColors.primaryColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppAssets.pencil),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              TempLanguage().lblEditAddMenuItems,
                              style: context.currentTextTheme.labelLarge
                                  ?.copyWith(color: AppColors.whiteColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
