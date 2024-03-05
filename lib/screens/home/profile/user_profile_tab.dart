import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/home/profile/widget/edit_profile_text_widget.dart';
import 'package:street_calle/screens/home/profile/widget/profile_image_widget.dart';
import 'package:street_calle/screens/home/profile/widget/update_widget.dart';
import 'package:street_calle/screens/home/profile/widget/user_info.dart';
import 'package:street_calle/screens/home/profile/widget/user_online_offline_widget.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/screens/home/profile/cubit/edit_profile_enable_cubit.dart';
import 'package:street_calle/utils/my_sizer.dart';
import 'package:street_calle/widgets/category_widget.dart';

class UserprofileTab extends StatelessWidget {
  const UserprofileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    context.read<EditProfileEnableCubit>().updateButtonClicked();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          TempLanguage().lblProfile,
          style: context.currentTextTheme.titleMedium?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
        titleSpacing: (userCubit.state.isVendor || userCubit.state.isEmployee) ? 15 : 0,
        leadingWidth: (userCubit.state.isVendor || userCubit.state.isEmployee) ? 60 : 60,
        leading: (userCubit.state.isVendor || userCubit.state.isEmployee)
            ? BlocBuilder<EditProfileEnableCubit, bool>(
              builder: (context, state) {
                 if (state) {
              return TextButton(
                  onPressed: (){
                    context.read<EditProfileEnableCubit>().updateButtonClicked();
                  },
                  child: Text(TempLanguage().lblCancel, style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.redColor, fontSize: MySizer.size12),)
              );
            }
                 return const SizedBox.shrink();
               },
             )
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ProfileImageWidget(),
              const SizedBox(
                height: 16,
              ),
              const EditProfileTextWidget(),
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
              userCubit.state.isVendor || userCubit.state.isEmployee
                  ? const CategoryWidget()
                  : const SizedBox.shrink(),
              SizedBox(
                height: userCubit.state.isVendor || userCubit.state.isEmployee ? 6 : 0,
              ),
              userCubit.state.isVendor || userCubit.state.isEmployee ? const UserOnlineOfflineWidget() : const SizedBox.shrink(),
              const UserInfo(),
            ],
          ),
        ),
      ),
    );
  }
}
