import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/constants.dart';


OutlineInputBorder titleBorder =  OutlineInputBorder(
  borderSide: BorderSide.none,
  borderRadius: BorderRadius.circular(40),
);


class AddItem extends StatelessWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TempLanguage().lblCreateMenu,
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
              //const SizedBox(height: 16,),
              Text(
                TempLanguage().lblAddItem,
                style: const TextStyle(
                  fontFamily: METROPOLIS_BOLD,
                  fontSize: 18,
                  color: AppColors.primaryFontColor
                )
              ),
              const SizedBox(
                height: 24,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  width: context.width,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blackColor.withOpacity(0.35),
                        spreadRadius: 0.5, // Spread radius
                        blurRadius: 8, // Blur radius
                        offset: const Offset(1, 8), // Offset in the Y direction
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(AppAssets.camera, width: 60, height: 60,),
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackColor.withOpacity(0.35),
                      spreadRadius: 0.5, // Spread radius
                      blurRadius: 8, // Blur radius
                      offset: const Offset(1, 8), // Offset in the Y direction
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 34, top: 12.0),
                      child: Text(
                        TempLanguage().lblItemTitle,
                        style: context.currentTextTheme.displaySmall?.copyWith(fontSize: 12, color: AppColors.placeholderColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 16.0, bottom: 16),
                      child: TextField(
                        style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.primaryFontColor),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 10),
                          isDense: true,
                          filled: true,
                          fillColor: AppColors.whiteColor,
                          border: titleBorder,
                          enabledBorder: titleBorder,
                          focusedBorder: titleBorder,
                          disabledBorder: titleBorder,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Text(
                        TempLanguage().lblPrice,
                        style: context.currentTextTheme.labelLarge?.copyWith(fontSize: 14, color: AppColors.primaryFontColor)
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blackColor.withOpacity(0.35),
                              spreadRadius: 0.5, // Spread radius
                              blurRadius: 8, // Blur radius
                              offset: const Offset(1, 8), // Offset in the Y direction
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 18, top: 12.0),
                              child: Text(
                                TempLanguage().lblActualPrice,
                                style: context.currentTextTheme.displaySmall?.copyWith(fontSize: 12, color: AppColors.placeholderColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 16.0, bottom: 12, top: 6),
                              child: TextField(
                                style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.primaryFontColor),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 10),
                                  isDense: true,
                                  filled: true,
                                  fillColor: AppColors.whiteColor,
                                  border: titleBorder,
                                  enabledBorder: titleBorder,
                                  focusedBorder: titleBorder,
                                  disabledBorder: titleBorder,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blackColor.withOpacity(0.35),
                              spreadRadius: 0.5, // Spread radius
                              blurRadius: 8, // Blur radius
                              offset: const Offset(1, 8), // Offset in the Y direction
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 18, top: 12.0),
                              child: Text(
                                TempLanguage().lblDiscountedPrice,
                                style: context.currentTextTheme.displaySmall?.copyWith(fontSize: 12, color: AppColors.placeholderColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 16.0, bottom: 12, top: 6),
                              child: TextField(
                                style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.primaryFontColor),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 10),
                                  isDense: true,
                                  filled: true,
                                  fillColor: AppColors.whiteColor,
                                  border: titleBorder,
                                  enabledBorder: titleBorder,
                                  focusedBorder: titleBorder,
                                  disabledBorder: titleBorder,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),

              Text(
                  TempLanguage().lblItemAddPricingCategories,
                  style: const TextStyle(
                      fontFamily: METROPOLIS_BOLD,
                      fontSize: 18,
                      color: AppColors.primaryFontColor
                  )
              ),
              const SizedBox(
                height: 16,
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackColor.withOpacity(0.35),
                      spreadRadius: 0.5, // Spread radius
                      blurRadius: 8, // Blur radius
                      offset: const Offset(1, 8), // Offset in the Y direction
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 34, top: 12.0),
                      child: Text(
                        TempLanguage().lblItemDescription,
                        style: context.currentTextTheme.displaySmall?.copyWith(fontSize: 12, color: AppColors.placeholderColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 16.0, bottom: 16),
                      child: TextField(
                        style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.primaryFontColor),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 10),
                          isDense: true,
                          filled: true,
                          fillColor: AppColors.whiteColor,
                          border: titleBorder,
                          enabledBorder: titleBorder,
                          focusedBorder: titleBorder,
                          disabledBorder: titleBorder,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),

              Text(
                  TempLanguage().lblItemAddFoodType,
                  style: const TextStyle(
                      fontFamily: METROPOLIS_BOLD,
                      fontSize: 18,
                      color: AppColors.primaryFontColor
                  )
              ),
              const SizedBox(
                height: 16,
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackColor.withOpacity(0.35),
                      spreadRadius: 0.5, // Spread radius
                      blurRadius: 8, // Blur radius
                      offset: const Offset(1, 8), // Offset in the Y direction
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 34, top: 12.0),
                      child: Text(
                        TempLanguage().lblItemFoodType,
                        style: context.currentTextTheme.displaySmall?.copyWith(fontSize: 12, color: AppColors.placeholderColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 16.0, bottom: 16),
                      child: TextField(
                        style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.primaryFontColor),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 10),
                          isDense: true,
                          filled: true,
                          fillColor: AppColors.whiteColor,
                          border: titleBorder,
                          enabledBorder: titleBorder,
                          focusedBorder: titleBorder,
                          disabledBorder: titleBorder,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  width: context.width,
                  height: defaultButtonSize,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    onPressed: (){},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppAssets.add, width: 15, height: 15,),
                        const SizedBox(width: 16,),
                        Text(
                          TempLanguage().lblItemAddToMenu,
                          style: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
