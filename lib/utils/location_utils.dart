// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:linker/main.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../UI/location_permission_screen.dart';
// import 'common.dart';
// import 'components/dialogs/own_dialog.dart';
// import 'components/permission_denied_dialog.dart';
//
// class LocationUtils {
//   static const double speedInMeterPerSecond = 5.0;
//   static bool isDisplayed = false;
//
//   static Duration getTimeInSeconds(double startLatitude, double startLongitude, double endLatitude, double endLongitude,
//       {double speedInMetersPerSecond = speedInMeterPerSecond}) {
//     double distanceInMeters = Geolocator.distanceBetween(
//       startLatitude,
//       startLongitude,
//       endLatitude,
//       endLongitude,
//     );
//
//     double timeInSeconds = distanceInMeters / speedInMetersPerSecond;
//     return Duration(seconds: timeInSeconds.toInt());
//   }
//
//   static Future<Position> fetchLocation() async {
// // bool serviceEnabled;
// // LocationPermission permission;
// //
// // // Test if location services are enabled.
// // serviceEnabled = await Geolocator.isLocationServiceEnabled();
// // if (!serviceEnabled) {
// //   return Future.error('Location services are disabled.');
// // }
// //
// // permission = await Geolocator.checkPermission();
// // if (permission == LocationPermission.denied) {
// //   permission = await Geolocator.requestPermission();
// //   if (permission == LocationPermission.denied) {
// //     // your App should show an explanatory UI now.
// //     return Future.error('Location permissions are denied');
// //   }
// // }
// //
// // if (permission == LocationPermission.deniedForever) {
// //   showDialog(
// //           context: getContext,
// //           builder: (BuildContext context) => const PermissionDeniedDialog(),
// //         );
// //   return Future.error(
// //       'Location permissions are permanently denied, we cannot request permissions.');
// // }
//
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       toast("Enable location service.");
// // return Future.error('Location services are disabled.');
//     }
//     permission = await Geolocator.checkPermission();
//
//     if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
//       return await Geolocator.getLastKnownPosition() ?? await Geolocator.getCurrentPosition();
//     }
//     return await Geolocator.getCurrentPosition();
//   }
//
//   static Future<void> requestLocationPermissionWithConsentDialog(
//       {BuildContext? scaffoldContext, required Function onGranted, required Function onDenied}) async {
//     if (isDisplayed) {
//       return;
//     }
//     isDisplayed = true;
//     bool isGranted = await Permission.location.isGranted;
//     if (!isGranted) {
//       await showConfirmDialogCustomOwn(
//         scaffoldContext ?? getContext,
//         title: 'Your consent is required',
//         subTitle: 'Location permission is required to run the app smoothly and work properly.',
//         positiveText: "OK",
//         cancelable: false,
//         barrierDismissible: false,
//         onAccept: (_) async {
//           requestLocationPermissions(scaffoldContext).then((isGrantedNow) => {
//             isDisplayed = false,
//             logger.d("Loading dialog dismissed."),
//             if (isGrantedNow)
//               {
//                 onGranted(),
//               }
//             else
//               {
//                 onDenied(),
//               }
//           });
//         },
//       );
//     }
//   }
//
//   static Future<bool> requestLocationPermissions(context) async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       toast("Location services are disabled.");
//       // return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // your App should show an explanatory UI now.
//         return false;
//         // return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       showDialog(
//         context: getContext,
//         builder: (BuildContext context) => const PermissionDeniedDialog(),
//       );
//       return false;
//       // return Future.error(
//       //     'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     return true;
//   }
//
//   static Future<bool> checkLocationPermissionNavigateToScreen() async {
//
//     bool isGranted = await Permission.location.isGranted;
//
//     if(!isGranted) {
//       // final returnedResult = await Navigator.of(getContext).push(
//       //   MaterialPageRoute(
//       //     builder: (context) => LocationPermissionScreen(),
//       //   ),
//       // );
//
//       // if (returnedResult != null) {
//       //   return returnedResult;
//       // }
//    return true;
//     } else {
//
//       return true;
//     }
//
//     return false;
//
//   }
//
// // void _navigateToSecondScreen(BuildContext context) async {
// //   final returnedResult = await Navigator.of(context).push(
// //     MaterialPageRoute(
// //       builder: (context) => LocationPermissionScreen(),
// //     ),
// //   );
// //
// //   if (returnedResult != null) {
// //     setState(() {
// //       result = returnedResult;
// //     });
// //   }
// // }
// }
