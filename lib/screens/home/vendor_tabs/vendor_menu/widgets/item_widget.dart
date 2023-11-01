import 'package:flutter/material.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/pricing_widget.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/widgets/image_widget.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({Key? key, required this.item, required this.onUpdate, required this.onDelete, required this.onTap, required this.isFromItemTab}) : super(key: key);
  final Item item;
  final bool isFromItemTab;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          const SizedBox(height: 12,),
          Row(
            children: [
              ImageWidget(image: item.image),
              const SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            item.title.capitalizeEachFirstLetter(),
                            style: const TextStyle(
                                fontSize: 24,
                                fontFamily: METROPOLIS_BOLD,
                                color: AppColors.primaryFontColor
                            ),
                          ),
                        ),
                        PricingWidget(item: item)
                        // Expanded(
                        //   child: (item.discountedPrice != null && item.discountedPrice != defaultPrice)
                        //       ? Column(
                        //     crossAxisAlignment: CrossAxisAlignment.end,
                        //     children: [
                        //       Text('\$${calculateDiscountAmount(item.actualPrice, item.discountedPrice)}',
                        //         style: const TextStyle(
                        //             fontFamily: METROPOLIS_BOLD,
                        //             fontSize: 23,
                        //             color: AppColors.primaryFontColor
                        //         ),
                        //       ),
                        //       Text('\$${item.actualPrice}',
                        //         style: const TextStyle(
                        //           fontFamily: METROPOLIS_BOLD,
                        //           fontSize: 16,
                        //           color: AppColors.primaryFontColor,
                        //           decoration: TextDecoration.lineThrough,
                        //           decorationColor: AppColors.redColor,
                        //           decorationThickness: 4.0,
                        //         ),
                        //       ),
                        //     ],
                        //   )
                        //       : Text('\$${item.actualPrice}',
                        //     textAlign: TextAlign.end,
                        //     style: const TextStyle(
                        //         fontFamily: METROPOLIS_BOLD,
                        //         fontSize: 23,
                        //         color: AppColors.primaryFontColor
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    isFromItemTab
                        ? Row(
                          children: [
                            Image.asset(AppAssets.marker, width: 12, height: 12, color: AppColors.primaryColor,),
                            const SizedBox(width: 4,),
                            Text(
                            'No 03, 4th Lane, Newyork',
                            style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.placeholderColor, fontSize: 14)
                        ),
                         ],
                    )
                        : const SizedBox.shrink(),
                    SizedBox(
                      height: isFromItemTab ? 6 : 0,
                    ),
                    Text(
                        item.foodType.capitalizeEachFirstLetter(),
                        style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor, fontSize: 14)
                    ),
                  ],
                ),
              ),
            ],
          ),
          isFromItemTab ? Row(
            children: [
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
                ),
              ),
            ],
          ) : const SizedBox.shrink(),
          const SizedBox(height: 12,),
          const Divider(
            color: AppColors.dividerColor,
          ),
        ],
      ),
    );
  }
}