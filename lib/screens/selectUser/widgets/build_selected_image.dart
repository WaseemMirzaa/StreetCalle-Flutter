import 'package:flutter/material.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';

class BuildSelectableImage extends StatelessWidget {
  BuildSelectableImage({Key? key, required this.assetPath, required this.isSelected, required this.onTap, required this.title}) : super(key: key);
  final String assetPath;
  final bool isSelected;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          SizedBox(
            width: 170,
            height: 170,
            child: Center(
              child: Image.asset(assetPath),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 57,
            child: Text(
              title,
              style: context.currentTextTheme.labelMedium,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primaryColor : AppColors.placeholderColor,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}