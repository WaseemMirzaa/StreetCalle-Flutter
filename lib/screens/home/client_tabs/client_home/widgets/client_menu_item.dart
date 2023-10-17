import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/models/user.dart';

class ClientMenuItem extends StatelessWidget {
  const ClientMenuItem({Key? key, required this.user, required this.onTap}) : super(key: key);
  final User user;
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
                child: user.image == null
                    ? Image.asset(
                  '${user.image}',
                  fit: BoxFit.cover,
                )
                    : CachedNetworkImage(
                     imageUrl: user.image!,
                     fit: BoxFit.cover,
                     placeholder: (context, url) => const CircularProgressIndicator(),
                     errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.name}',
                      style: const TextStyle(
                          fontSize: 24,
                          fontFamily: METROPOLIS_BOLD,
                          color: AppColors.primaryFontColor
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    // Text(
                    //     '${item.foodType}',
                    //     style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor, fontSize: 14)
                    // ),
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