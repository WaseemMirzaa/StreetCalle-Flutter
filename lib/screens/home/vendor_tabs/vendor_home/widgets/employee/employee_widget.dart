import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/widgets/address_widget.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/widgets/image_widget.dart';
import 'package:street_calle/generated/locale_keys.g.dart';

class EmployeeWidget extends StatelessWidget {
  const EmployeeWidget({Key? key, required this.onTap, required this.userData, required this.index}) : super(key: key);
  final VoidCallback onTap;
  final User userData;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              ImageWidget(image: userData.image ?? '',),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            userData.name.capitalizeEachFirstLetter(),
                            style: const TextStyle(
                                fontSize: 24,
                                fontFamily: METROPOLIS_BOLD,
                                color: AppColors.primaryFontColor
                            ),
                          ),
                        ),
                        userData.isEmployeeBlocked != true
                            ? const SizedBox.shrink()
                            : Text(
                          LocaleKeys.blocked.tr(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontFamily: METROPOLIS_R,
                              color: AppColors.redColor),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    AddressWidget(latitude: userData.latitude, longitude: userData.longitude,),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          const Divider(
            color: AppColors.dividerColor,
          ),
          SizedBox(
            height: index == 9 ? 60 : 0,
          ),
        ],
      ),
    );
  }
}