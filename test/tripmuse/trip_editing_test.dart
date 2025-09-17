/// TripMuse 行程編輯功能測試
///
/// 測試自動儲存、路線最佳化、活動移動等功能

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_example/tripmuse/models/models.dart';
import 'package:mapbox_maps_example/tripmuse/services/auto_save_service.dart';
import 'package:mapbox_maps_example/tripmuse/services/route_optimization_service.dart';
import 'package:mapbox_maps_example/tripmuse/services/activity_edit_service.dart';

void main() {
  group('行程編輯功能測試', () {
    late List<Activity> testActivities;
    late Trip testTrip;

    setUp(() {
      // 創建測試活動
      testActivities = [
        Activity(
          id: 'activity_1',
          name: '台北101',
          description: '觀景台',
          category: ActivityCategory.sightseeing,
          priority: ActivityPriority.high,
          timeFrom: '09:00',
          timeTo: '11:00',
          lat: 25.0340,
          lng: 121.5645,
        ),
        Activity(
          id: 'activity_2',
          name: '象山步道',
          description: '登山健行',
          category: ActivityCategory.outdoor,
          priority: ActivityPriority.medium,
          timeFrom: '14:00',
          timeTo: '16:00',
          lat: 25.0235,
          lng: 121.5707,
        ),
        Activity(
          id: 'activity_3',
          name: '信義商圈',
          description: '購物用餐',
          category: ActivityCategory.shopping,
          priority: ActivityPriority.low,
          timeFrom: '18:00',
          timeTo: '20:00',
          lat: 25.0336,
          lng: 121.5650,
        ),
      ];

      // 創建測試行程
      testTrip = Trip(
        id: 'test_trip',
        title: '台北一日遊',
        destination: const Destination(
          name: '台北市',
          city: '台北',
          country: '台灣',
          lat: 25.0330,
          lng: 121.5654,
        ),
        days: [
          DayPlan(
            dayIndex: 0,
            date: DateTime.now(),
            theme: '城市探索',
            activities: testActivities,
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });

    group('路線最佳化服務測試', () {
      test('計算兩點間距離', () {
        final distance = RouteOptimizationService.calculateDistance(
          25.0340, 121.5645, // 台北101
          25.0235, 121.5707, // 象山步道
        );
        
        expect(distance, greaterThan(0));
        expect(distance, lessThan(5)); // 應該在5公里內
      });

      test('計算旅行時間', () {
        final walkingTime = RouteOptimizationService.calculateTravelTime(1.0, TransportMode.walking);
        final drivingTime = RouteOptimizationService.calculateTravelTime(1.0, TransportMode.driving);
        
        expect(walkingTime, greaterThan(drivingTime));
        expect(walkingTime, equals(12)); // 1公里步行約12分鐘
        expect(drivingTime, equals(2)); // 1公里開車約2分鐘
      });

      test('最佳化活動順序', () {
        final result = RouteOptimizationService.optimizeDayActivities(
          testActivities,
          transportMode: TransportMode.walking,
          preserveTimeConstraints: false,
        );
        
        expect(result.optimizedActivities, hasLength(testActivities.length));
        expect(result.totalDistance, greaterThan(0));
        expect(result.totalTravelTime, greaterThan(0));
      });

      test('建議交通方式', () {
        final shortDistanceActivities = [
          testActivities[0], // 台北101
          testActivities[2], // 信義商圈（距離很近）
        ];
        
        final suggestedMode = RouteOptimizationService.suggestTransportMode(shortDistanceActivities);
        expect(suggestedMode, equals(TransportMode.walking));
      });

      test('驗證活動時間安排', () {
        final result = RouteOptimizationService.validateActivityTiming(
          testActivities,
          TransportMode.walking,
        );
        
        expect(result.isValid, isA<bool>());
        expect(result.issues, isA<List<TimingIssue>>());
      });

      test('自動調整活動時間', () {
        final adjustedActivities = RouteOptimizationService.autoAdjustTimingForTravel(
          testActivities,
          TransportMode.walking,
        );
        
        expect(adjustedActivities, hasLength(testActivities.length));
        expect(adjustedActivities.first.id, equals(testActivities.first.id));
      });
    });

    group('活動編輯服務測試', () {
      test('驗證時間範圍', () {
        expect(ActivityEditService.validateTimeRange('09:00', '11:00'), isTrue);
        expect(ActivityEditService.validateTimeRange('11:00', '09:00'), isFalse);
        expect(ActivityEditService.validateTimeRange('25:00', '11:00'), isFalse);
        expect(ActivityEditService.validateTimeRange('09:60', '11:00'), isFalse);
      });

      test('檢查時間衝突', () {
        final activity = testActivities[0];
        final otherActivities = testActivities.sublist(1);
        
        // 測試無衝突的時間
        final noConflict = ActivityEditService.checkTimeConflict(
          activity,
          '12:00',
          '13:00',
          otherActivities,
        );
        expect(noConflict, isFalse);
        
        // 測試有衝突的時間
        final hasConflict = ActivityEditService.checkTimeConflict(
          activity,
          '14:30',
          '15:30',
          otherActivities,
        );
        expect(hasConflict, isTrue);
      });

      test('跨日期移動活動', () {
        final twoDayTrip = testTrip.copyWith(
          days: [
            testTrip.days[0],
            DayPlan(
              dayIndex: 1,
              date: DateTime.now().add(const Duration(days: 1)),
              theme: '第二天',
              activities: [],
            ),
          ],
        );
        
        final updatedTrip = ActivityEditServiceExtended.moveActivityBetweenDays(
          twoDayTrip,
          0, // 從第一天
          1, // 移動到第二天
          testActivities[0],
        );
        
        expect(updatedTrip.days[0].activities, hasLength(2)); // 第一天少了一個活動
        expect(updatedTrip.days[1].activities, hasLength(1)); // 第二天多了一個活動
        expect(updatedTrip.days[1].activities.first.id, equals(testActivities[0].id));
      });

      test('批量刪除活動', () {
        final activityRefs = [
          ActivityReference(activityId: testActivities[0].id, dayIndex: 0),
          ActivityReference(activityId: testActivities[1].id, dayIndex: 0),
        ];
        
        final updatedTrip = ActivityEditServiceExtended.batchDeleteActivities(testTrip, activityRefs);
        
        expect(updatedTrip.days[0].activities, hasLength(1)); // 剩下一個活動
        expect(updatedTrip.days[0].activities.first.id, equals(testActivities[2].id));
      });

      test('最佳化整個行程路線', () {
        final optimizedTrip = ActivityEditServiceExtended.optimizeTripRoute(
          testTrip,
          transportMode: TransportMode.walking,
          preserveTimeConstraints: true,
        );
        
        expect(optimizedTrip.days, hasLength(testTrip.days.length));
        expect(optimizedTrip.days[0].activities, hasLength(testActivities.length));
        expect(optimizedTrip.updatedAt.isAfter(testTrip.updatedAt), isTrue);
      });

      test('計算行程統計資訊', () {
        final statistics = ActivityEditServiceExtended.calculateTripStatistics(
          testTrip,
          TransportMode.walking,
        );
        
        expect(statistics.totalActivities, equals(testActivities.length));
        expect(statistics.totalDistance, greaterThan(0));
        expect(statistics.totalTravelTime, greaterThan(0));
        expect(statistics.suggestedTransportMode, isA<TransportMode>());
      });
    });

    group('自動儲存服務測試', () {
      late AutoSaveService autoSaveService;

      setUp(() {
        autoSaveService = AutoSaveService();
      });

      tearDown(() {
        autoSaveService.dispose();
      });

      test('啟用和停用自動儲存', () {
        autoSaveService.enable();
        // 測試服務是否正常運作（無法直接測試私有成員）
        expect(() => autoSaveService.enable(), returnsNormally);
        
        autoSaveService.disable();
        expect(() => autoSaveService.disable(), returnsNormally);
      });

      test('設定當前行程', () {
        const tripId = 'test_trip_123';
        expect(() => autoSaveService.setCurrentTrip(tripId), returnsNormally);
      });

      test('標記行程需要儲存', () {
        autoSaveService.enable();
        expect(() => autoSaveService.markTripForSave(testTrip), returnsNormally);
      });
    });

    group('整合測試', () {
      test('完整的編輯流程', () {
        // 1. 移動活動
        final movedTrip = ActivityEditServiceExtended.moveActivityBetweenDays(
          testTrip.copyWith(
            days: [
              testTrip.days[0],
              DayPlan(
                dayIndex: 1,
                date: DateTime.now().add(const Duration(days: 1)),
                theme: '第二天',
                activities: [],
              ),
            ],
          ),
          0,
          1,
          testActivities[0],
        );
        
        // 2. 最佳化路線
        final optimizedTrip = ActivityEditServiceExtended.optimizeTripRoute(
          movedTrip,
          transportMode: TransportMode.walking,
        );
        
        // 3. 驗證結果
        expect(optimizedTrip.days, hasLength(2));
        expect(optimizedTrip.days[0].activities, hasLength(2));
        expect(optimizedTrip.days[1].activities, hasLength(1));
        
        // 4. 計算統計
        final statistics = ActivityEditServiceExtended.calculateTripStatistics(
          optimizedTrip,
          TransportMode.walking,
        );
        
        expect(statistics.totalActivities, equals(3));
        expect(statistics.formattedTotalDistance, isNotEmpty);
        expect(statistics.formattedTotalTravelTime, isNotEmpty);
      });
    });
  });
}