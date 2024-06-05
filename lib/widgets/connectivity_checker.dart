import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/generated/locale_keys.g.dart';

class ConnectivityChecker extends StatefulWidget {
  const ConnectivityChecker({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<ConnectivityChecker> createState() => _ConnectivityCheckerState();
}

class _ConnectivityCheckerState extends State<ConnectivityChecker> {

  // final NetworkHelper _connectivity = NetworkHelper.instance;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _connectivity.initialise();
  // }
  //
  // @override
  // void dispose() {
  //   _connectivity.disposeStream();
  //   super.dispose();
  // }

  late Stream<bool> mergedStream;
  final StreamController<bool> mergedStreamController = StreamController<bool>.broadcast();

  @override
  void initState() {
    super.initState();

    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.none) {
        mergedStreamController.sink.add(false);
      } else {
        mergedStreamController.sink.add(true);
      }
    });

    InternetConnection().onStatusChange.listen((locationStatus) {
      if(!mergedStreamController.isClosed) {
        mergedStreamController.sink.add(locationStatus == InternetStatus.connected);
      }
    });
    mergedStream = mergedStreamController.stream;
  }

  @override
  void dispose() {
    super.dispose();
    mergedStreamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: mergedStream,
        initialData: true,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!) {
              return widget.child;
            } else {
              return const InternetConnectionErrorWidget();
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
    );
  }
}

class InternetConnectionErrorWidget extends StatelessWidget {
  const InternetConnectionErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                AppAssets.logo,
                // scale: 4,
                height: 300,
                fit: BoxFit.fitHeight,
              ),
              Text(
                LocaleKeys.internetDisabled.tr(),
                textAlign: TextAlign.center,
                style: context.currentTextTheme.labelLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}