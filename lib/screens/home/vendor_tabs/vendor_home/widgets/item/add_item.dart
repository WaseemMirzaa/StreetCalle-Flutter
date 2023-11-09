import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_item_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_expanded_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_expanded_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/item/add_item_button.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/pricing_category_expanded_widget.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/item/item_image.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/food_type_expanded_widget.dart';


OutlineInputBorder titleBorder = OutlineInputBorder(
  borderSide: BorderSide.none,
  borderRadius: BorderRadius.circular(40),
);

class AddItem extends StatelessWidget {
  const AddItem({Key? key, required this.isUpdate, required this.isFromDetail}) : super(key: key);
  final bool isUpdate;
  final bool isFromDetail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TempLanguage().lblCreateMenu,
          style: context.currentTextTheme.titleMedium
              ?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                AppAssets.backIcon,
                width: 20,
                height: 20,
              )
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
              Text(TempLanguage().lblAddItem,
                  style: const TextStyle(
                      fontFamily: METROPOLIS_BOLD,
                      fontSize: 18,
                      color: AppColors.primaryFontColor)),
              const SizedBox(
                height: 24,
              ),

              ItemImage(isUpdate: isUpdate),
              const SizedBox(
                height: 32,
              ),

              const PricingCategoryExpandedWidget(),
              InkWell(
                onTap: () {
                  final pricingCubit = context.read<PricingCategoryCubit>();
                  if (pricingCubit.state.categoryType ==
                      PricingCategoryType.large) {
                    showToast(context,
                        TempLanguage().lblMaxPricingCategoryLimitIsThree);
                  } else {
                    switch (pricingCubit.state.categoryType) {
                      case PricingCategoryType.none:
                        pricingCubit
                            .setCategoryType(PricingCategoryType.smallMedium);
                        break;
                      case PricingCategoryType.smallMedium:
                        pricingCubit.setCategoryType(PricingCategoryType.large);
                        break;
                      default:
                        pricingCubit.setCategoryType(PricingCategoryType.none);
                        break;
                    }
                    context.read<PricingCategoryExpandedCubit>().expand();
                  }
                },
                child: Text(TempLanguage().lblItemAddPricingCategories,
                    style: const TextStyle(
                        fontFamily: METROPOLIS_BOLD,
                        fontSize: 18,
                        color: AppColors.primaryFontColor)),
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
                        style: context.currentTextTheme.displaySmall?.copyWith(
                            fontSize: 12, color: AppColors.placeholderColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 16.0, bottom: 16),
                      child: TextField(
                        controller: context.read<AddItemCubit>().descriptionController,
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
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),

              InkWell(
                onTap: () {
                  //_showInputDialog(context);
                  context.read<FoodTypeExpandedCubit>().expand();
                },
                child: Text(TempLanguage().lblItemAddFoodType,
                    style: const TextStyle(
                        fontFamily: METROPOLIS_BOLD,
                        fontSize: 18,
                        color: AppColors.primaryFontColor)),
              ),
              const SizedBox(
                height: 16,
              ),
              const FoodTypeExpandedWidget(isFromItem: true,),
              AddItemButton(isUpdate: isUpdate, isFromDetail: isFromDetail),
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