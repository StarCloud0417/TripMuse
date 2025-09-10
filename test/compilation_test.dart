import 'package:flutter_test/flutter_test.dart';
// 導入所有我們創建的文件來檢查編譯
import 'package:mapbox_maps_example/tripmuse/models/models.dart';
import 'package:mapbox_maps_example/tripmuse/services/api_client.dart';
import 'package:mapbox_maps_example/tripmuse/services/places_service.dart';
import 'package:mapbox_maps_example/tripmuse/utils/coordinate_validator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('編譯測試', () {
    test('所有模型和服務都能正常導入和實例化', () {
      // 測試模型創建
      final location = PlaceLocation(lat: 25.033, lng: 121.565);
      expect(location.lat, equals(25.033));
      expect(location.lng, equals(121.565));

      final activity = Activity(
        id: '1',
        name: '測試活動',
        description: '測試描述',
        timeFrom: '09:00',
        timeTo: '11:00',
        category: ActivityCategory.sightseeing,
        priority: ActivityPriority.high,
      );
      expect(activity.name, equals('測試活動'));

      // 測試服務創建
      final apiClient = ApiClient();
      expect(apiClient, isNotNull);

      final placesService = PlacesService(apiClient);
      expect(placesService, isNotNull);

      // 測試工具類
      final isValid = CoordinateValidator.isValidCoordinate(25.033, 121.565);
      expect(isValid, isTrue);
    });

    test('異常類別可以正常創建', () {
      const exception = PlacesException('測試異常');
      expect(exception.message, equals('測試異常'));

      const quotaException = PlacesQuotaExceededException('配額超限', retryAfterSeconds: 60);
      expect(quotaException.message, equals('配額超限'));
      expect(quotaException.retryAfterSeconds, equals(60));

      const invalidException = PlacesInvalidRequestException('無效請求', invalidField: 'query');
      expect(invalidException.message, equals('無效請求'));
      expect(invalidException.invalidField, equals('query'));

      const notFoundException = PlaceNotFoundException('地點未找到', 'test_place_id');
      expect(notFoundException.message, equals('地點未找到'));
      expect(notFoundException.placeId, equals('test_place_id'));
    });

    test('驗證結果類別可以正常創建', () {
      const result = ValidationResult(
        isValid: true,
        reason: '驗證通過',
        severity: ValidationSeverity.info,
        suggestedAction: '無需操作',
      );
      
      expect(result.isValid, isTrue);
      expect(result.reason, equals('驗證通過'));
      expect(result.severity, equals(ValidationSeverity.info));
      expect(result.suggestedAction, equals('無需操作'));
    });
  });
}