import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/selectUser/widgets/build_selected_image.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';

class SelectUserScreen extends StatefulWidget {
  const SelectUserScreen({Key? key}) : super(key: key);

  @override
  State<SelectUserScreen> createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  UserType _user = UserType.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 120,
          ),
          Expanded(
            child: SvgPicture.asset(AppAssets.logo, width: 120, height: 120,),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                TempLanguage().lblStreet,
                style: context.currentTextTheme.titleLarge?.copyWith(color: AppColors.primaryColor),
              ),
              Text(
                TempLanguage().lblCall,
                style: context.currentTextTheme.titleLarge?.copyWith(color: AppColors.primaryFontColor),
              ),
            ],
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BuildSelectableImage(
                    assetPath : AppAssets.client,
                    isSelected : _user == UserType.client,
                    title: TempLanguage().lblClient,
                    onTap: () {
                      setState(() {
                        _user = UserType.client;
                      });
                    },
                  ),
                  BuildSelectableImage(
                   assetPath : AppAssets.vendor,
                   isSelected :  _user == UserType.vendor,
                    title: TempLanguage().lblVendor,
                   onTap: () {
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    onPressed: (){
                      context.pushNamed(AppRoutingName.mainScreen, pathParameters: {'user': _user.name});
                    },
                    child: Text(
                      TempLanguage().lblNext,
                      style: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


