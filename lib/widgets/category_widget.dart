import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/main.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    return Chip(
      avatar: userCubit.state.categoryImage.isEmptyOrNull
          ? const SizedBox.shrink()
          : Image.network(
        userCubit.state.categoryImage,
        fit: BoxFit.cover,
      ),
      label: Text(LANGUAGE == 'en' ? userCubit.state.category : userCubit.state.translatedCategory, style: context.currentTextTheme.displaySmall,),
      backgroundColor: AppColors.greyColor,
      side: BorderSide.none,
      shape: const StadiumBorder(),
    );
  }
}