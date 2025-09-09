import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'user_preference_analysis.freezed.dart';
part 'user_preference_analysis.g.dart';

/// 使用者偏好分析資料模型
/// 
/// 由 LLM 分析使用者的旅行描述後產生的偏好分析結果
@freezed
class UserPreferenceAnalysis with _$UserPreferenceAnalysis {
  const factory UserPreferenceAnalysis({
    /// 主要關注重點
    required String primaryFocus,
    
    /// 旅行節奏
    required TravelPace travelPace,
    
    /// 興趣列表
    @Default([]) List<String> interests,
    
    /// 要避免的事項
    @Default([]) List<String> avoidances,
    
    /// 旅行情調/氛圍
    required String mood,
    
    /// 關鍵字列表
    @Default([]) List<String> keywords,
    
    /// 分析信心度 (0.0 - 1.0)
    @Default(0.0) double confidence,
    
    /// 分析時間戳記
    DateTime? analyzedAt,
  }) = _UserPreferenceAnalysis;

  factory UserPreferenceAnalysis.fromJson(Map<String, dynamic> json) => 
    _$UserPreferenceAnalysisFromJson(json);
}

/// UserPreferenceAnalysis 擴展方法
extension UserPreferenceAnalysisExtension on UserPreferenceAnalysis {
  /// 檢查是否偏好美食
  bool get prefersFoodExperience => 
    interests.any((interest) => 
      interest.contains('美食') || 
      interest.contains('小吃') || 
      interest.contains('餐廳'));
  
  /// 檢查是否偏好文化體驗
  bool get prefersCulturalExperience => 
    interests.any((interest) => 
      interest.contains('文化') || 
      interest.contains('歷史') || 
      interest.contains('博物館'));
  
  /// 檢查是否偏好自然景觀
  bool get prefersNatureExperience => 
    interests.any((interest) => 
      interest.contains('自然') || 
      interest.contains('山') || 
      interest.contains('海'));
  
  /// 檢查是否偏好購物
  bool get prefersShoppingExperience => 
    interests.any((interest) => 
      interest.contains('購物') || 
      interest.contains('市場') || 
      interest.contains('商店'));
  
  /// 檢查是否為放鬆型旅行
  bool get isRelaxedTravel => travelPace == TravelPace.slow;
  
  /// 檢查是否避免人群
  bool get avoidsCrowds => 
    avoidances.any((avoidance) => 
      avoidance.contains('人群') || 
      avoidance.contains('擁擠') || 
      avoidance.contains('排隊'));
  
  /// 取得偏好摘要
  String get preferenceSummary {
    final buffer = StringBuffer();
    buffer.write('主要關注：$primaryFocus');
    
    if (interests.isNotEmpty) {
      buffer.write('，興趣：${interests.take(3).join('、')}');
    }
    
    buffer.write('，節奏：${travelPace.displayName}');
    
    return buffer.toString();
  }
  
  /// 檢查分析結果是否可信
  bool get isReliable => confidence >= 0.7;
}