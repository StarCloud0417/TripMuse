import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_example/tripmuse/models/models.dart';
import 'package:mapbox_maps_example/tripmuse/services/api_client.dart';
import 'package:mapbox_maps_example/tripmuse/services/places_service.dart';
import 'package:mapbox_maps_example/tripmuse/utils/coordinate_validator.dart';

void main() {
  // 初始化 Flutter binding
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Places API Integration Tests', () {
    late PlacesService placesService;
    late ApiClient apiClient;

    setUpAll(() {
      apiClient = ApiClient();
      placesService = PlacesService(apiClient);
    });

    group('地點搜尋測試', () {
      test('搜尋台北101應該返回結果', () async {
        final results = await placesService.searchPlaces('台北101');
        
        expect(results, isNotEmpty);
        expect(results.first.name, contains('101'));
        expect(results.first.location.lat, closeTo(25.033, 0.1));
        expect(results.first.location.lng, closeTo(121.565, 0.1));
      });

      test('搜尋不存在的地點應該返回空列表', () async {
        final results = await placesService.searchPlaces('不存在的地點xyz123');
        
        expect(results, isEmpty);
      });

      test('使用位置參數搜尋應該返回附近結果', () async {
        final results = await placesService.searchPlaces(
          '餐廳',
          location: '25.033,121.565', // 台北101附近
          radius: 1000,
        );
        
        expect(results, isNotEmpty);
        // 驗證結果都在指定範圍內
        for (final place in results) {
          final distance = CoordinateValidator.calculateDistance(
            25.033, 121.565,
            place.location.lat, place.location.lng,
          );
          expect(distance, lessThan(2.0)); // 允許一些誤差
        }
      });
    });

    group('地點詳細資訊測試', () {
      test('取得有效地點詳細資訊', () async {
        // 先搜尋取得 place ID
        final searchResults = await placesService.searchPlaces('台北101');
        expect(searchResults, isNotEmpty);
        
        final placeId = searchResults.first.id;
        final details = await placesService.getPlaceDetails(placeId);
        
        expect(details, isNotNull);
        expect(details!.id, equals(placeId));
        expect(details.name, isNotEmpty);
        expect(details.address, isNotEmpty);
        expect(details.location.lat, isNotNull);
        expect(details.location.lng, isNotNull);
      });

      test('取得無效地點ID應該拋出異常', () async {
        expect(
          () => placesService.getPlaceDetails('invalid_place_id'),
          throwsA(isA<PlaceNotFoundException>()),
        );
      });
    });

    group('座標驗證測試', () {
      test('驗證有效座標', () async {
        final location = await placesService.validateAndEnhanceLocation('台北101');
        
        expect(location, isNotNull);
        expect(location!.lat, closeTo(25.033, 0.1));
        expect(location.lng, closeTo(121.565, 0.1));
      });

      test('驗證無效地點名稱應該返回null', () async {
        final location = await placesService.validateAndEnhanceLocation('不存在的地點xyz123');
        
        expect(location, isNull);
      });
    });

    group('活動資料增強測試', () {
      test('增強活動列表的地點資訊', () async {
        final activities = [
          Activity(
            id: '1',
            name: '台北101',
            description: '觀景台',
            timeFrom: '09:00',
            timeTo: '11:00',
            category: ActivityCategory.sightseeing,
            priority: ActivityPriority.high,
          ),
          Activity(
            id: '2',
            name: '象山步道',
            description: '登山健行',
            timeFrom: '14:00',
            timeTo: '17:00',
            category: ActivityCategory.outdoor,
            priority: ActivityPriority.medium,
          ),
        ];

        final enhancedActivities = await placesService.enhanceActivitiesWithPlaceData(
          activities,
          '台北',
        );

        expect(enhancedActivities, hasLength(2));
        
        // 檢查第一個活動是否被增強
        final taipei101 = enhancedActivities.first;
        expect(taipei101.lat, isNotNull);
        expect(taipei101.lng, isNotNull);
        expect(taipei101.placeId, isNotNull);
      });
    });

    group('快取機制測試', () {
      test('重複搜尋應該使用快取', () async {
        // 清除快取
        placesService.clearCache();
        
        // 第一次搜尋
        final stopwatch1 = Stopwatch()..start();
        final results1 = await placesService.searchPlaces('台北101');
        stopwatch1.stop();
        
        // 第二次搜尋 (應該使用快取)
        final stopwatch2 = Stopwatch()..start();
        final results2 = await placesService.searchPlaces('台北101');
        stopwatch2.stop();
        
        expect(results1.length, equals(results2.length));
        expect(stopwatch2.elapsedMilliseconds, lessThan(stopwatch1.elapsedMilliseconds));
      });

      test('快取統計應該正確', () async {
        placesService.clearCache();
        
        await placesService.searchPlaces('台北101');
        final stats = placesService.getCacheStats();
        
        expect(stats['searchCache'], greaterThan(0));
      });
    });

    group('錯誤處理測試', () {
      test('網路錯誤應該拋出適當異常', () async {
        // 這個測試需要模擬網路錯誤，實際實作時可能需要使用 mock
        // expect(() => placesService.searchPlaces('test'), throwsA(isA<PlacesException>()));
      });

      test('API 配額超限應該拋出適當異常', () async {
        // 這個測試需要模擬配額超限，實際實作時可能需要使用 mock
        // expect(() => placesService.searchPlaces('test'), throwsA(isA<PlacesQuotaExceededException>()));
      });
    });
  });

  group('CoordinateValidator Tests', () {
    group('座標驗證測試', () {
      test('有效座標應該通過驗證', () {
        expect(CoordinateValidator.isValidCoordinate(25.033, 121.565), isTrue);
        expect(CoordinateValidator.isValidCoordinate(-90, -180), isTrue);
        expect(CoordinateValidator.isValidCoordinate(90, 180), isTrue);
      });

      test('無效座標應該失敗', () {
        expect(CoordinateValidator.isValidCoordinate(91, 0), isFalse);
        expect(CoordinateValidator.isValidCoordinate(0, 181), isFalse);
        expect(CoordinateValidator.isValidCoordinate(0, 0), isFalse); // 零座標
      });

      test('台灣範圍檢查', () {
        expect(CoordinateValidator.isInTaiwan(25.033, 121.565), isTrue); // 台北
        expect(CoordinateValidator.isInTaiwan(22.627, 120.301), isTrue); // 高雄
        expect(CoordinateValidator.isInTaiwan(35.676, 139.650), isFalse); // 東京
      });
    });

    group('距離計算測試', () {
      test('計算台北到高雄的距離', () {
        final distance = CoordinateValidator.calculateDistance(
          25.033, 121.565, // 台北
          22.627, 120.301, // 高雄
        );
        
        expect(distance, closeTo(351, 10)); // 約351公里，允許10公里誤差
      });

      test('相同點距離應該為0', () {
        final distance = CoordinateValidator.calculateDistance(
          25.033, 121.565,
          25.033, 121.565,
        );
        
        expect(distance, closeTo(0, 0.001));
      });
    });

    group('活動座標驗證測試', () {
      test('有效活動座標驗證', () {
        final activity = Activity(
          id: '1',
          name: '台北101',
          description: '觀景台',
          timeFrom: '09:00',
          timeTo: '11:00',
          category: ActivityCategory.sightseeing,
          priority: ActivityPriority.high,
          lat: 25.033,
          lng: 121.565,
        );

        final destination = PlaceLocation(lat: 25.047, lng: 121.517); // 台北車站
        
        final result = CoordinateValidator.validateActivityCoordinate(
          activity,
          destination,
        );
        
        expect(result.isValid, isTrue);
        expect(result.severity, equals(ValidationSeverity.info));
      });

      test('距離過遠的活動應該警告', () {
        final activity = Activity(
          id: '1',
          name: '高雄85大樓',
          description: '觀景台',
          timeFrom: '09:00',
          timeTo: '11:00',
          category: ActivityCategory.sightseeing,
          priority: ActivityPriority.high,
          lat: 22.612, // 高雄
          lng: 120.301,
        );

        final destination = PlaceLocation(lat: 25.047, lng: 121.517); // 台北車站
        
        final result = CoordinateValidator.validateActivityCoordinate(
          activity,
          destination,
          maxDistanceKm: 50, // 設定較小的距離限制
        );
        
        expect(result.isValid, isFalse);
        expect(result.severity, equals(ValidationSeverity.warning));
      });

      test('缺少座標的活動應該警告', () {
        final activity = Activity(
          id: '1',
          name: '未知地點',
          description: '測試',
          timeFrom: '09:00',
          timeTo: '11:00',
          category: ActivityCategory.sightseeing,
          priority: ActivityPriority.medium,
          // 沒有 lat, lng (使用預設值 0.0)
        );

        final destination = PlaceLocation(lat: 25.047, lng: 121.517);
        
        final result = CoordinateValidator.validateActivityCoordinate(
          activity,
          destination,
        );
        
        expect(result.isValid, isFalse);
        expect(result.severity, equals(ValidationSeverity.warning));
      });
    });

    group('地理中心點計算測試', () {
      test('計算多個活動的地理中心點', () {
        final activities = [
          Activity(
            id: '1',
            name: '台北101',
            description: '觀景台',
            timeFrom: '09:00',
            timeTo: '11:00',
            category: ActivityCategory.sightseeing,
            priority: ActivityPriority.high,
            lat: 25.033,
            lng: 121.565,
          ),
          Activity(
            id: '2',
            name: '台北車站',
            description: '交通樞紐',
            timeFrom: '14:00',
            timeTo: '15:00',
            category: ActivityCategory.transportation,
            priority: ActivityPriority.medium,
            lat: 25.047,
            lng: 121.517,
          ),
        ];

        final center = CoordinateValidator.calculateGeographicCenter(activities);
        
        expect(center, isNotNull);
        expect(center!.lat, closeTo(25.040, 0.01));
        expect(center.lng, closeTo(121.541, 0.01));
      });

      test('沒有有效座標的活動應該返回null', () {
        final activities = [
          Activity(
            id: '1',
            name: '未知地點',
            description: '測試',
            timeFrom: '09:00',
            timeTo: '11:00',
            category: ActivityCategory.sightseeing,
            priority: ActivityPriority.medium,
            // 沒有座標 (使用預設值 0.0)
          ),
        ];

        final center = CoordinateValidator.calculateGeographicCenter(activities);
        
        expect(center, isNull);
      });
    });
  });
}