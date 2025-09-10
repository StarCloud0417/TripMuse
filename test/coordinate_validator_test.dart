import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_example/tripmuse/models/models.dart';
import 'package:mapbox_maps_example/tripmuse/utils/coordinate_validator.dart';

void main() {
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
        
        expect(distance, closeTo(297, 10)); // 約297公里，允許10公里誤差
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
        expect(result.severity, equals(ValidationSeverity.warning)); // 零座標是警告
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

    group('座標修正建議測試', () {
      test('建議相似活動的座標', () {
        final invalidActivity = Activity(
          id: '1',
          name: '台北101觀景台',
          description: '觀景台',
          timeFrom: '09:00',
          timeTo: '11:00',
          category: ActivityCategory.sightseeing,
          priority: ActivityPriority.high,
          // 無效座標
        );

        final validActivities = [
          Activity(
            id: '2',
            name: '台北101',
            description: '購物中心',
            timeFrom: '14:00',
            timeTo: '16:00',
            category: ActivityCategory.shopping,
            priority: ActivityPriority.medium,
            lat: 25.033,
            lng: 121.565,
          ),
        ];

        final suggestion = CoordinateValidator.suggestCoordinateCorrection(
          invalidActivity,
          validActivities,
        );

        expect(suggestion, isNotNull);
        expect(suggestion!.lat, equals(25.033));
        expect(suggestion.lng, equals(121.565));
      });

      test('沒有相似活動時使用地理中心點', () {
        final invalidActivity = Activity(
          id: '1',
          name: '完全不同的地點',
          description: '測試',
          timeFrom: '09:00',
          timeTo: '11:00',
          category: ActivityCategory.sightseeing,
          priority: ActivityPriority.high,
          // 無效座標
        );

        final validActivities = [
          Activity(
            id: '2',
            name: '台北101',
            description: '購物中心',
            timeFrom: '14:00',
            timeTo: '16:00',
            category: ActivityCategory.shopping,
            priority: ActivityPriority.medium,
            lat: 25.033,
            lng: 121.565,
          ),
          Activity(
            id: '3',
            name: '台北車站',
            description: '交通樞紐',
            timeFrom: '17:00',
            timeTo: '18:00',
            category: ActivityCategory.transportation,
            priority: ActivityPriority.low,
            lat: 25.047,
            lng: 121.517,
          ),
        ];

        final suggestion = CoordinateValidator.suggestCoordinateCorrection(
          invalidActivity,
          validActivities,
        );

        expect(suggestion, isNotNull);
        // 應該是兩個地點的中心點
        expect(suggestion!.lat, closeTo(25.040, 0.01));
        expect(suggestion.lng, closeTo(121.541, 0.01));
      });
    });

    group('行程座標驗證測試', () {
      test('驗證完整行程的座標', () {
        final trip = Trip(
          id: 'test-trip',
          title: '台北三日遊',
          destination: Destination(
            name: '台北',
            city: '台北',
            country: '台灣',
            lat: 25.047,
            lng: 121.517,
          ),
          days: [
            DayPlan(
              dayIndex: 1,
              date: DateTime.now(),
              theme: '台北市區觀光',
              activities: [
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
                  name: '遠方景點',
                  description: '距離過遠',
                  timeFrom: '14:00',
                  timeTo: '16:00',
                  category: ActivityCategory.sightseeing,
                  priority: ActivityPriority.medium,
                  lat: 22.612, // 高雄
                  lng: 120.301,
                ),
              ],
            ),
          ],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final results = CoordinateValidator.validateTripCoordinates(
          trip,
          maxDistanceKm: 100,
        );

        expect(results, hasLength(2));
        expect(results[0].validation.isValid, isTrue); // 台北101 應該有效
        expect(results[1].validation.isValid, isFalse); // 高雄景點應該無效
      });
    });
  });
}