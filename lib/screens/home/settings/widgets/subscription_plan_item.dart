import 'package:flutter/material.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.35),
            spreadRadius: 0.5, // Spread radius
            blurRadius: 4, // Blur radius
            offset: const Offset(1, 2), // Offset in the Y direction
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                      style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 14, color: AppColors.blackColor, fontWeight: FontWeight.bold)
                  ),
                ),
                isSubscribed ? SizedBox(
                  height: 30,
                  child: Chip(
                    label: Text(TempLanguage().lblActive, style: const TextStyle(color: Colors.white, fontSize: 14)),
                    padding: EdgeInsets.zero,
                    shape: const StadiumBorder(),
                    side: BorderSide.none,
                    backgroundColor: Colors.green,
                  ),
                ) : const SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: 5,),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                      description,
                      style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 12, color: AppColors.primaryFontColor)
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Price : ${amount}',
                    style: context.currentTextTheme.titleMedium?.copyWith(fontSize: 12, color: AppColors.primaryFontColor)
                ),
                Text(
                    'Duration : ${subtitle}',
                    style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 12, color: AppColors.primaryFontColor)
                ),
              ],
            ),

            const SizedBox(height: 4,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Free Trial : 60 days',
                    style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 12, color: AppColors.primaryFontColor)
                ),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSubscribed ? AppColors.redColor : AppColors.primaryColor
                    ),
                    child: Text(buttonText, style: const TextStyle(color: AppColors.whiteColor, fontSize: 14),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
