import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_example/tripmuse/models/models.dart';

void main() {
  group('TripMuse 資料模型測試', () {
    test('Activity 模型應該正確建立和序列化', () {
      // 建立測試活動
      final activity = Activity(
        id: 'test-activity-1',
        name: '台北101',
        description: '台北地標性建築',
        lat: 25.0330,
        lng: 121.5654,
        timeFrom: '09:00',
        timeTo: '11:00',
        category: ActivityCategory.sightseeing,
        priority: ActivityPriority.high,
        estimatedCost: 'NT\$600',
        tips: '建議提早到達避免排隊',
      );

      // 測試基本屬性
      expect(activity.name, equals('台北101'));
      expect(activity.category, equals(ActivityCategory.sightseeing));
      expect(activity.isHighPriority, isTrue);
      expect(activity.durationMinutes, equals(120));
      expect(activity.timeRange, equals('09:00 - 11:00'));

      // 測試 JSON 序列化
      final json = activity.toJson();
      expect(json['name'], equals('台北101'));
      expect(json['category'], equals('sightseeing'));

      // 測試 JSON 反序列化
      final activityFromJson = Activity.fromJson(json);
      expect(activityFromJson.name, equals(activity.name));
      expect(activityFromJson.category, equals(activity.category));
    });

    test('DayPlan 模型應該正確管理活動', () {
      // 建立測試活動
      final activities = [
        Activity(
          id: 'activity-1',
          name: '早餐',
          description: '傳統台式早餐',
          lat: 25.0330,
          lng: 121.5654,
          timeFrom: '08:00',
          timeTo: '09:00',
          category: ActivityCategory.food,
          priority: ActivityPriority.medium,
        ),
        Activity(
          id: 'activity-2',
          name: '台北101',
          description: '觀景台',
          lat: 25.0330,
          lng: 121.5654,
          timeFrom: '10:00',
          timeTo: '12:00',
          category: ActivityCategory.sightseeing,
          priority: ActivityPriority.high,
        ),
      ];

      // 建立每日計畫
      final dayPlan = DayPlan(
        dayIndex: 1,
        date: DateTime(2025, 10, 1),
        theme: '台北市區探索',
        activities: activities,
      );

      // 測試基本屬性
      expect(dayPlan.activityCount, equals(2));
      expect(dayPlan.foodActivityCount, equals(1));
      expect(dayPlan.highPriorityActivityCount, equals(1));
      expect(dayPlan.startTime, equals('08:00'));
      expect(dayPlan.endTime, equals('12:00'));
      expect(dayPlan.hasActivities, isTrue);

      // 測試活動分組
      final grouped = dayPlan.activitiesByCategory;
      expect(grouped[ActivityCategory.food]?.length, equals(1));
      expect(grouped[ActivityCategory.sightseeing]?.length, equals(1));
    });

    test('Trip 模型應該正確管理完整行程', () {
      // 建立目的地
      final destination = Destination(
        name: '台北',
        city: '台北',
        country: '台灣',
        lat: 25.0330,
        lng: 121.5654,
      );

      // 建立每日計畫
      final dayPlans = [
        DayPlan(
          dayIndex: 1,
          date: DateTime(2025, 10, 1),
          theme: '台北市區探索',
          activities: [
            Activity(
              id: 'activity-1',
              name: '台北101',
              description: '觀景台',
              lat: 25.0330,
              lng: 121.5654,
              timeFrom: '10:00',
              timeTo: '12:00',
              category: ActivityCategory.sightseeing,
              priority: ActivityPriority.high,
            ),
          ],
        ),
      ];

      // 建立行程
      final trip = Trip(
        id: 'test-trip-1',
        title: '台北一日遊',
        destination: destination,
        days: dayPlans,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: TripStatus.draft,
      );

      // 測試基本屬性
      expect(trip.totalDays, equals(1));
      expect(trip.totalActivities, equals(1));
      expect(trip.isDraft, isTrue);
      expect(trip.durationDescription, equals('1 天'));
      expect(trip.summary, contains('台北, 台灣'));
      expect(trip.summary, contains('1 天'));
      expect(trip.summary, contains('1 個景點'));

      // 測試日期相關方法
      expect(trip.startDate, equals(DateTime(2025, 10, 1)));
      expect(trip.endDate, equals(DateTime(2025, 10, 1)));
      expect(trip.hasDayPlan(1), isTrue);
      expect(trip.hasDayPlan(2), isFalse);
    });

    test('UserPreferenceAnalysis 應該正確分析偏好', () {
      final analysis = UserPreferenceAnalysis(
        primaryFocus: '美食體驗',
        travelPace: TravelPace.slow,
        budgetRange: BudgetRange.mid,
        interests: ['當地小吃', '傳統市場', '文化體驗'],
        avoidances: ['人群', '趕行程'],
        mood: '放鬆悠閒',
        keywords: ['美食', '放鬆', '文化'],
        confidence: 0.85,
      );

      // 測試偏好檢測
      expect(analysis.prefersFoodExperience, isTrue);
      expect(analysis.prefersCulturalExperience, isTrue);
      expect(analysis.prefersNatureExperience, isFalse);
      expect(analysis.isRelaxedTravel, isTrue);
      expect(analysis.avoidsCrowds, isTrue);
      expect(analysis.isReliable, isTrue);

      // 測試摘要
      expect(analysis.preferenceSummary, contains('美食體驗'));
      expect(analysis.preferenceSummary, contains('放鬆'));
    });

    test('UserPreferenceAnalysis fromJson 應該靈活處理budgetRange值', () {
      // 測試標準值
      final json1 = {
        'primaryFocus': '測試',
        'travelPace': 'slow',
        'budgetRange': 'mid',
        'interests': [],
        'avoidances': [],
        'mood': '測試',
        'keywords': [],
      };
      final analysis1 = UserPreferenceAnalysis.fromJson(json1);
      expect(analysis1.budgetRange, equals(BudgetRange.mid));

      // 測試變體值
      final json2 = {
        'primaryFocus': '測試',
        'travelPace': 'slow',
        'budgetRange': 'cheap', // 應該映射到low
        'interests': [],
        'avoidances': [],
        'mood': '測試',
        'keywords': [],
      };
      final analysis2 = UserPreferenceAnalysis.fromJson(json2);
      expect(analysis2.budgetRange, equals(BudgetRange.low));

      // 測試另一個變體
      final json3 = {
        'primaryFocus': '測試',
        'travelPace': 'slow',
        'budgetRange': 'luxury', // 應該映射到high
        'interests': [],
        'avoidances': [],
        'mood': '測試',
        'keywords': [],
      };
      final analysis3 = UserPreferenceAnalysis.fromJson(json3);
      expect(analysis3.budgetRange, equals(BudgetRange.high));

      // 測試未知值（應該使用預設值mid）
      final json4 = {
        'primaryFocus': '測試',
        'travelPace': 'slow',
        'budgetRange': 'unknown_value',
        'interests': [],
        'avoidances': [],
        'mood': '測試',
        'keywords': [],
      };
      final analysis4 = UserPreferenceAnalysis.fromJson(json4);
      expect(analysis4.budgetRange, equals(BudgetRange.mid));
    });

    test('TripRequest 應該正確驗證和轉換', () {
      final destination = Destination(
        name: '台北',
        city: '台北',
        country: '台灣',
        lat: 25.0330,
        lng: 121.5654,
        placeId: 'test-place-id',
      );

      final request = TripRequest(
        destination: destination.name,
        days: 3,
        description: '我想要一趟放鬆的美食之旅',
        preferences: TripPreferences(
          budget: 'mid',
          pace: 'slow',
          interests: ['food', 'culture'],
          companions: 2,
        ),
      );

      // 測試基本屬性
      expect(request.destination, equals('台北'));
      expect(request.days, equals(3));
      expect(request.description, contains('美食之旅'));
      expect(request.preferences?.budget, equals('mid'));
      expect(request.preferences?.companions, equals(2));

      // 測試 JSON 序列化
      final json = request.toJson();
      expect(json['destination'], equals('台北'));
      expect(json['days'], equals(3));
      expect(json['description'], contains('美食之旅'));
    });

    test('Enum 類型應該有正確的顯示名稱', () {
      expect(ActivityCategory.food.displayName, equals('美食'));
      expect(ActivityPriority.high.displayName, equals('高'));
      expect(TravelPace.slow.displayName, equals('放鬆'));
      expect(BudgetRange.mid.displayName, equals('中等'));
      expect(TravelStyle.leisure.displayName, equals('休閒'));
      expect(TripStatus.draft.displayName, equals('草稿'));
    });
  });
}