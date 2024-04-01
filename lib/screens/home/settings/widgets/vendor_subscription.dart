import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/screens/home/settings/widgets/individual_plans.dart';
import 'package:street_calle/screens/home/settings/widgets/agency_plans.dart';

import 'package:street_calle/revenucat/revenu_cat_api.dart';

class VendorSubscription extends StatefulWidget {
  const VendorSubscription({Key? key}) : super(key: key);

  @override
  State<VendorSubscription> createState() => _VendorSubscriptionState();
}

class _VendorSubscriptionState extends State<VendorSubscription> {
   Offering? offer;
   Map<String,Offering>? offers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RevenuCatAPI().initPlatformState(FirebaseAuth.instance.currentUser!.uid);
    if(Platform.isIOS){
      print('%%%%%%%%%%%%%%%%%%${Platform.isIOS}');
      initOfferings();
    }
    else{
      initOfferings();

    }
  }

  initOfferings()async{
    Offerings? offerings;

      offerings = await RevenuCatAPI.fetchAvailableProducts();
      if(offerings == null ||  offerings.current == null){
        print('offers null');
      }
      else{
        offer = offerings.current;
        print(offer?.availablePackages);
        offers = offerings.all;
        print('offers.all =======>');

        print(offerings.all['Established Agency']);
        setState(() {

        });
      }

  }
  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          TempLanguage().lblSubscriptionPlans,
          style: context.currentTextTheme.titleMedium?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () => ContextExtensions(context).pop(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(AppAssets.backIcon, width: 20, height: 20,)
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text(
                TempLanguage().lblChooseAPlane,
                style: context.currentTextTheme.titleMedium?.copyWith(fontSize: 18, color: AppColors.primaryFontColor),
              ),
              const SizedBox(height: 18,),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding:  const EdgeInsets.symmetric(horizontal: 14),
                // height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Image.asset(AppAssets.checkMarkIcon, width: 15, height: 15,),
                          const SizedBox(width: 16,),
                          const Flexible(
                            child: Text(
                              'Enjoy a free 60-day trial on all plans with full access to all features of subscribed plan.',//TempLanguage().lblAddUnlimitedMenuItems,
                              style: TextStyle(
                                  fontFamily: METROPOLIS_BOLD,
                                  fontSize: 12,
                                  color: AppColors.whiteColor
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(AppAssets.checkMarkIcon, width: 15, height: 15,),
                          const SizedBox(width: 16,),
                          const Flexible(
                            child: Text(
                              'After the trial period, you will be automatically enrolled in a paid subscription.',                            style: TextStyle(
                                fontFamily: METROPOLIS_BOLD,
                                fontSize: 12,
                                color: AppColors.whiteColor
                            ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(AppAssets.checkMarkIcon, width: 15, height: 15,),
                          const SizedBox(width: 16,),
                          const Flexible(
                            child: Text(
                              'You can cancel anytime during the trial period at no charge.',
                              style: TextStyle(
                                  fontFamily: METROPOLIS_BOLD,
                                  fontSize: 12,
                                  color: AppColors.whiteColor
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12,),
                      Row(
                        children: [
                          Image.asset(AppAssets.checkMarkIcon, width: 15, height: 15,),
                          const SizedBox(width: 16,),
                          Flexible(
                            child: Text(
                              TempLanguage().lblAddUnlimitedMenuItems,
                              style: const TextStyle(
                                  fontFamily: METROPOLIS_BOLD,
                                  fontSize: 12,
                                  color: AppColors.whiteColor
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12,),
                      Row(
                        children: [
                          Image.asset(AppAssets.checkMarkIcon, width: 15, height: 15,),
                          const SizedBox(width: 12,),
                          Flexible(
                            child: Text(
                              TempLanguage().lblMakeYourTruckVisible,
                              style: const TextStyle(
                                  fontFamily: METROPOLIS_BOLD,
                                  fontSize: 12,
                                  color: AppColors.whiteColor
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12,),

              userCubit.state.vendorType == VendorType.individual.name
                  ?  IndividualPlans(
                // offering: offer,
                offers: offers?['Individual'],)
                  :  AgencyPlans(
                newAgencyOffers: offers?['New Agency'],
                intermediateAgencyOffers: offers?['Intermediate Agency'],
                establishedAgencyOffers: offers?['Established Agency'],

              ),

              const SizedBox(height: 18,),
            ],
          ),
        ),
      ),
    );
  }
}
