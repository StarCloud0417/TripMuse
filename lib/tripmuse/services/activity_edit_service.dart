/// TripMuse 活動編輯服務
///
/// 提供活動編輯、移動、刪除等操作的業務邏輯

import '../models/models.dart';

class ActivityEditService {
  /// 驗證活動時間範圍
  static bool validateTimeRange(String timeFrom, String timeTo) {
    try {
      final fromParts = timeFrom.split(':');
      final toParts = timeTo.split(':');
      
      if (fromParts.length != 2 || toParts.length != 2) return false;
      
      final fromHour = int.parse(fromParts[0]);
      final fromMinute = int.parse(fromParts[1]);
      final toHour = int.parse(toParts[0]);
      final toMinute = int.parse(toParts[1]);
      
      // 驗證時間格式
      if (fromHour < 0 || fromHour > 23 || toHour < 0 || toHour > 23) return false;
      if (fromMinute < 0 || fromMinute > 59 || toMinute < 0 || toMinute > 59) return false;
      
      // 驗證時間邏輯（結束時間必須晚於開始時間）
      final fromTotalMinutes = fromHour * 60 + fromMinute;
      final toTotalMinutes = toHour * 60 + toMinute;
      
      return toTotalMinutes > fromTotalMinutes;
    } catch (e) {
      return false;
    }
  }

  /// 檢查活動時間是否與其他活動衝突
  static bool checkTimeConflict(
    Activity activity,
    String newTimeFrom,
    String newTimeTo,
    List<Activity> otherActivities,
  ) {
    try {
      final newFromMinutes = _timeToMinutes(newTimeFrom);
      final newToMinutes = _timeToMinutes(newTimeTo);
      
      for (final other in otherActivities) {
        if (other.id == activity.id) continue; // 跳過自己
        
        final otherFromMinutes = _timeToMinutes(other.timeFrom);
        final otherToMinutes = _timeToMinutes(other.timeTo);
        
        // 檢查時間重疊
        if (newFromMinutes < otherToMinutes && newToMinutes > otherFromMinutes) {
          return true; // 有衝突
        }
      }
      
      return false; // 無衝突
    } catch (e) {
      return true; // 發生錯誤時假設有衝突
    }
  }

  /// 更新活動時間
  static Activity updateActivityTime(
    Activity activity,
    String newTimeFrom,
    String newTimeTo,
  ) {
    return activity.copyWith(
      timeFrom: newTimeFrom,
      timeTo: newTimeTo,
    );
  }

  /// 從日程中移除活動
  static DayPlan removeActivityFromDay(DayPlan dayPlan, String activityId) {
    final updatedActivities = dayPlan.activities
        .where((activity) => activity.id != activityId)
        .toList();
    
    return dayPlan.copyWith(activities: updatedActivities);
  }

  /// 向日程添加活動
  static DayPlan addActivityToDay(DayPlan dayPlan, Activity activity) {
    final updatedActivities = List<Activity>.from(dayPlan.activities)
      ..add(activity);
    
    // 按時間排序
    updatedActivities.sort((a, b) => _timeToMinutes(a.timeFrom).compareTo(_timeToMinutes(b.timeFrom)));
    
    return dayPlan.copyWith(activities: updatedActivities);
  }

  /// 在日程中移動活動位置
  static DayPlan moveActivityInDay(
    DayPlan dayPlan,
    String activityId,
    int newIndex,
  ) {
    final activities = List<Activity>.from(dayPlan.activities);
    final activityIndex = activities.indexWhere((a) => a.id == activityId);
    
    if (activityIndex == -1 || newIndex < 0 || newIndex >= activities.length) {
      return dayPlan; // 無效操作，返回原始狀態
    }
    
    final activity = activities.removeAt(activityIndex);
    activities.insert(newIndex, activity);
    
    return dayPlan.copyWith(activities: activities);
  }

  /// 替換活動
  static DayPlan replaceActivity(
    DayPlan dayPlan,
    String oldActivityId,
    Activity newActivity,
  ) {
    final activities = dayPlan.activities.map((activity) {
      if (activity.id == oldActivityId) {
        return newActivity;
      }
      return activity;
    }).toList();
    
    return dayPlan.copyWith(activities: activities);
  }

  /// 自動調整活動時間以避免衝突
  static List<Activity> autoAdjustActivityTimes(List<Activity> activities) {
    if (activities.isEmpty) return activities;
    
    final sortedActivities = List<Activity>.from(activities)
      ..sort((a, b) => _timeToMinutes(a.timeFrom).compareTo(_timeToMinutes(b.timeFrom)));
    
    final adjustedActivities = <Activity>[];
    
    for (int i = 0; i < sortedActivities.length; i++) {
      final activity = sortedActivities[i];
      
      if (i == 0) {
        // 第一個活動不需要調整
        adjustedActivities.add(activity);
      } else {
        final previousActivity = adjustedActivities[i - 1];
        final previousEndMinutes = _timeToMinutes(previousActivity.timeTo);
        final currentStartMinutes = _timeToMinutes(activity.timeFrom);
        
        if (currentStartMinutes < previousEndMinutes) {
          // 有衝突，調整當前活動的開始時間
          final newStartTime = _minutesToTime(previousEndMinutes);
          final duration = _timeToMinutes(activity.timeTo) - _timeToMinutes(activity.timeFrom);
          final newEndTime = _minutesToTime(previousEndMinutes + duration);
          
          adjustedActivities.add(activity.copyWith(
            timeFrom: newStartTime,
            timeTo: newEndTime,
          ));
        } else {
          adjustedActivities.add(activity);
        }
      }
    }
    
    return adjustedActivities;
  }

  /// 計算活動間的建議間隔時間
  static int calculateRecommendedGap(Activity fromActivity, Activity toActivity) {
    // 根據活動類型和距離計算建議間隔
    // 這裡簡化為固定15分鐘間隔
    return 15;
  }

  /// 驗證活動編輯的完整性
  static ValidationResult validateActivityEdit(
    Activity originalActivity,
    Activity editedActivity,
    List<Activity> dayActivities,
  ) {
    final errors = <String>[];
    
    // 檢查必填欄位
    if (editedActivity.name.trim().isEmpty) {
      errors.add('活動名稱不能為空');
    }
    
    if (editedActivity.description.trim().isEmpty) {
      errors.add('活動描述不能為空');
    }
    
    // 檢查時間格式
    if (!validateTimeRange(editedActivity.timeFrom, editedActivity.timeTo)) {
      errors.add('時間設定無效');
    }
    
    // 檢查時間衝突
    if (checkTimeConflict(originalActivity, editedActivity.timeFrom, editedActivity.timeTo, dayActivities)) {
      errors.add('時間與其他活動衝突');
    }
    
    // 檢查座標有效性
    if (editedActivity.lat < -90 || editedActivity.lat > 90) {
      errors.add('緯度座標無效');
    }
    
    if (editedActivity.lng < -180 || editedActivity.lng > 180) {
      errors.add('經度座標無效');
    }
    
    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
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
}

/// 驗證結果類別
class ValidationResult {
  final bool isValid;
  final List<String> errors;

  const ValidationResult({
    required this.isValid,
    required this.errors,
  });
}