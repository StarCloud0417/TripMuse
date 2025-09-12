/// 地圖動畫功能測試
/// 
/// 測試地圖互動和動畫功能

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_example/tripmuse/services/trip_progress_calculator.dart';
import 'package:mapbox_maps_example/tripmuse/models/models.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  group('地圖動畫功能測試', () {
    test('旅程進度計算測試', () {
      // 創建測試行程
      final trip = Trip(
        id: 'test-trip',
        title: '測試行程',
        destination: const Destination(
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
            theme: '探索台北',
            activities: [
              Activity(
                id: 'activity-1',
                name: '台北101',
                description: '台北地標',
                category: ActivityCategory.sightseeing,
                priority: ActivityPriority.medium,
                timeFrom: '09:00',
                timeTo: '11:00',
                lat: 25.0330,
                lng: 121.5654,
              ),
            ],
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 創建測試位置
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

      // 計算旅程進度
      final progress = TripProgressCalculator.calculateTripProgress(trip, userPosition);

      // 驗證結果
      expect(progress, isNotNull);
      expect(progress!.currentDay, equals(1));
      expect(progress.currentActivity, isNotNull);
      expect(progress.currentActivity!.name, equals('台北101'));
    });

    test('距離計算測試', () {
      // 創建測試活動
      final activity = Activity(
        id: 'test-activity',
        name: '測試景點',
        description: '測試描述',
        category: ActivityCategory.sightseeing,
        priority: ActivityPriority.medium,
        timeFrom: '09:00',
        timeTo: '11:00',
        lat: 25.0330,
        lng: 121.5654,
      );

      // 創建測試位置（距離100米）
      final userPosition = Position(
        latitude: 25.0340, // 約100米差距
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

      // 測試活動完成狀態
      final isCompleted = TripProgressCalculator.isActivityCompleted(activity, userPosition);
      expect(isCompleted, isFalse); // 100米距離應該不算完成

      // 測試統計資訊
      final trip = Trip(
        id: 'test-trip',
        title: '測試行程',
        destination: const Destination(
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
            theme: '測試主題',
            activities: [activity],
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final stats = TripProgressCalculator.getTripStatistics(trip, userPosition);
      expect(stats['totalDays'], equals(1));
      expect(stats['totalActivities'], equals(1));
      expect(stats['completedActivities'], equals(0));
    });
  });
}