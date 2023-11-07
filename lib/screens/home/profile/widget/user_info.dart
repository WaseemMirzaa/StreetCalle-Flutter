import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/custom_widgets/custom_intl_phone_field.dart';
import 'package:street_calle/screens/home/profile/cubit/edit_profile_cubit.dart';
import 'package:street_calle/screens/home/profile/cubit/edit_profile_enable_cubit.dart';

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
    editCubit.aboutController.text = userCubit.state.userAbout;

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
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 16.0, bottom: 16),
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
        userCubit.state.isEmployee ? const SizedBox.shrink() : Container(
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

        const SizedBox(
          height: 16,
        ),
        userCubit.state.isEmployee ? const SizedBox.shrink() : Container(
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
                  TempLanguage().lblAbout,
                  style: context.currentTextTheme.displaySmall?.copyWith(fontSize: 12, color: AppColors.placeholderColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 16.0, bottom: 16),
                child: BlocBuilder<EditProfileEnableCubit, bool>(
                  builder: (context, state){
                    return TextField(
                      controller: context.read<EditProfileCubit>().aboutController,
                      style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 18, color: AppColors.primaryFontColor),
                      enabled: state,
                      maxLines: 5,
                      minLines: 5,
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
      ],
    );
  }
}