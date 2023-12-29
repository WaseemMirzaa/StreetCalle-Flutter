import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/filter_cubit.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/location_utils.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/client_selected_vendor_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/marker_cubit.dart';

class DisplayMap extends StatefulWidget {
  const DisplayMap({Key? key, required this.position, required this.isLocationUpdated}) : super(key: key);
  final Position? position;
  final bool isLocationUpdated;

  @override
  State<DisplayMap> createState() => _DisplayMapState();
}

class _DisplayMapState extends State<DisplayMap> {


  GoogleMapController? _controller;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userService = sl.get<UserService>();
    context.read<MapFilterCubit>().updateFilter(TempLanguage().lblAll);

    return FutureBuilder<List<User>>(
        future: userService.getVendorsAndEmployees(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
          } else {

            return BlocBuilder<MapFilterCubit, String>(
              builder: (context, filterString) {

                List<User> users = [];

                if (filterString != defaultVendorFilter) {
                  users = snap.data!.where((user) {
                    final category = user.category?.toLowerCase().trim() ?? '';
                    return category.contains(filterString.toLowerCase().trim());
                  }).toList();
                } else {
                  users = snap.data ?? [];
                }
                if (widget.position != null) {

                  addVendorMarkers(users, widget.position!).then((markers) {
                    //final locationCubit = context.read<CurrentLocationCubit>();
                    // if (locationCubit.state.latitude == null && locationCubit.state.longitude == null) {
                    //   locationCubit.setCurrentLocation(latitude: position.latitude, longitude: position.longitude);
                    // }
                    if (mounted) {
                      context.read<MarkersCubit>().setMarkers(markers);
                    }
                  });

                }

                return BlocBuilder<MarkersCubit, MarkersState>(
                  builder: (context, state) {
                    return GoogleMap(
                      mapType: MapType.normal,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      myLocationEnabled: true,
                      markers: state.markers,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) async {
                        _controller = controller;

                        if (widget.position != null) {
                          _getCameraPosition(widget.position!);
                        }
                      },
                    );
                  },
                );
              },
            );
          }
        }
    );
  }

  Future<void> _getCameraPosition(Position? position) async {
    if (position == null) {
      return;
    }
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 18,
    );

    // final GoogleMapController mapController = await _controller.future;
    _controller?.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));

  }

  Future<Set<Marker>> addVendorMarkers(List<User> users, Position position) async {
    Set<Marker> markers = <Marker>{};
    final markerAssets = [
      AppAssets.truckMarker,
      AppAssets.cargoTruckMarker,
      AppAssets.ambulanceMarker
    ];
    int markerIndex = 0;

    for (User user in users) {
      if (user.latitude != null && user.longitude != null) {
        BitmapDescriptor? icon;
        if (user.image == null) {
          icon = await createCustomMarkerIconLocal(markerAssets[markerIndex]);
        } else {
          icon = await createCustomMarkerIconNetwork(user.isEmployee ? user.employeeOwnerImage! : user.image!);
        }

        /// Inside 10-miles area
        if (LocationUtils.isDistanceWithinRange(position.latitude, position.longitude, user.latitude!, user.longitude!, 10)) {
          final marker = Marker(
              icon: icon,
              markerId: MarkerId('${user.uid}'),
              position: LatLng(user.latitude!, user.longitude!),
              onTap: (){
                context.read<ClientSelectedVendorCubit>().selectedVendorId(user.uid);
                context.pushNamed(AppRoutingName.clientMenuItemDetail, extra: user);
              }
          );

          markers.add(marker);
        }
        markerIndex = (markerIndex + 1) % markerAssets.length;
      }
    }

    if(widget.isLocationUpdated) {
      final marker = Marker(
        markerId: MarkerId('${position.latitude}--${position.longitude}'),
        position: LatLng(position.latitude, position.longitude),
      );
      markers.add(marker);
    }
    return markers;
  }
}