import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/current_location_cubit.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/location_utils.dart';
import 'package:street_calle/utils/constant/app_colors.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({Key? key}) : super(key: key);

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

  Future animateToPosition({double? lat, double? long}) async {
   // final GoogleMapController mapController = await _controller.future;
    await _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat ?? 0.0, long ?? 0.0,), zoom: 18)));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationCubit = context.read<CurrentLocationCubit>().state;

    return Scaffold(
      body: FutureBuilder<String?>(
        future: LocationUtils.getAddressFromLatLng(LatLng(locationCubit.latitude ?? 0.0, locationCubit.longitude ?? 0.0)),
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
                  target: LatLng(locationCubit.latitude ?? 0.0, locationCubit.longitude ?? 0.0), //initial position
                  zoom: 18.0, //initial zoom level
                ),
                mapType: MapType.normal,
                //map type
                onMapCreated: (controller) async {

                  log('iii Map Created');

                  List<Placemark> placemarks = await placemarkFromCoordinates(
                    cameraPosition?.target.latitude ?? locationCubit.latitude ?? 0.0,
                    cameraPosition?.target.longitude ?? locationCubit.longitude ?? 0.0,
                    // localeIdentifier: "en"
                  );

                  if (placemarks.isNotEmpty) {
                     setState(() {
                       location = '${placemarks.first.name}, ${placemarks.first.locality}, ${placemarks.first.administrativeArea}';
                     });
                    //if (isFirstTime) {
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
                      isFirstTime = false;
                   // }
                  }
                  // if(!_controller.isCompleted){
                  //   _controller.complete(controller);
                  // }
                  _controller = controller;
                },

                onCameraMove: (CameraPosition cameraPositiona) async {
                  log('iii Camera Move ${cameraPosition.toString()}');
                  cameraPosition = cameraPositiona;
                },

                onCameraIdle: () async {
                  log('iii Camera Idle ${locationCubit.latitude}--${locationCubit.longitude}');
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                    cameraPosition?.target.latitude ?? locationCubit.latitude ?? 0.0,
                    cameraPosition?.target.longitude ?? locationCubit.longitude ?? 0.0,
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
                      left: 0,
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
                      bottom: 0,
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
                                    await animateToPosition();
                                    if (!isGotLocation) {
                                      isGotLocation = true;

                                      // final loc = await locationController.fetchLocation();
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
                                      isFirstTime = false;
                                      setState(() {});
                                    }
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
                                // .cornerRadiusWithClipRRect(15),
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
                              )),
                          15.height,
                          InkWell(
                            onTap: () async {
                              // List<Placemark> placeMarks =
                              // await placemarkFromCoordinates(
                              //   cameraPosition?.target.latitude ?? widget.currentLocation.latitude,
                              //   cameraPosition?.target.longitude ?? widget.currentLocation.longitude,
                              // );
                              // if (address != null && placeMarks.isNotEmpty) {
                              //   address?.locality = placeMarks.first.locality ??
                              //       placeMarks.first.country;
                              //
                              //   address?.postalCode =
                              //       placeMarks.first.postalCode;
                              //   address?.street = placeMarks.first.street;
                              //   address?.name = placeMarks.first.name;
                              //   address?.administrativeArea =
                              //       placeMarks.first.administrativeArea;
                              //   address?.country = placeMarks.first.country;
                              //   address?.subAdministrativeArea =
                              //       placeMarks.first.subAdministrativeArea;
                              //   address?.longitude = cameraPosition?.target.longitude ?? widget.currentLocation.longitude;
                              //   address?.latitude =
                              //       cameraPosition?.target.latitude ?? widget.currentLocation.latitude;
                              //
                              //   location.value = "${placeMarks.first.name}, ${placeMarks.first.locality}, ${placeMarks.first.administrativeArea}";
                              //
                              //   address?.completeAddress = location.value;
                              //   Navigator.pop(context, address);
                              // }
                            },
                            child: Container(
                              height: 40,
                              width: 200,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryLightColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Select',
                                  // style: GoogleFonts.poppins(
                                  //   fontSize: 18,
                                  //   fontWeight: FontWeight.w500,
                                  //   color: address?.postalCode == null
                                  //       ? Colors.black.withOpacity(0.5)
                                  //       : Colors.black,
                                  // ),
                                ),
                              ),
                            ).cornerRadiusWithClipRRect(10),
                          ),
                          50.height
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
