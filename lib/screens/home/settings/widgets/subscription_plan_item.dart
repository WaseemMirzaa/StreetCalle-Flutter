import 'package:flutter/material.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';

class SubscriptionPlanItem extends StatelessWidget {
  const SubscriptionPlanItem({
    Key? key,
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.buttonText,
    required this.onTap,
    required this.isSubscribed,
    required this.description,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String buttonText;
  final String description;
  final String amount;
  final bool isSubscribed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                      title,
                      style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 18, color: AppColors.blackColor, fontWeight: FontWeight.bold)
                  ),
                ),
                isSubscribed ? const SizedBox(
                  height: 30,
                  child: Chip(
                    label: Text('active', style: TextStyle(color: Colors.white)),
                    padding: EdgeInsets.zero,
                    shape: StadiumBorder(),
                    side: BorderSide.none,
                    backgroundColor: Colors.green,
                  ),
                ) : const SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: 12,),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                      description,
                      style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 18, color: AppColors.primaryFontColor)
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12,),

            Text(
                amount,
                style: context.currentTextTheme.titleMedium?.copyWith(fontSize: 40, color: AppColors.primaryFontColor)
            ),
            Text(
                subtitle,
                style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 20, color: AppColors.primaryFontColor)
            ),
            const SizedBox(height: 4,),
            SizedBox(
              width: 130,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSubscribed ? AppColors.redColor : AppColors.primaryColor
                ),
                child: Text(buttonText, style: const TextStyle(color: AppColors.whiteColor),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
