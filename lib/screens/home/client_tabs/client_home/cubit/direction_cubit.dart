import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';

class DirectionState {
  final Polyline? polyline;
  final Set<Marker>? markers;
  final LatLng? currentUserLocation;
  final LatLng? vendorLocation;

  DirectionState({this.polyline, this.markers, this.currentUserLocation, this.vendorLocation});

  DirectionState copyWith({
    Polyline? polyline,
    Set<Marker>? markers,
    LatLng? currentUserLocation,
    LatLng? vendorLocation,
  }) {
    return DirectionState(
      polyline: polyline ?? this.polyline,
      markers: markers ?? this.markers,
      currentUserLocation: currentUserLocation ?? this.currentUserLocation,
      vendorLocation: vendorLocation ?? this.vendorLocation
    );
  }

}

class DirectionCubit extends Cubit<DirectionState>{
  DirectionCubit() : super(DirectionState());

  LatLng _currentUserLocation = const LatLng(0.0, 0.0);
  LatLng _vendorLocation = const LatLng(0.0, 0.0);
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = 'AIzaSyBhXRneUK9kcMvVjPed9VKFB1TXASwKd3E';

  final Stream<Position> _locationStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(distanceFilter: 20, accuracy: LocationAccuracy.bestForNavigation)
  );

  Future<void> init(String? clientVendorId) async {
    final userService = sl.get<UserService>();

    _locationStream.listen((position) {
      _currentUserLocation = LatLng(position.latitude, position.longitude);
      _addMarkers();
      _updatePolyline();
    });

    userService.getUser(clientVendorId ?? '').listen((user) {
      if (user.data() != null && user.data()!.latitude != null && user.data()!.longitude != null) {
        _vendorLocation = LatLng(user.data()!.latitude!, user.data()!.longitude!);
        _addMarkers();
        _updatePolyline();
      }
    });

    _updatePolyline();
  }

  Future<void> _updatePolyline() async {
    if (_currentUserLocation == const LatLng(0.0, 0.0) || _vendorLocation == const LatLng(0.0, 0.0)) {
      return;
    }
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(_currentUserLocation.latitude, _currentUserLocation.longitude),
      PointLatLng(_vendorLocation.latitude, _vendorLocation.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    _addMarkers().then((markers){
      Polyline polyline = Polyline(
        polylineId: const PolylineId('user_vendor_polyline'),
        points: polylineCoordinates,
        color: AppColors.primaryColor,
        width: 5,
      );

      _updateMap(polyline, markers);
    });
  }

  Future<Set<Marker>> _addMarkers() async {
    Set<Marker> markers = {};

    final marker = await createCustomMarkerIconLocal(AppAssets.truckMarker);
    markers.add(
      Marker(
        markerId: const MarkerId('user_marker'),
        position: _currentUserLocation,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    markers.add(
      Marker(
        markerId: const MarkerId('vendor_marker'),
        position: _vendorLocation,
        icon: marker,
      ),
    );
    return markers;
  }

  void _updateMap(Polyline polyline, Set<Marker> markers){
    emit(state.copyWith(polyline: polyline, markers: markers, currentUserLocation: _currentUserLocation, vendorLocation: _vendorLocation));
  }
}