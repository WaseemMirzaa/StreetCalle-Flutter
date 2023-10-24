import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';

class AddEmployeeMenuItemsScreen extends StatelessWidget {
  const AddEmployeeMenuItemsScreen({Key? key}) : super(key: key);

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
          TempLanguage().lblAddMenuItems,
          style: context.currentTextTheme.titleMedium
              ?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {},
              child: Column(
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
                            Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Burgers',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: METROPOLIS_BOLD,
                                        color: AppColors.primaryFontColor),
                                  ),
                                ),
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: true,
                                  side: const BorderSide(
                                      color: AppColors.primaryFontColor,
                                      width: 1.5),
                                  shape: const StadiumBorder(),
                                  onChanged: (bool? value) {},
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
                            const SizedBox(
                              height: 6,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Divider(
                    color: AppColors.dividerColor,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
