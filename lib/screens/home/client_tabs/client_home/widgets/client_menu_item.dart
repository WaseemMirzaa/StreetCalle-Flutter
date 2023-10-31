import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/location_utils.dart';

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
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)
                ),
                clipBehavior: Clip.hardEdge,
                child: user.image == null
                    ? Image.asset(
                  '${user.image}',
                  fit: BoxFit.cover,
                )
                    : CachedNetworkImage(
                     imageUrl: user.image!,
                     fit: BoxFit.cover,
                     placeholder: (context, url) => const CircularProgressIndicator(),
                     errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
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
                    (user.latitude != null && user.longitude != null)
                      ? Row(
                      children: [
                        Image.asset(AppAssets.marker, width: 12, height: 12, color: AppColors.primaryColor,),
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
                    )
                      : const SizedBox.shrink(),
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