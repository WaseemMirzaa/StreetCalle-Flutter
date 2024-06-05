import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/main.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/item/price_tile.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/my_sizer.dart';

class PricingCategory extends StatelessWidget {
  const PricingCategory({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    final isSmallItemAvailable = (item.translatedST?[LANGUAGE] as String?).isEmptyOrNull;
    final isMediumItemAvailable = (item.translatedMT?[LANGUAGE] as String?).isEmptyOrNull;
    final isLargeItemAvailable = (item.translatedLT?[LANGUAGE] as String?).isEmptyOrNull;

    MySizer().init(context);
    return Row(
      mainAxisAlignment: isLargeItemAvailable ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
      children: [
        isSmallItemAvailable
            ? const SizedBox.shrink()
            : PriceTile(title: (item.translatedST?[LANGUAGE] as String? ?? ''), actualPrice: item.smallItemActualPrice, discountedPrice: item.smallItemDiscountedPrice),
        isMediumItemAvailable ? const SizedBox.shrink() : SizedBox(
          height: 50,
          width: isLargeItemAvailable ? MySizer.size90 : MySizer.size2,
          child:  VerticalDivider(
            width: MySizer.size2,
            color: AppColors.placeholderColor,
          ),
        ),

        isMediumItemAvailable
            ? const SizedBox.shrink()
            : PriceTile(title: (item.translatedMT?[LANGUAGE] as String? ?? ''), actualPrice: item.mediumItemActualPrice, discountedPrice: item.mediumItemDiscountedPrice),
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
            : PriceTile(title: (item.translatedLT?[LANGUAGE] as String? ?? ''), actualPrice: item.largeItemActualPrice, discountedPrice: item.largeItemDiscountedPrice),
      ],
    );
  }
}