
import 'package:background_location/background_location.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/services/shared_preferences_service.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'dart:math' show atan2, cos, sin, sqrt, pi;

class LocationUtils {

  static Position? position;

  static Future<Position> fetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print(serviceEnabled);
    if (!serviceEnabled) {
      toast(TempLanguage().lblEnableLocationService);
    }
    permission = await Geolocator.checkPermission();
    print(permission);


    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      print('if condition permission');
      return await Geolocator.getLastKnownPosition() ?? await Geolocator.getCurrentPosition();
    }
    var a = await Geolocator.getCurrentPosition();
    print('This is Longitude : ${a.longitude} iiiiiiiiiiiiiiiiiiiiiiiiiii' );
    return a;
  }

  static Future<void> getBackgroundLocation() async {

    await BackgroundLocation.setAndroidNotification(
      title: TempLanguage().lblBackgroundServiceIsRunning,
      message: TempLanguage().lblBackgroundLocationInProgress,
      icon: '@mipmap/ic_launcher',
    );

    final sharedPref = sl.get<SharedPreferencesService>();
    final userService = sl.get<UserService>();
    //await BackgroundLocation.setAndroidConfiguration(1000);
    await BackgroundLocation.startLocationService(distanceFilter: 50);

    BackgroundLocation.getLocationUpdates((Location location) {
      if (location.longitude != null && location.latitude != null) {
          userService.updateUserLocation(location.latitude!, location.longitude!, sharedPref.getStringAsync(SharePreferencesKey.USER_ID));
      }
    });

    try {
      final currentLocation = await fetchLocation();
      userService.updateUserLocation(currentLocation.latitude, currentLocation.longitude, sharedPref.getStringAsync(SharePreferencesKey.USER_ID));
    } catch(e) {
      log('Error: $e');
    }
  }

  static void stopBackgroundLocation() {
   BackgroundLocation.stopLocationService();
  }

  static String calculateVendorsDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    var distance = Geolocator.distanceBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude
    );
    var distanceInKm = distance / 1000;
    return distanceInKm.toStringAsFixed(2);
  }

  static Future<String?> getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placeMarks.isNotEmpty) {
        Placemark placeMark = placeMarks[0];
        //String address = '${placeMark.street}, ${placeMark.locality}, ${placeMark.postalCode}, ${placeMark.country}';
        String address = '${placeMark.name}, ${placeMark.locality}, ${placeMark.administrativeArea}';
        return address;
      } else {
        return TempLanguage().lblAddressNotFound;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getAddressFromPosition() async {
    try {
      final position = await LocationUtils.fetchLocation();
      List<Placemark> placeMarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placeMarks.isNotEmpty) {
        Placemark placeMark = placeMarks[0];
        //String address = '${placeMark.street}, ${placeMark.locality}, ${placeMark.postalCode}, ${placeMark.country}';
        String address = '${placeMark.name}, ${placeMark.locality}, ${placeMark.administrativeArea}';
        return address;
      } else {
        return TempLanguage().lblAddressNotFound;
      }
    } catch (e) {
      return null;
    }
  }

  static double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  static double distanceInMiles(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    const double earthRadiusMiles = 3958.8; // Radius of the Earth in miles

    double dLat = degreesToRadians(endLatitude - startLatitude);
    double dLon = degreesToRadians(endLongitude - startLongitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(degreesToRadians(startLatitude)) * cos(degreesToRadians(endLatitude)) *
            sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusMiles * c;
  }

  static bool isDistanceWithinRange(double startLatitude, double startLongitude, double endLatitude, double endLongitude, double rangeMiles) {
    double distanceInMilesValue = distanceInMiles(startLatitude, startLongitude, endLatitude, endLongitude);
    return distanceInMilesValue <= rangeMiles;
  }
}