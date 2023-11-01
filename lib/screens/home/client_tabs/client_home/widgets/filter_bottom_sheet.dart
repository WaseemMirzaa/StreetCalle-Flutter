import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/filter_food_cubit.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/my_sizer.dart';

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
                TempLanguage().lblSelectFoodType,
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
                      label: Text(TempLanguage().lblWesternFood, style: context.currentTextTheme.displaySmall,),
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
                      label: Text(TempLanguage().lblChineseFood, style: context.currentTextTheme.displaySmall,),
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
                      label: Text(TempLanguage().lblItalianFood, style: context.currentTextTheme.displaySmall,),
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
                    TempLanguage().lblFilter,
                    style: context.currentTextTheme.labelLarge,
                  ),
                  InkWell(
                    onTap: (){
                      context.read<FilterFoodCubit>().resetFilterItems();
                      context.pop();
                    },
                    child: Text(
                      TempLanguage().lblReset,
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
                    TempLanguage().lblPrice,
                    style: context.currentTextTheme.labelLarge,
                  ),
                  Text(
                    TempLanguage().lblSetManually,
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
                    TempLanguage().lblDistanceTime,
                    style: context.currentTextTheme.labelLarge,
                  ),
                  Text(
                    TempLanguage().lblSetManually,
                    style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                      '${_distanceRangeValues.start.round().toString()} ${TempLanguage().lblMins}'
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
                      '${_distanceRangeValues.end.round().toString()} ${TempLanguage().lblMins}'
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: context.width,
                child: AppButton(
                  text: TempLanguage().lblApply,
                  elevation: 0.0,
                  onTap: () {
                    context.read<FilterFoodCubit>().filterItems(
                        _priceRangeValues.start.roundToDouble(),
                        _priceRangeValues.end.roundToDouble(),
                        _foodType == FoodType.none ? '' : _foodType.name,
                        context.read<ItemList>().state
                    );
                    context.pop();
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