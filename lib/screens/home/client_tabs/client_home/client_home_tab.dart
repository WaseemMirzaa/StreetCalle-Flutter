import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';

class ClientHomeTab extends StatelessWidget {
  const ClientHomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 54, left: 24, right: 24),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (String? value) {},
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20),
                      filled: true,
                      prefixIcon: Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryLightColor,
                            shape: BoxShape.circle
                          ),
                          child: const Icon(Icons.search, color: AppColors.hintColor,)),
                      hintStyle: context.currentTextTheme.displaySmall,
                      hintText: TempLanguage().lblSearchFoodTrucks,
                      fillColor: AppColors.whiteColor,
                      border: clientSearchBorder,
                      focusedBorder: clientSearchBorder,
                      disabledBorder: clientSearchBorder,
                      enabledBorder: clientSearchBorder,
                    ),
                  ),
                ),
                const SizedBox(width: 16,),
                InkWell(
                  onTap: (){
                    context.pushNamed(AppRoutingName.clientMenu);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLightColor,
                      shape: BoxShape.circle
                    ),
                    child: Image.asset(AppAssets.topMenuIcon),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
