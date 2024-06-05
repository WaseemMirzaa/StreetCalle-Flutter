import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/my_sizer.dart';

import 'package:street_calle/generated/locale_keys.g.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({Key? key}) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RangeValues _priceRangeValues = const RangeValues(1, 50);
  RangeValues _distanceRangeValues = const RangeValues(1, 50);
  FoodType _foodType = FoodType.none;

  @override
  Widget build(BuildContext context) {
    MySizer().init(context);
    return SizedBox(
      height: MySizer.screenHeight,
      width: MySizer.screenWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Text(
                LocaleKeys.selectFoodType.tr(),
                style: context.currentTextTheme.labelLarge,
              ),

              const SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 4.0,
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        _foodType = FoodType.western;
                      });
                    },
                    child: Chip(
                      label: Text(LocaleKeys.westernFood.tr(), style: context.currentTextTheme.displaySmall,),
                      backgroundColor: _foodType == FoodType.western ? AppColors.primaryLightColor : AppColors.chipBackgroundColor,
                      side: BorderSide.none,
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        _foodType = FoodType.chinese;
                      });
                    },
                    child: Chip(
                      label: Text(LocaleKeys.chineseFood.tr(), style: context.currentTextTheme.displaySmall,),
                      backgroundColor: _foodType == FoodType.chinese ? AppColors.primaryLightColor : AppColors.chipBackgroundColor,
                      side: BorderSide.none,
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        _foodType = FoodType.italian;
                      });
                    },
                    child: Chip(
                      label: Text(LocaleKeys.italianFood.tr(), style: context.currentTextTheme.displaySmall,),
                      backgroundColor: _foodType == FoodType.italian ? AppColors.primaryLightColor : AppColors.chipBackgroundColor,
                      side: BorderSide.none,
                    ),
                  ),
                ],
              ),
              const Divider(color: AppColors.dividerColor, thickness: 1.5,),

              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.filter.tr(),
                    style: context.currentTextTheme.labelLarge,
                  ),
                  InkWell(
                    onTap: (){
                      //context.read<ApplyFilterCubit>().resetApplyFilter();
                      //context.read<FilterItemsCubit>().resetFilterItems();
                      context.pop();
                    },
                    child: Text(
                      LocaleKeys.reset.tr(),
                      style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.price.tr(),
                    style: context.currentTextTheme.labelLarge,
                  ),
                  Text(
                    LocaleKeys.setManually.tr(),
                    style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                      '\$${_priceRangeValues.start.round().toString()}'
                  ),
                  Expanded(
                    child: RangeSlider(
                      values: _priceRangeValues,
                      max: 100,
                      min: 1,
                      labels: RangeLabels(
                        _priceRangeValues.start.round().toString(),
                        _priceRangeValues.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _priceRangeValues = values;
                        });
                      },
                    ),
                  ),
                  Text(
                      '\$${_priceRangeValues.end.round().toString()}'
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.distanceTime.tr(),
                    style: context.currentTextTheme.labelLarge,
                  ),
                  Text(
                    LocaleKeys.setManually.tr(),
                    style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                      '${_distanceRangeValues.start.round().toString()} ${LocaleKeys.mins.tr()}'
                  ),
                  Expanded(
                    child: RangeSlider(
                      values: _distanceRangeValues,
                      max: 100,
                      min: 1,
                      overlayColor: MaterialStateProperty.all<Color?>(AppColors.primaryLightColor),
                      labels: RangeLabels(
                        _distanceRangeValues.start.round().toString(),
                        _distanceRangeValues.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _distanceRangeValues = values;
                        });
                      },
                    ),
                  ),
                  Text(
                      '${_distanceRangeValues.end.round().toString()} ${LocaleKeys.mins.tr()}'
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: context.width,
                child: AppButton(
                  text: LocaleKeys.apply.tr(),
                  elevation: 0.0,
                  onTap: () {
                    // context.read<ApplyFilterCubit>().applyFilter();
                    // context.read<FilterFoodCubit>().filterItems(
                    //     _priceRangeValues.start.roundToDouble(),
                    //     _priceRangeValues.end.roundToDouble(),
                    //     _foodType == FoodType.none ? '' : _foodType.name,
                    //     context.read<ItemList>().state
                    // );
                    // context.pop();
                  },
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),
                  textStyle: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                  color: AppColors.primaryColor,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}