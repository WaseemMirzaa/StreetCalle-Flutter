import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/widgets/address_widget.dart';

class ClientFavouriteItem extends StatelessWidget {
  const ClientFavouriteItem({Key? key, required this.user, required this.onTap, required this.onDelete}) : super(key: key);
  final User user;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          const SizedBox(height: 12,),
          Row(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)
                ),
                clipBehavior: Clip.hardEdge,
                child: CachedNetworkImage(
                  imageUrl: user.employeeOwnerImage.isEmptyOrNull
                          ? user.image ?? ''
                          : user.employeeOwnerImage ?? '',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            user.employeeOwnerName.isEmptyOrNull
                                ? user.name.capitalizeEachFirstLetter()
                                : user.employeeOwnerName.capitalizeEachFirstLetter(),
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 24,
                                fontFamily: METROPOLIS_BOLD,
                                color: AppColors.primaryFontColor
                            ),
                          ),
                        ),
                        //const SizedBox(width: 6,),
                        Expanded(
                          child: Row(
                            children: [
                              Image.asset(user.isOnline ?? false ? AppAssets.online : AppAssets.offline, width: 10, height: 10,),
                              const SizedBox(width: 12,),
                              const Icon(Icons.favorite, size: 20, color: AppColors.redColor),
                              const SizedBox(width: 12,),
                              InkWell(
                                onTap: onDelete,
                                child: Image.asset(AppAssets.delete, width: 16, height: 16,),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
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