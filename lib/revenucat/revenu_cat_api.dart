// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:street_calle/revenucat/revenuecar_constants.dart';
//
// class RevenuCatAPI{
//
//   static Future<void> initPlatformState() async {
//
//     late PurchasesConfiguration configuration;
//     if (Platform.isAndroid) {
//       configuration = PurchasesConfiguration(googleApiKey);
//     } else if (Platform.isIOS) {
//       configuration = PurchasesConfiguration(appleApiKey);
//     }
//     await Purchases.configure(configuration);
//   }
//
//   static Future<Offerings?> fetchAvailableProducts() async {
//     try {
//       var offerings = await Purchases.getOfferings();
//       return offerings;
//
//       // Process offerings here
//     } catch (e) {
//        print('Error fetching offerings: $e');
//       // Handle the error, check logs, and refer to documentation
//     }
//     return null;
//
//   }
//
//   static Future<void> purchasePackage(Package package, String entitleIdentifier) async {
//     try {
//       CustomerInfo customerInfo = await Purchases.purchasePackage(package);
//
//       var isPro = customerInfo.entitlements.all[entitleIdentifier]?.isActive ?? false;
//       if (isPro) {
//         // Unlock that great "pro" content
//       }
//     } on PlatformException catch (e) {
//       var errorCode = PurchasesErrorHelper.getErrorCode(e);
//       if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
//         //showError(e);
//       }
//     }
//   }
//
//   static Future<void> checkSubscriptionStatus(String entitleIdentifier) async {
//     try {
//       CustomerInfo customerInfo = await Purchases.getCustomerInfo();
//       if (customerInfo.entitlements.all[entitleIdentifier]?.isActive ?? false) {
//         // Grant user "pro" access
//       }
//     } on PlatformException catch (e) {
//       // Error fetching purchaser info
//     }
//   }
//
//   static Future<void> restorePurchase() async {
//     try {
//       CustomerInfo restoredInfo = await Purchases.restorePurchases();
//       // ... check restored customerInfo to see if entitlement is now active
//     } on PlatformException catch (e) {
//       // Error restoring purchases
//     }
//   }
//
// }



// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:street_calle/revenucat/revenuecar_constants.dart';
import 'package:street_calle/revenucat/singleton_data.dart';
import 'package:url_launcher/url_launcher.dart';



class RevenuCatAPI {

  Future<void> ConfigureSDK() async {
    await Purchases.setLogLevel(LogLevel.debug);

    late PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(googleApiKey);
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(appleApiKey);
    }
    await Purchases.configure(configuration);

