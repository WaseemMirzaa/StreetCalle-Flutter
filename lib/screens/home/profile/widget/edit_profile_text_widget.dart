import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/screens/home/profile/cubit/edit_profile_enable_cubit.dart';
import 'package:street_calle/utils/common.dart';

class EditProfileTextWidget extends StatelessWidget {
  const EditProfileTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    return BlocBuilder<EditProfileEnableCubit, bool>(
      builder: (_, state) {
        if (!state) {
          return GestureDetector(
            onTap: (){
              if (userCubit.state.isGuest) {
                showGuestLoginDialog(context);
              } else {
                final imageCubit = context.read<ImageCubit>();
                final userCubit = context.read<UserCubit>();
                imageCubit.resetForUpdateImage(userCubit.state.userImage ?? '',);
                // context.read<EditProfileCubit>().nameController.text = userCubit.state.userName;

                context.read<EditProfileEnableCubit>().editButtonClicked();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(AppAssets.editPencil, width: 15, height: 15,),
                const SizedBox(width: 6,),
                Text(
                  TempLanguage().lblEditProfile,
                  style: context.currentTextTheme.displaySmall?.copyWith(fontSize: 18, color: AppColors.primaryColor),
                )
              ],
            ),
          );
        }
        return const SizedBox(height: 18,);
      },
    );
  }
}
