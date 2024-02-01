import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/screens/home/profile/cubit/edit_profile_cubit.dart';
import 'package:street_calle/screens/home/profile/cubit/edit_profile_enable_cubit.dart';

class UpdateWidget extends StatelessWidget {
  const UpdateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DialogRoute? progressDialog;
    return BlocListener<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileSuccess) {
          final userCubit = context.read<UserCubit>();
          final user = state.user;

          userCubit.setUserImage(user.image ?? '');
          userCubit.setUsername(user.name ?? '');
          userCubit.setUserPhone(user.phone ?? '');
          userCubit.setUserCountryCode(user.countryCode ?? initialCountyCode);
          userCubit.setUserAbout(user.about ?? '');
          context.read<ImageCubit>().resetImage();

          showToast(context, TempLanguage().lblEditProfileSuccessfully);
          context.read<EditProfileEnableCubit>().updateButtonClicked();
          if (progressDialog != null) {
            Navigator.of(context).removeRoute(progressDialog as Route);
          }

        } else if (state is EditProfileFailure) {
          showToast(context, state.error);
          if (progressDialog != null) {
            Navigator.of(context).removeRoute(progressDialog as Route);
          }
        } else if (state is EditProfileLoading) {
          progressDialog = showProgressDialog(context);
          Navigator.of(context).push(progressDialog as Route);
        }
      },
      child: BlocBuilder<EditProfileEnableCubit, bool>(
        builder: (context, state) {
          if (state) {
            return TextButton(
                onPressed: (){
                  _update(context);
                },
                child: Text(TempLanguage().lblUpdate, style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor),)
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _update(BuildContext context) {
    final imageCubit = context.read<ImageCubit>();
    final userCubit = context.read<UserCubit>();
    final editProfileCubit = context.read<EditProfileCubit>();

    final image = imageCubit.state.selectedImage.path;
    final url = imageCubit.state.url;
    final isUpdated = imageCubit.state.isUpdated;
    final name = editProfileCubit.nameController.text;
    final phone = editProfileCubit.phoneController.text;
    final countryCode = editProfileCubit.countryCodeController.text;

    Country country = countries.where((element) => element.code == (countryCode.isEmpty ? initialCountyCode : countryCode)).first;

    if (image.isEmpty && url == null) {
      showToast(context, TempLanguage().lblSelectImage);
    } else if (name.isEmpty) {
      showToast(context, TempLanguage().lblEnterYourName);
    } else if ((userCubit.state.isVendor || userCubit.state.isEmployee) && !userCubit.state.isEmployee && (phone.isEmpty || !phone.validatePhone() || phone.length != country.minLength)) {
      showToast(context, TempLanguage().lblEnterYourPhone);
    } else {
      if (isUpdated ?? false) {
        editProfileCubit.editProfile(image: image, isUpdate: true);
      } else {
        editProfileCubit.editProfile(image: url ?? '', isUpdate: false);
      }
    }
  }
}