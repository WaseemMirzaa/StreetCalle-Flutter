import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart' hide StringExtension;
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/utils/location_utils.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/marker_cubit.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/widgets/category_widget.dart';

class VendorProfile extends StatefulWidget {
  const VendorProfile({Key? key}) : super(key: key);

  @override
  State<VendorProfile> createState() => _VendorProfileState();
}

class _VendorProfileState extends State<VendorProfile> {

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
    final userCubit = context.read<UserCubit>();
    final userAbout = userCubit.state.userAbout;
    final isAboutAvailable = userAbout.isNotEmpty;

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
        child: SingleChildScrollView(
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

              const Align(
                alignment: Alignment.center,
                child: CategoryWidget(),
              ),

              SizedBox(height: isAboutAvailable ? 30 : 0,),
              isAboutAvailable ? Text(
                TempLanguage().lblAbout,
                style: context.textTheme.displaySmall?.copyWith(color: AppColors.secondaryFontColor),
              ) : const SizedBox.shrink(),

              SizedBox(height: isAboutAvailable ? 10 : 0,),
              isAboutAvailable ? Text(
                userAbout.trim().capitalizeFirstLetter(),
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

              Container(
                width: ContextExtensions(context).width(),
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20)
                ),
                child: FutureBuilder<Position>(
                  future: LocationUtils.fetchLocation(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
                    } else if (snap.hasError) {
                      return Center(child: Text(TempLanguage().lblSomethingWentWrong));
                    } else {
                      return FutureBuilder<List<User>>(
                        future: userService.getOnlineEmployees(userCubit.state.userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            );
                          } else {


                            final users = snapshot.data ?? [];
                            if (snap.data != null) {
                              final position = snap.data!;
                              addEmployeeMarkers(users, position).then((markers) {
                                context.read<MarkersCubit>().setMarkers(markers);
                              });
                            }

                            return BlocBuilder<MarkersCubit, MarkersState>(
                              builder: (context, state) {
                                return Column(
                                  children: [
                                   SizedBox(
                                     height: 200,
                                     child:  GoogleMap(
                                       mapType: MapType.normal,
                                       zoomControlsEnabled: false,
                                       myLocationButtonEnabled: false,
                                       myLocationEnabled: true,
                                       markers: state.markers,
                                       initialCameraPosition: _kGooglePlex,
                                       onMapCreated: (GoogleMapController controller) async {
                                         if(!_controller.isCompleted){
                                           _controller.complete(controller);

                                           _getCameraPosition(snap.data);
                                         }
                                       },
                                     ),
                                   ),

                                    const SizedBox(height: 20,),
                                    state.markers.isEmpty
                                        ? const SizedBox.shrink()
                                        : FutureBuilder<User?>(
                                        future: findNearestUser(users, snap.data!),
                                        builder: (context, userSnapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return const SizedBox.shrink();
                                          } else {
                                            return Row(
                                              children: [
                                                Text(
                                                  TempLanguage().lblNearestToYou,
                                                  style: context.currentTextTheme.labelSmall?.copyWith(color: AppColors.primaryColor),
                                                ),
                                                Text(
                                                  ' ${userSnapshot.data?.name?.trim().capitalizeEachFirstLetter()}',
                                                  style: context.currentTextTheme.labelSmall?.copyWith(color: AppColors.secondaryFontColor),
                                                ),
                                              ],
                                            );
                                          }
                                        }
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
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

  Future<Set<Marker>> addEmployeeMarkers(List<User> users, Position position) async {
    Set<Marker> markers = <Marker>{};

    for (User user in users) {
      if (user.latitude != null && user.longitude != null) {
        final marker = Marker(
            icon: BitmapDescriptor.defaultMarker,
            markerId: MarkerId('${user.uid}'),
            position: LatLng(user.latitude!, user.longitude!),
        );
        markers.add(marker);
      }
    }
    return markers;
  }

}