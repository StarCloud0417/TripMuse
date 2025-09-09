import 'package:freezed_annotation/freezed_annotation.dart';
import 'destination.dart';
import 'enums.dart';

part 'trip_request.freezed.dart';
part 'trip_request.g.dart';

/// 行程生成請求資料模型
/// 
/// 用於向 API 發送行程生成請求的資料結構
@freezed
class TripRequest with _$TripRequest {
  const factory TripRequest({
    /// 請求唯一識別碼
    required String requestId,
    
    /// 請求時間戳記
    required DateTime timestamp,
    
    /// 使用者 ID（可為空，Guest 模式）
    String? userId,
    
    /// 目的地資訊
    required Destination destination,
    
    /// 旅行天數
    required int days,
    
    /// 開始日期
    required DateTime startDate,
    
    /// 結束日期
    required DateTime endDate,
    
    /// 旅行描述（使用者輸入的自然語言）
    required String travelDescription,
    
    /// 預算範圍
    BudgetRange? budget,
    
    /// 旅伴數量
    @Default(1) int groupSize,
    
    /// 旅行風格
    TravelStyle? travelStyle,
    
    /// 語言偏好
    @Default('zh-TW') String locale,
  }) = _TripRequest;

  factory TripRequest.fromJson(Map<String, dynamic> json) => _$TripRequestFromJson(json);
}

/// TripRequest 擴展方法
extension TripRequestExtension on TripRequest {
  /// 檢查請求是否有效
  bool get isValid {
    return destination.hasCoordinates &&
           days > 0 &&
           days <= 30 && // 最多 30 天
           travelDescription.trim().isNotEmpty &&
           startDate.isBefore(endDate);
  }
  
  /// 取得旅行持續時間描述
  String get durationDescription {
    if (days == 1) return '1 天';
    return '$days 天';
  }
  
  /// 取得旅伴描述
  String get groupDescription {
    switch (groupSize) {
      case 1:
        return '個人旅行';
      case 2:
        return '雙人旅行';
      default:
        return '$groupSize 人旅行';
    }
  }
  
  /// 取得預算描述
  String get budgetDescription {
    return budget?.displayName ?? '未指定';
  }
  
  /// 取得旅行風格描述
  String get styleDescription {
    return travelStyle?.displayName ?? '未指定';
  }
  
  /// 轉換為 API 請求格式
  Map<String, dynamic> toApiRequest() {
    return {
      'requestId': requestId,
      'timestamp': timestamp.toIso8601String(),
      'userId': userId,
      'tripRequest': {
        'destination': {
          'name': destination.name,
          'placeId': destination.placeId,
          'coordinates': {
            'lat': destination.lat,
            'lng': destination.lng,
          },
        },
        'duration': {
          'days': days,
          'startDate': startDate.toIso8601String().split('T')[0],
          'endDate': endDate.toIso8601String().split('T')[0],
        },
        'travelDescription': travelDescription,
        'basicPreferences': {
          'budget': budget?.name,
          'groupSize': groupSize,
          'travelStyle': travelStyle?.name,
        },
        'locale': locale,
      },
    };
  }
}