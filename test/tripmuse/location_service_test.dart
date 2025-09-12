/// 位置服務測試
/// 
/// 測試位置服務的核心功能

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import '../../lib/tripmuse/services/location_service.dart';
import '../../lib/tripmuse/services/navigation_helper.dart';
import '../../lib/tripmuse/models/models.dart';

void main() {
  group('LocationService Tests', () {
    late LocationService locationService;

    setUp(() {
      locationService = LocationService();
    });

    tearDown(() {
      locationService.dispose();
    });

    test('should calculate distance between two points', () {
      // 台北101 和 台北車站的距離
      const lat1 = 25.0330; // 台北101
      const lng1 = 121.5654;
      const lat2 = 25.0478; // 台北車站
      const lng2 = 121.5170;

      final distance = locationService.calculateDistance(lat1, lng1, lat2, lng2);

      // 實際距離約 5.1 公里
      expect(distance, greaterThan(5000));
      expect(distance, lessThan(6000));
    });

    test('should validate activity coordinates', () {
      final activity = Activity(
        id: '1',
        name: '台北101',
        description: '台北地標',
        lat: 25.0330,
        lng: 121.5654,
        category: ActivityCategory.sightseeing,
        priority: ActivityPriority.high,
        placeId: 'ChIJrbz4w5WrQjQRXBBmgp0_th4',
      );

      // 測試活動座標有效性
      expect(activity.lat, equals(25.0330));
      expect(activity.lng, equals(121.5654));
      expect(activity.placeId, isNotNull);
    });
  });

  group('TripProgressCalculator Tests', () {
    test('should calculate trip progress correctly', () {
      // 創建測試行程
      final trip = Trip(
        id: 'test-trip',
        title: '台北一日遊',
        destination: Destination(
          name: '台北',
          city: '台北',
          country: '台灣',
          lat: 25.0330,
          lng: 121.5654,
        ),
        days: [
          DayPlan(
            dayIndex: 1,
            date: DateTime.now(),
            theme: '城市探索',
            activities: [
              Activity(
                id: '1',
                name: '台北101',
                description: '台北地標',
                lat: 25.0330,
                lng: 121.5654,
                category: ActivityCategory.sightseeing,
                priority: ActivityPriority.high,
              ),
              Activity(
                id: '2',
                name: '台北車站',
                description: '交通樞紐',
                lat: 25.0478,
                lng: 121.5170,
                category: ActivityCategory.sightseeing,
                priority: ActivityPriority.medium,
              ),
            ],
          ),
        ],
        preferenceAnalysis: UserPreferenceAnalysis(
          primaryFocus: '城市觀光',
          travelPace: TravelPace.medium,
          budgetRange: BudgetRange.mid,
          interests: ['觀光', '美食'],
          avoidances: [],
          mood: '輕鬆',
          keywords: ['台北', '觀光'],
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 模擬使用者位置（台北101附近）
      final userPosition = Position(
        latitude: 25.0330,
        longitude: 121.5654,
        timestamp: DateTime.now(),
        accuracy: 10.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );

      final progress = TripProgressCalculator.calculateTripProgress(trip, userPosition);

      expect(progress.currentDay, equals(1));
      expect(progress.overallProgress, greaterThanOrEqualTo(0.0));
      expect(progress.overallProgress, lessThanOrEqualTo(1.0));
      expect(progress.dayProgress, greaterThanOrEqualTo(0.0));
      expect(progress.dayProgress, lessThanOrEqualTo(1.0));
    });
  });

  group('NavigationHelper Tests', () {
    test('should format distance correctly', () {
      final locationService = LocationService();
      final navigationHelper = NavigationHelper(locationService);

      // 測試米的格式化
      expect(navigationHelper.formatDistance(50.0), equals('50m'));
      expect(navigationHelper.formatDistance(999.0), equals('999m'));

      // 測試公里的格式化
      expect(navigationHelper.formatDistance(1000.0), equals('1.0km'));
      expect(navigationHelper.formatDistance(1500.0), equals('1.5km'));
      expect(navigationHelper.formatDistance(2300.0), equals('2.3km'));

      // 測試 null 值
      expect(navigationHelper.formatDistance(null), equals('未知距離'));
    });

    test('should return correct distance color', () {
      final locationService = LocationService();
      final navigationHelper = NavigationHelper(locationService);

      // 測試距離顏色
      expect(navigationHelper.getDistanceColor(30.0), equals('#4CAF50')); // 綠色 - 很近
      expect(navigationHelper.getDistanceColor(100.0), equals('#FF9800')); // 橙色 - 中等
      expect(navigationHelper.getDistanceColor(500.0), equals('#F44336')); // 紅色 - 較遠
      expect(navigationHelper.getDistanceColor(null), equals('#9E9E9E')); // 灰色 - 未知
    });
  });
}