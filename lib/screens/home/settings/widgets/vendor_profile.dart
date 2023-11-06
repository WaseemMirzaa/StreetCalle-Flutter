import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/cubit/user_state.dart';

class VendorProfile extends StatefulWidget {
  const VendorProfile({Key? key}) : super(key: key);

  @override
  State<VendorProfile> createState() => _VendorProfileState();
}

class _VendorProfileState extends State<VendorProfile> {

  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 10,
  );

  @override
  void dispose() {
    _controller = Completer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          TempLanguage().lblProfile,
          style: context.textTheme.titleMedium?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(AppAssets.backIcon, width: 20, height: 20,)
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 34.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userCubit.state.isOnline ? TempLanguage().lblOnline : TempLanguage().lblOffline,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 10,),
                Image.asset(userCubit.state.isOnline ? AppAssets.online : AppAssets.offline, width: 18, height: 18,),
              ],
            ),
            const SizedBox(height: 10,),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 120,
                height: 120,
                padding: const EdgeInsets.all(6), // Border width
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryLightColor,
                    ],
                  ),
                ),
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(58), // Image radius
                    child: CachedNetworkImage(
                      imageUrl: context.read<UserCubit>().state.userImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30,),
            Text(
              TempLanguage().lblLiveLocation,
              style: context.textTheme.displaySmall?.copyWith(color: AppColors.secondaryFontColor),
            ),
            const SizedBox(height: 20,),

            Container(
              width: context.width(),
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20)
              ),
              child: GoogleMap(
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                //markers: state.markers,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) async {
                  if(!_controller.isCompleted){
                    _controller.complete(controller);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
