/// 旅程進度計算器
/// 
/// 根據用戶位置和行程安排計算旅程進度

import 'package:geolocator/geolocator.dart';
import '../models/models.dart';

/// 旅程進度計算器
class TripProgressCalculator {
  /// 計算旅程進度
  static TripProgress? calculateTripProgress(Trip trip, Position? userPosition) {
    if (userPosition == null || trip.days.isEmpty) return null;
    
    // 獲取當前日期
    final now = DateTime.now();
    final tripStartDate = trip.startDate ?? DateTime.now();
    final daysSinceStart = now.difference(tripStartDate).inDays;
    
    // 確定當前是第幾天
    int currentDay = (daysSinceStart + 1).clamp(1, trip.days.length);
    
    // 如果行程還沒開始
    if (daysSinceStart < 0) {
      currentDay = 1;
    }
    
    // 如果行程已結束
    if (daysSinceStart >= trip.days.length) {
      return TripProgress(
        currentDay: trip.days.length,
        overallProgress: 1.0,
        dayProgress: 1.0,
        isCompleted: true,
      );
    }
    
    final currentDayPlan = trip.days[currentDay - 1];
    
    // 找到最近的活動
    Activity? nearestActivity;
    double? minDistance;
    
    for (final activity in currentDayPlan.activities) {
      final distance = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        activity.lat,
        activity.lng,
      );
      
      if (minDistance == null || distance < minDistance) {
        minDistance = distance;
        nearestActivity = activity;
      }
    }
    
    // 確定當前活動和下一個活動
    Activity? currentActivity;
    Activity? nextActivity;
    
    if (nearestActivity != null) {
      final currentActivityIndex = currentDayPlan.activities.indexOf(nearestActivity);
      
      // 如果距離很近（100米內），認為是當前活動
      if (minDistance != null && minDistance <= 100) {
        currentActivity = nearestActivity;
        
        // 找下一個活動
        if (currentActivityIndex < currentDayPlan.activities.length - 1) {
          nextActivity = currentDayPlan.activities[currentActivityIndex + 1];
        } else if (currentDay < trip.days.length) {
          // 下一天的第一個活動
          final nextDayPlan = trip.days[currentDay];
          if (nextDayPlan.activities.isNotEmpty) {
            nextActivity = nextDayPlan.activities.first;
          }
        }
      } else {
        // 距離較遠，認為正在前往該活動
        nextActivity = nearestActivity;
      }
    }
    
    // 計算當日進度
    double dayProgress = 0.0;
    if (currentActivity != null) {
      final activityIndex = currentDayPlan.activities.indexOf(currentActivity);
      dayProgress = (activityIndex + 1) / currentDayPlan.activities.length;
    }
    
    // 計算整體進度
    final completedDays = currentDay - 1;
    final totalDays = trip.days.length;
    double overallProgress = (completedDays + dayProgress) / totalDays;
    
    // 計算到下一個活動的距離
    double? distanceToNext;
    if (nextActivity != null) {
      distanceToNext = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        nextActivity.lat,
        nextActivity.lng,
      );
    }
    
    // 估算到達時間（假設步行速度 5km/h）
    String? estimatedArrivalTime;
    if (distanceToNext != null) {
      final walkingSpeedKmh = 5.0;
      final timeInHours = (distanceToNext / 1000) / walkingSpeedKmh;
      final timeInMinutes = (timeInHours * 60).round();
      
      if (timeInMinutes < 60) {
        estimatedArrivalTime = '約 $timeInMinutes 分鐘';
      } else {
        final hours = timeInMinutes ~/ 60;
        final minutes = timeInMinutes % 60;
        estimatedArrivalTime = '約 $hours 小時 $minutes 分鐘';
      }
    }
    
    return TripProgress(
      currentDay: currentDay,
      overallProgress: overallProgress.clamp(0.0, 1.0),
      dayProgress: dayProgress.clamp(0.0, 1.0),
      currentActivity: currentActivity,
      nextActivity: nextActivity,
      isCompleted: overallProgress >= 1.0,
      distanceToNext: distanceToNext,
      estimatedArrivalTime: estimatedArrivalTime,
    );
  }
  
  /// 計算活動完成狀態
  static bool isActivityCompleted(Activity activity, Position userPosition) {
    final distance = Geolocator.distanceBetween(
      userPosition.latitude,
      userPosition.longitude,
      activity.lat,
      activity.lng,
    );
    
    // 如果在50米內，認為已完成該活動
    return distance <= 50;
  }
  
  /// 獲取行程統計資訊
  static Map<String, dynamic> getTripStatistics(Trip trip, Position? userPosition) {
    final totalActivities = trip.days.expand((day) => day.activities).length;
    int completedActivities = 0;
    
    if (userPosition != null) {
      for (final day in trip.days) {
        for (final activity in day.activities) {
          if (isActivityCompleted(activity, userPosition)) {
            completedActivities++;
          }
        }
      }
    }
    
    return {
      'totalDays': trip.days.length,
      'totalActivities': totalActivities,
      'completedActivities': completedActivities,
      'completionRate': totalActivities > 0 ? completedActivities / totalActivities : 0.0,
    };
  }
}