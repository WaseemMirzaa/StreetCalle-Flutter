import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/screens/home/profile/cubit/edit_profile_enable_cubit.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileEnableCubit, bool>(
      builder: (context, state) {
        if (state) {
          return  BlocBuilder<ImageCubit, ImageState>(
            builder: (context, state) {
              return Stack(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(6),
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryColor,
                          AppColors.primaryLightColor,
                        ],
                      ),
                    ),
                    child: state.selectedImage.path.isNotEmpty
                        ? ClipOval(
                      child: Image.file(File(state.selectedImage.path), fit: BoxFit.cover),
                    )
                        : context.watch<UserCubit>().state.userImage.isEmpty
                        ? const Icon(Icons.image_outlined, color: AppColors.whiteColor,)
                        : ClipOval(
                      child: Image.network(context.read<UserCubit>().state.userImage, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    bottom: 0, // Adjust the position as needed
                    right: 0, // Adjust the position as needed
                    child: FloatingActionButton(
                      mini: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      onPressed: () {
                        context.read<ImageCubit>().selectImage();
                      },
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              );
            },
          );
        }
        return context.watch<UserCubit>().state.userImage.isEmpty
            ? Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryColor,
          ),
          child: const Icon(Icons.image_outlined, color: AppColors.whiteColor),
        )
            : Container(
          width: 120,
          height: 120,
          padding: const EdgeInsets.all(6), // Border width
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryColor,
                AppColors.primaryLightColor,
              ],
            ),
          ),
          child: ClipOval(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(58), // Image radius
              child: CachedNetworkImage(
                imageUrl: context.read<UserCubit>().state.userImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
