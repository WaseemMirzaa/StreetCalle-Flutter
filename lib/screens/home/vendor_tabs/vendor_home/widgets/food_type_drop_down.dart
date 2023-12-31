import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_item_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_drop_down_cubit.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_deal_cubit.dart';

OutlineInputBorder titleBorder = OutlineInputBorder(
  borderSide: BorderSide.none,
  borderRadius: BorderRadius.circular(40),
);

class FoodTypeDropDown extends StatelessWidget {
  const FoodTypeDropDown({Key? key, required this.isFromItem}) : super(key: key);
  final bool isFromItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withOpacity(0.35),
                spreadRadius: 0.5,
                blurRadius: 8,
                offset: const Offset(1, 8),
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
                  style: context.currentTextTheme.displaySmall?.copyWith(
                      fontSize: 12, color: AppColors.placeholderColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 16.0, bottom: 16),
                child: BlocBuilder<FoodTypeCubit, List<String>>(
                  builder: (context, state) {
                    return DropdownButtonFormField<String>(
                      value: context.read<FoodTypeCubit>().defaultValue, // Set the currently selected food type
                      onChanged: (String? newValue) => _dropDownValueChanged(context, newValue, isFromItem),
                      items: state.map((foodType) {
                        return DropdownMenuItem<String>(
                          value: foodType,
                          child: Text(foodType),
                        );
                      }).toList(),
                      style: context.currentTextTheme.labelSmall?.copyWith(
                          fontSize: 18, color: AppColors.primaryFontColor),
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        BlocBuilder<FoodTypeDropDownCubit, bool>(
          builder: (context, state) {
            return state
                ? Column(
              children: [
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
                        offset: const Offset(
                            1, 8), // Offset in the Y direction
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 34, top: 12.0),
                        child: Text(
                          TempLanguage().lblAddFoodType,
                          style: context.currentTextTheme.displaySmall
                              ?.copyWith(
                              fontSize: 12,
                              color: AppColors.placeholderColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 16.0, bottom: 16),
                        child: TextField(
                          controller: isFromItem
                              ? context.read<AddItemCubit>().customFoodTypeController
                              : context.read<AddDealCubit>().customFoodTypeController,
                          onSubmitted: (text)=> _onSubmitted(context, text, isFromItem),
                          style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 18, color: AppColors.primaryFontColor),
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
              ],
            )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  void _onSubmitted(BuildContext context, String text, bool isFromItem) {
    final foodTypeCubit = context.read<FoodTypeCubit>();
    final addItemCubit = context.read<AddItemCubit>();
    final addDealCubit = context.read<AddDealCubit>();
    final foodTypeDropDownCubit = context.read<FoodTypeDropDownCubit>();

    foodTypeCubit.defaultValue = text;
    foodTypeCubit.addString(text);
    foodTypeCubit.addToFirebase(text);
    if (isFromItem) {
      addItemCubit.foodTypeController.text = text;
      addItemCubit.customFoodTypeController.clear();
    } else {
      addDealCubit.foodTypeController.text = text;
      addDealCubit.customFoodTypeController.clear();
    }
    foodTypeDropDownCubit.resetState();
  }

  void _dropDownValueChanged(BuildContext context, String? newValue, bool isFromItem) {
    final foodTypeCubit = context.read<FoodTypeCubit>();
    final addItemCubit = context.read<AddItemCubit>();
    final addDealCubit = context.read<AddDealCubit>();
    final foodTypeDropDownCubit = context.read<FoodTypeDropDownCubit>();

    if (!newValue.isEmptyOrNull && newValue != TempLanguage().lblSelect) {
      if (isFromItem) {
        addItemCubit.foodTypeController.text = newValue!;
      } else {
        addDealCubit.foodTypeController.text = newValue!;
      }
      foodTypeCubit.defaultValue = newValue;
      if (newValue == '+ ${TempLanguage().lblAddFoodType}') {
        foodTypeDropDownCubit.addFoodTypeSelected();
      } else {
        foodTypeDropDownCubit.resetState();
      }
    } else {
      foodTypeCubit.defaultValue = TempLanguage().lblSelect;
      if (isFromItem) {
        addItemCubit.foodTypeController.clear();
      } else {
        addDealCubit.foodTypeController.clear();
      }
    }
  }
}