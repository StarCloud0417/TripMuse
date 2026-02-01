import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity;
  
  ConnectivityService(this._connectivity);
  
  /// Stream of connectivity changes
  Stream<ConnectivityResult> get connectivityStream => 
    _connectivity.onConnectivityChanged.map((results) => results.first);
  
  /// Check current connectivity status
  Future<ConnectivityResult> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    return results.first;
  }
  
  /// Check if device is currently online
  Future<bool> get isOnline async {
    final result = await checkConnectivity();
    return result != ConnectivityResult.none;
  }
  
  /// Check if device has WiFi connection
  Future<bool> get hasWiFi async {
    final result = await checkConnectivity();
    return result == ConnectivityResult.wifi;
  }
  
  /// Check if device has mobile data connection
  Future<bool> get hasMobileData async {
    final result = await checkConnectivity();
    return result == ConnectivityResult.mobile;
  }
}