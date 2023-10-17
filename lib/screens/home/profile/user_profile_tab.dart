import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/home/profile/cubit/profile_status_cubit.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/screens/home/profile/cubit/edit_profile_cubit.dart';


class UserprofileTab extends StatelessWidget {
  const UserprofileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          TempLanguage().lblProfile,
          style: context.currentTextTheme.titleMedium?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              context.watch<UserCubit>().state.userImage.isEmpty
              ? Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
                child: const Icon(Icons.image_outlined, color: AppColors.whiteColor,)
              )
              : ClipRRect(
                child: Container(
                  padding: const EdgeInsets.all(6), // Border width
                  decoration: const BoxDecoration(
                      //color: AppColors.primaryColor,
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
                      child: Image.network(context.read<UserCubit>().state.userImage, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: (){
                  final imageCubit = context.read<ImageCubit>();
                  final userCubit = context.read<UserCubit>();
                  imageCubit.resetForUpdateImage(userCubit.state.userImage ?? '',);
                  context.read<EditProfileCubit>().nameController.text = userCubit.state.userName;

                  context.pushNamed(AppRoutingName.editProfile);
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
              ),

              const SizedBox(
                height: 16,
              ),
              Text(
                'Hi there ${context.read<UserCubit>().state.userName.toString().split(' ')[0]}!',
                style: const TextStyle(
                  fontFamily: METROPOLIS_BOLD,
                  fontSize: 16,
                  color: AppColors.primaryFontColor
                ),
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
                      padding: const EdgeInsets.only(left: 34, right: 16.0, bottom: 16),
                      child: Text(
                          context.watch<UserCubit>().state.userName,
                          style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.primaryFontColor),
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
                      child: Text(
                        context.watch<UserCubit>().state.userEmail,
                        style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.primaryFontColor),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 34, right: 16.0, bottom: 16),
                      child: Text(
                        context.watch<UserCubit>().state.userPhone,
                        style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.primaryFontColor),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
