import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/location_utils.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/marker_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/client_selected_vendor_cubit.dart';
import 'package:street_calle/widgets/search_field.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/current_location_cubit.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/models/drop_down_item.dart';
import 'package:street_calle/services/category_service.dart';
import 'package:street_calle/screens/selectUser/widgets/drop_down_widget.dart';

class ClientHomeTab extends StatelessWidget {
  const ClientHomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DropDownItem? selectedItem;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: ContextExtension(context).width,
            height: ContextExtension(context).height,
            child: FutureBuilder<Position>(
              future: LocationUtils.fetchLocation(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
                } else if (snapshot.hasError) {
                  return Center(child: Text(TempLanguage().lblSomethingWentWrong));
                } else {
                  return BlocBuilder<CurrentLocationCubit, CurrentLocationState>(
                    builder: (context, state) {
                      if (state.updatedLatitude != null && state.updatedLongitude != null) {
                          Position position = Position(
                              longitude: state.updatedLongitude!,
                              latitude: state.updatedLatitude!,
                              timestamp: DateTime.now(),
                              accuracy: 0.0,
                              altitude: 0.0,
                              heading: 0.0,
                              speed: 0.0,
                              speedAccuracy: 0.0, altitudeAccuracy: 100,headingAccuracy: 100);
                        return DisplayMap(position: position, isLocationUpdated: true,);
                      } else {
                        return DisplayMap(position: snapshot.data, isLocationUpdated: false,);
                      }
                    },
                  );
                }
              },
            )
          ),
          Padding(
            padding: const EdgeInsets.only(top: 54, left: 24, right: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          context.pushNamed(AppRoutingName.clientMenu);
                        },
                        child: SearchField(
                          padding: EdgeInsets.zero,
                          hintText: TempLanguage().lblSearchFoodTrucks,
                          onChanged: (String? value) {},
                        ),
                      ),
                    ),
                    const SizedBox(width: 16,),
                    InkWell(
                      onTap: (){
                        context.pushNamed(AppRoutingName.clientMenu);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                            color: AppColors.primaryLightColor,
                            shape: BoxShape.circle
                        ),
                        child: Image.asset(AppAssets.topMenuIcon),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12,),
                FutureBuilder<List<dynamic>?>(
                  future: sl.get<CategoryService>().fetchCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
                    } else if (snapshot.hasData && snapshot.data != null) {
                      List<DropDownItem> category = [];
                      snapshot.data?.forEach((element) {
                        final dropDown = DropDownItem(
                            title: element[CategoryKey.TITLE],
                            icon: Image.network(element[CategoryKey.ICON], width: 18, height: 18,),
                            url: element[CategoryKey.ICON]
                        );
                        category.add(dropDown);
                      });

                      selectedItem = category[0];

                      return Container(
                        margin: const EdgeInsets.only(right: 130),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blackColor.withOpacity(0.15),
                              spreadRadius: 3, // Spread radius
                              blurRadius: 18, // Blur radius
                              offset: const Offset(0, 2), // Offset in the Y direction
                            ),
                          ],
                        ),
                        child: DropDownWidget(
                          initialValue: selectedItem,
                          items: category,
                          onChanged: (value) {
                            selectedItem = value;
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(TempLanguage().lblSomethingWentWrong),
                      );
                    }
                    return Center(
                      child: Text(TempLanguage().lblSomethingWentWrong),
                    );
                  },
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 30,
            left: 30,
            right: 30,
            child: BlocBuilder<CurrentLocationCubit, CurrentLocationState>(
              builder: (context, state) {
                final latLng = LatLng(state.updatedLatitude ?? 0.0, state.updatedLongitude ?? 0.0);
                return FutureBuilder(
                    future: state.updatedLatitude == null ? LocationUtils.getAddressFromPosition() : LocationUtils.getAddressFromLatLng(latLng),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }
                      if (snapshot.hasData && snapshot.data != null) {
                        return Container(
                          height: defaultButtonSize,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLightColor,
                            borderRadius: BorderRadius.circular(defaultRadius),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 8,),
                              Expanded(
                                child: Text('${snapshot.data}', style: const TextStyle(color: AppColors.blackColor),),
                              ),
                              IconButton(
                                onPressed: () async {
                                  LocationUtils.fetchLocation().then((current){
                                    final position = LatLng(current.latitude, current.longitude);
                                    context.pushNamed(AppRoutingName.locationPicker, extra: position);
                                  });
                                },
                                icon: const Icon(Icons.edit, color: AppColors.blackColor,),
                              ),
                              const SizedBox(width: 8,),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


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

    return FutureBuilder<List<User>>(
        future: userService.getVendorsAndEmployees(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
          } else {
            final users = snap.data ?? [];
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