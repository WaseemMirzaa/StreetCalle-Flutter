import 'dart:async';
import 'dart:io';
import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/widgets/permission_screen.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/custom_widgets/own_show_confirm_dialog.dart';

class PermissionUtils {
  static bool isDisplayed = false;

  /// Custom Permission dialog
  static Future<void> requestCustomPermissions({
    required BuildContext scaffoldContext,
    required Function onLocationGranted,
    required Function onLocationDenied,
    required Function onNotificationGranted,
    required Function onNotificationDenied,
  }) async {
    locationStatus().then((isLocationGranted) async {
      if (!isLocationGranted) {
        PermissionResponse permissionResponse =
            await showCustomLocationPermissionDialog(
          scaffoldContext: scaffoldContext,
          title: TempLanguage().lblYourConsent,
          message: TempLanguage().lblLocationPermissionRequired,
        );

        switch (permissionResponse) {
          case PermissionResponse.granted:
            onLocationGranted();
            break;
          case PermissionResponse.denied:
            onLocationDenied();
            break;
          case PermissionResponse.canceled:
            break;
        }

        //checkAndRequestNotificationPermission(scaffoldContext, onNotificationGranted(), onNotificationDenied());
        notificationStatus().then((isNotificationGranted) async {
          if (!isNotificationGranted) {
            PermissionResponse permissionResponse =
                await showCustomNotificationPermissionDialog(
              scaffoldContext: scaffoldContext,
              title: TempLanguage().lblYourConsent,
              message: TempLanguage().lblNotificationPermissionRequired,
            );

            switch (permissionResponse) {
              case PermissionResponse.granted:
                onNotificationGranted();
                break;
              case PermissionResponse.denied:
                onNotificationDenied();
                break;
              case PermissionResponse.canceled:
                break;
            }
          }
        });
      } else {
        //checkAndRequestNotificationPermission(scaffoldContext, onNotificationGranted(), onNotificationDenied());
        notificationStatus().then((isNotificationGranted) async {
          if (!isNotificationGranted) {
            PermissionResponse permissionResponse =
                await showCustomNotificationPermissionDialog(
              scaffoldContext: scaffoldContext,
              title: TempLanguage().lblYourConsent,
              message: TempLanguage().lblNotificationPermissionRequired,
            );

            switch (permissionResponse) {
              case PermissionResponse.granted:
                onNotificationGranted();
                break;
              case PermissionResponse.denied:
                onNotificationDenied();
                break;
              case PermissionResponse.canceled:
                break;
            }
          }
        });
      }
    });
  }

  /// Location Permission

  static Future<bool> locationStatus() async {
    return await Permission.location.isGranted;
  }

  static Future<PermissionResponse> showCustomLocationPermissionDialog({
    required BuildContext scaffoldContext,
    required String title,
    required String message,
  }) async {
    Completer<PermissionResponse> completer = Completer<PermissionResponse>();

    ownShowConfirmDialogCustom(
      scaffoldContext,
      title: TempLanguage().lblYourConsent,
      subTitle: TempLanguage().lblLocationPermissionRequired,
      positiveText: TempLanguage().lblOk,
      cancelable: false,
      dialogType: CustomDialogType.LOCATION,
      primaryColor: AppColors.primaryColor,
      barrierDismissible: false,
      onAccept: (_) async {
        Navigator.pop(scaffoldContext);
        requestLocationPermissions(scaffoldContext).then((isGrantedNow) => {
              if (isGrantedNow)
                {completer.complete(PermissionResponse.granted)}
              else
                {completer.complete(PermissionResponse.denied)}
            });
      },
      onCancel: (_) {
        Navigator.pop(scaffoldContext);
        completer.complete(PermissionResponse.canceled);
      },
    );

    return completer.future;
  }

