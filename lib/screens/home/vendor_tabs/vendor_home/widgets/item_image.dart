import 'dart:io';
import 'package:flutter/material.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';

class ItemImage extends StatelessWidget {
  const ItemImage({Key? key, required this.isUpdate}) : super(key: key);
  final bool isUpdate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: context.width,
        height: 120,
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
        child: BlocBuilder<ImageCubit, ImageState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () async {
                context.read<ImageCubit>().selectImage();
              },
              child: state.selectedImage.path.isNotEmpty
                  ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: state.url != null
                      ? Image.network(state.url!, fit: BoxFit.cover)
                      : Image.file(File(state.selectedImage.path),
                      fit: BoxFit.cover))
                  : isUpdate
                  ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(state.url!, fit: BoxFit.cover))
                  : Center(
                child: Image.asset(
                  AppAssets.camera,
                  width: 60,
                  height: 60,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}