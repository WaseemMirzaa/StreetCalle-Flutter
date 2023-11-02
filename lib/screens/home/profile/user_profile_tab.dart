import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:street_calle/screens/home/profile/cubit/edit_profile_enable_cubit.dart';
import 'package:street_calle/screens/home/profile/cubit/profile_status_cubit.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/custom_widgets/custom_intl_phone_field.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/screens/home/profile/cubit/edit_profile_cubit.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';

GlobalKey<State> _dialogKey = GlobalKey<State>();

class UserprofileTab extends StatelessWidget {
  const UserprofileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          TempLanguage().lblProfile,
          style: context.currentTextTheme.titleMedium?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
        titleSpacing: (userCubit.state.isVendor || userCubit.state.isEmployee) ? 15 : 0,
        leadingWidth: (userCubit.state.isVendor || userCubit.state.isEmployee) ? 0 : 60,
        leading: (userCubit.state.isVendor || userCubit.state.isEmployee)
            ? const SizedBox.shrink()
            : GestureDetector(
          onTap: () => context.pop(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(AppAssets.backIcon, width: 20, height: 20,)
            ],
          ),
        ),
        actions: const [
          UpdateWidget(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              BlocBuilder<EditProfileEnableCubit, bool>(
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
              ),

              const SizedBox(
                height: 16,
              ),
              BlocBuilder<EditProfileEnableCubit, bool>(
                builder: (_, state) {
                  if (!state) {
                    return GestureDetector(
                      onTap: (){
                         final imageCubit = context.read<ImageCubit>();
                         final userCubit = context.read<UserCubit>();
                         imageCubit.resetForUpdateImage(userCubit.state.userImage ?? '',);
                        // context.read<EditProfileCubit>().nameController.text = userCubit.state.userName;

                        context.read<EditProfileEnableCubit>().editButtonClicked();
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
              ),

              const SizedBox(
                height: 16,
              ),
              BlocSelector<UserCubit, UserState, String>(
                  selector: (userState) => userState.userName,
                  builder: (context, userName) {
                    return Text(
                      '${TempLanguage().lblHiThere} ${userName.capitalizeEachFirstLetter()}!',
                      style: const TextStyle(
                          fontFamily: METROPOLIS_BOLD,
                          fontSize: 16,
                          color: AppColors.primaryFontColor
                      ),
                    );
                  }
              ),

              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 30,
                width: 50,
                child: FittedBox(
                  child: BlocBuilder<ProfileStatusCubit, bool>(
                    builder: (context, state) {
                      return Switch(
                        value: state,
                        activeColor: const Color(0xff4BC551),
                        onChanged: (bool value) {
                          final profileCubit = context.read<ProfileStatusCubit>();
                          final userCubit = context.read<UserCubit>();

                          if (state) {
                            profileCubit.goOffline();
                            userCubit.setIsOnline(false);
                          } else {
                            profileCubit.goOnline();
                            userCubit.setIsOnline(true);
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
              BlocBuilder<ProfileStatusCubit, bool>(
                builder: (context, state) {
                  return Text(
                    state ? TempLanguage().lblOnline : TempLanguage().lblOffline,
                    style: const TextStyle(
                      // fontFamily: RIFTSOFT,
                      fontSize: 18,
                    ),
                  );
                },
              ),

              const UserInfo(),

            ],
          ),
        ),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    final editCubit = context.read<EditProfileCubit>();
    editCubit.nameController.text = userCubit.state.userName;
    editCubit.phoneController.text = userCubit.state.userPhone;
    editCubit.customPhoneController.text = userCubit.state.userPhone;
    editCubit.countryCodeController.text = userCubit.state.countryCode;


    return Column(
      children: [
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
              // Padding(
              //   padding: const EdgeInsets.only(left: 34, right: 16.0, bottom: 16),
              //   child: Text(
              //     context.read<UserCubit>().state.userName,
              //     style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 18, color: AppColors.primaryFontColor),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 16.0, bottom: 16),
                child: BlocBuilder<EditProfileEnableCubit, bool>(
                  builder: (context, state){
                    return TextField(
                      controller: context.read<EditProfileCubit>().nameController,
                      style: context.currentTextTheme.labelSmall?.copyWith(
                          fontSize: 18, color: AppColors.primaryFontColor),
                      enabled: state,
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
                    );
                  },
                ),
              ),
            ],
          ),
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
                  TempLanguage().lblEmail,
                  style: context.currentTextTheme.displaySmall?.copyWith(fontSize: 12, color: AppColors.placeholderColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 34, right: 16.0, bottom: 16),
                child: BlocBuilder<EditProfileEnableCubit, bool>(
                  builder: (context, state) {
                    if (state) {
                      return Text(
                        context.watch<UserCubit>().state.userEmail,
                        style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 18, color: AppColors.placeholderColor),
                      );
                    }
                    return Text(
                      context.watch<UserCubit>().state.userEmail,
                      style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 18, color: AppColors.primaryFontColor),
                    );
                  },
                ),
              ),
            ],
          ),
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
                  TempLanguage().lblMobileNo,
                  style: context.currentTextTheme.displaySmall?.copyWith(fontSize: 12, color: AppColors.placeholderColor),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 34, right: 16.0, bottom: 16),
              //   child: Text(
              //     context.watch<UserCubit>().state.userPhone,
              //     style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 18, color: AppColors.primaryFontColor),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 24, right: 16.0, bottom: 16),
              //   child: TextField(
              //     controller: context.read<EditProfileCubit>().phoneController,
              //     style: context.currentTextTheme.labelSmall?.copyWith(
              //         fontSize: 18, color: AppColors.primaryFontColor),
              //     decoration: InputDecoration(
              //       contentPadding: const EdgeInsets.only(left: 10),
              //       isDense: true,
              //       filled: true,
              //       fillColor: AppColors.whiteColor,
              //       border: titleBorder,
              //       enabledBorder: titleBorder,
              //       focusedBorder: titleBorder,
              //       disabledBorder: titleBorder,
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                child: BlocBuilder<EditProfileEnableCubit, bool>(
                  builder: (context, state) {
                    return CustomIntlPhoneField(
                      enabled: state,
                      style: context.currentTextTheme.labelSmall?.copyWith(
                          fontSize: 18, color: AppColors.primaryFontColor),
                      dropdownTextStyle: context.currentTextTheme.labelSmall?.copyWith(
                          fontSize: 18, color: AppColors.primaryFontColor),
                      showDropdownIcon: false,
                      controller: context.read<EditProfileCubit>().phoneController,
                      disableLengthCheck: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        fillColor: AppColors.whiteColor,
                        filled: true,
                        hintText: TempLanguage().lblPhoneNumber,
                        hintStyle: context.currentTextTheme.displaySmall?.copyWith(fontSize: 16, color: AppColors.secondaryFontColor),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(40)
                        ),
                      ),
                      initialCountryCode: editCubit.countryCodeController.text.isEmpty ? initialCountyCode : editCubit.countryCodeController.text,
                      onChanged: (phone) {
                        context.read<EditProfileCubit>().customPhoneController.text = phone.completeNumber;
                        print(context.read<EditProfileCubit>().customPhoneController.text);
                      },
                      onCountryChanged: (Country? country) {
                        context.read<EditProfileCubit>().countryCodeController.text = country?.code ?? initialCountyCode;
                      },
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class UpdateWidget extends StatelessWidget {
  const UpdateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileSuccess) {
          final userCubit = context.read<UserCubit>();

          userCubit.setUserImage(state.user.image ?? '');
          userCubit.setUsername(state.user.name ?? '');
          userCubit.setUserPhone(state.user.phone ?? '');
          userCubit.setUserCountryCode(state.user.countryCode ?? initialCountyCode);
          context.read<ImageCubit>().resetImage();

          showToast(context, TempLanguage().lblEditProfileSuccessfully);
          context.read<EditProfileEnableCubit>().updateButtonClicked();

        } else if (state is EditProfileFailure) {
          showToast(context, state.error);
        }
        Navigator.of(_dialogKey.currentContext!).pop();
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
    final editProfileCubit = context.read<EditProfileCubit>();

    final image = imageCubit.state.selectedImage.path;
    final url = imageCubit.state.url;
    final isUpdated = imageCubit.state.isUpdated;
    final name = editProfileCubit.nameController.text;
    final phone = editProfileCubit.customPhoneController.text;

    if (image.isEmpty && url == null) {
      showToast(context, TempLanguage().lblSelectImage);
    } else if (name.isEmpty) {
      showToast(context, TempLanguage().lblEnterYourName);
    } else if (phone.isEmpty || !phone.validatePhone()) {
      showToast(context, TempLanguage().lblEnterYourPhone);
    } else {
      showLoadingDialog(context, _dialogKey);
      if (isUpdated ?? false) {
        editProfileCubit.editProfile(image: image, isUpdate: true);
      } else {
        editProfileCubit.editProfile(image: url ?? '', isUpdate: false);
        //context.read<EditProfileEnableCubit>().updateButtonClicked();
      }
    }
  }
}
