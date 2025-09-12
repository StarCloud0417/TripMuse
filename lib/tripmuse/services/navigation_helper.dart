/// 導航輔助服務
/// 
/// 提供導航相關功能，包括距離計算、導航啟動等

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import '../providers/location_provider.dart' show locationServiceProvider;
import 'location_service.dart';

/// 導航輔助服務 Provider
final navigationHelperProvider = Provider<NavigationHelper>((ref) {
  final locationService = ref.read(locationServiceProvider);
  return NavigationHelper(locationService);
});

/// 導航輔助服務
class NavigationHelper {
  final LocationService _locationService;
  
  NavigationHelper(this._locationService);
  
  /// 獲取到活動的距離（米）
  double? getDistanceToActivity(Activity activity) {
    final userPosition = _locationService.lastKnownPosition;
    if (userPosition == null) return null;
    
    return geo.Geolocator.distanceBetween(
      userPosition.latitude,
      userPosition.longitude,
      activity.lat,
      activity.lng,
    );
  }
  
  /// 檢查是否在活動位置附近（100米內）
  bool isAtActivity(Activity activity) {
    final distance = getDistanceToActivity(activity);
    return distance != null && distance <= 100;
  }
  
  /// 格式化距離顯示
  String formatDistance(double? distanceInMeters) {
    if (distanceInMeters == null) return '未知距離';

    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()}m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)}km';
    }
  }

  /// 獲取距離對應的顏色
  String getDistanceColor(double? distanceInMeters) {
    if (distanceInMeters == null) return '#9E9E9E'; // 灰色 - 未知

    if (distanceInMeters <= 50) return '#4CAF50'; // 綠色 - 很近
    if (distanceInMeters <= 200) return '#FF9800'; // 橙色 - 中等距離
    return '#F44336'; // 紅色 - 較遠
  }
  
  /// 啟動導航到活動位置
  Future<void> navigateToActivity(Activity activity) async {
    final lat = activity.lat;
    final lng = activity.lng;

    // 嘗試使用 Google Maps
    final googleMapsUrl = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');

    try {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      // 如果Google Maps失敗，嘗試使用通用地圖 URL
      final fallbackUrl = Uri.parse('geo:$lat,$lng?q=$lat,$lng(${Uri.encodeComponent(activity.name)})');

      try {
        await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      } catch (fallbackError) {
        // 如果都失敗了，嘗試使用更簡單的geo URL
        final simpleGeoUrl = Uri.parse('geo:$lat,$lng');

        try {
          await launchUrl(simpleGeoUrl, mode: LaunchMode.externalApplication);
        } catch (simpleError) {
          throw Exception('無法啟動導航應用。請確認已安裝地圖應用程式。\n錯誤詳情: $simpleError');
        }
      }
    }
  }
  
  /// 計算兩點之間的距離
  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    return geo.Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
  }
  
  /// 獲取最近的活動
  Activity? findNearestActivity(List<Activity> activities) {
    final userPosition = _locationService.lastKnownPosition;
    if (userPosition == null || activities.isEmpty) return null;
    
    Activity? nearest;
    double? minDistance;
    
    for (final activity in activities) {
      final distance = calculateDistance(
        userPosition.latitude,
        userPosition.longitude,
        activity.lat,
        activity.lng,
      );
      
      if (minDistance == null || distance < minDistance) {
        minDistance = distance;
        nearest = activity;
      }
    }
    
    return nearest;
  }
  
  /// 獲取活動的方向角度（相對於北方）
  double getBearingToActivity(Activity activity) {
    final userPosition = _locationService.lastKnownPosition;
    if (userPosition == null) return 0.0;
    
    return geo.Geolocator.bearingBetween(
      userPosition.latitude,
      userPosition.longitude,
      activity.lat,
      activity.lng,
    );
  }
  
  /// 獲取方向描述
  String getDirectionDescription(double bearing) {
    if (bearing >= -22.5 && bearing < 22.5) return '北方';
    if (bearing >= 22.5 && bearing < 67.5) return '東北方';
    if (bearing >= 67.5 && bearing < 112.5) return '東方';
    if (bearing >= 112.5 && bearing < 157.5) return '東南方';
    if (bearing >= 157.5 || bearing < -157.5) return '南方';
    if (bearing >= -157.5 && bearing < -112.5) return '西南方';
    if (bearing >= -112.5 && bearing < -67.5) return '西方';
    if (bearing >= -67.5 && bearing < -22.5) return '西北方';
    return '未知方向';
  }
}