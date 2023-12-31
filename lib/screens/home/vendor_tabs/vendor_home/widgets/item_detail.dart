import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_item_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_cubit.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_expanded_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_expanded_cubit.dart';

class ItemDetail extends StatefulWidget {
  const ItemDetail({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {

  late Item item;

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Stack(
          children: [
            SizedBox(
              height: 350,
              width: context.width,
              child: item.image.isEmptyOrNull ? Image.asset(AppAssets.camera, fit: BoxFit.cover,) : Image.network(item.image!, fit: BoxFit.cover,),
            ),

            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.5), Colors.white.withOpacity(0.0)],
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height - 270,
                decoration: const BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0, top: 24.0, right: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title.capitalizeEachFirstLetter() ?? '',
                        style: context.currentTextTheme.titleMedium?.copyWith(color: AppColors.primaryFontColor),
                      ),
                      Text(
                        item.foodType.capitalizeEachFirstLetter() ?? '',
                        style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      (item.actualPrice !=null && item.actualPrice == defaultPrice)
                       ? PricingCategory(item: item)
                       : Align(
                        alignment: Alignment.centerRight,
                        child:  (item.discountedPrice != null && item.discountedPrice != defaultPrice)
                            ? Column(
                          children: [
                            Text(
                              '\$${calculateDiscountAmount(item.actualPrice, item.discountedPrice)}',
                              style: context.currentTextTheme.titleMedium,
                            ),
                            Text(
                              '\$${item.actualPrice}',
                              style: context.currentTextTheme.titleMedium?.copyWith(
                                  fontSize: 16,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: AppColors.redColor,
                                  decorationThickness: 4.0
                              ),
                            ),
                          ],
                        )
                            : Text(
                          '\$${item.actualPrice}',
                          style: context.currentTextTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      item.description.isEmptyOrNull
                          ? const SizedBox.shrink()
                          : Text(
                        TempLanguage().lblDescription,
                        style: const TextStyle(
                            fontFamily: METROPOLIS_BOLD,
                            fontSize: 16, color: AppColors.primaryFontColor, fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      item.description.isEmptyOrNull
                          ? const SizedBox.shrink()
                          : Text(
                        item.description.capitalizeFirstLetter() ?? '',
                        style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.secondaryFontColor, fontSize: 14),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      item.description.isEmptyOrNull
                          ? const SizedBox.shrink()
                          : const Divider(color: AppColors.dividerColor,),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: 240,
              right: 15,
              child: InkWell(
                onTap: () => _onUpdate(context, item),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Image.asset(AppAssets.whiteIconImage).image,
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(AppAssets.edit, width: 25, height: 25,)
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 40,
              left: 15,
              child: GestureDetector(
                onTap: (){
                  context.pop();
                },
                child: Image.asset(AppAssets.backIcon, color: AppColors.whiteColor, width: 24, height: 24,),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onUpdate (BuildContext context, Item itemParam) async {
    final imageCubit =  context.read<ImageCubit>();
    final itemCubit = context.read<AddItemCubit>();
    final foodTypeExpandedCubit = context.read<FoodTypeExpandedCubit>();
    final foodTypeCubit = context.read<FoodTypeCubit>();
    final pricingCategoryExpandCubit = context.read<PricingCategoryExpandedCubit>();
    final pricingCategoryTypeCubit = context.read<PricingCategoryCubit>();

    itemCubit.titleController.text = itemParam.title ?? '';
    itemCubit.descriptionController.text = itemParam.description ?? '';
    itemCubit.foodTypeController.text = itemParam.foodType ?? '';
    itemCubit.actualPriceController.text = itemParam.actualPrice.toString();
    itemCubit.discountedPriceController.text = itemParam.discountedPrice.toString();
    itemCubit.id = itemParam.id ?? '';
    itemCubit.createdAt = itemParam.createdAt ?? Timestamp.now();
    itemCubit.smallItemTitleController.text = itemParam.smallItemTitle ?? '';
    itemCubit.mediumItemTitleController.text = itemParam.mediumItemTitle ?? '';
    itemCubit.largeItemTitleController.text = itemParam.largeItemTitle ?? '';
    itemCubit.smallItemActualPriceController.text = itemParam.smallItemActualPrice.toString();
    itemCubit.mediumItemActualPriceController.text = itemParam.mediumItemActualPrice.toString();
    itemCubit.largeItemActualPriceController.text = itemParam.largeItemActualPrice.toString();
    itemCubit.smallItemDiscountedPriceController.text = itemParam.smallItemDiscountedPrice.toString();
    itemCubit.mediumItemDiscountedPriceController.text = itemParam.mediumItemDiscountedPrice.toString();
    itemCubit.largeItemDiscountedPriceController.text = itemParam.largeItemDiscountedPrice.toString();

    if (itemCubit.foodTypeController.text.isNotEmpty) {
      foodTypeExpandedCubit.expand();
      foodTypeCubit.addString(itemCubit.foodTypeController.text);
      foodTypeCubit.defaultValue = itemCubit.foodTypeController.text;
    } else {
      foodTypeExpandedCubit.collapse();
      foodTypeCubit.defaultValue = TempLanguage().lblSelect;
    }

    if (itemCubit.smallItemTitleController.text.isNotEmpty) {
      pricingCategoryExpandCubit.expand();
      if (itemCubit.largeItemTitleController.text.isNotEmpty) {
        pricingCategoryTypeCubit.setCategoryType(PricingCategoryType.large);
      }
    } else {
      pricingCategoryExpandCubit.collapse();
    }

    imageCubit.resetForUpdateImage(itemParam.image ?? '',);

    final result = await context.pushNamed(AppRoutingName.addItem, pathParameters: {IS_UPDATE: true.toString(), IS_FROM_DETAIL: true.toString()});
    if (result != null) {
      setState(() {
        item = result as Item;
      });
    }
  }
}


class PricingCategory extends StatelessWidget {
  const PricingCategory({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        item.smallItemTitle.isEmptyOrNull
            ? const SizedBox.shrink()
            : PriceTile(title: item.smallItemTitle, actualPrice: item.smallItemActualPrice, discountedPrice: item.smallItemDiscountedPrice),
        // SizedBox(
        //   width: item.smallItemTitle.isEmptyOrNull ? 0 : 12,
        // ),
        item.mediumItemTitle.isEmptyOrNull ? const SizedBox.shrink() : const SizedBox(
          height: 50,
          width: 2,
          child: VerticalDivider(
            width: 2,
            color: AppColors.placeholderColor,
          ),
        ),

        item.mediumItemTitle.isEmptyOrNull
            ? const SizedBox.shrink()
            : PriceTile(title: item.mediumItemTitle, actualPrice: item.mediumItemActualPrice, discountedPrice: item.mediumItemDiscountedPrice),
        // SizedBox(
        //   width: item.mediumItemTitle.isEmptyOrNull ? 0 : 12,
        // ),
        item.largeItemTitle.isEmptyOrNull ? const SizedBox.shrink() : const SizedBox(
          height: 50,
          width: 2,
          child: VerticalDivider(
            width: 2,
            color: AppColors.placeholderColor,
          ),
        ),

        item.largeItemTitle.isEmptyOrNull
            ? const SizedBox.shrink()
            : PriceTile(title: item.largeItemTitle, actualPrice: item.largeItemActualPrice, discountedPrice: item.largeItemDiscountedPrice),
      ],
    );
  }
}

class PriceTile extends StatelessWidget {
  const PriceTile({Key? key, required this.title, required this.actualPrice, required this.discountedPrice}) : super(key: key);
  final String? title;
  final num? actualPrice;
  final num? discountedPrice;

  @override
  Widget build(BuildContext context) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.center,
      //mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          title.capitalizeEachFirstLetter(),
          style: context.currentTextTheme.labelMedium,
        ),
        const SizedBox(height: 5,),

        (discountedPrice != null && actualPrice != defaultPrice)
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${calculateDiscountAmount(actualPrice, discountedPrice)}',
              style: context.currentTextTheme.labelMedium,
            ),
            const SizedBox(height: 3,),
            Text(
              '\$$actualPrice',
              style: context.currentTextTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: AppColors.redColor,
                  decorationThickness: 4.0
              ),
            ),
          ],
        )
            : Text(
          '\$$actualPrice',
          style: context.currentTextTheme.titleMedium,
        ),
      ],
    );
  }
}