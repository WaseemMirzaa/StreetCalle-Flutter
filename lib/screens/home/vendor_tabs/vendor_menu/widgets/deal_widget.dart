import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/models/deal.dart';

class DealWidget extends StatelessWidget {
  const DealWidget({Key? key, required this.deal}) : super(key: key);
  final Deal deal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12,),
        Row(
          children: [
            Container(
              width: 80,
              height: 90,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)
              ),
              clipBehavior: Clip.hardEdge,
              child: CachedNetworkImage(
                imageUrl: '${deal.image}',
                fit: BoxFit.cover,
              ),
            ),
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
                          '${deal.title}',
                          style: const TextStyle(
                              fontSize: 24,
                              fontFamily: METROPOLIS_BOLD,
                              color: AppColors.primaryFontColor
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '\$${deal.actualPrice?.toInt()}',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              fontSize: 24,
                              fontFamily: METROPOLIS_BOLD,
                              color: AppColors.primaryFontColor
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                      '${deal.foodType}',
                      style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor, fontSize: 16)
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
    );
  }
}