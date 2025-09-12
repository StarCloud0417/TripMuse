/// 位置服務
/// 
/// 提供位置追蹤、權限管理和導航功能

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';

/// 位置服務狀態
enum LocationServiceStatus {
  unknown,
  disabled,
  denied,
  deniedForever,
  granted,
  loading,
}

/// 位置更新事件
class LocationUpdate {
  final Position position;
  final DateTime timestamp;
  final double? accuracy;

  const LocationUpdate({
    required this.position,
    required this.timestamp,
    this.accuracy,
  });
}

/// 位置服務
class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  StreamController<LocationUpdate>? _locationController;
  StreamSubscription<Position>? _positionSubscription;
  Position? _lastKnownPosition;
  LocationServiceStatus _status = LocationServiceStatus.unknown;

  /// 位置更新流
  Stream<LocationUpdate> get locationStream {
    _locationController ??= StreamController<LocationUpdate>.broadcast();
    return _locationController!.stream;
  }

  /// 當前位置服務狀態
  LocationServiceStatus get status => _status;

  /// 最後已知位置
  Position? get lastKnownPosition => _lastKnownPosition;

  /// 檢查並請求位置權限
  Future<LocationServiceStatus> checkAndRequestPermission() async {
    try {
      _status = LocationServiceStatus.loading;

      // 檢查位置服務是否啟用
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _status = LocationServiceStatus.disabled;
        return _status;
      }

      // 檢查權限狀態
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _status = LocationServiceStatus.denied;
          return _status;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _status = LocationServiceStatus.deniedForever;
        return _status;
      }

      _status = LocationServiceStatus.granted;
      return _status;
    } catch (e) {
      debugPrint('❌ 位置權限檢查失敗: $e');
      _status = LocationServiceStatus.denied;
      return _status;
    }
  }

  /// 獲取當前位置
  Future<Position?> getCurrentPosition() async {
    try {
      final status = await checkAndRequestPermission();
      if (status != LocationServiceStatus.granted) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      _lastKnownPosition = position;
      return position;
    } catch (e) {
      debugPrint('❌ 獲取當前位置失敗: $e');
      return null;
    }
  }

  /// 開始位置追蹤
  Future<bool> startLocationTracking() async {
    try {
      final status = await checkAndRequestPermission();
      if (status != LocationServiceStatus.granted) {
        return false;
      }

      // 停止現有的追蹤
      await stopLocationTracking();

      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // 移動10米才更新
      );

      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) {
          _lastKnownPosition = position;
          _locationController?.add(LocationUpdate(
            position: position,
            timestamp: DateTime.now(),
            accuracy: position.accuracy,
          ));
        },
        onError: (error) {
          debugPrint('❌ 位置追蹤錯誤: $error');
        },
      );

      debugPrint('✅ 位置追蹤已開始');
      return true;
    } catch (e) {
      debugPrint('❌ 開始位置追蹤失敗: $e');
      return false;
    }
  }

  /// 停止位置追蹤
  Future<void> stopLocationTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    debugPrint('🛑 位置追蹤已停止');
  }

  /// 計算兩點之間的距離（米）
  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
  }

  /// 計算到活動的距離
  double? calculateDistanceToActivity(Activity activity) {
    if (_lastKnownPosition == null) return null;
    
    return calculateDistance(
      _lastKnownPosition!.latitude,
      _lastKnownPosition!.longitude,
      activity.lat,
      activity.lng,
    );
  }

  /// 找到最近的活動
  Activity? findNearestActivity(List<Activity> activities) {
    if (_lastKnownPosition == null || activities.isEmpty) return null;

    Activity? nearest;
    double? minDistance;

    for (final activity in activities) {
      final distance = calculateDistanceToActivity(activity);
      if (distance != null && (minDistance == null || distance < minDistance)) {
        minDistance = distance;
        nearest = activity;
      }
    }

    return nearest;
  }

  /// 檢查是否到達活動位置（50米內）
  bool isAtActivity(Activity activity, {double threshold = 50.0}) {
    final distance = calculateDistanceToActivity(activity);
    return distance != null && distance <= threshold;
  }

  /// 開啟外部導航應用
  Future<bool> openNavigation(Activity activity, {NavigationApp? preferredApp}) async {
    try {
      final lat = activity.lat;
      final lng = activity.lng;

      String url;
      
      switch (preferredApp ?? NavigationApp.auto) {
        case NavigationApp.googleMaps:
          url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&destination_place_id=${activity.placeId ?? ''}&travelmode=walking';
          break;
        case NavigationApp.appleMaps:
          url = 'https://maps.apple.com/?daddr=$lat,$lng&dirflg=w';
          break;
        case NavigationApp.auto:
          // 自動選擇可用的導航應用
          if (defaultTargetPlatform == TargetPlatform.iOS) {
            url = 'https://maps.apple.com/?daddr=$lat,$lng&dirflg=w';
          } else {
            url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=walking';
          }
          break;
      }

      final uri = Uri.parse(url);
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        debugPrint('✅ 已開啟導航到: ${activity.name}');
        return true;
      } catch (e) {
        debugPrint('❌ 無法開啟導航應用: $e');
        return false;
      }
    } catch (e) {
      debugPrint('❌ 開啟導航失敗: $e');
      return false;
    }
  }

  /// 釋放資源
  void dispose() {
    stopLocationTracking();
    _locationController?.close();
    _locationController = null;
  }
}

