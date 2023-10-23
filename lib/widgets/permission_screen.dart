import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/location_utils.dart';
import 'package:street_calle/utils/permission_utils.dart';
import 'package:street_calle/utils/constant/app_colors.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key, required this.title});
  final String title;

  @override
  PermissionScreenState createState() => PermissionScreenState();
}

class PermissionScreenState extends State<PermissionScreen> with WidgetsBindingObserver {
  bool isGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {

      bool isLocationGranted = await PermissionUtils.locationStatus();
      bool isNotificationGranted = await PermissionUtils.notificationStatus();
      bool isVersion12 = await PermissionUtils.checkAndroidSDK();

      if (isVersion12 ? (isLocationGranted && isNotificationGranted) : isLocationGranted) {
        Navigator.pop(context, true);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Perform any actions you want when the screen is closing
        if (isGranted) {
          Navigator.pop(context, isGranted); // Return result before closing
          return true; // Allow screen to close
        } else {
          return false; // Dont allow to close
        }
      },
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  AppAssets.logo,
                  // scale: 4,
                  height: 300,
                  fit: BoxFit.fitHeight,
                ),
                Text(widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.primaryFontColor),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  height: defaultButtonSize,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: AppButton(
                    text: TempLanguage().lblOpenSettings,
                    elevation: 0.0,
                    onTap: () async {
                      // await PermissionUtils.requestLocationPermissions(context).then((isPermissionGranted) {
                      //    isGranted = isPermissionGranted;
                      //    Navigator.pop(context, isGranted);
                      // });
                      openAppSettings();
                    },
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    ),
                    textStyle: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                    color: AppColors.primaryColor,
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
