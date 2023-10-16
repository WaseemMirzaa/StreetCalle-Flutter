import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/common.dart';

class ClientMenuItemDetail extends StatelessWidget {
  const ClientMenuItemDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.backgroundImage, fit: BoxFit.fill,),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 34,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: (){
                        context.pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios, color: AppColors.blackColor,),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: (){},
                        icon: Image.asset(AppAssets.filterIcon, width: 24, height: 24,),
                    ),
                    IconButton(
                        onPressed: (){},
                        icon: Image.asset(AppAssets.marker, width: 24, height: 24,),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 54.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      padding: const EdgeInsets.all(4), // Border width
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle, // Uncomment this line
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primaryColor,
                            AppColors.primaryLightColor,
                          ],
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: Image.asset(AppAssets.teaImage, fit: BoxFit.cover).image,
                      )
                    ),
                    const SizedBox(width: 12,),
                    const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tea House',
                            style: TextStyle(
                                fontSize: 24,
                                fontFamily: METROPOLIS_BOLD,
                                color: AppColors.primaryFontColor
                            ),
                          ),
                          SizedBox(height: 6,),
                          Icon(
                              Icons.favorite_border_rounded
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 44),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      TempLanguage().lblDeals,
                      style: context.currentTextTheme.labelMedium?.copyWith(fontSize: 16),
                    ),

                    Text(
                      TempLanguage().lblViewAll,
                      style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: context.width,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: AppColors.containerBackgroundColor.withOpacity(0.9), // Adjust opacity for the glass effect
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(left: 4),
                        width: 80,
                        height: 60,
                        child: CircleAvatar(
                          backgroundImage: Image.asset(AppAssets.teaImage, fit: BoxFit.contain,).image,
                        )
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blackColor.withOpacity(0.25),
                        spreadRadius: 2, // Spread radius
                        blurRadius: 15, // Blur radius
                        offset: const Offset(0, 8), // Offset in the Y direction
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (String? value) {},
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20),
                      filled: true,
                      prefixIcon: Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(AppAssets.searchIcon, color: AppColors.secondaryFontColor, width: 18, height: 18,),
                            ],
                          )
                      ),
                      hintStyle: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.placeholderColor),
                      hintText: TempLanguage().lblSearchFood,
                      fillColor: AppColors.whiteColor,
                      border: clientSearchBorder,
                      focusedBorder: clientSearchBorder,
                      disabledBorder: clientSearchBorder,
                      enabledBorder: clientSearchBorder,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 44),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      TempLanguage().lblItems,
                      style: context.currentTextTheme.labelMedium?.copyWith(fontSize: 16),
                    ),

                    Text(
                      TempLanguage().lblViewAll,
                      style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(60), bottomRight: Radius.circular(60)),
                          color: AppColors.primaryColor
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ListView.builder(
                        itemCount: 15,
                        //padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 44.0, right: 14),
                                  child: Container(
                                    height: 100,
                                    width: context.width,
                                    padding: const EdgeInsets.only(left: 44.0, right: 14),
                                    decoration:  BoxDecoration(
                                      color: AppColors.whiteColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.blackColor.withOpacity(0.25),
                                          spreadRadius: 2, // Spread radius
                                          blurRadius: 15, // Blur radius
                                          offset: const Offset(0, 8), // Offset in the Y direction
                                        ),
                                      ],
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const SizedBox(height: 4,),
                                              Text(
                                                'Tea',
                                                 style: context.currentTextTheme.labelMedium?.copyWith(color: AppColors.primaryFontColor),
                                              ),
                                              Text(
                                                'Lorem ipsum dolor sit amet, consectetur',
                                                style: context.currentTextTheme.displaySmall,
                                              ),
                                              Text(
                                                'Westren Food',
                                                style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 18.0),
                                          child: Text(
                                            '\$5',
                                            style: context.currentTextTheme.labelMedium?.copyWith(color: AppColors.primaryFontColor),
                                          ),
                                        ),
                                        const SizedBox(width: 24,),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  left: 0,
                                  child: Container(
                                    width: 80, height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      // image: DecorationImage(
                                      //   image: AssetImage(AppAssets.customTriangle)
                                      // )
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.asset(AppAssets.teaImage, width: 50, height: 50, fit: BoxFit.cover,),
                                  ),
                                ),
                                Positioned(
                                  top: 28,
                                  right: 0,
                                  child: Container(
                                    width: 40, height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.whiteColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.blackColor.withOpacity(0.25),
                                          spreadRadius: 1, // Spread radius
                                          blurRadius: 10, // Blur radius
                                          offset: const Offset(0, 0), // Offset in the Y direction
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.arrow_forward_ios, color: AppColors.primaryColor,)
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
