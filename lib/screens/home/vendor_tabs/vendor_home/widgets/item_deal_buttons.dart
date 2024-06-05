import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/my_sizer.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_deal_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_item_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_drop_down_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_expanded_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_expanded_cubit.dart';
import 'package:street_calle/generated/locale_keys.g.dart';

class ItemDealsButtons extends StatelessWidget {
  const ItemDealsButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        children: [
          MyButton(
            title: LocaleKeys.addItem.tr(),
            onTap: (){
              if (userCubit.state.isSubscribed) {
                _addItem(context);
              } else {
                showToast(context, LocaleKeys.pleaseSubscribedFirst.tr());
              }
            },
          ),
          const SizedBox(
            width: 12,
          ),
          MyButton(
            title: LocaleKeys.addDeal.tr(),
            onTap: (){
              if (userCubit.state.isSubscribed) {
                _addDeal(context);
              } else {
                showToast(context, LocaleKeys.pleaseSubscribedFirst.tr());
              }
            },
          ),
        ],
      ),
    );
  }

  void _addDeal(BuildContext context) {
    context.read<FoodTypeCubit>().loadFromFirebase();
    _resetCubitStates(context);

    final addDealCubit = context.read<AddDealCubit>();
    addDealCubit.clearControllers();

    context.pushNamed(AppRoutingName.addDeal, pathParameters: {
      IS_UPDATE: false.toString(),
      IS_FROM_DETAIL: false.toString()
    });
  }

  void _addItem(BuildContext context) {
    _resetCubitStates(context);

    final pricingCubit = context.read<PricingCategoryCubit>();
    final pricingExpandedCubit = context.read<PricingCategoryExpandedCubit>();
    final addItemCubit = context.read<AddItemCubit>();
    final foodTypeCubit = context.read<FoodTypeCubit>();

    foodTypeCubit.loadFromFirebase();
    pricingExpandedCubit.collapse();
    pricingCubit.setCategoryType(PricingCategoryType.none);
    addItemCubit.clear();

    context.pushNamed(AppRoutingName.addItem, pathParameters: {
      IS_UPDATE: false.toString(),
      IS_FROM_DETAIL: false.toString()
    });
  }

  void _resetCubitStates(BuildContext context) {
    final imageCubit = context.read<ImageCubit>();
    final foodTypeExpandedCubit = context.read<FoodTypeExpandedCubit>();
    final foodTypeDropDownCubit = context.read<FoodTypeDropDownCubit>();
    final foodTypeCubit = context.read<FoodTypeCubit>();

    imageCubit.resetImage();
    foodTypeExpandedCubit.collapse();
    foodTypeDropDownCubit.resetState();
    foodTypeCubit.defaultValue = LocaleKeys.select.tr();
    foodTypeCubit.loadFromFirebase();
  }
}

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.onTap, required this.title}) : super(key: key);
  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    MySizer().init(context);
    return Expanded(
      child: SizedBox(
        height: defaultButtonSize,
        child: AppButton(
          elevation: 0.0,
          onTap: onTap,
          shapeBorder: RoundedRectangleBorder(
              side:
              const BorderSide(color: AppColors.primaryColor),
              borderRadius: BorderRadius.circular(30)),
          textStyle: context.currentTextTheme.labelLarge
              ?.copyWith(color: AppColors.whiteColor),
          color: AppColors.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(
                  AppAssets.add,
                  width: MySizer.size15,
                  height: MySizer.size15,
                ),
              ),
              // SizedBox(
              //   width: MySizer.size14,
              // ),
              Expanded(
                flex: 2,
                child: Text(
                  title,
                  style: context.currentTextTheme.labelLarge
                      ?.copyWith(
                      color: AppColors.whiteColor,
                      fontSize: MySizer.size14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}