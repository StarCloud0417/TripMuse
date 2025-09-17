/// TripMuse 路線最佳化服務
///
/// 提供活動路線計算和最佳化功能

import 'dart:math' as math;
import '../models/models.dart';

class RouteOptimizationService {
  /// 計算兩點間的距離（公里）
  static double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371; // 地球半徑（公里）
    
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLng = _degreesToRadians(lng2 - lng1);
    
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) * math.cos(_degreesToRadians(lat2)) *
        math.sin(dLng / 2) * math.sin(dLng / 2);
    
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    
    return earthRadius * c;
  }
  
  /// 計算預估旅行時間（分鐘）
  static int calculateTravelTime(double distance, TransportMode mode) {
    switch (mode) {
      case TransportMode.walking:
        return (distance * 12).round(); // 步行速度約 5 km/h
      case TransportMode.cycling:
        return (distance * 4).round(); // 騎車速度約 15 km/h
      case TransportMode.driving:
        return (distance * 2).round(); // 開車速度約 30 km/h（市區）
      case TransportMode.publicTransport:
        return (distance * 3).round(); // 大眾運輸約 20 km/h
    }
  }
  
  /// 最佳化單日活動順序
  static OptimizationResult optimizeDayActivities(
    List<Activity> activities, {
    TransportMode transportMode = TransportMode.walking,
    bool preserveTimeConstraints = true,
  }) {
    if (activities.length <= 1) {
      return OptimizationResult(
        optimizedActivities: activities,
        totalDistance: 0,
        totalTravelTime: 0,
        improvementPercentage: 0,
      );
    }
    
    // 計算原始路線
    final originalDistance = _calculateTotalDistance(activities);
    final originalTravelTime = _calculateTotalTravelTime(activities, transportMode);
    
    List<Activity> optimizedActivities;
    
    if (preserveTimeConstraints) {
      // 保持時間約束的最佳化
      optimizedActivities = _optimizeWithTimeConstraints(activities, transportMode);
    } else {
      // 完全基於距離的最佳化（旅行商問題的近似解）
      optimizedActivities = _optimizeByDistance(activities);
    }
    
    // 計算最佳化後的路線
    final optimizedDistance = _calculateTotalDistance(optimizedActivities);
    final optimizedTravelTime = _calculateTotalTravelTime(optimizedActivities, transportMode);
    
    // 計算改善百分比
    final improvementPercentage = originalDistance > 0 
        ? ((originalDistance - optimizedDistance) / originalDistance * 100)
        : 0;
    
    return OptimizationResult(
      optimizedActivities: optimizedActivities,
      totalDistance: optimizedDistance,
      totalTravelTime: optimizedTravelTime,
      improvementPercentage: improvementPercentage.toDouble(),
      originalDistance: originalDistance,
      originalTravelTime: originalTravelTime,
    );
  }
  
  /// 重新計算活動間的路線
  static List<RouteSegment> calculateRouteSegments(
    List<Activity> activities,
    TransportMode transportMode,
  ) {
    final segments = <RouteSegment>[];
    
    for (int i = 0; i < activities.length - 1; i++) {
      final from = activities[i];
      final to = activities[i + 1];
      
      final distance = calculateDistance(from.lat, from.lng, to.lat, to.lng);
      final travelTime = calculateTravelTime(distance, transportMode);
      
      segments.add(RouteSegment(
        fromActivity: from,
        toActivity: to,
        distance: distance,
        travelTime: travelTime,
        transportMode: transportMode,
      ));
    }
    
    return segments;
  }
  
  /// 建議最佳的交通方式
  static TransportMode suggestTransportMode(List<Activity> activities) {
    if (activities.length <= 1) return TransportMode.walking;
    
    final totalDistance = _calculateTotalDistance(activities);
    final averageDistance = totalDistance / (activities.length - 1);
    
    if (averageDistance <= 0.5) {
      return TransportMode.walking; // 平均距離 500m 以內，建議步行
    } else if (averageDistance <= 2.0) {
      return TransportMode.cycling; // 平均距離 2km 以內，建議騎車
    } else if (averageDistance <= 5.0) {
      return TransportMode.publicTransport; // 平均距離 5km 以內，建議大眾運輸
    } else {
      return TransportMode.driving; // 超過 5km，建議開車
    }
  }
  
  /// 檢查活動時間是否合理
  static TimeValidationResult validateActivityTiming(
    List<Activity> activities,
    TransportMode transportMode,
  ) {
    final issues = <TimingIssue>[];
    
    for (int i = 0; i < activities.length - 1; i++) {
      final current = activities[i];
      final next = activities[i + 1];
      
      final distance = calculateDistance(current.lat, current.lng, next.lat, next.lng);
      final requiredTravelTime = calculateTravelTime(distance, transportMode);
      
      final currentEndTime = _timeToMinutes(current.timeTo);
      final nextStartTime = _timeToMinutes(next.timeFrom);
      final availableTime = nextStartTime - currentEndTime;
      
      if (availableTime < requiredTravelTime) {
        issues.add(TimingIssue(
          fromActivity: current,
          toActivity: next,
          requiredTime: requiredTravelTime,
          availableTime: availableTime,
          shortfall: requiredTravelTime - availableTime,
        ));
      }
    }
    
    return TimeValidationResult(
      isValid: issues.isEmpty,
      issues: issues,
    );
  }
  
  /// 自動調整活動時間以符合交通需求
  static List<Activity> autoAdjustTimingForTravel(
    List<Activity> activities,
    TransportMode transportMode,
  ) {
    if (activities.length <= 1) return activities;
    
    final adjustedActivities = <Activity>[activities.first];
    
    for (int i = 1; i < activities.length; i++) {
      final previous = adjustedActivities[i - 1];
      final current = activities[i];
      
      final distance = calculateDistance(previous.lat, previous.lng, current.lat, current.lng);
      final requiredTravelTime = calculateTravelTime(distance, transportMode);
      
      final previousEndTime = _timeToMinutes(previous.timeTo);
      final suggestedStartTime = previousEndTime + requiredTravelTime;
      
      final currentStartTime = _timeToMinutes(current.timeFrom);
      final currentDuration = _timeToMinutes(current.timeTo) - currentStartTime;
      
      if (suggestedStartTime > currentStartTime) {
        // 需要調整開始時間
        final newStartTime = _minutesToTime(suggestedStartTime);
        final newEndTime = _minutesToTime(suggestedStartTime + currentDuration);
        
        adjustedActivities.add(current.copyWith(
          timeFrom: newStartTime,
          timeTo: newEndTime,
        ));
      } else {
        adjustedActivities.add(current);
      }
    }
    
    return adjustedActivities;
  }
  
  /// 計算總距離
  static double _calculateTotalDistance(List<Activity> activities) {
    double totalDistance = 0;
    
    for (int i = 0; i < activities.length - 1; i++) {
      final current = activities[i];
      final next = activities[i + 1];
      totalDistance += calculateDistance(current.lat, current.lng, next.lat, next.lng);
    }
    
    return totalDistance;
  }
  
  /// 計算總旅行時間
  static int _calculateTotalTravelTime(List<Activity> activities, TransportMode mode) {
    int totalTime = 0;
    
    for (int i = 0; i < activities.length - 1; i++) {
      final current = activities[i];
      final next = activities[i + 1];
      final distance = calculateDistance(current.lat, current.lng, next.lat, next.lng);
      totalTime += calculateTravelTime(distance, mode);
    }
    
    return totalTime;
  }
  
  /// 保持時間約束的最佳化
  static List<Activity> _optimizeWithTimeConstraints(
    List<Activity> activities,
    TransportMode transportMode,
  ) {
    // 按時間排序
    final sortedActivities = List<Activity>.from(activities)
      ..sort((a, b) => _timeToMinutes(a.timeFrom).compareTo(_timeToMinutes(b.timeFrom)));
    
    // 在相同時間段內進行局部最佳化
    final optimized = <Activity>[];
    var currentGroup = <Activity>[];
    
    for (final activity in sortedActivities) {
      if (currentGroup.isEmpty) {
        currentGroup.add(activity);
      } else {
        final lastActivity = currentGroup.last;
        final timeDiff = _timeToMinutes(activity.timeFrom) - _timeToMinutes(lastActivity.timeTo);
        
        if (timeDiff <= 30) { // 30分鐘內的活動視為同一組
          currentGroup.add(activity);
        } else {
          // 最佳化當前組
          if (currentGroup.length > 1) {
            optimized.addAll(_optimizeByDistance(currentGroup));
          } else {
            optimized.addAll(currentGroup);
          }
          currentGroup = [activity];
        }
      }
    }
    
    // 處理最後一組
    if (currentGroup.isNotEmpty) {
      if (currentGroup.length > 1) {
        optimized.addAll(_optimizeByDistance(currentGroup));
      } else {
        optimized.addAll(currentGroup);
      }
    }
    
    return optimized;
  }
  
  /// 基於距離的最佳化（最近鄰演算法）
  static List<Activity> _optimizeByDistance(List<Activity> activities) {
    if (activities.length <= 2) return activities;
    
    final optimized = <Activity>[];
    final remaining = List<Activity>.from(activities);
    
    // 從第一個活動開始
    var current = remaining.removeAt(0);
    optimized.add(current);
    
    while (remaining.isNotEmpty) {
      var nearestIndex = 0;
      var nearestDistance = double.infinity;
      
      for (int i = 0; i < remaining.length; i++) {
        final distance = calculateDistance(
          current.lat, current.lng,
          remaining[i].lat, remaining[i].lng,
        );
        
        if (distance < nearestDistance) {
          nearestDistance = distance;
          nearestIndex = i;
        }
      }
      
      current = remaining.removeAt(nearestIndex);
      optimized.add(current);
    }
    
    return optimized;
  }
  
  /// 將時間字串轉換為分鐘數
  static int _timeToMinutes(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return hour * 60 + minute;
  }
  
  /// 將分鐘數轉換為時間字串
  static String _minutesToTime(int minutes) {
    final hour = minutes ~/ 60;
    final minute = minutes % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
  
  /// 將度數轉換為弧度
  static double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }
}

