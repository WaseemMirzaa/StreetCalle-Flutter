import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';

OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(40),
    borderSide: BorderSide.none
);

class CustomTextField extends StatefulWidget {
  CustomTextField({Key? key, required this.hintText, required this.keyboardType, required this.asset, required this.controller, required this.isPassword, this.isObscure}) : super(key: key);
  final String hintText;
  final String asset;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool isPassword;
  final bool? isObscure;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  bool passwordVisible = true;

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
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isObscure ?? false ? passwordVisible : false,
        decoration: InputDecoration(
          hintText: widget.hintText,
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
              children: [SvgPicture.asset(widget.asset, width: widget.isPassword ? 14 : 18, height: widget.isPassword ? 14 : 18,)],
            ),
          ),
          suffixIcon: widget.isObscure ?? false
              ? IconButton(
            icon: Icon(passwordVisible
                ? Icons.visibility
                : Icons.visibility_off),
            onPressed: () {
              setState(
                    () {
                  passwordVisible = !passwordVisible;
                },
              );
            },
          )
              : const SizedBox.shrink(),
          border: border,
          enabledBorder: border,
          disabledBorder: border,
          focusedBorder: border,
        ),
      ),
    );
  }
}
