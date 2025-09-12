import 'dart:math' as math;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/tripmuse/models/models.dart';

/// 地理座標驗證和處理工具類
/// 
/// 提供座標驗證、距離計算、邊界檢查等功能
class CoordinateValidator {
  // 地球半徑 (公里)
  static const double _earthRadiusKm = 6371.0;
  
  // 台灣地理邊界 (大致範圍)
  static const double _taiwanMinLat = 21.5;
  static const double _taiwanMaxLat = 25.5;
  static const double _taiwanMinLng = 119.5;
  static const double _taiwanMaxLng = 122.5;
  
  // 合理的座標範圍
  static const double _minLatitude = -90.0;
  static const double _maxLatitude = 90.0;
  static const double _minLongitude = -180.0;
  static const double _maxLongitude = 180.0;

  /// 驗證座標是否有效 (改進版)
  /// [lat] 緯度
  /// [lng] 經度
  /// [strict] 是否使用嚴格模式 (檢查台灣範圍)
  static bool isValidCoordinate(double? lat, double? lng, {bool strict = false}) {
    // 空值檢查
    if (lat == null || lng == null) {
      print('❌ 座標驗證失敗: 空值 (lat: $lat, lng: $lng)');
      return false;
    }

    // NaN 檢查
    if (lat.isNaN || lng.isNaN) {
      print('❌ 座標驗證失敗: NaN 值 (lat: $lat, lng: $lng)');
      return false;
    }

    // 放寬的基本範圍檢查 (允許邊界情況)
    if (lat < _minLatitude - 0.1 || lat > _maxLatitude + 0.1) {
      print('❌ 座標驗證失敗: 緯度超出範圍 (lat: $lat, 允許範圍: ${_minLatitude - 0.1} ~ ${_maxLatitude + 0.1})');
      return false;
    }
    if (lng < _minLongitude - 0.1 || lng > _maxLongitude + 0.1) {
      print('❌ 座標驗證失敗: 經度超出範圍 (lng: $lng, 允許範圍: ${_minLongitude - 0.1} ~ ${_maxLongitude + 0.1})');
      return false;
    }

    // 檢查是否為零座標 (通常是無效的)
    if (lat.abs() < 0.0001 && lng.abs() < 0.0001) {
      print('❌ 座標驗證失敗: 零座標 (lat: $lat, lng: $lng)');
      return false;
    }

    // 嚴格模式：檢查是否在台灣範圍內
    if (strict) {
      final inTaiwan = isInTaiwan(lat, lng);
      if (!inTaiwan) {
        print('⚠️ 座標在台灣範圍外 (lat: $lat, lng: $lng)');
      }
      return inTaiwan;
    }

    print('✅ 座標驗證通過 (lat: $lat, lng: $lng)');
    return true;
  }

  /// 檢查座標是否在台灣範圍內
  static bool isInTaiwan(double lat, double lng) {
    return lat >= _taiwanMinLat && 
           lat <= _taiwanMaxLat && 
           lng >= _taiwanMinLng && 
           lng <= _taiwanMaxLng;
  }

  /// 清理和標準化座標
  /// [lat] 緯度
  /// [lng] 經度
  /// 返回清理後的座標，如果無效則返回 null
  static Point? sanitizeCoordinate(double? lat, double? lng) {
    if (lat == null || lng == null) {
      print('⚠️ 座標清理: 空值輸入 (lat: $lat, lng: $lng)');
      return null;
    }

    if (lat.isNaN || lng.isNaN) {
      print('⚠️ 座標清理: NaN 值輸入 (lat: $lat, lng: $lng)');
      return null;
    }

    // 修剪到合理的小數位數 (避免過度精確)
    final sanitizedLat = double.parse(lat.toStringAsFixed(6));
    final sanitizedLng = double.parse(lng.toStringAsFixed(6));

    print('🧹 座標清理: ($lat, $lng) -> ($sanitizedLat, $sanitizedLng)');
    return Point(coordinates: Position(sanitizedLng, sanitizedLat));
  }

  /// 驗證座標列表並過濾無效座標
  /// [coordinates] 座標列表
  /// [strict] 是否使用嚴格模式
  /// 返回有效的座標列表
  static List<Point> validateAndFilterCoordinates(
    List<Point?> coordinates, {
    bool strict = false,
  }) {
    final validCoordinates = <Point>[];

    print('🔍 開始驗證 ${coordinates.length} 個座標...');

    for (final coord in coordinates) {
      if (coord == null) {
        print('⚠️ 跳過空座標');
        continue;
      }

      final position = coord.coordinates;
      final sanitized = sanitizeCoordinate(position.lat.toDouble(), position.lng.toDouble());
      if (sanitized == null) {
        print('⚠️ 座標清理失敗: (${position.lat}, ${position.lng})');
        continue;
      }

      if (isValidCoordinate(position.lat.toDouble(), position.lng.toDouble(), strict: strict)) {
        validCoordinates.add(sanitized);
      } else {
        print('❌ 座標驗證失敗: (${position.lat}, ${position.lng})');
      }
    }

    print('✅ 驗證完成: ${validCoordinates.length}/${coordinates.length} 個有效座標');
    return validCoordinates;
  }

