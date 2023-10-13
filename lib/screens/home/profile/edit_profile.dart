import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/screens/home/profile/cubit/edit_profile_cubit.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/common.dart';

OutlineInputBorder titleBorder =  OutlineInputBorder(
  borderSide: BorderSide.none,
  borderRadius: BorderRadius.circular(40),
);


class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          TempLanguage().lblEditProfile,
          style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryFontColor, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            BlocBuilder<ImageCubit, ImageState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () async {
                    context.read<ImageCubit>().selectImage();
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
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
                );
              },
            ),

            const SizedBox(
              height: 16,
            ),
            Container(
              width: context.width,
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(40),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 34, top: 12.0),
                    child: Text(
                      TempLanguage().lblName,
                      style: context.currentTextTheme.displaySmall?.copyWith(fontSize: 12, color: AppColors.placeholderColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 16.0, bottom: 16),
                    child: TextField(
                      controller: context.watch<EditProfileCubit>().nameController,
                      style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.primaryFontColor),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 10),
                        isDense: true,
                        filled: true,
                        fillColor: AppColors.whiteColor,
                        border: titleBorder,
                        enabledBorder: titleBorder,
                        focusedBorder: titleBorder,
                        disabledBorder: titleBorder,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 34,
            ),
            BlocConsumer<EditProfileCubit, EditProfileState>(
              listener: (context, state) {
                if (state is EditProfileSuccess) {
                  final userCubit = context.read<UserCubit>();

                  userCubit.setUsername(state.user.name ?? '');
                  userCubit.setUserImage(state.user.image ?? '');

                  showToast(context, TempLanguage().lblEditProfileSuccessfully);
                  Navigator.pop(context);
                } else if (state is EditProfileFailure) {
                  showToast(context, state.error);
                }
              },
              builder: (context, state) {
                return state is EditProfileLoading
                    ? const CircularProgressIndicator(color: AppColors.primaryColor,)
                    : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    width: context.width,
                    height: defaultButtonSize,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                      ),
                      onPressed: ()=> _update(context),
                      child: Text(
                        TempLanguage().lblUpdate,
                        style: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _update(BuildContext context) {
    final imageCubit = context.read<ImageCubit>();
    final editProfileCubit = context.read<EditProfileCubit>();

    final image = imageCubit.state.selectedImage.path;
    final url = imageCubit.state.url;
    final isUpdated = imageCubit.state.isUpdated;
    final name = editProfileCubit.nameController.text;

    if (image.isEmpty && url == null) {
      showToast(context, TempLanguage().lblSelectImage);
    } else if (name.isEmpty) {
      if (name.length < 3) {
        showToast(context, TempLanguage().lblEnterYourName);
      } else {
        showToast(context, TempLanguage().lblNameMustBeGrater);
      }
    } else {
      if (isUpdated ?? false) {
        editProfileCubit.editProfile(image: image, isUpdate: true);
      } else {
        editProfileCubit.editProfile(image: url ?? '', isUpdate: false);
      }
    }
  }
}
