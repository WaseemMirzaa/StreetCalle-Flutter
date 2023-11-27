import 'package:flutter/material.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/pricing_widget.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/widgets/image_widget.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/utils/constant/temp_language.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({Key? key, required this.item, this.user, this.isLastIndex, required this.onUpdate, required this.onDelete, required this.onTap, required this.isFromItemTab}) : super(key: key);
  final Item item;
  final User? user;
  final bool? isLastIndex;
  final bool isFromItemTab;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          const SizedBox(height: 12,),
          Row(
            children: [
              ImageWidget(image: item.image),
              const SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            item.title.capitalizeEachFirstLetter(),
                            style: const TextStyle(
                                fontSize: 23,
                                fontFamily: METROPOLIS_BOLD,
                                color: AppColors.primaryFontColor
                            ),
                          ),
                        ),
                        PricingWidget(item: item)
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                        item.foodType.capitalizeEachFirstLetter(),
                        style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor, fontSize: 16)
                    ),
                  ],
                ),
              ),
            ],
          ),
          isFromItemTab
              ? Row(
            children: [
              const Spacer(),
              InkWell(
                  onTap: onUpdate,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(AppAssets.edit, color: AppColors.redColor, width: 15, height: 15,),
                  )),
              const SizedBox(width: 4,),
              InkWell(
                onTap: onDelete,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(AppAssets.delete, color: AppColors.redColor, width: 15, height: 15),
                ),
              ),
            ],
          )
              : user == null
                ? const SizedBox.shrink()
                : Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        '${user!.clientVendorDistance} ${TempLanguage().lblMiles}',
                        style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor, fontSize: 16)
                    ),
                  ),
                ),
          const SizedBox(height: 12,),
          const Divider(
            color: AppColors.dividerColor,
          ),
          SizedBox(height: isLastIndex ?? false ? (isFromItemTab ? 0 : 70) : 0,),
        ],
      ),
    );
  }
}