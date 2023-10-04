import 'package:flutter/material.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';

class SubscriptionPlanItem extends StatelessWidget {
  const SubscriptionPlanItem({Key? key, required this.title, required this.amount, required this.subtitle, required this.onTap}) : super(key: key);
  final String title;
  final String amount;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        height: 150,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withOpacity(0.35),
              spreadRadius: 0.5, // Spread radius
              blurRadius: 8, // Blur radius
              offset: const Offset(1, 8), // Offset in the Y direction
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12,),
            Text(
                title,
                style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 26, color: AppColors.primaryFontColor)
            ),

            Text(
                amount,
                style: context.currentTextTheme.titleMedium?.copyWith(fontSize: 46, color: AppColors.primaryFontColor)
            ),

            Text(
                subtitle,
                style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 18, color: AppColors.primaryFontColor)
            ),
            const SizedBox(height: 12,),
          ],
        ),
      ),
    );
  }
}
