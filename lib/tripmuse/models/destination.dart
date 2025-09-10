import 'package:freezed_annotation/freezed_annotation.dart';

part 'destination.freezed.dart';
part 'destination.g.dart';

/// 目的地資料模型
/// 
/// 代表旅行的目的地資訊，包含地理位置和相關詳細資訊
@freezed
class Destination with _$Destination {
  const factory Destination({
    /// 目的地名稱
    required String name,
    
    /// 城市名稱
    required String city,
    
    /// 國家名稱
    required String country,
    
    /// 緯度座標
    @Default(0.0) double lat,
    
    /// 經度座標
    @Default(0.0) double lng,
    
    /// Google Places ID
    String? placeId,
    
    /// 完整地址
    String? fullAddress,
    
    /// 時區
    String? timezone,
    
    /// 貨幣代碼
    String? currencyCode,
    
    /// 語言代碼
    String? languageCode,
    
    /// 目的地照片 URLs
    @Default([]) List<String> photos,
  }) = _Destination;

  factory Destination.fromJson(Map<String, dynamic> json) => _$DestinationFromJson(json);
}

/// Destination 擴展方法
extension DestinationExtension on Destination {
  /// 取得完整的目的地顯示名稱
  String get fullDisplayName {
    if (city == name) {
      return '$name, $country';
    }
    return '$name, $city, $country';
  }
  
  /// 取得簡短的顯示名稱
  String get shortDisplayName => '$city, $country';
  
  /// 檢查是否為國內目的地（台灣）
  bool get isDomestic => country.contains('台灣') || country.contains('Taiwan');
  
  /// 檢查是否有地理座標
  bool get hasCoordinates => lat != 0.0 && lng != 0.0;
  
  /// 取得座標字串
  String get coordinatesString => '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
}