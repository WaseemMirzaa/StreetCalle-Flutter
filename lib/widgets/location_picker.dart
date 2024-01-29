import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/current_location_cubit.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/location_utils.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/screens/home/client_tabs/client_search/cubit/filter_cubit.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({Key? key, required this.position}) : super(key: key);
  final LatLng position;

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  GoogleMapController? _controller;
  CameraPosition? cameraPosition;
  String location = '';
  bool isGotLocation = false;
  bool isFirstTime = true;
  bool currLocIconPress = false;
  LatLng? position;

  Future animateToPosition({double? lat, double? long}) async {
   // final GoogleMapController mapController = await _controller.future;
    await _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat ?? 0.0, long ?? 0.0,), zoom: 18)));
  }

  @override
  void initState() {
    super.initState();
    position = widget.position;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final locationCubit = context.read<CurrentLocationCubit>().state;
    final userCubit = context.read<UserCubit>();

    return Scaffold(
      body: FutureBuilder<String?>(
        future: LocationUtils.getAddressFromLatLng(LatLng(position?.latitude ?? 0.0, position?.longitude ?? 0.0)),
        builder: (ctx, snap) {
          if (snap.hasData) {
            return Stack(
                children: [
                  GoogleMap(
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                zoomGesturesEnabled: true,
                //enable Zoom in, out on map
                initialCameraPosition: CameraPosition(
                  target: position ?? const LatLng(0.0, 0.0), //initial position
                  zoom: 18.0, //initial zoom level
                ),
                mapType: MapType.normal,
                //map type
                onMapCreated: (controller) async {
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                    cameraPosition?.target.latitude ?? position?.latitude ?? 0.0,
                    cameraPosition?.target.longitude ?? position?.longitude ?? 0.0,
                    // localeIdentifier: "en"
                  );
                  if (placemarks.isNotEmpty) {
                     setState(() {
                       location = '${placemarks.first.name}, ${placemarks.first.locality}, ${placemarks.first.administrativeArea}';
                     });
                      final loc = await LocationUtils.fetchLocation();
                      Position position = Position(
                          altitudeAccuracy: 0.0,
                          longitude: loc.longitude,
                          latitude: loc.latitude,
                          timestamp: DateTime.now(),
                          accuracy: 0.0,
                          altitude: 0.0,
                          heading: 0.0,
                          speed: 0.0,
                          speedAccuracy: 100, headingAccuracy: 100);
                      await animateToPosition(lat: position.latitude, long: position.longitude);
                  }
                  _controller = controller;
                },

                onCameraMove: (CameraPosition cameraPositiona) async {
                  cameraPosition = cameraPositiona;
                },

                onCameraIdle: () async {
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                    cameraPosition?.target.latitude ?? position?.latitude ?? 0.0,
                    cameraPosition?.target.longitude ?? position?.longitude ?? 0.0,
                  );
                  if (placemarks.isNotEmpty) {
                    setState(() {
                      location = '${placemarks.first.name}, ${placemarks.first.locality}, ${placemarks.first.administrativeArea}';
                    });
                  }
                },
              ),
                  Center(
                child: SvgPicture.asset(
                  AppAssets.mapPin,
                  width: 40,
                  height: 40,
                ),
              ),
                  SizedBox(
                height: ContextExtensions(context).height(),
                child: Stack(
                  children: [
                    Positioned(
                      top: 40,
                      left: 10,
                      child: IconButton(
                        onPressed: (){
                          context.pop();
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.only(right: 4.0, bottom: 15),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                  onTap: () async {
                                    final loc = await LocationUtils.fetchLocation();
                                    Position position = Position(
                                        longitude: loc.longitude,
                                        latitude: loc.latitude,
                                        timestamp: DateTime.now(),
                                        accuracy: 0.0,
                                        altitude: 0.0,
                                        heading: 0.0,
                                        speed: 0.0,
                                        speedAccuracy: 0.0, altitudeAccuracy: 100,headingAccuracy: 100);
                                    await animateToPosition(lat: position.latitude, long: position.longitude,);
                                  },
                                  child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(50),
                                          color: Colors.white70,
                                          border:
                                          Border.all(color: Colors.grey)),
                                      child: const Icon(
                                        size: 25,
                                        Icons.gps_fixed,
                                        // Icons.gps_not_fixed_outlined,
                                        color: Colors.black87,
                                        // color: white,
                                      ))
                              ),
                            ),
                          ),
                          10.height,
                          Container(
                              padding: const EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width - 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: SvgPicture.asset(
                                  AppAssets.mapPin,
                                  width: 25,
                                ),
                                title: Text(
                                  location,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                dense: true,
                              ),
                          ),
                          15.height,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 44.0),
                            child: SizedBox(
                              width: ContextExtension(context).width,
                              height: defaultButtonSize,
                              child: AppButton(
                                text: TempLanguage().lblSelect,
                                elevation: 0.0,
                                enabled: !userCubit.state.isGuest,
                                onTap: () {
                                  final localItems = context.read<LocalItemsStorage>();
                                  final dealItems = context.read<LocalDealsStorage>();
                                  localItems.resetLocalItem();
                                  dealItems.resetLocalDeal();

                                  context.read<CurrentLocationCubit>().setUpdatedLocation(
                                      updatedLatitude: cameraPosition?.target.latitude,
                                      updatedLongitude: cameraPosition?.target.longitude
                                  );
                                 Navigator.pop(context);
                                },
                                shapeBorder: RoundedRectangleBorder(
                                    side: BorderSide.none,
                                    borderRadius: BorderRadius.circular(30)
                                ),
                                textStyle: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.blackColor),
                                color: AppColors.primaryLightColor,
                                disabledColor: AppColors.greyColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              ]
            );
          } else if (snap.hasError) {
            toast(snap.error.toString());
            Navigator.pop(context);
            return Container();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