/// 交通方式
enum TransportMode {
  walking('步行'),
  cycling('騎車'),
  driving('開車'),
  publicTransport('大眾運輸');
  
  const TransportMode(this.displayName);
  final String displayName;
}

/// 最佳化結果
class OptimizationResult {
  final List<Activity> optimizedActivities;
  final double totalDistance;
  final int totalTravelTime;
  final double improvementPercentage;
  final double? originalDistance;
  final int? originalTravelTime;
  
  const OptimizationResult({
    required this.optimizedActivities,
    required this.totalDistance,
    required this.totalTravelTime,
    required this.improvementPercentage,
    this.originalDistance,
    this.originalTravelTime,
  });
  
  /// 是否有改善
  bool get hasImprovement => improvementPercentage > 0;
  
  /// 格式化的改善描述
  String get improvementDescription {
    if (!hasImprovement) return '無需最佳化';
    
    return '減少 ${improvementPercentage.toStringAsFixed(1)}% 的總距離';
  }
}

/// 路線段
class RouteSegment {
  final Activity fromActivity;
  final Activity toActivity;
  final double distance;
  final int travelTime;
  final TransportMode transportMode;
  
  const RouteSegment({
    required this.fromActivity,
    required this.toActivity,
    required this.distance,
    required this.travelTime,
    required this.transportMode,
  });
  
