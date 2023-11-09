import 'package:flutter/material.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';

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

        (discountedPrice != null && discountedPrice != defaultPrice)
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
            : Column(
              children: [
                Text(
          '\$$actualPrice',
          style: context.currentTextTheme.labelMedium,
        ),
                const SizedBox(height: 3,),
                Text(
                  '',
                  style: context.currentTextTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.redColor,
                      decorationThickness: 4.0
                  ),
                ),
              ],
            ),
      ],
    );
  }
}