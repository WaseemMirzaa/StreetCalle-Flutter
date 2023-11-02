import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/client_selected_vendor_cubit.dart';

class ClientVendorDirection extends StatefulWidget {
  const ClientVendorDirection({Key? key}) : super(key: key);

  @override
  State<ClientVendorDirection> createState() => _ClientVendorDirectionState();
}

class _ClientVendorDirectionState extends State<ClientVendorDirection> {

  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = 'AIzaSyBhXRneUK9kcMvVjPed9VKFB1TXASwKd3E';

  final Stream<Position> _locationStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(distanceFilter: 0, accuracy: LocationAccuracy.bestForNavigation)
  );

  @override
  void dispose() {
    _controller = Completer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userService = sl.get<UserService>();
    String? clientVendorId = context.select((ClientSelectedVendorCubit cubit) => cubit.state);

    return Scaffold(
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: StreamBuilder<Position>(
          stream: _locationStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
            } else if (snapshot.hasError) {
              return Center(child: Text(TempLanguage().lblSomethingWentWrong));
            } else {
              return StreamBuilder<DocumentSnapshot>(
                stream: userService.getUser(clientVendorId ?? ''),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
                  }

                  /// origin marker
                  final orgLat = LatLng(snapshot.data!.latitude, snapshot.data!.longitude);
                  _addMarker(orgLat, 'origin', BitmapDescriptor.defaultMarker);

                  /// destination marker
                  final destLat = LatLng((snap.data!.data() as User).latitude!, (snap.data!.data() as User).longitude!);
                  _addMarker(destLat, 'destination', BitmapDescriptor.defaultMarkerWithHue(90));

                  _getPolyline(orgLat, destLat);
                  return GoogleMap(
                    mapType: MapType.normal,
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    //markers: state.markers,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) async {
                      if(!_controller.isCompleted){
                        _controller.complete(controller);

                        //_getCameraPosition(snapshot.data);
                      }
                    },
                  );
                },
              );
            }
          },
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
      zoom: 18,
    );

    final GoogleMapController mapController = await _controller.future;
    mapController.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));

  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline(LatLng org, LatLng dest) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(org.latitude, org.longitude),
        PointLatLng(dest.latitude, dest.longitude),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: 'Sabo, Yaba Lagos Nigeria')]
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}



class Test extends StatefulWidget {
  Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  late GoogleMapController mapController;

  double _originLatitude = 6.5212402, _originLongitude = 3.3679965;

  double _destLatitude = 6.849660, _destLongitude = 3.648190;

  Map<MarkerId, Marker> markers = {};

  Map<PolylineId, Polyline> polylines = {};

  List<LatLng> polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = 'AIzaSyBhXRneUK9kcMvVjPed9VKFB1TXASwKd3E';

  @override
  void initState() {
    super.initState();

    /// origin marker
    _addMarker(LatLng(_originLatitude, _originLongitude), 'origin', BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(_destLatitude, _destLongitude), 'destination', BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(_originLatitude, _originLongitude), zoom: 15),
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
          )),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(_originLatitude, _originLongitude),
        PointLatLng(_destLatitude, _destLongitude),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: 'Sabo, Yaba Lagos Nigeria')]
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}
