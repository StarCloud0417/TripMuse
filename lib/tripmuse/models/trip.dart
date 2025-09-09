import 'package:freezed_annotation/freezed_annotation.dart';
import 'destination.dart';
import 'day_plan.dart';
import 'user_preference_analysis.dart';

part 'trip.freezed.dart';
part 'trip.g.dart';

/// 行程資料模型
///
/// 代表完整的旅行行程，包含目的地、每日計畫和使用者偏好分析
@freezed
class Trip with _$Trip {
  const factory Trip({
    /// 行程唯一識別碼
    required String id,

    /// 行程標題
    required String title,

    /// 目的地資訊
    required Destination destination,

    /// 每日行程計畫
    @Default([]) List<DayPlan> days,

    /// 使用者偏好分析
    UserPreferenceAnalysis? preferenceAnalysis,

    /// 建立時間
    required DateTime createdAt,

    /// 最後更新時間
    required DateTime updatedAt,

    /// 使用者 ID（可為空，Guest 模式）
    String? userId,

    /// 生成此行程的 AI 模型
    String? generatedBy,

    /// 行程狀態
    @Default(TripStatus.draft) TripStatus status,

    /// 行程備註
    String? notes,

    /// 是否為收藏
    @Default(false) bool isFavorite,

    /// 分享設定
    TripSharingSettings? sharingSettings,
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
}

/// 行程狀態
enum TripStatus {
  draft('草稿'),
  active('進行中'),
  completed('已完成'),
  archived('已封存');

  const TripStatus(this.displayName);
  final String displayName;
}

/// 行程分享設定
@freezed
class TripSharingSettings with _$TripSharingSettings {
  const factory TripSharingSettings({
    /// 是否啟用分享
    @Default(false) bool isEnabled,

    /// 分享 Token
    String? shareToken,

    /// 分享連結過期時間
    DateTime? expiresAt,

    /// 分享建立時間
    DateTime? createdAt,
  }) = _TripSharingSettings;

  factory TripSharingSettings.fromJson(Map<String, dynamic> json) =>
      _$TripSharingSettingsFromJson(json);
}

/// Trip 擴展方法
extension TripExtension on Trip {
  /// 取得行程總天數
  int get totalDays => days.length;

  /// 取得行程總活動數
  int get totalActivities =>
      days.fold(0, (sum, day) => sum + day.activityCount);

  /// 取得行程開始日期
  DateTime? get startDate => days.isNotEmpty ? days.first.date : null;

  /// 取得行程結束日期
  DateTime? get endDate => days.isNotEmpty ? days.last.date : null;

  /// 取得行程持續時間描述
  String get durationDescription {
    if (totalDays == 1) return '1 天';
    return '$totalDays 天';
  }

  /// 檢查行程是否為進行中
  bool get isActive => status == TripStatus.active;

  /// 檢查行程是否已完成
  bool get isCompleted => status == TripStatus.completed;

  /// 檢查行程是否為草稿
  bool get isDraft => status == TripStatus.draft;

  /// 檢查是否有偏好分析
  bool get hasPreferenceAnalysis => preferenceAnalysis != null;

  /// 檢查是否可以分享
  bool get canShare =>
      sharingSettings?.isEnabled == true && sharingSettings?.shareToken != null;

  /// 取得分享連結是否過期
  bool get isShareExpired {
    final expiresAt = sharingSettings?.expiresAt;
    return expiresAt != null && DateTime.now().isAfter(expiresAt);
  }

  /// 取得格式化的建立時間
  String get formattedCreatedAt {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} 天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} 小時前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} 分鐘前';
    } else {
      return '剛剛';
    }
  }

  /// 取得行程摘要
  String get summary {
    final buffer = StringBuffer();
    buffer.write(destination.shortDisplayName);
    buffer.write(' • ');
    buffer.write(durationDescription);

    if (totalActivities > 0) {
      buffer.write(' • ');
      buffer.write('$totalActivities 個景點');
    }

    return buffer.toString();
  }

  /// 根據日期索引取得特定日期的行程
  DayPlan? getDayPlan(int dayIndex) {
    try {
      return days.firstWhere((day) => day.dayIndex == dayIndex);
    } catch (e) {
      return null;
    }
  }

  /// 檢查是否有指定日期的行程
  bool hasDayPlan(int dayIndex) => getDayPlan(dayIndex) != null;
}
