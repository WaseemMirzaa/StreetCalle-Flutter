import 'package:flutter/material.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/main.dart';

class PricingWidget extends StatelessWidget {
  const PricingWidget({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    bool isSmallItemAvailable = item.smallItemActualPrice != null && item.smallItemActualPrice != defaultPrice;
    bool isSmallItemDiscountedAvailable = item.smallItemDiscountedPrice != null && item.smallItemDiscountedPrice != defaultPrice;
    bool isMediumItemAvailable = item.mediumItemActualPrice != null && item.mediumItemActualPrice != defaultPrice;
    bool isDiscountAvailable = item.discountedPrice != null && item.discountedPrice != defaultPrice;

    return (isSmallItemAvailable && isMediumItemAvailable)
        ? (isSmallItemDiscountedAvailable)
           ? Row(
      children: [
        Text('\$${calculateDiscountAmount(item.smallItemActualPrice, item.smallItemDiscountedPrice)}',
          style: const TextStyle(
              fontFamily: METROPOLIS_BOLD,
              fontSize: 23,
              color: AppColors.primaryFontColor
          ),
        ),
        const SizedBox(width: 4,),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
              color: AppColors.chipColor,
              borderRadius: BorderRadius.circular(4)
          ),
          child: Text('${item.translatedST?[LANGUAGE] as String? ?? ''}', style: const TextStyle(fontSize: 12),),
        ),
      ],
    )
           : Row(
      children: [
        Text('\$${item.smallItemActualPrice}',
          style: const TextStyle(
              fontFamily: METROPOLIS_BOLD,
              fontSize: 23,
              color: AppColors.primaryFontColor
          ),
        ),
        const SizedBox(width: 4,),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
              color: AppColors.chipColor,
              borderRadius: BorderRadius.circular(4)
          ),
          child: Text('${item.translatedST?[LANGUAGE] as String? ?? ''}', style: const TextStyle(fontSize: 12),),
        ),
      ],
    )
        : (isDiscountAvailable)
           ? Row(
      children: [
        Text('\$${calculateDiscountAmount(item.actualPrice, item.discountedPrice)}',
          style: const TextStyle(
              fontFamily: METROPOLIS_BOLD,
              fontSize: 23,
              color: AppColors.primaryFontColor
          ),
        ),
        const SizedBox(width: 6,),
        Text('\$${item.actualPrice}',
          style: const TextStyle(
            fontFamily: METROPOLIS_BOLD,
            fontSize: 16,
            color: AppColors.primaryFontColor,
            decoration: TextDecoration.lineThrough,
            decorationColor: AppColors.redColor,
            decorationThickness: 4.0,
          ),
        ),
      ],
    )
           : Text('\$${item.actualPrice}',
      style: const TextStyle(
          fontFamily: METROPOLIS_BOLD,
          fontSize: 23,
          color: AppColors.primaryFontColor
      ),
    );
  }
}