import 'package:flutter/material.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/textStyle/app_text_style.dart';


/// Styles class holding app text theming information
class TextThemes {
  /// Main text theme
  static TextTheme get textTheme {
    return const TextTheme(
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
      // bodyLarge: AppTextStyles.bodyLarge,
      // bodyMedium: AppTextStyles.bodyMedium,
      // bodySmall: AppTextStyles.bodySmall,
      // headlineLarge: AppTextStyles.headlineLarge,
      // headlineMedium: AppTextStyles.headlineMedium,
      // headlineSmall: AppTextStyles.headlineSmall,
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      // titleSmall: AppTextStyles.titleSmall,
      // displayLarge: AppTextStyles.displayLarge,
      // displayMedium: AppTextStyles.displayMedium,
      displaySmall: AppTextStyles.displaySmall,
    );
  }

  /// Dark text theme
  static TextTheme get darkTextTheme {
    return TextTheme(
      labelLarge: AppTextStyles.labelLarge.copyWith(
        color: AppColors.whiteColor,
      ),
      labelMedium: AppTextStyles.labelMedium.copyWith(
        color: AppColors.labelBlack,
      ),
      labelSmall: AppTextStyles.labelSmall.copyWith(
        color: AppColors.secondaryFontColor,
      ),
      // bodyLarge: AppTextStyles.bodyLarge.copyWith(
      //   color: AppColors.whiteColor,
      // ),
      // bodyMedium: AppTextStyles.bodyMedium.copyWith(
      //   color: AppColors.whiteColor,
      // ),
      // bodySmall: AppTextStyles.bodySmall.copyWith(
      //   color: AppColors.whiteColor,
      // ),
      // headlineLarge: AppTextStyles.headlineLarge.copyWith(
      //   color: AppColors.whiteColor,
      // ),
      // headlineMedium: AppTextStyles.headlineMedium.copyWith(
      //   color: AppColors.whiteColor,
      // ),
      // headlineSmall: AppTextStyles.headlineSmall.copyWith(
      //   color: AppColors.whiteColor,
      // ),
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium.copyWith(
        color: AppColors.primaryFontColor,
      ),
      // titleSmall: AppTextStyles.titleSmall.copyWith(
      //   color: AppColors.whiteColor,
      // ),
      // displayLarge: AppTextStyles.displayLarge.copyWith(
      //   color: AppColors.whiteColor,
      // ),
      // displayMedium: AppTextStyles.displayMedium.copyWith(
      //   color: AppColors.whiteColor,
      // ),
      displaySmall: AppTextStyles.displaySmall.copyWith(
        color: AppColors.hintColor,
      ),
    );
  }

  /// Light text theme
  static TextTheme get lightTextTheme {
    return TextTheme(
      labelLarge: AppTextStyles.labelLarge.copyWith(
        color: AppColors.whiteColor,
      ),
      labelMedium: AppTextStyles.labelMedium.copyWith(
        color: AppColors.labelBlack,
      ),
      // labelSmall: AppTextStyles.labelSmall.copyWith(
      //   color: AppColors.blackColor,
      // ),
      // bodyLarge: AppTextStyles.bodyLarge.copyWith(
      //   color: AppColors.blackColor,
      // ),
      // bodyMedium: AppTextStyles.bodyMedium.copyWith(
      //   color: AppColors.blackColor,
      // ),
      // bodySmall: AppTextStyles.bodySmall.copyWith(
      //   color: AppColors.blackColor,
      // ),
      // headlineLarge: AppTextStyles.headlineLarge.copyWith(
      //   color: AppColors.blackColor,
      // ),
      // headlineMedium: AppTextStyles.headlineMedium.copyWith(
      //   color: AppColors.blackColor,
      // ),
      // headlineSmall: AppTextStyles.headlineSmall.copyWith(
      //   color: AppColors.blackColor,
      // ),
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium.copyWith(
        color: AppColors.primaryFontColor,
      ),
      // titleSmall: AppTextStyles.titleSmall.copyWith(
      //   color: AppColors.blackColor,
      // ),
      // displayLarge: AppTextStyles.displayLarge.copyWith(
      //   color: AppColors.blackColor,
      // ),
      // displayMedium: AppTextStyles.displayMedium.copyWith(
      //   color: AppColors.blackColor,
      // ),
      displaySmall: AppTextStyles.displaySmall.copyWith(
        color: AppColors.hintColor,
      ),
    );
  }
}
