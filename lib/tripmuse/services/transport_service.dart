import 'dart:math' as math;
import '../models/models.dart';

/// 交通服務
/// 
/// 負責計算活動之間的交通時間和距離
class TransportService {
  /// 計算兩個活動之間的交通信息
  /// 
  /// 根據兩個活動的位置和選擇的交通方式計算通勤時間和距離
  static TransportInfo calculateTransport({
    required Activity fromActivity,
    required Activity toActivity,
    required TransportMode mode,
  }) {
    // 計算兩點之間的直線距離（公尺）
    final distance = _calculateDistance(
      fromActivity.lat,
      fromActivity.lng,
      toActivity.lat,
      toActivity.lng,
    );
    
    // 根據交通方式計算通勤時間
    final duration = _calculateDuration(distance, mode);
    
    // 估算費用
    final cost = _estimateCost(distance, mode);
    
    return TransportInfo(
      mode: mode,
      durationMinutes: duration,
      distanceMeters: distance.round(),
      estimatedCost: cost,
    );
  }
  
  /// 為整個行程生成交通信息
  /// 
  /// 為每日行程中的活動之間生成交通信息
  static Trip generateTransportForTrip(Trip trip, [TransportMode? defaultMode]) {
    // 如果沒有指定預設交通方式，使用步行
    defaultMode ??= TransportMode.walking;
    final updatedDays = trip.days.map((dayPlan) {
      if (dayPlan.activities.length <= 1) {
        return dayPlan; // 如果只有一個或沒有活動，不需要交通信息
      }
      
      final transports = <TransportInfo>[];
      
      for (int i = 0; i < dayPlan.activities.length - 1; i++) {
        final fromActivity = dayPlan.activities[i];
        final toActivity = dayPlan.activities[i + 1];
        
        final transport = calculateTransport(
          fromActivity: fromActivity,
          toActivity: toActivity,
          mode: defaultMode!,
        );
        
        transports.add(transport);
      }
      
      return dayPlan.copyWith(transports: transports);
    }).toList();
    
    return trip.copyWith(days: updatedDays);
  }
  
  /// 計算兩點之間的直線距離（公尺）
  /// 
  /// 使用 Haversine 公式計算地球表面兩點之間的距離
  static double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371000; // 地球半徑（公尺）
    
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLng = _degreesToRadians(lng2 - lng1);
    
    final double a = 
        (dLat / 2).sin() * (dLat / 2).sin() +
        lat1.cos() * lat2.cos() * 
        (dLng / 2).sin() * (dLng / 2).sin();
    
    final double c = 2 * (a.sqrt()).asin();
    
    return earthRadius * c;
  }
  
  /// 將角度轉換為弧度
  static double _degreesToRadians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }
  
  /// 根據距離和交通方式計算通勤時間（分鐘）
  static int _calculateDuration(double distanceMeters, TransportMode mode) {
    // 不同交通方式的平均速度（公尺/分鐘）
    final speedMap = {
      TransportMode.walking: 80.0,    // 步行：約 4.8 km/h
      TransportMode.cycling: 200.0,   // 騎車：約 12 km/h
      TransportMode.driving: 500.0,   // 開車：約 30 km/h（市區）
      TransportMode.taxi: 400.0,      // 計程車：約 24 km/h（市區含等車時間）
      TransportMode.transit: 300.0,   // 大眾運輸：約 18 km/h（含等車時間）
      TransportMode.metro: 600.0,     // 地鐵：約 36 km/h
    };
    
    final speed = speedMap[mode] ?? 300.0;
    final duration = (distanceMeters / speed).ceil();
    
    // 最少 1 分鐘，最多 180 分鐘
    return duration.clamp(1, 180);
  }
  
  /// 估算交通費用
  static String? _estimateCost(double distanceMeters, TransportMode mode) {
    final distanceKm = distanceMeters / 1000;
    
    switch (mode) {
      case TransportMode.walking:
      case TransportMode.cycling:
        return null; // 免費
        
      case TransportMode.driving:
        // 油費 + 停車費估算
        final fuelCost = distanceKm * 3; // 每公里約 3 元油費
        final parkingCost = distanceKm > 2 ? 50 : 0; // 超過 2 公里可能需要停車費
        return '約 ${(fuelCost + parkingCost).round()} 元';
        
      case TransportMode.taxi:
        // 計程車費用估算（起跳價 + 跳錶）
        final baseFare = 85; // 起跳價
        final meterFare = (distanceKm * 25).round(); // 每公里約 25 元
        return '約 ${baseFare + meterFare} 元';
        
      case TransportMode.transit:
        // 大眾運輸費用
        if (distanceKm <= 2) {
          return '約 15 元';
        } else if (distanceKm <= 5) {
          return '約 20 元';
        } else {
          return '約 25 元';
        }
        
      case TransportMode.metro:
        // 地鐵費用
        if (distanceKm <= 3) {
          return '約 20 元';
        } else if (distanceKm <= 8) {
          return '約 25 元';
        } else {
          return '約 30 元';
        }
    }
  }
  
  /// 根據活動類型推薦交通方式
  static TransportMode recommendTransportMode({
    required Activity fromActivity,
    required Activity toActivity,
    required double distanceMeters,
  }) {
    final distanceKm = distanceMeters / 1000;
    
    // 根據距離推薦交通方式
    if (distanceKm <= 0.5) {
      return TransportMode.walking; // 500 公尺內建議步行
    } else if (distanceKm <= 2) {
      return TransportMode.cycling; // 2 公里內建議騎車
    } else if (distanceKm <= 10) {
      return TransportMode.transit; // 10 公里內建議大眾運輸
    } else {
      return TransportMode.driving; // 超過 10 公里建議開車
    }
  }
  
  /// 獲取所有可用的交通方式
  static List<TransportMode> getAvailableTransportModes() {
    return TransportMode.values;
  }
  
  /// 獲取交通方式的詳細信息
  static Map<String, dynamic> getTransportModeInfo(TransportMode mode) {
    switch (mode) {
      case TransportMode.walking:
        return {
          'name': '步行',
          'icon': '🚶',
          'description': '適合短距離，環保健康',
          'avgSpeed': '4.8 km/h',
          'cost': '免費',
        };
      case TransportMode.cycling:
        return {
          'name': '騎車',
          'icon': '🚴',
          'description': '適合中短距離，靈活便利',
          'avgSpeed': '12 km/h',
          'cost': '免費',
        };
      case TransportMode.driving:
        return {
          'name': '開車',
          'icon': '🚗',
          'description': '適合長距離，舒適快速',
          'avgSpeed': '30 km/h',
          'cost': '油費+停車費',
        };
      case TransportMode.taxi:
        return {
          'name': '計程車',
          'icon': '🚕',
          'description': '門到門服務，方便舒適',
          'avgSpeed': '24 km/h',
          'cost': '起跳+跳錶',
        };
      case TransportMode.transit:
        return {
          'name': '大眾運輸',
          'icon': '🚌',
          'description': '經濟實惠，覆蓋面廣',
          'avgSpeed': '18 km/h',
          'cost': '15-25元',
        };
      case TransportMode.metro:
        return {
          'name': '地鐵',
          'icon': '🚇',
          'description': '快速準時，避開塞車',
          'avgSpeed': '36 km/h',
          'cost': '20-30元',
        };
    }
  }
}

/// 數學擴展
extension MathExtension on double {
  double sin() => math.sin(this);
  double cos() => math.cos(this);
  double asin() => math.asin(this);
  double sqrt() => math.sqrt(this);
}