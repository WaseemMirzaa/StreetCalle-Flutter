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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    if (FirebaseAuth.instance.currentUser != null) {
      print(
          '####################################################################################################################################################################################################');
      initPlatformState(FirebaseAuth.instance.currentUser!.uid);
    }
  }

  Future<void> initPlatformState(String uid) async {
    print('========> syncPurchaces');

    print(uid);
    print('========> firebase app user id');
    await Purchases.logIn(uid).then((value) {
      appData.appUserID = value.customerInfo.originalAppUserId;
      print('========>  app user id while used to login');
      print(value.customerInfo.originalAppUserId);
      print('========>  app user id saved in appdata');
      print(appData.appUserID);
    });

    // appData.appUserID = result.customerInfo.originalAppUserId;
    print(appData.appUserID);
    print('========>  app user id appdata');

    await Purchases.syncPurchases();

    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      // appData.appUserID = await Purchases.appUserID;
      // print(Purchases.appUserID.toString());
      // print('========>  app user id in Purchases');
      //
      // print(appData.appUserID);
      // print('========>  app user id appdata after getting from purchases');

      // CustomerInfo customerInfo = await Purchases.getCustomerInfo();
print(customerInfo.entitlements.active.isNotEmpty);
print(customerInfo.entitlements.active);
print(customerInfo.entitlements.all);
print(customerInfo.entitlements.active.values);

      print('%%%%%%%%%%%%%%%%%% active subscription or not');

checkAllSubscriptions();

      // if(customerInfo.entitlements.active.isNotEmpty){
      //   print(customerInfo.activeSubscriptions);
      //   print('%%%%%%%%%%%%%%%%%% active subscription');
      //
      //   print('%%%%%%%%%%%%%%%%%%active subscriptions');
      //
      //   print(customerInfo.entitlements.active);
      //   // print(customerInfo.entitlements.active[entitlementID]?.isActive);
      //   print('%%%%%%%%%%%%%%%%%% active entitlement');
      //   // print(customerInfo.entitlements.active[entitlementID]?.store);
      //   print('%%%%%%%%%%%%%%%%%% active entitlement');
      //   // print(customerInfo.entitlements.active[entitlementID]?.periodType);
      //   print('%%%%%%%%%%%%%%%%%% active entitlement');
      //
      //   appData.entitlementIsActive =   true;
      //   appData.entitlement = customerInfo.activeSubscriptions.toString() ?? '';
      //   print(appData.entitlement);
      //
      //   print('${appData.entitlementIsActive}!!!!!!!!!!!!_____!!!!!!!!!!!!!!');
      //   print('%%%%%%%%%%%%%%%%%%');
      //   print(appData.appUserID);
      //   print(customerInfo.entitlements.all[entitlementIDInd]);
      // }

    });
  }

  static Future<void> checkAllSubscriptions() async {
    final customerInfo = await Purchases.getCustomerInfo();

    if (customerInfo.entitlements.active.isEmpty) {
      appData.entitlementIsActive =   false;
      appData.entitlement = '';
      print('User is not subscribed to any entitlements');
    } else {
      for (final entitlement in customerInfo.entitlements.active.values) {
        print(entitlement.isActive);
        print('User =============<><');
        print(customerInfo.entitlements.active.values);


        if (entitlement.isActive) {
          print("User is subscribed to '${entitlement.productIdentifier}'");
          appData.entitlementIsActive =   true;
          appData.entitlement = entitlement.productIdentifier ?? '';
          print(appData.entitlement);

          print('${appData.entitlementIsActive}!!!!!!!!!!!!_____!!!!!!!!!!!!!!');
          // Grant features based on entitlement ID
        }
      }
    }
  }

  static Future<Offerings> fetchAvailableProducts() async {
    return await Purchases.getOfferings();
  }

  static Future<void> purchasePackage(
      Package package, String entitleIdentifier, BuildContext context) async {
    print(package);
    print(entitleIdentifier);
    print('0000000000000000000000000000000000000000000000000000000000000000');


    try {
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);

      print(customerInfo.entitlements.all[entitleIdentifier]);
      // entitleIdentifier == 'Individual Starter Plan' ? entitlementIDInd : entitlementIDInd;
      print(customerInfo.entitlements.active[entitleIdentifier]);

      EntitlementInfo? entitlement =
      customerInfo.entitlements.all[entitleIdentifier];

      print(entitlement?.isActive);
      print('0000000000000000');
      appData.entitlementIsActive = entitlement?.isActive ?? false;
      appData.entitlement = entitlement?.productIdentifier ?? '';
      print(appData.entitlement);


      print(appData.entitlementIsActive);
    } catch (e) {

      print(e);
    }

    // Navigator.pop(context);
    // Navigator.pop(context);
  }

  static Future<String?> checkSubscriptionStatuses() async {
    print('in check subscriptin');
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();

      for (final entitlement in customerInfo.entitlements.active.values) {
        print('in check subscriptin for llop');

        if (entitlement.isActive) {
          print('${entitlement.productIdentifier} is active');
          // Grant features based on entitlement ID

         return entitlement.productIdentifier.toString();
        } else {
          print('${entitlement.identifier} is not active');
          return entitlement.identifier.toString();

        }

      }
      return '';

    } on PlatformException {
      // Handle error fetching purchaser info
      print('Error fetching subscription information');
    }
  }

  static Future<void> restorePurchase() async {
    try {
      CustomerInfo restoredInfo = await Purchases.restorePurchases();
      // ... check restored customerInfo to see if entitlement is now active
    } on PlatformException {
      // Error restoring purchases
    }
  }

  static Future<void> cancelSubscription() async {
    try {
      CustomerInfo customerInfo =
          await Purchases.getCustomerInfo();


      // Grant user "pro" access
      final Uri url =
      Uri.parse(customerInfo.managementURL!);

      if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
    }
    } on PlatformException {
    // Error fetching purchaser info
    }
  }
}
