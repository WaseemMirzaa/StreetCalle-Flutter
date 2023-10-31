import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/search_cubit.dart';

class FoodSearchField extends StatelessWidget {
  const FoodSearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0),
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
          onChanged: (String? value) => _searchQuery(context, value),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20),
            filled: true,
            prefixIcon: Container(
                margin: const EdgeInsets.only(left: 5),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(AppAssets.searchIcon, color: AppColors.secondaryFontColor, width: 18, height: 18,),
                  ],
                )
            ),
            hintStyle: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.placeholderColor),
            hintText: TempLanguage().lblSearchFood,
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

  void _searchQuery(BuildContext context, String? value) {
    context.read<FoodSearchCubit>().updateQuery(value ?? '');
  }
}