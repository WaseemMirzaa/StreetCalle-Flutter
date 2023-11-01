import 'package:flutter/material.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/widgets/address_widget.dart';
import 'package:street_calle/widgets/image_widget.dart';

class ClientMenuItem extends StatelessWidget {
  const ClientMenuItem({Key? key, required this.user, required this.onTap}) : super(key: key);
  final User user;
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
              ImageWidget(image: user.image),
              const SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.name}',
                      style: const TextStyle(
                          fontSize: 24,
                          fontFamily: METROPOLIS_BOLD,
                          color: AppColors.primaryFontColor
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    AddressWidget(latitude: user.latitude, longitude: user.longitude,),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12,),
          const Divider(
            color: AppColors.dividerColor,
          ),
        ],
      ),
    );
  }
}