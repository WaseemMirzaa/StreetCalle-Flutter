import 'package:background_location/background_location.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/services/shared_preferences_service.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/constants.dart';

class LocationUtils {

  static Future<Position> fetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      toast(TempLanguage().lblEnableLocationService);
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return await Geolocator.getLastKnownPosition() ?? await Geolocator.getCurrentPosition();
    }
    return await Geolocator.getCurrentPosition();
  }

  static Future<void> getBackgroundLocation() async {

    await BackgroundLocation.setAndroidNotification(
      title: 'Background service is running',
      message: 'Background location in progress',
      icon: '@mipmap/ic_launcher',
    );

    final sharedPref = sl.get<SharedPreferencesService>();
    final userService = sl.get<UserService>();
    //await BackgroundLocation.setAndroidConfiguration(1000);
    await BackgroundLocation.startLocationService(distanceFilter: 0);

    BackgroundLocation.getLocationUpdates((location) {
      if (location.longitude != null && location.latitude != null) {

        userService.updateUserLocation(location.latitude!, location.longitude!, sharedPref.getStringAsync(SharePreferencesKey.USER_ID));
      }
    });
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
        String address = '${placeMark.street}, ${placeMark.locality}';
        return address;
      } else {
        return TempLanguage().lblAddressNotFound;
      }
    } catch (e) {
      return null;
    }
  }

}