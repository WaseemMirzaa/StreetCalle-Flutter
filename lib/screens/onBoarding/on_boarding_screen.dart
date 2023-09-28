import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'dart:developer' as log;

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  var _currentIndex = 0;
  final _list = [
    Image.asset(AppAssets.onBoardingImage1, width: 300, height: 300,),
    Image.asset(AppAssets.onBoardingImage2, width: 300, height: 300,),
    Image.asset(AppAssets.onBoardingImage3, width: 300, height: 300,),
    Image.asset(AppAssets.onBoardingImage4, width: 300, height: 300,),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Column(
          children: [
            const Spacer(),
            Expanded(
              child: SvgPicture.asset(AppAssets.logo, width: 180, height: 180,),
            ),
            Expanded(
              flex: 2,
              child: _list[_currentIndex],
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
                        setState(() {
                          if (_currentIndex < _list.length - 1) {
                            _currentIndex ++;
                          } else {
                            log.log('iii go to next screen');
                            context.goNamed(AppRoutingName.selectUserScreen);
                          }
                        });
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
      ),
    );
  }
}
