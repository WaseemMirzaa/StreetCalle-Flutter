import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart' hide StringExtension;
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/utils/location_utils.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/utils/constant/constants.dart';

class ClientVendorProfile extends StatefulWidget {
  ClientVendorProfile({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<ClientVendorProfile> createState() => _ClientVendorProfileState();
}

class _ClientVendorProfileState extends State<ClientVendorProfile> {

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 10,
  );

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = await _controller.future;
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userService = sl.get<UserService>();
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
      body: FutureBuilder<Position>(
        future: LocationUtils.fetchLocation(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
          } else if (snap.hasError) {
            return Center(
              child: Text(TempLanguage().lblSomethingWentWrong),
            );
          } else {
            return FutureBuilder<User>(
              future: userService.userByUid(widget.userId),
              builder: (context, snapshot) {
                if(snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
                }
                else if (snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
                } else {
                  final user = snapshot.data!;
                  bool isAboutAvailable = !user.about.isEmptyOrNull;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 34.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              user.isOnline ? TempLanguage().lblOnline : TempLanguage().lblOffline,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Image.asset(user.isOnline ? AppAssets.online : AppAssets.offline, width: 18, height: 18,),
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
                                  imageUrl: user.employeeOwnerImage.isEmptyOrNull ? user.image ?? '' : user.employeeOwnerImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10,),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${TempLanguage().lblHiIts} ${user.employeeOwnerName.isEmptyOrNull ? user.name?.capitalizeEachFirstLetter() : user.employeeOwnerName!.capitalizeEachFirstLetter()}!',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontFamily: METROPOLIS_BOLD,
                                fontSize: 16,
                                color: AppColors.primaryFontColor
                            ),
                          ),
                        ),

                        SizedBox(height: isAboutAvailable ? 30 : 0,),
                        isAboutAvailable ? Text(
                          TempLanguage().lblAbout,
                          style: context.textTheme.displaySmall?.copyWith(color: AppColors.secondaryFontColor),
                        ) : const SizedBox.shrink(),

                        SizedBox(height: isAboutAvailable ? 10 : 0,),
                        isAboutAvailable ? Text(
                          user.about!.trim().capitalizeFirstLetter(),
                          style: context.textTheme.labelSmall?.copyWith(fontSize: 14),
                        ) : const SizedBox.shrink(),
                        SizedBox(height: isAboutAvailable ? 10 : 0,),
                        isAboutAvailable ? const Divider(
                          color: AppColors.dividerColor,
                        ) : const SizedBox.shrink(),

                        const SizedBox(height: 15,),
                        Text(
                          TempLanguage().lblLiveLocation,
                          style: context.textTheme.displaySmall?.copyWith(color: AppColors.secondaryFontColor),
                        ),
                        const SizedBox(height: 20,),

                        FutureBuilder(
                            future: addEmployeeMarkers(user),
                            builder: (context, markerSnap) {
                              if (markerSnap.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
                              }
                              if (markerSnap.hasData && markerSnap.data != null) {
                                return SizedBox(
                                  height: 200,
                                  child:  GoogleMap(
                                    mapType: MapType.normal,
                                    zoomControlsEnabled: false,
                                    myLocationButtonEnabled: false,
                                    myLocationEnabled: true,
                                    markers: markerSnap.data!,
                                    initialCameraPosition: _kGooglePlex,
                                    onMapCreated: (GoogleMapController controller) async {
                                      if(!_controller.isCompleted){
                                        _controller.complete(controller);

                                        _getCameraPosition(snap.data);
                                      }
                                    },
                                  ),
                                );
                              }
                              return Center(child: Text(TempLanguage().lblSomethingWentWrong),);
                            }
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  Future<void> _getCameraPosition(Position? position) async {
    if (position == null) {
      return;
    }
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 11,
    );

    final GoogleMapController mapController = await _controller.future;
    mapController.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));

  }

  Future<Set<Marker>> addEmployeeMarkers(User user) async {
    Set<Marker> markers = <Marker>{};

    if (user.latitude != null && user.longitude != null) {
      final marker = Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: MarkerId('${user.uid}'),
        position: LatLng(user.latitude!, user.longitude!),
      );
      markers.add(marker);
    }
    return markers;
  }

}
