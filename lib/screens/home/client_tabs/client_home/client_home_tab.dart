import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/location_utils.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';

class ClientHomeTab extends StatefulWidget {
  const ClientHomeTab({Key? key}) : super(key: key);

  @override
  State<ClientHomeTab> createState() => _ClientHomeTabState();
}

class _ClientHomeTabState extends State<ClientHomeTab> {

 Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

 static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _getCameraPosition();
  }

  @override
  void dispose() {
    _controller = Completer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: context.width,
            height: context.height,
            child: GoogleMap(
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) async {
                if(!_controller.isCompleted){
                  _controller.complete(controller);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 54, left: 24, right: 24),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (String? value) {},
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20),
                      filled: true,
                      prefixIcon: Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          decoration: const BoxDecoration(
                              color: AppColors.primaryLightColor,
                              shape: BoxShape.circle
                          ),
                          child: const Icon(Icons.search, color: AppColors.hintColor,)),
                      hintStyle: context.currentTextTheme.displaySmall,
                      hintText: TempLanguage().lblSearchFoodTrucks,
                      fillColor: AppColors.whiteColor,
                      border: clientSearchBorder,
                      focusedBorder: clientSearchBorder,
                      disabledBorder: clientSearchBorder,
                      enabledBorder: clientSearchBorder,
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
          ),
        ],
      ),
    );
  }

 Future<CameraPosition> _getCameraPosition() async {
   final position = await LocationUtils.fetchLocation();
   CameraPosition cameraPosition = CameraPosition(
     target: LatLng(position.latitude, position.longitude),
     zoom: 14,
   );

   final GoogleMapController mapController = await _controller.future;
   mapController.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));

   return cameraPosition;
 }

}
