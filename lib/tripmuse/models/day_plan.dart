import 'package:freezed_annotation/freezed_annotation.dart';
import 'activity.dart';
import 'transport_info.dart';
import 'enums.dart';

part 'day_plan.freezed.dart';
part 'day_plan.g.dart';

/// 每日行程計畫資料模型
///
/// 代表旅行中的單日行程，包含該日的主題和所有活動
@freezed
class DayPlan with _$DayPlan {
  const factory DayPlan({
    /// 日期索引 (從 1 開始)
    required int dayIndex,

    /// 日期
    required DateTime date,

    /// 當日主題
    required String theme,

    /// 當日活動列表
    @Default([]) List<Activity> activities,

    /// 活動之間的交通信息 (索引對應活動間的交通，如 [0] 是第一個活動到第二個活動的交通)
    @Default([]) List<TransportInfo> transports,

    /// 當日備註
    String? notes,

    /// 預估總花費
    String? estimatedTotalCost,
  }) = _DayPlan;

  factory DayPlan.fromJson(Map<String, dynamic> json) =>
      _$DayPlanFromJson(json);
}

/// DayPlan 擴展方法
extension DayPlanExtension on DayPlan {
  /// 取得當日活動總數
  int get activityCount => activities.length;

  /// 取得當日美食活動數量
  int get foodActivityCount => activities.where((a) => a.isFood).length;

  /// 取得當日高優先級活動數量
  int get highPriorityActivityCount =>
      activities.where((a) => a.isHighPriority).length;

  /// 取得當日第一個活動的開始時間
  String? get startTime =>
      activities.isNotEmpty ? activities.first.timeFrom : null;

  /// 取得當日最後一個活動的結束時間
  String? get endTime => activities.isNotEmpty ? activities.last.timeTo : null;

  /// 取得格式化的日期字串
  String get formattedDate {
    final months = [
      '一月',
      '二月',
      '三月',
      '四月',
      '五月',
      '六月',
      '七月',
      '八月',
      '九月',
      '十月',
      '十一月',
      '十二月'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  /// 取得星期幾
  String get weekday {
    const weekdays = ['週一', '週二', '週三', '週四', '週五', '週六', '週日'];
    return weekdays[date.weekday - 1];
  }

  /// 檢查是否有活動
  bool get hasActivities => activities.isNotEmpty;

  /// 取得活動按類別分組
  Map<ActivityCategory, List<Activity>> get activitiesByCategory {
    final Map<ActivityCategory, List<Activity>> grouped = {};
    for (final activity in activities) {
      grouped.putIfAbsent(activity.category, () => []).add(activity);
    }
    return grouped;
  }

  /// 取得指定活動索引之後的交通信息
  TransportInfo? getTransportAfter(int activityIndex) {
    if (activityIndex >= 0 && activityIndex < transports.length) {
      return transports[activityIndex];
    }
    return null;
  }

  /// 檢查是否有交通信息
  bool get hasTransports => transports.isNotEmpty;

  /// 取得總通勤時間（分鐘）
  int get totalTransportDuration {
    return transports.fold(0, (sum, transport) => sum + transport.durationMinutes);
  }
}
