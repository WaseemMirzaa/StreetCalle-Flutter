import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/direction_cubit.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/client_selected_vendor_cubit.dart';

class ClientVendorDirection extends StatefulWidget {
  const ClientVendorDirection({Key? key}) : super(key: key);

  @override
  State<ClientVendorDirection> createState() => _ClientVendorDirectionState();
}

class _ClientVendorDirectionState extends State<ClientVendorDirection> {

  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    String? clientVendorId = context.read<ClientSelectedVendorCubit>().state;
    context.read<DirectionCubit>().init(clientVendorId);
  }

  void _animateCamera(LatLng currentUserLocation) {
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: currentUserLocation, zoom: 18)));
  }

  @override
  void dispose() {
    _mapController?.dispose();
    //_markers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<DirectionCubit, DirectionState>(
            builder: (context, state) {

              if (state.currentUserLocation != null) {
                _animateCamera(state.currentUserLocation!);
              }

              return state.polyline == null || state.currentUserLocation == null
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),)
                  : GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: state.currentUserLocation!,
                  zoom: 15,
                ),
                polylines: <Polyline>{state.polyline!},
                markers: state.markers!,
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
              );
            },
          ),
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
        ],
      ),
    );
  }
}