import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/location_utils.dart';

class AddressWidget extends StatelessWidget {
  const AddressWidget({Key? key, this.latitude, this.longitude}) : super(key: key);
  final double? latitude;
  final double? longitude;

  @override
  Widget build(BuildContext context) {
    return (latitude != null && longitude != null)
        ? Row(
      children: [
        Image.asset(AppAssets.marker, width: 12, height: 12, color: AppColors.primaryColor,),
        const SizedBox(width: 4,),
        Flexible(
          child: FutureBuilder<String?>(
              future: LocationUtils.getAddressFromLatLng(LatLng(latitude!, longitude!)),
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
        : const SizedBox.shrink();
  }
}
