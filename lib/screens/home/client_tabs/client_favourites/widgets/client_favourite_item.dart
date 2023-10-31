import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/utils/location_utils.dart';

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
                  imageUrl: '${user.image}',
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
                      children: [
                        Text(
                          '${user.name}',
                          style: const TextStyle(
                              fontSize: 24,
                              fontFamily: METROPOLIS_BOLD,
                              color: AppColors.primaryFontColor
                          ),
                        ),
                        const SizedBox(width: 6,),
                        Image.asset(user.isOnline ?? false ? AppAssets.online : AppAssets.offline, width: 10, height: 10,),
                        const Spacer(),
                        const Icon(Icons.favorite, size: 20, color: AppColors.redColor),
                        const SizedBox(width: 12,),
                        InkWell(
                          onTap: onDelete,
                          child: Image.asset(AppAssets.delete, width: 16, height: 16,),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(AppAssets.marker, width: 16, height: 16, color: AppColors.primaryColor,),
                        const SizedBox(width: 4,),
                        Flexible(
                          child: FutureBuilder<String?>(
                              future: LocationUtils.getAddressFromLatLng(LatLng(user.latitude!, user.longitude!)),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const SizedBox.shrink();
                                }
                                if (snapshot.hasData && snapshot.data != null) {
                                  return Text(
                                      '${snapshot.data}',
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.placeholderColor, fontSize: 14)
                                  );
                                }
                                return const SizedBox.shrink();
                              }
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(
                    //   height: 6,
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 2.0),
                    //   child: Text(
                    //       '${item.foodType}',
                    //       style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor, fontSize: 14)
                    //   ),
                    // ),
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