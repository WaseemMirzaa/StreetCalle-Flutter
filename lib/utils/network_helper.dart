import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkHelper {
  NetworkHelper._();

  static final _instance = NetworkHelper._();
  static NetworkHelper get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();
  Stream<bool> get myStream => _controller.stream;

  void initialise() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add(isOnline);
  }

  void disposeStream() => _controller.close();
}