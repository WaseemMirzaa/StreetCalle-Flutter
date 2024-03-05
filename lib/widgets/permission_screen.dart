import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/my_sizer.dart';
import 'package:street_calle/utils/permission_utils.dart';
import 'package:street_calle/utils/constant/app_colors.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key, required this.title});

  final String title;

  @override
  PermissionScreenState createState() => PermissionScreenState();
}

class PermissionScreenState extends State<PermissionScreen>
    with WidgetsBindingObserver {
  bool isGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Schedule the execution of _showPermissionDialog after the first frame is built
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      // print(await PermissionUtils.locationStatus());
      // print(await PermissionUtils.notificationStatus());
      //
      // print('%%%%%%%%%%%%%%%%');
if(await PermissionUtils.locationStatus() == false ||
    await PermissionUtils.notificationStatus() == false){
  _showPermissionDialog();

}
    });

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final userCubit = context.read<UserCubit>();
    if (state == AppLifecycleState.resumed) {
      bool isLocationGranted = await PermissionUtils.locationStatus();
      bool isNotificationGranted = await PermissionUtils.notificationStatus();
      bool isVersion12 = await PermissionUtils.checkAndroidSDK();


      if (userCubit.state.isVendor || userCubit.state.isEmployee && !userCubit.state.isEmployeeBlocked) {
        if (isVersion12 ? (isLocationGranted && isNotificationGranted) : isLocationGranted) {
          Navigator.pop(context, true);
        }
      } else {
        if (isLocationGranted) {
          Navigator.pop(context, true);
        }
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
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: context.currentTextTheme.labelLarge,
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
                          borderRadius: BorderRadius.circular(30)),
                      textStyle: context.currentTextTheme.labelLarge
                          ?.copyWith(color: AppColors.whiteColor),
                      color: AppColors.primaryColor,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _showPermissionDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding:  EdgeInsets.symmetric(vertical: MySizer.size100),
          child:AlertDialog(
            title:  Text('Permission Required', style: context.currentTextTheme.labelMedium,),
            content:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'To provide you with the best experience, we need the following permissions:', style: context.currentTextTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Location:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  ' This app uses your device location (background and when in use) to facilitate users by showing them the current location of food trucks.', style: context.currentTextTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                Text(
                  'Your location is only accessed for the purpose of providing correct locations to users of the app and is not shared with third parties.', style: context.currentTextTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Notifications:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  ' To notify you about new food truck locations and promotions.', style: context.currentTextTheme.bodySmall,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Code to request location permission can be placed here
                },
                child: const Text('OK'),
              ),
            ],

          )
        );
      },
    );
  }}
