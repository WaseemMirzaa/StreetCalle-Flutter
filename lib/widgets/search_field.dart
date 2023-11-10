import 'package:flutter/material.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';

class SearchField extends StatelessWidget {
  SearchField({Key? key, required this.onChanged, required this.hintText, required this.padding}) : super(key: key);
  final ValueChanged<String?> onChanged;
  final String hintText;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withOpacity(0.25),
              spreadRadius: 2, // Spread radius
              blurRadius: 15, // Blur radius
              offset: const Offset(0, 8), // Offset in the Y direction
            ),
          ],
        ),
        child: TextField(
          onChanged: (String? value) => onChanged.call(value),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20),
            filled: true,
            prefixIconConstraints: const BoxConstraints(
                minWidth: 60,
                minHeight: 40
            ),
            prefixIcon: Container(
                margin: const EdgeInsets.only(right: 4),
                decoration: const BoxDecoration(
                    color: AppColors.primaryLightColor,
                    shape: BoxShape.circle
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(AppAssets.searchIcon, color: AppColors.blackColor, width: 18, height: 18,),
                  ],
                )
            ),
            hintStyle: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.placeholderColor),
            hintText: hintText,
            fillColor: AppColors.whiteColor,
            border: clientSearchBorder,
            focusedBorder: clientSearchBorder,
            disabledBorder: clientSearchBorder,
            enabledBorder: clientSearchBorder,
          ),
        ),
      ),
    );
  }
}