import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class Reachability extends Object {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? connectivitySubscription;

  // current network status
  String _connectStatus = 'Unknown';
  String get connectStatus => _connectStatus;

  //Constant for check network status
  static const String _connectivityMobile = "ConnectivityResult.mobile";
  static const String _connectivityWifi = "ConnectivityResult.wifi";

  factory Reachability() {
    return _singleton;
  }

  static final Reachability _singleton = Reachability._internal();
  static final Reachability instance = _singleton;
  
  Reachability._internal() {
    // شيلنا كل الـ Casting الغريب اللي كان موجود هنا
    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectStatus = result.toString();
      debugPrint("ConnectionStatus :: = $_connectStatus");
    });
  }

  dispose() {
    connectivitySubscription?.cancel();
  }

  // set up initial
  Future<void> setUpConnectivity() async {
    String connectionStatus;

    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
      debugPrint("ConnectionStatus :: => $connectionStatus");
    } on Exception catch (e) {
      debugPrint(e.toString());
      connectionStatus = 'Failed to get connectivity.';
    }
    _connectStatus = connectionStatus;
    debugPrint("ConnectionStatus :: => $_connectStatus");
  }

  // check for network available
  bool isInterNetAvailable() {
    debugPrint("ConnectionStatus :: => $_connectStatus");
    return (_connectStatus == Reachability._connectivityMobile) ||
        (_connectStatus == Reachability._connectivityWifi);
  }
}
