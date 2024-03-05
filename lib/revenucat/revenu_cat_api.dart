import 'dart:io';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenuCatAPI{

  static Future<void> initPlatformState() async {

    late PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration('goog_eVoBcGsxTiwQWdNPCVpHeXsLCkz');
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration('appl_jnwNgRrmTqnyuKGsjHolmxtcYPl');
    }
    await Purchases.configure(configuration);
  }

  static Future<Offerings?> fetchAvailableProducts() async {
    try {
      var offerings = await Purchases.getOfferings();
      return offerings;

      // Process offerings here
    } catch (e) {
       print('Error fetching offerings: $e');
      // Handle the error, check logs, and refer to documentation
    }
    return null;

  }

  static Future<void> purchasePackage(Package package, String entitleIdentifier) async {
    try {
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);

      var isPro = customerInfo.entitlements.all[entitleIdentifier]?.isActive ?? false;
      if (isPro) {
        // Unlock that great "pro" content
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        //showError(e);
      }
    }
  }

  static Future<void> checkSubscriptionStatus(String entitleIdentifier) async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      if (customerInfo.entitlements.all[entitleIdentifier]?.isActive ?? false) {
        // Grant user "pro" access
      }
    } on PlatformException catch (e) {
      // Error fetching purchaser info
    }
  }

  static Future<void> restorePurchase() async {
    try {
      CustomerInfo restoredInfo = await Purchases.restorePurchases();
      // ... check restored customerInfo to see if entitlement is now active
    } on PlatformException catch (e) {
      // Error restoring purchases
    }
  }

}