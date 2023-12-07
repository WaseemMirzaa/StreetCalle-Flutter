import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';

class LocationImageWidget extends StatelessWidget {
  const LocationImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context.read<ImageCubit>().selectImage();
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withOpacity(0.35),
              spreadRadius: 0.5, // Spread radius
              blurRadius: 4, // Blur radius
              offset: const Offset(1, 4), // Offset in the Y direction
            ),
          ],
        ),
        child: BlocBuilder<ImageCubit, ImageState>(
          builder: (context, state) {
            return state.selectedImage.path.isNotEmpty
                ? Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.file(File(state.selectedImage.path), fit: BoxFit.cover,
                  width: 120,
                  height: 120,),
              ),
            )
                : Center(
              child: Image.asset(
                AppAssets.camera,
                width: 60,
                height: 60,
              ),
            );
          },
        ),
      ),
    );
  }
}