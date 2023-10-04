import 'package:flutter/material.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';

class SettingItem extends StatelessWidget {
  const SettingItem({Key? key, required this.title, required this.onTap}) : super(key: key);
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle
            ),
          ),
          title: Text(title,
            style: const TextStyle(
                fontFamily: POPPINS_R,
                fontSize: 15,
                color: AppColors.blackColor
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 15,),
          onTap: onTap,
        ),
        const Divider(color: AppColors.dividerColor,),
      ],
    );
  }
}