    // if (FirebaseAuth.instance.currentUser != null) {
    //   initPlatformState(FirebaseAuth.instance.currentUser!.uid, 'N');
    // }
  }

  Future<void> initPlatformState(String uid, String vendorType) async {
    await Purchases.logIn(uid).then((value) {
      appData.appUserID = value.customerInfo.originalAppUserId;
    });
    await Purchases.syncPurchases();
    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      checkAllSubscriptions(vendorType);
    });
  }

  static Future<void> checkAllSubscriptions(String vendorType) async {
    final customerInfo = await Purchases.getCustomerInfo();
    if (customerInfo.entitlements.active.isEmpty) {
      appData.entitlementIsActive =   false;
      appData.entitlement = '';
    } else {
      if(vendorType == 'agency'){
        if((customerInfo.entitlements.active.values.first.productIdentifier == 'ind_growth_v2'
            || customerInfo.entitlements.active.values.first.productIdentifier == 'ind_starter_v2'
            || customerInfo.entitlements.active.values.first.productIdentifier == 'ind_growth_v1'
            || customerInfo.entitlements.active.values.first.productIdentifier == 'ind_starter_v1')
                && customerInfo.entitlements.active.length == 2){
          for (final entitlement in customerInfo.entitlements.active.values) {
            if (entitlement.isActive) {
              appData.entitlementIsActive = true;
              appData.entitlement = customerInfo.entitlements.active.values.last.productIdentifier ?? '';
              return;
            }else{
             appData.entitlementIsActive =   false;
              appData.entitlement = '';
            }
          }
        }else if((customerInfo.entitlements.active.values.last.productIdentifier == 'ind_growth_v2'
              || customerInfo.entitlements.active.values.last.productIdentifier == 'ind_starter_v2'
              || customerInfo.entitlements.active.values.last.productIdentifier == 'ind_growth_v1'
              || customerInfo.entitlements.active.values.last.productIdentifier == 'ind_starter_v1')
              && customerInfo.entitlements.active.values.length ==2){
          for (final entitlement in customerInfo.entitlements.active.values) {
              print(customerInfo.entitlements.active.values.last.productIdentifier);
              if (entitlement.isActive) {
                appData.entitlementIsActive = true;
                appData.entitlement = customerInfo.entitlements.active.values.first.productIdentifier ?? '';
                return;
              }else{
               appData.entitlementIsActive =   false;
                appData.entitlement = '';
              }
            }
        }
        else if(!(customerInfo.entitlements.active.values.first.productIdentifier == 'ind_growth_v2'
            || customerInfo.entitlements.active.values.first.productIdentifier == 'ind_starter_v2'
            || customerInfo.entitlements.active.values.first.productIdentifier == 'ind_growth_v1'
            || customerInfo.entitlements.active.values.first.productIdentifier == 'ind_starter_v1')
            && customerInfo.entitlements.active.values.length ==1){
          for (final entitlement in customerInfo.entitlements.active.values) {
            print(customerInfo.entitlements.active.values.last.productIdentifier);
            if (entitlement.isActive) {
              appData.entitlementIsActive = true;
              appData.entitlement = customerInfo.entitlements.active.values.first.productIdentifier ?? '';
              return;
            }else{
             appData.entitlementIsActive =   false;
              appData.entitlement = '';
            }
          }
        }
        else{
          appData.entitlementIsActive = false;
          AppData().entitlementIsActive = false;
          appData.entitlement = '';
        }
      }else if(vendorType == 'individual'){
        if((customerInfo.entitlements.active.values.first.productIdentifier == 'ind_growth_v2'
            || customerInfo.entitlements.active.values.first.productIdentifier == 'ind_starter_v2'
            || customerInfo.entitlements.active.values.first.productIdentifier == 'ind_growth_v1'
            || customerInfo.entitlements.active.values.first.productIdentifier == 'ind_starter_v1')
                && customerInfo.entitlements.active.values.length ==2
        ){
          for (final entitlement in customerInfo.entitlements.active.values) {
            if (entitlement.isActive) {
              // print(entitlement.isActive);
              // print(entitlement.productIdentifier);
              appData.entitlementIsActive = true;
              appData.entitlement = customerInfo.entitlements.active.values.first.productIdentifier ?? '';
                            return;
            }
          }
        }else if((customerInfo.entitlements.active.values.last.productIdentifier == 'ind_growth_v2'
            || customerInfo.entitlements.active.values.last.productIdentifier == 'ind_starter_v2'
            || customerInfo.entitlements.active.values.last.productIdentifier == 'ind_growth_v1'
            || customerInfo.entitlements.active.values.last.productIdentifier == 'ind_starter_v1')
                && customerInfo.entitlements.active.values.length ==2){
          for (final entitlement in customerInfo.entitlements.active.values) {
            if (entitlement.isActive) {
              appData.entitlementIsActive = true;
              appData.entitlement = customerInfo.entitlements.active.values.last.productIdentifier ?? '';
              return;
            }
          }
        }
        else if(customerInfo.entitlements.active.values.first.productIdentifier == 'ind_growth_v2'
            || customerInfo.entitlements.active.values.first.productIdentifier == 'ind_starter_v2'
            || customerInfo.entitlements.active.values.first.productIdentifier == 'ind_growth_v1'
            || customerInfo.entitlements.active.values.first.productIdentifier == 'ind_starter_v1'
                && customerInfo.entitlements.active.values.length ==1){
          for (final entitlement in customerInfo.entitlements.active.values) {
            if (entitlement.isActive) {
              print('individual 0000000000  else if 3');
              appData.entitlementIsActive = true;
              appData.entitlement = customerInfo.entitlements.active.values.first.productIdentifier ?? '';
              return;
            }
          }
        }  else{
          print('ind 0000000000 elsee');
          appData.entitlementIsActive = false;
          AppData().entitlementIsActive = false;
          appData.entitlement = '';
        }
      }else{
        print(vendorType);
        print(' in last else 000000000');
        appData.entitlementIsActive = false;
        appData.entitlement = '';
      }
    }
  }

  static Future<Offerings> fetchAvailableProducts() async {
    return await Purchases.getOfferings();
  }

  static Future<void> purchasePackage(
      Package package, String entitleIdentifier, BuildContext context) async {
    try {
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);

      EntitlementInfo? entitlement = customerInfo.entitlements.all[entitleIdentifier];

      appData.entitlementIsActive = entitlement?.isActive ?? false;
      appData.entitlement = entitlement?.productIdentifier ?? '';
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> updatePackage(
      Package package, String entitleIdentifier, BuildContext context) async {
    try {
      CustomerInfo customerInfo = await Purchases.purchasePackage(package,
          googleProductChangeInfo: GoogleProductChangeInfo(appData.entitlement,
              prorationMode: GoogleProrationMode.immediateWithTimeProration));

      EntitlementInfo? entitlement =
          customerInfo.entitlements.all[entitleIdentifier];

      appData.entitlementIsActive = entitlement?.isActive ?? false;
      appData.entitlement = entitlement?.productIdentifier ?? '';
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<String?> checkSubscriptionStatuses() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();

      for (final entitlement in customerInfo.entitlements.active.values) {

        if (entitlement.isActive) {
         return entitlement.productIdentifier.toString();
        } else {
          return entitlement.identifier.toString();
        }
      }
      return '';
    } on PlatformException {
      log('Error fetching subscription information');
    }
  }


  static Future<bool> checkSubscriptionStatus() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      for (final entitlement in customerInfo.entitlements.active.values) {
        if (entitlement.isActive) {
          return true;
        }
      }
      return false;
    } on PlatformException {
      log('Error fetching subscription information');
      return false;
    }
  }

   static Future<void> restorePurchase( BuildContext context, String vendorType) async {

    try {

      CustomerInfo restoredInfo = await Purchases.restorePurchases();
      // print(restoredInfo.entitlements.active[entitlementID]?.productIdentifier);
    if(restoredInfo.entitlements.active.isNotEmpty){
      if(restoredInfo.entitlements.active.values.first.productIdentifier != null){
        if(restoredInfo.entitlements.active.values.first.productIdentifier.isNotEmpty){
          print(restoredInfo.entitlements.active.length);
          print(restoredInfo.entitlements.active);


          if(vendorType == 'agency'){
            if (['ind_starter_v1', 'ind_starter_v2', 'ind_growth_v2', 'ind_growth__v1']
                .contains(restoredInfo.entitlements.active.values.first.productIdentifier)
                && restoredInfo.entitlements.active.length == 2) {
              print('Subscription Restored  iiiiiiiiiiii1');
              Navigator.pop(context);
              toast('Subscription Restored');
            }else if(['ind_starter_v1', 'ind_starter_v2', 'ind_growth_v2', 'ind_growth__v1']
                .contains(restoredInfo.entitlements.active.values.first.productIdentifier)
                && restoredInfo.entitlements.active.length == 1){
              toast('No Subscriptions');
              print('No Subscription   iiiiiiiiiiii2');

              Navigator.pop(context);
            }else if(['ind_starter_v1', 'ind_starter_v2', 'ind_growth_v2', 'ind_growth__v1']
                .contains(restoredInfo.entitlements.active.values.last.productIdentifier)
                && restoredInfo.entitlements.active.length == 2){
              toast('Subscription Restored');
              print('Subscription Restored   iiiiiiiiiiii25');

              Navigator.pop(context);
            }else if(!['ind_starter_v1', 'ind_starter_v2', 'ind_growth_v2', 'ind_growth__v1']
                .contains(restoredInfo.entitlements.active.values.first.productIdentifier)
                && restoredInfo.entitlements.active.length == 1){
              toast('Subscription Restored');
              print('Subscription Restored  iiiiiiiiiiii3');

              Navigator.pop(context);
            }
          }else if (vendorType == 'individual'){
            if (['ind_starter_v1', 'ind_starter_v2', 'ind_growth_v2', 'ind_growth__v1']
                .contains(restoredInfo.entitlements.active.values.first.productIdentifier)
                && restoredInfo.entitlements.active.length == 1) {
              Navigator.pop(context);
              toast('Subscription Restored');
            }else if(['ind_starter_v1', 'ind_starter_v2', 'ind_growth_v2', 'ind_growth__v1']
                .contains(restoredInfo.entitlements.active.values.last.productIdentifier)
                && restoredInfo.entitlements.active.length == 2){
              toast('Subscription Restored');
              Navigator.pop(context);
            }else if(['ind_starter_v1', 'ind_starter_v2', 'ind_growth_v2', 'ind_growth__v1']
                .contains(restoredInfo.entitlements.active.values.first.productIdentifier)
                && restoredInfo.entitlements.active.length == 2){
              toast('Subscription Restored');
              Navigator.pop(context);
            }else if(!['ind_starter_v1', 'ind_starter_v2', 'ind_growth_v2', 'ind_growth__v1']
                .contains(restoredInfo.entitlements.active.values.first.productIdentifier)
                && restoredInfo.entitlements.active.length == 1){
              toast('No Subscriptions');
              Navigator.pop(context);
            }
          }else{
            toast('No Subscriptions');
            Navigator.pop(context);

            // Helpers.showSnackBar(context: context, title: "No Subscriptions");
            // lp.startLoading(false);
            print('No Subscriptions');


          }
        }  else{
          toast('No Subscriptions');
          Navigator.pop(context);

          print('No Subscriptions');

          // Helpers.showSnackBar(context: context, title: "No Subscriptions");
          // lp.startLoading(false);

        }
      }
      else{
        toast('No Subscriptions');
        Navigator.pop(context);

        print('No Subscriptions');


      }
    }else{
      toast('No Subscriptions');
      Navigator.pop(context);

      print('No Subscriptions');



    }

      // ... check restored customerInfo to see if entitlement is now active
    } on PlatformException {
      // lp.startLoading(false);

      // Error restoring purchases
    }
  }


  static Future<void> cancelSubscription() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();

      // Grant user "pro" access
      final Uri url = Uri.parse(customerInfo.managementURL!);

      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    } on PlatformException {
      // Error fetching purchaser info
    }
  }
}
