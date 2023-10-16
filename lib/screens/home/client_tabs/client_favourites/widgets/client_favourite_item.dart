import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';

class ClientFavouriteItem extends StatelessWidget {
  const ClientFavouriteItem({Key? key, required this.item, required this.onTap}) : super(key: key);
  final Item item;
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
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  '${item.image}',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${item.title}',
                          style: const TextStyle(
                              fontSize: 24,
                              fontFamily: METROPOLIS_BOLD,
                              color: AppColors.primaryFontColor
                          ),
                        ),
                        const SizedBox(width: 6,),
                        Image.asset(AppAssets.online, width: 10, height: 10,),
                        const Spacer(),
                        InkWell(
                          onTap: (){},
                          child: const Icon(Icons.favorite, size: 20, color: AppColors.redColor),
                        ),
                        const SizedBox(width: 12,),
                        InkWell(
                          onTap: (){},
                          child: Image.asset(AppAssets.delete, width: 16, height: 16,),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(AppAssets.marker, width: 16, height: 16, color: AppColors.primaryColor,),
                        const SizedBox(width: 4,),
                        Text(
                            'test location',
                            style: context.currentTextTheme.displaySmall?.copyWith(fontSize: 14)
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text(
                          '${item.foodType}',
                          style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor, fontSize: 14)
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12,),
          const Divider(
            color: AppColors.dividerColor,
          ),
        ],
      ),
    );
  }
}