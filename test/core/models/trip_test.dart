import 'package:flutter_test/flutter_test.dart';
import 'package:tripmuse/core/models/models.dart';

void main() {
  group('Trip', () {
    final testDestination = const Destination(
      name: '台北, 台灣',
      city: '台北',
      country: '台灣',
      lat: 25.0330,
      lng: 121.5654,
    );

    final testPreferenceAnalysis = const UserPreferenceAnalysis(
      primaryFocus: '美食體驗',
      travelPace: TravelPace.slow,
      interests: ['當地小吃', '傳統市場'],
      avoidances: ['人擠人景點'],
      mood: '放鬆',
      keywords: ['美食', '放鬆'],
    );

    final testActivities = [
      const Activity(
        id: 'activity-1',
        name: '迪化街',
        description: '百年老街品嚐傳統茶點和乾貨',
        lat: 25.0540,
        lng: 121.5128,
        timeFrom: '09:00',
        timeTo: '11:00',
        category: ActivityCategory.food,
        priority: ActivityPriority.high,
      ),
      const Activity(
        id: 'activity-2',
        name: '故宮博物院',
        description: '參觀世界級文物收藏',
        lat: 25.1013,
        lng: 121.5485,
        timeFrom: '14:00',
        timeTo: '17:00',
        category: ActivityCategory.culture,
        priority: ActivityPriority.medium,
      ),
    ];

    final testDayPlans = [
      DayPlan(
        dayIndex: 1,
        date: DateTime(2024, 10, 1),
        theme: '傳統市場美食探索',
        activities: [testActivities[0]],
      ),
      DayPlan(
        dayIndex: 2,
        date: DateTime(2024, 10, 2),
        theme: '文化古蹟巡禮',
        activities: [testActivities[1]],
      ),
    ];

    test('should create trip from valid data', () {
      final trip = Trip(
        id: 'trip-123',
        title: '台北放鬆美食3日遊',
        destination: testDestination,
        days: testDayPlans,
        preferenceAnalysis: testPreferenceAnalysis,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
        userId: 'user-123',
        generatedBy: 'gpt-4o',
        isFavorite: true,
        isShared: false,
      );

      expect(trip.id, equals('trip-123'));
      expect(trip.title, equals('台北放鬆美食3日遊'));
      expect(trip.destination.name, equals('台北, 台灣'));
      expect(trip.days.length, equals(2));
      expect(trip.preferenceAnalysis.primaryFocus, equals('美食體驗'));
      expect(trip.userId, equals('user-123'));
      expect(trip.generatedBy, equals('gpt-4o'));
      expect(trip.isFavorite, isTrue);
      expect(trip.isShared, isFalse);
    });

    test('should serialize and deserialize correctly', () {
      final trip = Trip(
        id: 'trip-123',
        title: '台北放鬆美食3日遊',
        destination: testDestination,
        days: testDayPlans,
        preferenceAnalysis: testPreferenceAnalysis,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final json = trip.toJson();
      
      // Convert nested objects to proper JSON format
      final jsonWithNested = Map<String, dynamic>.from(json);
      jsonWithNested['destination'] = trip.destination.toJson();
      jsonWithNested['days'] = trip.days.map((d) {
        final dayJson = d.toJson();
        dayJson['activities'] = d.activities.map((a) => a.toJson()).toList();
        return dayJson;
      }).toList();
      jsonWithNested['preferenceAnalysis'] = trip.preferenceAnalysis.toJson();
      
      final deserialized = Trip.fromJson(jsonWithNested);

      expect(deserialized.id, equals(trip.id));
      expect(deserialized.title, equals(trip.title));
      expect(deserialized.destination.name, equals(trip.destination.name));
      expect(deserialized.days.length, equals(trip.days.length));
      expect(deserialized.preferenceAnalysis.primaryFocus, equals(trip.preferenceAnalysis.primaryFocus));
    });

    test('should calculate total activities correctly', () {
      final trip = Trip(
        id: 'trip-123',
        title: '台北放鬆美食3日遊',
        destination: testDestination,
        days: testDayPlans,
        preferenceAnalysis: testPreferenceAnalysis,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(trip.totalActivities, equals(2));
    });

    test('should get trip duration correctly', () {
      final trip = Trip(
        id: 'trip-123',
        title: '台北放鬆美食3日遊',
        destination: testDestination,
        days: testDayPlans,
        preferenceAnalysis: testPreferenceAnalysis,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(trip.duration, equals(2));
    });

    test('should get start and end dates correctly', () {
      final trip = Trip(
        id: 'trip-123',
        title: '台北放鬆美食3日遊',
        destination: testDestination,
        days: testDayPlans,
        preferenceAnalysis: testPreferenceAnalysis,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(trip.startDate, equals(DateTime(2024, 10, 1)));
      expect(trip.endDate, equals(DateTime(2024, 10, 2)));
    });

    test('should get all activities across days', () {
      final trip = Trip(
        id: 'trip-123',
        title: '台北放鬆美食3日遊',
        destination: testDestination,
        days: testDayPlans,
        preferenceAnalysis: testPreferenceAnalysis,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final allActivities = trip.allActivities;

      expect(allActivities.length, equals(2));
      expect(allActivities.any((a) => a.name == '迪化街'), isTrue);
      expect(allActivities.any((a) => a.name == '故宮博物院'), isTrue);
    });

    test('should filter activities by category', () {
      final trip = Trip(
        id: 'trip-123',
        title: '台北放鬆美食3日遊',
        destination: testDestination,
        days: testDayPlans,
        preferenceAnalysis: testPreferenceAnalysis,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final foodActivities = trip.getActivitiesByCategory(ActivityCategory.food);
      final cultureActivities = trip.getActivitiesByCategory(ActivityCategory.culture);

      expect(foodActivities.length, equals(1));
      expect(foodActivities.first.name, equals('迪化街'));

      expect(cultureActivities.length, equals(1));
      expect(cultureActivities.first.name, equals('故宮博物院'));
    });

    test('should get high priority activities', () {
      final trip = Trip(
        id: 'trip-123',
        title: '台北放鬆美食3日遊',
        destination: testDestination,
        days: testDayPlans,
        preferenceAnalysis: testPreferenceAnalysis,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final highPriorityActivities = trip.highPriorityActivities;

      expect(highPriorityActivities.length, equals(1));
      expect(highPriorityActivities.first.name, equals('迪化街'));
    });

    test('should check if trip is active', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      // Create a trip that includes today
      final activeDayPlans = [
        DayPlan(
          dayIndex: 1,
          date: today,
          theme: '今日行程',
          activities: [testActivities[0]],
        ),
      ];

      final activeTrip = Trip(
        id: 'trip-123',
        title: '當前行程',
        destination: testDestination,
        days: activeDayPlans,
        preferenceAnalysis: testPreferenceAnalysis,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(activeTrip.isActive, isTrue);
    });

    test('should copy with updated time', () {
      final originalTime = DateTime(2024, 1, 1);
      final trip = Trip(
        id: 'trip-123',
        title: '台北放鬆美食3日遊',
        destination: testDestination,
        days: testDayPlans,
        preferenceAnalysis: testPreferenceAnalysis,
        createdAt: originalTime,
        updatedAt: originalTime,
      );

      final updatedTrip = trip.copyWithUpdatedTime();

      expect(updatedTrip.createdAt, equals(originalTime));
      expect(updatedTrip.updatedAt.isAfter(originalTime), isTrue);
    });
  });
}