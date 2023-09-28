import 'package:flutter/material.dart';
import 'package:street_calle/utils/themes/text_theme.dart';
import 'package:street_calle/utils/constant/app_colors.dart';


/// Font family string
const String fontFamily = 'Montserrat';

/// Styles class holding app theming information
class AppThemes {
  /// Dark theme data of the app
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      //fontFamily: fontFamily,
      //scaffoldBackgroundColor: AppColors.primaryColor,
      textTheme: TextThemes.darkTextTheme,
      primaryTextTheme: TextThemes.lightTextTheme,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        //backgroundColor: AppColors.black,
        //titleTextStyle: AppTextStyles.h2,
      ),
      // colorScheme: ColorScheme(background: AppColors.black),
    );
  }

  /// Light theme data of the app
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primaryColor,
      //fontFamily: fontFamily,
      //colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
      useMaterial3: true,
      dialogBackgroundColor: AppColors.whiteColor,
      scaffoldBackgroundColor: AppColors.whiteColor,
      textTheme: TextThemes.textTheme,
      primaryTextTheme: TextThemes.lightTextTheme,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryColor,
        secondary: AppColors.primaryLightColor,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
        backgroundColor: AppColors.whiteColor,
        scrolledUnderElevation: 0.0,
      ),
    );
  }
}
