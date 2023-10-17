import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';

class ItemView extends StatelessWidget {
  const ItemView({
    Key? key,
    required this.index,
    required this.item,
    required this.onUpdate,
    required this.onDelete,
    required this.onTap
  }) : super(key: key);

  final int index;
  final Item item;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(width: 6,),
            index == 0
                ? TextButton(
                onPressed: (){},
                child: Text(TempLanguage().lblViewAll,
                  style: context.currentTextTheme.labelSmall?.copyWith(color: AppColors.primaryColor, fontSize: 16),)
            )
                : const SizedBox.shrink(),

            const Spacer(),
            InkWell(
                onTap: onUpdate,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(AppAssets.edit, color: AppColors.redColor, width: 15, height: 15,),
                )),
            const SizedBox(width: 4,),
            InkWell(
                onTap: onDelete,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(AppAssets.delete, color: AppColors.redColor, width: 15, height: 15),
                )),
            const SizedBox(width: 16,),
          ],
        ),
        SizedBox(height: index == 0 ? 0 : 10,),
        InkWell(
          onTap: onTap,
          child: SizedBox(
              height: 200,
              width: context.width,
              child: CachedNetworkImage(
                imageUrl: item.image ?? '',
                fit: BoxFit.cover,
              )
          ),
        ),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.title.capitalizeEachFirstLetter() ?? '',
                style: const TextStyle(
                    fontFamily: METROPOLIS_BOLD,
                    fontSize: 23,
                    color: AppColors.primaryFontColor
                ),
              ),
              PricingWidget(item: item),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(item.foodType.capitalizeEachFirstLetter() ?? '',
            style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor, fontSize: 16),
          ),
        ),
        const SizedBox(height: 12,),
      ],
    );
  }
}

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
        ? Text('${TempLanguage().lblStartingFrom} \$${calculateDiscountAmount(item.smallItemActualPrice, item.smallItemDiscountedPrice)}',
      style: const TextStyle(
          fontFamily: METROPOLIS_BOLD,
          fontSize: 16,
          color: AppColors.primaryFontColor
      ),
    )
        : Text('${TempLanguage().lblStartingFrom} \$${item.smallItemActualPrice}',
      style: const TextStyle(
          fontFamily: METROPOLIS_BOLD,
          fontSize: 20,
          color: AppColors.primaryFontColor
      ),
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