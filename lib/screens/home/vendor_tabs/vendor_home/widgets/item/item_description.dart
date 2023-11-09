import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';

class ItemDescription extends StatelessWidget {
  const ItemDescription({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        item.description.isEmptyOrNull
            ? const SizedBox.shrink()
            : Text(
          TempLanguage().lblDescription,
          style: const TextStyle(
              fontFamily: METROPOLIS_BOLD,
              fontSize: 16, color: AppColors.primaryFontColor, fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        item.description.isEmptyOrNull
            ? const SizedBox.shrink()
            : Text(
          item.description.capitalizeFirstLetter() ?? '',
          style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.secondaryFontColor, fontSize: 14),
        ),

        const SizedBox(
          height: 10,
        ),
        item.description.isEmptyOrNull
            ? const SizedBox.shrink()
            : const Divider(color: AppColors.dividerColor,),
      ],
    );
  }
}