  /// 從活動列表中提取並驗證座標
  /// [activities] 活動列表
  /// [strict] 是否使用嚴格模式
  /// 返回有效的座標列表和無效活動的列表
  static CoordinateValidationResult extractAndValidateActivityCoordinates(
    List<Activity> activities, {
    bool strict = false,
  }) {
    final validCoordinates = <Point>[];
    final invalidActivities = <Activity>[];

    print('🔍 開始驗證 ${activities.length} 個活動的座標...');

    for (final activity in activities) {
      // 檢查活動是否有有效座標
      if (activity.lat == 0.0 && activity.lng == 0.0) {
        print('⚠️ 活動 "${activity.name}" 缺少座標資訊');
        invalidActivities.add(activity);
        continue;
      }

      final sanitized = sanitizeCoordinate(activity.lat, activity.lng);
      if (sanitized == null) {
        print('⚠️ 活動 "${activity.name}" 座標清理失敗: (${activity.lat}, ${activity.lng})');
        invalidActivities.add(activity);
        continue;
      }

      if (isValidCoordinate(activity.lat, activity.lng, strict: strict)) {
        validCoordinates.add(sanitized);
        print('✅ 活動 "${activity.name}" 座標驗證通過: (${activity.lat}, ${activity.lng})');
      } else {
        print('❌ 活動 "${activity.name}" 座標驗證失敗: (${activity.lat}, ${activity.lng})');
        invalidActivities.add(activity);
      }
    }

    print('✅ 活動座標驗證完成: ${validCoordinates.length}/${activities.length} 個有效座標');
    return CoordinateValidationResult(
      validCoordinates: validCoordinates,
      invalidActivities: invalidActivities,
    );
  }