  /// 格式化距離
  String get formattedDistance {
    if (distance < 1) {
      return '${(distance * 1000).round()}m';
    } else {
      return '${distance.toStringAsFixed(1)}km';
    }
  }
  
  /// 格式化旅行時間
  String get formattedTravelTime {
    if (travelTime < 60) {
      return '${travelTime}分鐘';
    } else {
      final hours = travelTime ~/ 60;
      final minutes = travelTime % 60;
      return '${hours}小時${minutes}分鐘';
    }
  }
}

/// 時間驗證結果
class TimeValidationResult {
  final bool isValid;
  final List<TimingIssue> issues;
  
  const TimeValidationResult({
    required this.isValid,
    required this.issues,
  });
}

/// 時間問題
class TimingIssue {
  final Activity fromActivity;
  final Activity toActivity;
  final int requiredTime;
  final int availableTime;
  final int shortfall;
  
  const TimingIssue({
    required this.fromActivity,
    required this.toActivity,
    required this.requiredTime,
    required this.availableTime,
    required this.shortfall,
  });
  
  /// 問題描述
  String get description {
    return '從「${fromActivity.name}」到「${toActivity.name}」需要 $requiredTime 分鐘，'
           '但只有 $availableTime 分鐘，不足 $shortfall 分鐘';
  }
}