import 'package:flutter/material.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/temp_language.dart';


OutlineInputBorder searchBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(40.0),
  borderSide: const BorderSide(color: AppColors.primaryColor),
);



class VendorHomeTab extends StatelessWidget {
  const VendorHomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20,),
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: const Icon(Icons.image_outlined, color: AppColors.whiteColor,),
            ),
            const SizedBox(height: 12,),
            Text(
              'Hello Amanda!',
              textAlign: TextAlign.center,
              style: context.currentTextTheme.titleMedium?.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 16,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20),
                  filled: true,
                  prefixIcon: Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: const Icon(Icons.search, color: AppColors.secondaryFontColor,)),
                  hintStyle: context.currentTextTheme.displaySmall,
                  hintText: 'Search Item / Deal',
                  fillColor: Colors.white70,
                  border: searchBorder,
                  focusedBorder: searchBorder,
                  disabledBorder: searchBorder,
                  enabledBorder: searchBorder,
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: defaultButtonSize,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                        onPressed: () {

                        },
                        child: Row(
                          children: [
                            Image.asset(AppAssets.add, width: 15, height: 15,),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(
                              TempLanguage().lblAddItem,
                              style: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12,),
                  Expanded(
                    child: SizedBox(
                      height: defaultButtonSize,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                        onPressed: () {},
                        child: Row(
                          children: [
                            Image.asset(AppAssets.add, width: 15, height: 15,),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(
                              TempLanguage().lblAddDeal,
                              style: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
