import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/models/user.dart';

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


Future<BitmapDescriptor> createCustomMarkerIconNetwork(String imagePath, {bool shouldAddRedCircle = false}) async {

  final Uint8List? markerIcon = await getBytesFromNetworkImage(imagePath, 100);

  final ui.Codec codec = await ui.instantiateImageCodec(markerIcon ?? Uint8List(0));
  final ui.Image image = (await codec.getNextFrame()).image;
  const int size = 120; // Assuming square dimensions
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

// Calculate the center of the circular area
  const centerX = size / 2;
  const centerY = size / 2;

// Calculate the radius of the circular area
  const radius = size / 3;

// Draw a circular border
  final paintBorder = Paint()
    ..color = AppColors.primaryLightColor // Set the border color
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10.0; // Set the border width

  canvas.drawCircle(
    const Offset(centerX, centerY),
    radius,
    paintBorder,
  );

  // Set your condition here

  if (shouldAddRedCircle) {
    // Calculate the position for the red circle in the top-right corner
    const redCircleRadius = 20.0;
    const redCircleX = size - redCircleRadius;
    const redCircleY = redCircleRadius;

    // Draw a red circle in the top-right corner
    final paintRedCircle = Paint()
      ..color = Colors.red // Set the red color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      const Offset(redCircleX, redCircleY),
      redCircleRadius,
      paintRedCircle,
    );
  }

  final matrix = Matrix4.identity();

// Calculate the scale factors to fit the image into the box
  double scaleX = 100 / image.width;
  double scaleY = 100 / image.height;

// Apply the scale to the matrix
  matrix.scale(scaleX, scaleY);

// Clip the image to the circular area
  final paintImage = Paint()
    ..shader = ImageShader(
      image,
      TileMode.clamp,
      TileMode.clamp,
      Float64List.fromList(matrix.storage),
    )
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

  canvas.drawCircle(
    const Offset(centerX, centerY),
    radius - 2.0, // Adjust the value to account for the border width
    paintImage,
  );

  final picture = recorder.endRecording();
  final img = await picture.toImage(size.toInt(), size.toInt());
  final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(Uint8List.view(pngBytes!.buffer));
}

Future<Uint8List?> getBytesFromNetworkImage(String imageUrl, int width) async {
  final Completer<Uint8List?> completer = Completer<Uint8List?>();
  Image.network(
    imageUrl,
    width: width.toDouble(),
  ).image.resolve(const ImageConfiguration()).addListener(
    ImageStreamListener(
          (ImageInfo info, bool synchronousCall) async {
        final ByteData? data = await info.image.toByteData(format: ui.ImageByteFormat.png);
        completer.complete(data?.buffer.asUint8List());
      },
      onError: (dynamic exception, StackTrace? stackTrace) {
        completer.completeError(exception);
      },
    ),
  );

  return completer.future;
}

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


Future<User?> findNearestUser(List<User> users, Position currentLocation) {
  double shortestDistance = double.infinity;
  User? nearestUser;

  for (User user in users) {
    if (user.latitude != null && user.longitude != null) {
      double distance = Geolocator.distanceBetween(
        currentLocation.latitude,
        currentLocation.longitude,
        user.latitude!,
        user.longitude!,
      );
      if (distance < shortestDistance) {
        shortestDistance = distance;
        nearestUser = user;
      }
    }
  }
  return Future.value(nearestUser);
}