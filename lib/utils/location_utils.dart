import 'package:background_location/background_location.dart';
import 'package:geolocator/geolocator.dart';
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

}