  static Future<bool> requestLocationPermissions(context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      toast(TempLanguage().lblDisableLocationService);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    // if (permission == LocationPermission.deniedForever) {
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) => const PermissionDeniedDialog(),
    //   );
    //   return false;
    // }
    return true;
  }

  static Future<bool> checkStatus() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // static Future<void> requestLocationPermissionWithConsentDialog({BuildContext? scaffoldContext, required Function onGranted, required Function onDenied}) async {
  //   if (isDisplayed) {
  //     return;
  //   }
  //   isDisplayed = true;
  //   bool isGranted = await Permission.location.isGranted;
  //   if (!isGranted) {
  //     await showConfirmDialogCustom(
  //         scaffoldContext!,
  //         title: TempLanguage().lblYourConsent,
  //         subTitle: TempLanguage().lblLocationPermissionRequired,
  //         positiveText: TempLanguage().lblOk,
  //         cancelable: false,
  //         barrierDismissible: false,
  //         onAccept: (_) async {
  //           requestLocationPermissions(scaffoldContext).then((isGrantedNow) => {
  //             isDisplayed = false,
  //             //logger.d("Loading dialog dismissed."),
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
  //         onCancel: (_) {
  //           Navigator.pop(scaffoldContext);
  //         }
  //     );
  //   }
  // }

  /// Notification Permission

  static Future<void> checkAndRequestNotificationPermission(
      BuildContext scaffoldContext,
      Function onNotificationGranted,
      Function onNotificationDenied) async {
    notificationStatus().then((isNotificationGranted) async {
      if (!isNotificationGranted) {
        PermissionResponse permissionResponse =
            await showCustomNotificationPermissionDialog(
          scaffoldContext: scaffoldContext,
          title: TempLanguage().lblYourConsent,
          message: TempLanguage().lblNotificationPermissionRequired,
        );

        switch (permissionResponse) {
          case PermissionResponse.granted:
            onNotificationGranted();
            break;
          case PermissionResponse.denied:
            onNotificationDenied();
            break;
          case PermissionResponse.canceled:
            break;
        }
      }
    });
  }

  static Future<bool> notificationStatus() async {
    if (isAndroid && (await DeviceInformation.apiLevel >= 31)) {
      return await Permission.notification.isGranted;
    }
    return true;
  }

  static Future<PermissionResponse> showCustomNotificationPermissionDialog({
    required BuildContext scaffoldContext,
    required String title,
    required String message,
  }) async {
    Completer<PermissionResponse> completer = Completer<PermissionResponse>();

    await ownShowConfirmDialogCustom(scaffoldContext,
        title: TempLanguage().lblYourConsent,
        subTitle: TempLanguage().lblNotificationPermissionRequired,
        positiveText: TempLanguage().lblOk,
        cancelable: false,
        dialogType: CustomDialogType.NOTIFICATION,
        primaryColor: AppColors.primaryColor,
        barrierDismissible: false, onAccept: (_) async {
      Navigator.pop(scaffoldContext);
      requestNotificationPermissions(scaffoldContext).then((isGrantedNow) => {
            if (isGrantedNow)
              {completer.complete(PermissionResponse.granted)}
            else
              {completer.complete(PermissionResponse.denied)}
          });
    }, onCancel: (_) {
      Navigator.pop(scaffoldContext);
      completer.complete(PermissionResponse.canceled);
    });

    return completer.future;
  }

  static Future<bool> requestNotificationPermissions(context) async {
    PermissionStatus notificationPermission;

    notificationPermission = await Permission.notification.status;
    if (notificationPermission.isDenied) {
      notificationPermission = await Permission.notification.request();
      if (notificationPermission.isDenied) {
        return false;
      }
    }

    // if (notificationPermission.isPermanentlyDenied) {
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) => const PermissionDeniedDialog(),
    //   );
    //   return false;
    // }
    return notificationPermission.isGranted;
  }

  static Future<void> checkAndShowNotificationPermission({
    required BuildContext scaffoldContext,
    required Function onNotificationGranted,
    required Function onNotificationDenied,
  }) async {
    if (isAndroid) {
      final sdkInt = await DeviceInformation.apiLevel;
      if (sdkInt >= 31) {
        notificationStatus().then((isNotificationGranted) async {
          if (!isNotificationGranted) {
            PermissionResponse permissionResponse =
                await showCustomNotificationPermissionDialog(
              scaffoldContext: scaffoldContext,
              title: TempLanguage().lblYourConsent,
              message: TempLanguage().lblNotificationPermissionRequired,
            );

            switch (permissionResponse) {
              case PermissionResponse.granted:
                onNotificationGranted();
                break;
              case PermissionResponse.denied:
                onNotificationDenied();
                break;
              case PermissionResponse.canceled:
                break;
            }
          }
        });
      }
    }
  }

  // static Future<void> requestNotificationPermissionWithConsentDialog({BuildContext? scaffoldContext, required Function onGranted, required Function onDenied}) async {
  //   if (isDisplayed) {
  //     return;
  //   }
  //   isDisplayed = true;
  //   bool isGranted = await Permission.location.isGranted;
  //   if (!isGranted) {
  //     await showConfirmDialogCustom(
  //         scaffoldContext!,
  //         title: 'Your consent is required',
  //         subTitle: 'Location permission is required to run the app smoothly and work properly.',
  //         positiveText: 'OK',
  //         cancelable: false,
  //         barrierDismissible: false,
  //         onAccept: (_) async {
  //           requestLocationPermissions(scaffoldContext).then((isGrantedNow) => {
  //             isDisplayed = false,
  //             //logger.d("Loading dialog dismissed."),
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
  //         onCancel: (_) {
  //           Navigator.pop(scaffoldContext);
  //         }
  //     );
  //   }
  // }

  /// Navigate to Permission Screen
  // static Future<bool> checkLocationPermissionNavigateToScreen(BuildContext context) async {
  //   bool isLocationGranted = await Permission.location.isGranted;
  //   if(!isLocationGranted) {
  //     final returnedResult = await Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (context) => const LocationPermissionScreen(),
  //       ),
  //     );
  //
  //     if (returnedResult != null) {
  //       return returnedResult;
  //     }
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  static Future<bool> checkPermissionsAndNavigateToScreen(
      BuildContext context) async {
    bool isLocationGranted = await locationStatus();
    bool isNotificationGranted = await notificationStatus();
    bool isVersion12 = await checkAndroidSDK();

    if (Platform.isIOS && !isLocationGranted) {
      String title = isLocationGranted
          ? (isVersion12
          ? TempLanguage().lblNotificationPermission
          : TempLanguage().lblLocationPermission)
          : TempLanguage().lblLocationAndNotificationPermission;

      final returnedResult = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PermissionScreen(title: title),
        ),
      );

      if (returnedResult != null) {
        return returnedResult;
      }
    } else if (!(isLocationGranted &&
        ((isVersion12 ? isNotificationGranted : true)))) {
      String title = isLocationGranted
          ? (isVersion12
              ? TempLanguage().lblNotificationPermission
              : TempLanguage().lblLocationPermission)
          : TempLanguage().lblLocationAndNotificationPermission;

      final returnedResult = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PermissionScreen(title: title),
        ),
      );

      if (returnedResult != null) {
        return returnedResult;
      }
    }

    return false;
  }

  static Future<bool> checkAndroidSDK() async {
    return isAndroid && (await DeviceInformation.apiLevel >= 31);
  }

  static Future<bool> checkLocationPermissionsAndNavigateToScreen(
      BuildContext context) async {
    bool isLocationGranted = await locationStatus();

    if (!isLocationGranted) {
      String title = TempLanguage().lblLocationPermission;

      final returnedResult = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PermissionScreen(title: title),
        ),
      );

      if (returnedResult != null) {
        return returnedResult;
      }
    }

    return false;
  }
}
