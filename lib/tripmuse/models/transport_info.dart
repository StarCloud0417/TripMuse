import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'transport_info.freezed.dart';
part 'transport_info.g.dart';

/// 交通資訊模型
/// 
/// 代表兩個活動之間的交通方式和通勤時間
@freezed
class TransportInfo with _$TransportInfo {
  const factory TransportInfo({
    /// 交通方式
    required TransportMode mode,
    
    /// 通勤時間（分鐘）
    required int durationMinutes,
    
    /// 距離（公尺）
    int? distanceMeters,
    
    /// 預估費用
    String? estimatedCost,
    
    /// 路線描述
    String? routeDescription,
  }) = _TransportInfo;

  factory TransportInfo.fromJson(Map<String, dynamic> json) => 
      _$TransportInfoFromJson(json);
}

/// TransportInfo 擴展方法
extension TransportInfoExtension on TransportInfo {
  /// 取得格式化的通勤時間
  String get formattedDuration {
    if (durationMinutes < 60) {
      return '$durationMinutes 分鐘';
    } else {
      final hours = durationMinutes ~/ 60;
      final minutes = durationMinutes % 60;
      if (minutes == 0) {
        return '$hours 小時';
      } else {
        return '$hours 小時 $minutes 分鐘';
      }
    }
  }
  
  /// 取得格式化的距離
  String get formattedDistance {
    if (distanceMeters == null) return '';
    
    if (distanceMeters! < 1000) {
      return '$distanceMeters 公尺';
    } else {
      final km = (distanceMeters! / 1000).toStringAsFixed(1);
      return '$km 公里';
    }
  }
  
  /// 取得交通方式的圖標
  String get modeIcon {
    switch (mode) {
      case TransportMode.walking:
        return '🚶';
      case TransportMode.driving:
        return '🚗';
      case TransportMode.transit:
        return '🚌';
      case TransportMode.cycling:
        return '🚴';
      case TransportMode.taxi:
        return '🚕';
      case TransportMode.metro:
        return '🚇';
    }
  }
  
  /// 取得交通方式的顯示名稱
  String get modeName {
    switch (mode) {
      case TransportMode.walking:
        return '步行';
      case TransportMode.driving:
        return '開車';
      case TransportMode.transit:
        return '大眾運輸';
      case TransportMode.cycling:
        return '騎車';
      case TransportMode.taxi:
        return '計程車';
      case TransportMode.metro:
        return '地鐵';
    }
  }
}