/// 導航應用選項
enum NavigationApp {
  auto,
  googleMaps,
  appleMaps,
}

/// 旅程進度計算器
class TripProgressCalculator {
  /// 計算行程整體進度
  static TripProgress calculateTripProgress(Trip trip, Position? currentPosition) {
    if (currentPosition == null) {
      return TripProgress(
        currentDay: 1,
        currentActivity: null,
        nextActivity: null,
        overallProgress: 0.0,
        dayProgress: 0.0,
        isCompleted: false,
      );
    }

    final locationService = LocationService();
    final today = DateTime.now();
    
    // 找到當前應該進行的日期
    DayPlan? currentDayPlan;
    int currentDayIndex = 0;
    
    for (int i = 0; i < trip.days.length; i++) {
      final dayPlan = trip.days[i];
      if (dayPlan.date.day == today.day && 
          dayPlan.date.month == today.month && 
          dayPlan.date.year == today.year) {
        currentDayPlan = dayPlan;
        currentDayIndex = i;
        break;
      }
    }

    // 如果沒有找到當天的行程，使用第一天
    currentDayPlan ??= trip.days.first;

    // 找到最近的活動
    final nearestActivity = locationService.findNearestActivity(currentDayPlan.activities);
    
    // 找到下一個活動
    Activity? nextActivity;
    if (nearestActivity != null) {
      final currentIndex = currentDayPlan.activities.indexOf(nearestActivity);
      if (currentIndex < currentDayPlan.activities.length - 1) {
        nextActivity = currentDayPlan.activities[currentIndex + 1];
      } else if (currentDayIndex < trip.days.length - 1) {
        // 下一天的第一個活動
        nextActivity = trip.days[currentDayIndex + 1].activities.first;
      }
    }

    // 計算進度
    final totalActivities = trip.days.fold<int>(0, (sum, day) => sum + day.activities.length);
    final completedActivities = _calculateCompletedActivities(trip, currentPosition);
    final overallProgress = totalActivities > 0 ? completedActivities / totalActivities : 0.0;
    
    final dayProgress = currentDayPlan.activities.isNotEmpty 
        ? _calculateDayProgress(currentDayPlan, currentPosition) 
        : 0.0;

    return TripProgress(
      currentDay: currentDayIndex + 1,
      currentActivity: nearestActivity,
      nextActivity: nextActivity,
      overallProgress: overallProgress,
      dayProgress: dayProgress,
      isCompleted: overallProgress >= 1.0,
    );
  }

  static int _calculateCompletedActivities(Trip trip, Position currentPosition) {
    final locationService = LocationService();
    int completed = 0;
    
    for (final day in trip.days) {
      for (final activity in day.activities) {
        if (locationService.isAtActivity(activity)) {
          completed++;
        }
      }
    }
    
    return completed;
  }

  static double _calculateDayProgress(DayPlan dayPlan, Position currentPosition) {
    final locationService = LocationService();
    int completed = 0;
    
    for (final activity in dayPlan.activities) {
      if (locationService.isAtActivity(activity)) {
        completed++;
      }
    }
    
    return dayPlan.activities.isNotEmpty ? completed / dayPlan.activities.length : 0.0;
  }
}

/// 旅程進度資訊
class TripProgress {
  final int currentDay;
  final Activity? currentActivity;
  final Activity? nextActivity;
  final double overallProgress; // 0.0 - 1.0
  final double dayProgress; // 0.0 - 1.0
  final bool isCompleted;

  const TripProgress({
    required this.currentDay,
    this.currentActivity,
    this.nextActivity,
    required this.overallProgress,
    required this.dayProgress,
    required this.isCompleted,
  });
}