  /// 計算兩點間的距離 (公里)
  /// 使用 Haversine 公式
  static double calculateDistance(
    double lat1, double lng1, 
    double lat2, double lng2
  ) {
    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);
    
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) *
        math.sin(dLng / 2) * math.sin(dLng / 2);
    
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    
    return _earthRadiusKm * c;
  }

  /// 驗證座標與參考點的距離是否合理
  /// [coordinate] 要驗證的座標
  /// [reference] 參考座標
  /// [maxDistanceKm] 最大允許距離 (公里)
  static bool isWithinReasonableDistance(
    PlaceLocation coordinate,
    PlaceLocation reference,
    double maxDistanceKm,
  ) {
    final distance = calculateDistance(
      coordinate.lat, coordinate.lng,
      reference.lat, reference.lng,
    );
    
    return distance <= maxDistanceKm;
  }

  /// 驗證活動座標的合理性
  /// [activity] 活動資料
  /// [destinationCenter] 目的地中心點
  /// [maxDistanceKm] 最大允許距離 (預設 100 公里)
  static ValidationResult validateActivityCoordinate(
    Activity activity,
    PlaceLocation? destinationCenter, {
    double maxDistanceKm = 100.0,
  }) {
    // 檢查活動是否有有效座標 (預設值 0.0 表示未設定)
    if (activity.lat == 0.0 && activity.lng == 0.0) {
      return ValidationResult(
        isValid: false,
        reason: '活動缺少座標資訊',
        severity: ValidationSeverity.warning,
      );
    }

    final lat = activity.lat;
    final lng = activity.lng;

    // 基本座標驗證
    if (!isValidCoordinate(lat, lng)) {
      return ValidationResult(
        isValid: false,
        reason: '座標格式無效: ($lat, $lng)',
        severity: ValidationSeverity.error,
      );
    }

    // 如果有目的地中心點，檢查距離
    if (destinationCenter != null) {
      final distance = calculateDistance(
        lat, lng,
        destinationCenter.lat, destinationCenter.lng,
      );

      if (distance > maxDistanceKm) {
        return ValidationResult(
          isValid: false,
          reason: '活動距離目的地過遠: ${distance.toStringAsFixed(1)} 公里',
          severity: ValidationSeverity.warning,
          suggestedAction: '建議重新搜尋或驗證地點資訊',
        );
      }
    }

    return ValidationResult(
      isValid: true,
      reason: '座標驗證通過',
      severity: ValidationSeverity.info,
    );
  }

  /// 批量驗證行程中所有活動的座標
  /// [trip] 行程資料
  /// [maxDistanceKm] 最大允許距離
  static List<ActivityValidationResult> validateTripCoordinates(
    Trip trip, {
    double maxDistanceKm = 100.0,
  }) {
    final results = <ActivityValidationResult>[];
    final destinationCenter = PlaceLocation(
      lat: trip.destination.lat,
      lng: trip.destination.lng,
    );

    for (final day in trip.days) {
      for (final activity in day.activities) {
        final validation = validateActivityCoordinate(
          activity,
          destinationCenter,
          maxDistanceKm: maxDistanceKm,
        );

        results.add(ActivityValidationResult(
          dayIndex: day.dayIndex,
          activity: activity,
          validation: validation,
        ));
      }
    }

    return results;
  }

  /// 尋找座標異常的活動
  /// [validationResults] 驗證結果列表
  static List<ActivityValidationResult> findAnomalousActivities(
    List<ActivityValidationResult> validationResults,
  ) {
    return validationResults
        .where((result) => !result.validation.isValid)
        .toList();
  }

  /// 計算行程的地理中心點
  /// [activities] 活動列表
  static PlaceLocation? calculateGeographicCenter(List<Activity> activities) {
    final validActivities = activities
        .where((activity) => isValidCoordinate(activity.lat, activity.lng))
        .toList();

    if (validActivities.isEmpty) return null;

    double totalLat = 0.0;
    double totalLng = 0.0;

    for (final activity in validActivities) {
      totalLat += activity.lat;
      totalLng += activity.lng;
    }

    return PlaceLocation(
      lat: totalLat / validActivities.length,
      lng: totalLng / validActivities.length,
    );
  }

  /// 建議座標修正
  /// [invalidActivity] 無效座標的活動
  /// [validActivities] 有效座標的活動列表
  static PlaceLocation? suggestCoordinateCorrection(
    Activity invalidActivity,
    List<Activity> validActivities,
  ) {
    if (validActivities.isEmpty) return null;

    // 尋找名稱相似的活動
    final similarActivities = validActivities.where((activity) {
      return _calculateNameSimilarity(
        invalidActivity.name.toLowerCase(),
        activity.name.toLowerCase(),
      ) > 0.5;
    }).toList();

    if (similarActivities.isNotEmpty) {
      // 使用最相似活動的座標
      return PlaceLocation(
        lat: similarActivities.first.lat,
        lng: similarActivities.first.lng,
      );
    }

    // 使用地理中心點
    return calculateGeographicCenter(validActivities);
  }

  /// 轉換角度為弧度
  static double _toRadians(double degrees) {
    return degrees * (math.pi / 180.0);
  }

  /// 計算字串相似度 (簡單的 Jaccard 相似度)
  static double _calculateNameSimilarity(String name1, String name2) {
    final words1 = name1.split(' ').toSet();
    final words2 = name2.split(' ').toSet();
    
    final intersection = words1.intersection(words2).length;
    final union = words1.union(words2).length;
    
    return union > 0 ? intersection / union : 0.0;
  }
}

/// 座標驗證結果
class ValidationResult {
  final bool isValid;
  final String reason;
  final ValidationSeverity severity;
  final String? suggestedAction;

  const ValidationResult({
    required this.isValid,
    required this.reason,
    required this.severity,
    this.suggestedAction,
  });

  @override
  String toString() {
    return 'ValidationResult(isValid: $isValid, reason: $reason, severity: $severity)';
  }
}

/// 活動座標驗證結果
class ActivityValidationResult {
  final int dayIndex;
  final Activity activity;
  final ValidationResult validation;

  const ActivityValidationResult({
    required this.dayIndex,
    required this.activity,
    required this.validation,
  });

  @override
  String toString() {
    return 'ActivityValidationResult(day: $dayIndex, activity: ${activity.name}, valid: ${validation.isValid})';
  }
}

/// 驗證嚴重程度
enum ValidationSeverity {
  info,
  warning,
  error,
}

/// 座標驗證結果
class CoordinateValidationResult {
  final List<Point> validCoordinates;
  final List<Activity> invalidActivities;

  const CoordinateValidationResult({
    required this.validCoordinates,
    required this.invalidActivities,
  });

  bool get hasInvalidActivities => invalidActivities.isNotEmpty;
  int get totalActivities => validCoordinates.length + invalidActivities.length;
  double get validationRate => totalActivities > 0 ? validCoordinates.length / totalActivities : 0.0;

  @override
  String toString() {
    return 'CoordinateValidationResult(valid: ${validCoordinates.length}, invalid: ${invalidActivities.length}, rate: ${(validationRate * 100).toStringAsFixed(1)}%)';
  }
}