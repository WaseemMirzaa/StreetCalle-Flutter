import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/screens/home/settings/widgets/individual_plans.dart';
import 'package:street_calle/screens/home/settings/widgets/agency_plans.dart';
import 'package:street_calle/revenucat/revenu_cat_api.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/revenucat/singleton_data.dart';
import 'package:street_calle/generated/locale_keys.g.dart';

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
    super.initState();
    initOfferings();
  }

  initOfferings()async{
     Offerings offerings = await RevenuCatAPI.fetchAvailableProducts();
      if(offerings.current != null){
        setState(() {
          offer = offerings.current;
          offers = offerings.all;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    final userService = sl.get<UserService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          //TempLanguage().lblSubscriptionPlans,
          LocaleKeys.subscriptionPlans.tr(),
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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text(
                //TempLanguage().lblChooseAPlane,
                LocaleKeys.chooseAPlane.tr(),
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
                          Flexible(
                            child: Text(
                              LocaleKeys.enjoyFreeDays.tr(),//TempLanguage().lblAddUnlimitedMenuItems,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(AppAssets.checkMarkIcon, width: 15, height: 15,),
                          const SizedBox(width: 16,),
                          Flexible(
                            child: Text(
                              LocaleKeys.afterTrialPeriod.tr(),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(AppAssets.checkMarkIcon, width: 15, height: 15,),
                          const SizedBox(width: 16,),
                          Flexible(
                            child: Text(
                              LocaleKeys.cancelAnyTime.tr(),
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
                          const SizedBox(width: 16,),
                          Flexible(
                            child: Text(
                              //TempLanguage().lblAddUnlimitedMenuItems,
                              LocaleKeys.addUnlimitedMenuItems.tr(),
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
                              //TempLanguage().lblMakeYourTruckVisible,
                              LocaleKeys.makeYourTruckVisible.tr(),
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
              ElevatedButton(
                onPressed: (){
                  showCircularProgressDialog(context);
                  RevenuCatAPI.restorePurchase(context, userCubit.state.vendorType).then((value) {
                    if(['ind_starter_v1', 'ind_starter_v2', 'ind_growth_v2', 'ind_growth__v1']
                        .contains(AppData().entitlement)){
                      syncUserSubscriptionStatus(userService, userCubit,AppData().entitlementIsActive, SubscriptionType.individual.name,AppData().entitlement);
                    }else{
                      syncUserSubscriptionStatus(userService, userCubit,AppData().entitlementIsActive, SubscriptionType.agency.name,AppData().entitlement);

                    }
                    Navigator.pop(context);
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor:  AppColors.primaryColor
                ),
                child: Text(LocaleKeys.restoreSubscription.tr(), style: const TextStyle(color: AppColors.whiteColor, fontSize: 14),),
              ),


              const SizedBox(height: 18,),
            ],
          ),
        ),
      ),
    );
  }
   Future<void> syncUserSubscriptionStatus(
       UserService userService,
       UserCubit userCubit,
       bool isSubscribed,
       String subscriptionType,
       String planLookUpKey
       ) async {

     final result = await userService.updateUserSubscription(
         isSubscribed, subscriptionType, userCubit.state.userId, planLookUpKey);
     if (result) {
       userCubit.setIsSubscribed(isSubscribed);
       userCubit.setSubscriptionType(subscriptionType);
       userCubit.setPlanLookUpKey(planLookUpKey);
     }
     if (!isSubscribed) {
       await userService.updateUserStripeDetails(
           '', '', '', userCubit.state.userId);
       userCubit.setSubscriptionId('');
       userCubit.setStripeId('');
       userCubit.setSessionId('');
     }
   }

   void showCircularProgressDialog(BuildContext context) {
     showDialog(
       context: context,
       barrierDismissible: false,
       builder: (BuildContext context) {
         return Dialog(
           backgroundColor: Colors.transparent,
           child: Container(
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(10.0),
             ),
             padding: const EdgeInsets.all(20.0),
             child: const Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 CircularProgressIndicator(),
                 SizedBox(height: 20.0),
                 Text(
                   'Loading...',
                   style: TextStyle(
                     fontSize: 16.0,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
               ],
             ),
           ),
         );
       },
     );
   }

}
