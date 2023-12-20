import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/client_selected_vendor_cubit.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/location_utils.dart';

class VendorEmployeeMap extends StatefulWidget {
  const VendorEmployeeMap({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<VendorEmployeeMap> createState() => _VendorEmployeeMapState();
}

class _VendorEmployeeMapState extends State<VendorEmployeeMap> {
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

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: context.width(),
            height: context.height(),
            child: FutureBuilder<Position?>(
              future: LocationUtils.fetchLocation(),
              builder: (context, positionSnap) {
                if (positionSnap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
                } else if (positionSnap.hasError) {
                  return Center(child: Text(TempLanguage().lblSomethingWentWrong),);
                } else if (positionSnap.hasData && positionSnap.data != null) {
                  return FutureBuilder<User>(
                    future: userService.userByUid(widget.userId),
                    builder: (context, userSnap) {
                     if (userSnap.data == null) {
                        return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
                      } else {
                        final user = userSnap.data!;
                        return FutureBuilder<List<User>>(
                            future: userService.getOnlineEmployees(widget.userId),
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
                              } else {
                                List<User> users = [...snapshot.data ?? [], user];
                                return FutureBuilder(
                                    future: addEmployeeMarkers(users),
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
                                              _controller = controller;
                                              _getCameraPosition(positionSnap.data);
                                            },
                                          ),
                                        );
                                      }
                                      return Center(child: Text(TempLanguage().lblSomethingWentWrong),);
                                    }
                                );
                              }
                            }
                        );
                      }
                    },
                  );
                } else {
                  return Center(child: Text(TempLanguage().lblSomethingWentWrong),);
                }
              },
            ),
          ),
          Positioned(
            top: 40,
            left: 0,
            child: IconButton(
              onPressed: (){
                ContextExtensions(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
        ],
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

    _controller?.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));

  }

  Future<Set<Marker>> addEmployeeMarkers(List<User> users) async {
    Set<Marker> markers = <Marker>{};

    for (User user in users) {
      if (user.latitude != null && user.longitude != null) {
        final marker = Marker(
            icon: BitmapDescriptor.defaultMarker,
            markerId: MarkerId('${user.uid}'),
            position: LatLng(user.latitude!, user.longitude!),
            onTap: () {
              context.read<ClientSelectedVendorCubit>().selectedVendorId(user.uid);
              context.pushNamed(AppRoutingName.clientMenuItemDetail, extra: user);
            }
        );
        markers.add(marker);
      }
    }
    return markers;
  }
}