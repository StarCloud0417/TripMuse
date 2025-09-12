import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/tripmuse/utils/coordinate_validator.dart';

void main() {
  group('CoordinateValidator Tests', () {
    test('should validate valid coordinates', () {
      // 測試有效的台灣座標 (台北 101)
      expect(CoordinateValidator.isValidCoordinate(25.0330, 121.5654), true);
      // 測試有效的台灣座標 (高雄)
      expect(CoordinateValidator.isValidCoordinate(22.6273, 120.3014), true);
    });

    test('should reject invalid coordinates', () {
      // 測試無效的空值座標
      expect(CoordinateValidator.isValidCoordinate(null, null), false);
      // 測試無效的 NaN 座標
      expect(CoordinateValidator.isValidCoordinate(double.nan, 121.5654), false);
      // 測試無效的零座標
      expect(CoordinateValidator.isValidCoordinate(0.0, 0.0), false);
      // 測試超出範圍的緯度
      expect(CoordinateValidator.isValidCoordinate(91.0, 121.5654), false);
      // 測試超出範圍的經度
      expect(CoordinateValidator.isValidCoordinate(25.0330, 181.0), false);
    });

    test('should sanitize coordinates', () {
      // 測試座標清理
      final result = CoordinateValidator.sanitizeCoordinate(25.033011111, 121.565411111);
      expect(result, isNotNull);
      expect(result!.coordinates.lat, closeTo(25.033011, 0.000001));
      expect(result.coordinates.lng, closeTo(121.565411, 0.000001));
    });

    test('should handle null inputs in sanitization', () {
      // 測試空值輸入
      expect(CoordinateValidator.sanitizeCoordinate(null, 121.5654), null);
      expect(CoordinateValidator.sanitizeCoordinate(25.0330, null), null);
    });

    test('should validate coordinate lists', () {
      final coordinates = [
        Point(coordinates: Position(121.5654, 25.0330)), // 有效
        Point(coordinates: Position(120.3014, 22.6273)), // 有效
        null, // 無效
        Point(coordinates: Position(0.0, 0.0)), // 無效
      ];

      final result = CoordinateValidator.validateAndFilterCoordinates(coordinates);
      expect(result.length, 2); // 應該只返回 2 個有效座標
    });
  });
}
