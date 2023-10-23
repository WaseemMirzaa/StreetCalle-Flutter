import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService extends StatefulWidget {
  final Widget child;

  LocationService({super.key, required this.child});

  @override
  State<LocationService> createState() => _LocationServiceState();
}

class _LocationServiceState extends State<LocationService> {

  Stream<ServiceStatus> serviceStatusStream = Geolocator.getServiceStatusStream();
  @override
  void initState() {
    super.initState();
    // PermissionUtils.checkStatus().then((value){
    //
    // });

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ServiceStatus>(
      initialData: ServiceStatus.disabled,
      stream: Geolocator.getServiceStatusStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final status = snapshot.data;
          if (status == ServiceStatus.enabled) {
            return widget.child;
          } else {
            // You can customize the message or UI here when location service is disabled.
            return const Text('Location service is disabled.');
          }
        }
        return const CircularProgressIndicator(); // Loading indicator while waiting for data.
      },
    );
  }
}
