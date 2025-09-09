/// TripMuse 網路狀態服務
/// 
/// 監控網路連線狀態和提供網路相關功能

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 網路狀態
enum NetworkStatus {
  connected,
  disconnected,
  unknown,
}

/// 連線類型
enum ConnectionType {
  wifi,
  mobile,
  ethernet,
  none,
}

/// 網路資訊
class NetworkInfo {
  const NetworkInfo({
    required this.status,
    required this.connectionType,
    this.isMetered = false,
  });

  final NetworkStatus status;
  final ConnectionType connectionType;
  final bool isMetered; // 是否為計量網路（如行動數據）

  bool get isConnected => status == NetworkStatus.connected;
  bool get isWifi => connectionType == ConnectionType.wifi;
  bool get isMobile => connectionType == ConnectionType.mobile;
}

/// 網路服務
class NetworkService {
  NetworkService() {
    _init();
  }

  final Connectivity _connectivity = Connectivity();
  final StreamController<NetworkInfo> _networkController = StreamController<NetworkInfo>.broadcast();

  NetworkInfo _currentNetworkInfo = const NetworkInfo(
    status: NetworkStatus.unknown,
    connectionType: ConnectionType.none,
  );

  /// 當前網路資訊
  NetworkInfo get currentNetworkInfo => _currentNetworkInfo;

  /// 網路狀態串流
  Stream<NetworkInfo> get networkStream => _networkController.stream;

  /// 是否已連線
  bool get isConnected => _currentNetworkInfo.isConnected;

  /// 初始化
  void _init() {
    // 監聽連線狀態變化
    _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
    
    // 檢查初始狀態
    _checkInitialConnectivity();
  }

  /// 檢查初始連線狀態
  Future<void> _checkInitialConnectivity() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      _onConnectivityChanged(connectivityResults);
    } catch (e) {
      _updateNetworkInfo(const NetworkInfo(
        status: NetworkStatus.unknown,
        connectionType: ConnectionType.none,
      ));
    }
  }

  /// 處理連線狀態變化
  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final networkInfo = _parseConnectivityResults(results);
    _updateNetworkInfo(networkInfo);
  }

  /// 解析連線結果
  NetworkInfo _parseConnectivityResults(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return const NetworkInfo(
        status: NetworkStatus.disconnected,
        connectionType: ConnectionType.none,
      );
    }

    // 優先順序：WiFi > Ethernet > Mobile
    if (results.contains(ConnectivityResult.wifi)) {
      return const NetworkInfo(
        status: NetworkStatus.connected,
        connectionType: ConnectionType.wifi,
        isMetered: false,
      );
    } else if (results.contains(ConnectivityResult.ethernet)) {
      return const NetworkInfo(
        status: NetworkStatus.connected,
        connectionType: ConnectionType.ethernet,
        isMetered: false,
      );
    } else if (results.contains(ConnectivityResult.mobile)) {
      return const NetworkInfo(
        status: NetworkStatus.connected,
        connectionType: ConnectionType.mobile,
        isMetered: true,
      );
    } else {
      return const NetworkInfo(
        status: NetworkStatus.unknown,
        connectionType: ConnectionType.none,
      );
    }
  }

  /// 更新網路資訊
  void _updateNetworkInfo(NetworkInfo networkInfo) {
    _currentNetworkInfo = networkInfo;
    _networkController.add(networkInfo);
  }

  /// 檢查網路連線
  Future<bool> checkConnectivity() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      return !connectivityResults.contains(ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }

  /// 等待網路連線
  Future<void> waitForConnection({Duration? timeout}) async {
    if (isConnected) return;

    final completer = Completer<void>();
    late StreamSubscription subscription;

    subscription = networkStream.listen((networkInfo) {
      if (networkInfo.isConnected) {
        subscription.cancel();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    if (timeout != null) {
      Timer(timeout, () {
        subscription.cancel();
        if (!completer.isCompleted) {
          completer.completeError(TimeoutException('等待網路連線超時', timeout));
        }
      });
    }

    return completer.future;
  }

  /// 釋放資源
  void dispose() {
    _networkController.close();
  }
}

/// 網路服務 Provider
final networkServiceProvider = Provider<NetworkService>((ref) {
  final service = NetworkService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// 網路狀態 Provider
final networkStatusProvider = StreamProvider<NetworkInfo>((ref) {
  final networkService = ref.watch(networkServiceProvider);
  return networkService.networkStream;
});

/// 連線狀態 Provider
final isConnectedProvider = Provider<bool>((ref) {
  final networkStatus = ref.watch(networkStatusProvider);
  return networkStatus.when(
    data: (info) => info.isConnected,
    loading: () => false,
    error: (_, __) => false,
  );
});