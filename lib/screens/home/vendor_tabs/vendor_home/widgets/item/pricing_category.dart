import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/item/price_tile.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/utils/constant/app_colors.dart';

class PricingCategory extends StatelessWidget {
  const PricingCategory({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    final isSmallItemAvailable =  item.smallItemTitle.isEmptyOrNull;
    final isMediumItemAvailable =  item.mediumItemTitle.isEmptyOrNull;
    final isLargeItemAvailable =  item.largeItemTitle.isEmptyOrNull;

    return Row(
      mainAxisAlignment: isLargeItemAvailable ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
      children: [
        isSmallItemAvailable
            ? const SizedBox.shrink()
            : PriceTile(title: item.smallItemTitle, actualPrice: item.smallItemActualPrice, discountedPrice: item.smallItemDiscountedPrice),
        isMediumItemAvailable ? const SizedBox.shrink() : SizedBox(
          height: 50,
          width: isLargeItemAvailable ? 140 : 2,
          child: const VerticalDivider(
            width: 2,
            color: AppColors.placeholderColor,
          ),
        ),

        isMediumItemAvailable
            ? const SizedBox.shrink()
            : PriceTile(title: item.mediumItemTitle, actualPrice: item.mediumItemActualPrice, discountedPrice: item.mediumItemDiscountedPrice),
        isLargeItemAvailable ? const SizedBox.shrink() : const SizedBox(
          height: 50,
          width: 2,
          child: VerticalDivider(
            width: 2,
            color: AppColors.placeholderColor,
          ),
        ),

        isLargeItemAvailable
            ? const SizedBox.shrink()
            : PriceTile(title: item.largeItemTitle, actualPrice: item.largeItemActualPrice, discountedPrice: item.largeItemDiscountedPrice),
      ],
    );
  }
}