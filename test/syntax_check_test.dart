import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_example/tripmuse/services/places_service.dart';
import 'package:mapbox_maps_example/tripmuse/services/api_client.dart';
import 'package:mapbox_maps_example/tripmuse/utils/coordinate_validator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('語法檢查測試', () {
    test('PlacesService 可以正常實例化', () {
      final apiClient = ApiClient();
      final placesService = PlacesService(apiClient);
      expect(placesService, isNotNull);
    });

    test('CoordinateValidator 靜態方法可以正常調用', () {
      final isValid = CoordinateValidator.isValidCoordinate(25.033, 121.565);
      expect(isValid, isTrue);

      final distance = CoordinateValidator.calculateDistance(
        25.033, 121.565,
        25.047, 121.517,
      );
      expect(distance, greaterThan(0));
    });

    test('PlacesService 方法簽名正確', () {
      final apiClient = ApiClient();
      final placesService = PlacesService(apiClient);
      
      // 檢查方法是否存在（不實際調用）
      expect(placesService.searchPlaces, isA<Function>());
      expect(placesService.getPlaceDetails, isA<Function>());
      expect(placesService.validateAndEnhanceLocation, isA<Function>());
      expect(placesService.enhanceActivitiesWithPlaceData, isA<Function>());
    });
  });
}