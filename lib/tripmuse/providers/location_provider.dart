/// 位置狀態管理
/// 
/// 使用 Riverpod 管理位置服務狀態和旅程進度

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../services/trip_progress_calculator.dart' as calc;
import '../models/models.dart';
import '../models/trip_models.dart' as trip_models;

/// 位置服務 Provider
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

/// 位置權限狀態 Provider
final locationPermissionProvider = StateNotifierProvider<LocationPermissionNotifier, LocationServiceStatus>((ref) {
  return LocationPermissionNotifier(ref.read(locationServiceProvider));
});

/// 當前位置 Provider
final currentLocationProvider = StateNotifierProvider<CurrentLocationNotifier, AsyncValue<Position?>>((ref) {
  return CurrentLocationNotifier(ref.read(locationServiceProvider));
});

/// 位置追蹤狀態 Provider
final locationTrackingProvider = StateNotifierProvider<LocationTrackingNotifier, bool>((ref) {
  return LocationTrackingNotifier(ref.read(locationServiceProvider));
});

/// 旅程進度 Provider
final tripProgressProvider = StateNotifierProvider.family<TripProgressNotifier, trip_models.TripProgress?, Trip>((ref, trip) {
  final currentLocation = ref.watch(currentLocationProvider);
  return TripProgressNotifier(trip, currentLocation.value);
});

/// 位置權限狀態管理器
class LocationPermissionNotifier extends StateNotifier<LocationServiceStatus> {
  final LocationService _locationService;

  LocationPermissionNotifier(this._locationService) : super(LocationServiceStatus.unknown) {
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    state = await _locationService.checkAndRequestPermission();
  }

  Future<void> requestPermission() async {
    state = LocationServiceStatus.loading;
    state = await _locationService.checkAndRequestPermission();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
    // 重新檢查權限狀態
    await Future.delayed(const Duration(seconds: 1));
    await _checkPermission();
  }
}

/// 當前位置狀態管理器
class CurrentLocationNotifier extends StateNotifier<AsyncValue<Position?>> {
  final LocationService _locationService;
  StreamSubscription<LocationUpdate>? _locationSubscription;

  CurrentLocationNotifier(this._locationService) : super(const AsyncValue.loading()) {
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      // 獲取當前位置
      final position = await _locationService.getCurrentPosition();
      state = AsyncValue.data(position);

      // 監聽位置更新
      _locationSubscription = _locationService.locationStream.listen(
        (locationUpdate) {
          state = AsyncValue.data(locationUpdate.position);
        },
        onError: (error) {
          state = AsyncValue.error(error, StackTrace.current);
        },
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshLocation() async {
    state = const AsyncValue.loading();
    try {
      final position = await _locationService.getCurrentPosition();
      state = AsyncValue.data(position);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
}

/// 位置追蹤狀態管理器
class LocationTrackingNotifier extends StateNotifier<bool> {
  final LocationService _locationService;

  LocationTrackingNotifier(this._locationService) : super(false);

  Future<void> startTracking() async {
    if (state) return; // 已經在追蹤中
    
    final success = await _locationService.startLocationTracking();
    state = success;
  }

  Future<void> stopTracking() async {
    if (!state) return; // 沒有在追蹤
    
    await _locationService.stopLocationTracking();
    state = false;
  }

  Future<void> toggleTracking() async {
    if (state) {
      await stopTracking();
    } else {
      await startTracking();
    }
  }
}

/// 旅程進度狀態管理器
class TripProgressNotifier extends StateNotifier<trip_models.TripProgress?> {
  final Trip _trip;
  Position? _currentPosition;

  TripProgressNotifier(this._trip, this._currentPosition) : super(null) {
    _updateProgress();
  }

  void updatePosition(Position? position) {
    _currentPosition = position;
    _updateProgress();
  }

  void _updateProgress() {
    if (_currentPosition != null) {
      state = calc.TripProgressCalculator.calculateTripProgress(_trip, _currentPosition);
    }
  }

  /// 標記活動為已完成
  void markActivityCompleted(Activity activity) {
    // 這裡可以實作活動完成的邏輯
    // 例如儲存到本地資料庫或更新狀態
    _updateProgress();
  }

  /// 跳到下一個活動
  void goToNextActivity() {
    if (state?.nextActivity != null) {
      // 可以實作自動導航到下一個活動的邏輯
      _updateProgress();
    }
  }
}

