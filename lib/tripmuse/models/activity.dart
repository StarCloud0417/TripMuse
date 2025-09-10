import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

/// 活動/景點資料模型
/// 
/// 代表行程中的單一活動或景點，包含位置、時間、描述等完整資訊
@freezed
class Activity with _$Activity {
  const factory Activity({
    /// 活動唯一識別碼
    required String id,
    
    /// 活動名稱
    required String name,
    
    /// 活動描述
    required String description,
    
    /// 緯度座標
    @Default(0.0) double lat,
    
    /// 經度座標
    @Default(0.0) double lng,
    
    /// 開始時間 (HH:mm 格式)
    required String timeFrom,
    
    /// 結束時間 (HH:mm 格式)
    required String timeTo,
    
    /// 活動類別
    required ActivityCategory category,
    
    /// 活動優先級
    required ActivityPriority priority,
    
    /// 預估花費
    String? estimatedCost,
    
    /// 旅行小貼士
    String? tips,
    
    /// 地點照片 URLs
    @Default([]) List<String> photos,
    
    /// Google Places ID
    String? placeId,
    
    /// 地址
    String? address,
    
    /// 評分 (1-5)
    double? rating,
    
    /// 建議停留時間（分鐘）
    int? suggestedDurationMinutes,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);
}

/// Activity 擴展方法
extension ActivityExtension on Activity {
  /// 取得活動持續時間（分鐘）
  int get durationMinutes {
    try {
      final fromParts = timeFrom.split(':');
      final toParts = timeTo.split(':');
      
      final fromMinutes = int.parse(fromParts[0]) * 60 + int.parse(fromParts[1]);
      final toMinutes = int.parse(toParts[0]) * 60 + int.parse(toParts[1]);
      
      return toMinutes - fromMinutes;
    } catch (e) {
      return suggestedDurationMinutes ?? 60; // 預設 1 小時
    }
  }
  
  /// 檢查是否為美食活動
  bool get isFood => category == ActivityCategory.food;
  
  /// 檢查是否為高優先級活動
  bool get isHighPriority => priority == ActivityPriority.high;
  
  /// 取得格式化的時間範圍
  String get timeRange => '$timeFrom - $timeTo';
}