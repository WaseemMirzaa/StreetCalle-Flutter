import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({Key? key, required this.hintText, required this.keyboardType, required this.asset, required this.controller, required this.isPassword}) : super(key: key);
  final String hintText;
  final String asset;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool isPassword;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.15),
            spreadRadius: 3, // Spread radius
            blurRadius: 15, // Blur radius
            offset: const Offset(1, 3), // Offset in the Y direction
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: context.currentTextTheme.displaySmall,
          filled: true,
          isDense: true,
          fillColor: AppColors.whiteColor,
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: AppColors.primaryLightColor,
                shape: BoxShape.circle
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [SvgPicture.asset(asset, width: isPassword ? 14 : 18, height: isPassword ? 14 : 18,)],
            ),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide.none
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide.none
          ),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide.none
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide.none
          ),
        ),
      ),
    );
  }
}
