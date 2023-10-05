import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';

class ItemView extends StatelessWidget {
  const ItemView({Key? key, required this.index, required this.item, required this.onUpdate, required this.onDelete, required this.onTap}) : super(key: key);
  final int index;
  final Item item;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 6,),
              index ==0
                  ? TextButton(
                  onPressed: (){},
                  child: Text(TempLanguage().lblViewAll,
                    style: context.currentTextTheme.labelSmall?.copyWith(color: AppColors.primaryColor),)
              )
                  : const SizedBox.shrink(),

              const Spacer(),
              InkWell(
                  onTap: onUpdate,
                  child: Image.asset(AppAssets.edit, color: AppColors.redColor, width: 15, height: 15,)),
              const SizedBox(width: 8,),
              InkWell(
                  onTap: onDelete,
                  child: Image.asset(AppAssets.delete, color: AppColors.redColor, width: 15, height: 15)),
              const SizedBox(width: 16,),
            ],
          ),
          SizedBox(height: index == 0 ? 0 : 10,),
          SizedBox(
              height: 150,
              width: context.width,
              child: CachedNetworkImage(
                imageUrl: item.image ?? '',
                fit: BoxFit.cover,
              )
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.title ?? '',
                  style: const TextStyle(
                      fontFamily: METROPOLIS_BOLD,
                      fontSize: 16,
                      color: AppColors.primaryFontColor
                  ),
                ),
                Text('\$${item.actualPrice}',
                  style: const TextStyle(
                      fontFamily: METROPOLIS_BOLD,
                      fontSize: 23,
                      color: AppColors.primaryFontColor
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(item.foodType ?? '',
              style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor, fontSize: 12),
            ),
          ),
          const SizedBox(height: 24,),
        ],
      ),
    );
  }
}
