import 'package:flutter/material.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_assets.dart';

class CustomBottomNavItem extends StatelessWidget {
  final String iconAsset;
  final String text;
  final bool isSelected;

  const CustomBottomNavItem({super.key,
    required this.iconAsset,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        isSelected
            ? Container(
          width: 80,
          height: 80,
          padding: EdgeInsets.zero,
          child: Image.asset(AppAssets.iconImage, fit: BoxFit.contain),
        )
            : const SizedBox.shrink(),
        Positioned(
          child: Container(
            margin: const EdgeInsets.only(right: 6),
            child: Column(
              children: [
                Image.asset(iconAsset, width: 16, height: 16),
                const SizedBox(height: 3,),
                Text(
                  text,
                  style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}