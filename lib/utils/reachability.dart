import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class Reachability extends Object {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;

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
    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      _updateConnectionStatus(result);
    });
  }

  dispose() {
    connectivitySubscription?.cancel();
  }

  // set up initial
  Future<void> setUpConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } on Exception catch (e) {
      debugPrint(e.toString());
      _connectStatus = 'Failed to get connectivity.';
    }
  }

  // Helper method to handle the new List format
  void _updateConnectionStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.wifi)) {
      _connectStatus = _connectivityWifi;
    } else if (result.contains(ConnectivityResult.mobile)) {
      _connectStatus = _connectivityMobile;
    } else {
      _connectStatus = result.isNotEmpty ? result.first.toString() : 'ConnectivityResult.none';
    }
    debugPrint("ConnectionStatus :: => $_connectStatus");
  }

  // check for network available
  bool isInterNetAvailable() {
    debugPrint("ConnectionStatus :: => $_connectStatus");
    return (_connectStatus == Reachability._connectivityMobile) ||
        (_connectStatus == Reachability._connectivityWifi);
  }
}
