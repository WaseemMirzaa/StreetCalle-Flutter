import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/screens/selectUser/widgets/build_selected_image.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/cubit/user_state.dart';

class SelectUserScreen extends StatefulWidget {
  const SelectUserScreen({Key? key}) : super(key: key);

  @override
  State<SelectUserScreen> createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  UserType _user = UserType.client;

  @override
  Widget build(BuildContext context) {
    //TODO: User can select these options one time only
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 70,
          ),
          Expanded(
            child: SvgPicture.asset(AppAssets.logo, width: 230, height: 230,),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BuildSelectableImage(
                    assetPath : AppAssets.clientIcon,
                    isSelected : _user == UserType.client,
                    title: TempLanguage().lblClient,
                    onTap: () {
                      context.read<UserCubit>().setIsVendor(false);
                      setState(() {
                        _user = UserType.client;
                      });
                    },
                  ),
                  BuildSelectableImage(
                   assetPath : AppAssets.vendorIcon,
                   isSelected :  _user == UserType.vendor,
                    title: TempLanguage().lblVendor,
                   onTap: () {
                     context.read<UserCubit>().setIsVendor(true);
                      setState(() {
                        _user = UserType.vendor;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 54.0),
                child: SizedBox(
                  width: context.width,
                  height: defaultButtonSize,
                  child: AppButton(
                    text: TempLanguage().lblNext,
                    elevation: 0.0,
                    onTap: () {
                      context.pushNamed(_user.name == UserType.client.name ? AppRoutingName.clientMainScreen : AppRoutingName.mainScreen, pathParameters: {USER: _user.name});
                    },
                    shapeBorder: RoundedRectangleBorder(
                        side: const BorderSide(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    textStyle: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                    color: AppColors.primaryColor,
                  ),
                  // child: ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: AppColors.primaryColor,
                  //   ),
                  //   onPressed: (){
                  //     context.pushNamed(_user.name == UserType.client.name ? AppRoutingName.clientMainScreen : AppRoutingName.mainScreen, pathParameters: {USER: _user.name});
                  //   },
                  //   child: Text(
                  //     TempLanguage().lblNext,
                  //     style: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                  //   ),
                  // ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


