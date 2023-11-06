import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';

void showToast(BuildContext context, String title) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(title),
      action: SnackBarAction(
          label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

/// has match return bool for pattern matching
bool hasMatch(String? s, String p) {
  return (s == null) ? false : RegExp(p).hasMatch(s);
}

void showLoadingDialog(BuildContext context, GlobalKey<State>? dialogKey) {
  showAdaptiveDialog(
    context: context,
    barrierDismissible: false, // Prevent user from dismissing the dialog
    builder: (BuildContext context) {
      return AlertDialog(
        key: dialogKey,
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const CircularProgressIndicator(
                color: Colors.black,
              ),
              const SizedBox(width: 16),
              Text(TempLanguage().lblPleaseWait),
            ],
          ),
        ),
      );
    },
  );
}

DialogRoute showProgressDialog(BuildContext context) {
  return DialogRoute(
      context: context,
      builder: (_)=> AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.blackColor,),
            const SizedBox(height: 16.0),
            Text(TempLanguage().lblPleaseWait),
          ],
        ),
      ),
      barrierDismissible: false
  );
}

num calculateDiscountAmount(num? actualPrice, num? disCountedPrice) {
  if (actualPrice == null || disCountedPrice == null) {
    return defaultPrice;
  }
  num price = (actualPrice > disCountedPrice)
      ? actualPrice - disCountedPrice
      : actualPrice;
  return price.abs();
}

OutlineInputBorder searchBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(40.0),
  borderSide: const BorderSide(color: AppColors.primaryColor),
);

OutlineInputBorder clientSearchBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(40.0),
  borderSide: BorderSide.none,
);

OutlineInputBorder titleBorder = OutlineInputBorder(
  borderSide: BorderSide.none,
  borderRadius: BorderRadius.circular(40),
);

OutlineInputBorder vendorSelectionBorder = OutlineInputBorder(
  borderSide: BorderSide.none,
  borderRadius: BorderRadius.circular(40),
);


Future<BitmapDescriptor> createCustomMarkerIconLocal(String imagePath, {int imageWidth = 100}) async {
  final Uint8List? markerIcon = await getBytesFromAsset(imagePath, imageWidth);
  return BitmapDescriptor.fromBytes(markerIcon!);
}

Future<Uint8List?> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
      ?.buffer
      .asUint8List();
}