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

import 'dart:developer';
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
      initPlatformState(FirebaseAuth.instance.currentUser!.uid);
    }
  }

  Future<void> initPlatformState(String uid) async {
    await Purchases.logIn(uid).then((value) {
      appData.appUserID = value.customerInfo.originalAppUserId;
    });

    await Purchases.syncPurchases();

    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      checkAllSubscriptions();
    });
  }

  static Future<void> checkAllSubscriptions() async {
    final customerInfo = await Purchases.getCustomerInfo();

    if (customerInfo.entitlements.active.isEmpty) {
      appData.entitlementIsActive =   false;
      appData.entitlement = '';
    } else {
      for (final entitlement in customerInfo.entitlements.active.values) {
        if (entitlement.isActive) {
          appData.entitlementIsActive = true;
          appData.entitlement = entitlement.productIdentifier ?? '';
          return;
        }
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
