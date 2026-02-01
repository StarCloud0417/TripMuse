import 'package:flutter_test/flutter_test.dart';
import 'package:tripmuse/core/models/models.dart';

void main() {
  group('Activity', () {
    test('should create activity from valid data', () {
      const activity = Activity(
        id: 'activity-1',
        name: '迪化街',
        description: '百年老街品嚐傳統茶點和乾貨',
        lat: 25.0540,
        lng: 121.5128,
        timeFrom: '09:00',
        timeTo: '11:00',
        category: ActivityCategory.food,
        priority: ActivityPriority.high,
        estimatedCost: 'NT\$200-500',
        tips: '建議早上前往，人潮較少且店家剛開始營業',
        address: '台北市大同區迪化街一段',
        photos: ['photo1.jpg', 'photo2.jpg'],
        rating: 4.5,
        placeId: 'place-123',
      );

      expect(activity.id, equals('activity-1'));
      expect(activity.name, equals('迪化街'));
      expect(activity.description, equals('百年老街品嚐傳統茶點和乾貨'));
      expect(activity.lat, equals(25.0540));
      expect(activity.lng, equals(121.5128));
      expect(activity.timeFrom, equals('09:00'));
      expect(activity.timeTo, equals('11:00'));
      expect(activity.category, equals(ActivityCategory.food));
      expect(activity.priority, equals(ActivityPriority.high));
      expect(activity.estimatedCost, equals('NT\$200-500'));
      expect(activity.tips, equals('建議早上前往，人潮較少且店家剛開始營業'));
      expect(activity.address, equals('台北市大同區迪化街一段'));
      expect(activity.photos, equals(['photo1.jpg', 'photo2.jpg']));
      expect(activity.rating, equals(4.5));
      expect(activity.placeId, equals('place-123'));
    });

    test('should serialize to JSON correctly', () {
      const activity = Activity(
        id: 'activity-1',
        name: '迪化街',
        description: '百年老街品嚐傳統茶點和乾貨',
        lat: 25.0540,
        lng: 121.5128,
        timeFrom: '09:00',
        timeTo: '11:00',
        category: ActivityCategory.food,
        priority: ActivityPriority.high,
      );

      final json = activity.toJson();

      expect(json['id'], equals('activity-1'));
      expect(json['name'], equals('迪化街'));
      expect(json['category'], equals('food'));
      expect(json['priority'], equals('high'));
      expect(json['photos'], equals([]));
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 'activity-1',
        'name': '迪化街',
        'description': '百年老街品嚐傳統茶點和乾貨',
        'lat': 25.0540,
        'lng': 121.5128,
        'timeFrom': '09:00',
        'timeTo': '11:00',
        'category': 'food',
        'priority': 'high',
        'estimatedCost': 'NT\$200-500',
        'tips': '建議早上前往',
        'address': '台北市大同區迪化街一段',
        'photos': ['photo1.jpg'],
        'rating': 4.5,
        'placeId': 'place-123',
      };

      final activity = Activity.fromJson(json);

      expect(activity.id, equals('activity-1'));
      expect(activity.name, equals('迪化街'));
      expect(activity.category, equals(ActivityCategory.food));
      expect(activity.priority, equals(ActivityPriority.high));
      expect(activity.photos, equals(['photo1.jpg']));
    });

    test('should calculate duration in minutes correctly', () {
      const activity = Activity(
        id: 'activity-1',
        name: 'Test Activity',
        description: 'Test Description',
        lat: 25.0540,
        lng: 121.5128,
        timeFrom: '09:00',
        timeTo: '11:30',
        category: ActivityCategory.sightseeing,
        priority: ActivityPriority.medium,
      );

      expect(activity.durationInMinutes, equals(150)); // 2.5 hours = 150 minutes
    });

    test('should check if activity is active at given time', () {
      const activity = Activity(
        id: 'activity-1',
        name: 'Test Activity',
        description: 'Test Description',
        lat: 25.0540,
        lng: 121.5128,
        timeFrom: '09:00',
        timeTo: '11:00',
        category: ActivityCategory.sightseeing,
        priority: ActivityPriority.medium,
      );

      final testTime1 = DateTime(2024, 1, 1, 9, 0);  // 9:00 AM - should be active (start time)
      final testTime2 = DateTime(2024, 1, 1, 10, 0); // 10:00 AM - should be active
      final testTime3 = DateTime(2024, 1, 1, 8, 0);  // 8:00 AM - should not be active
      final testTime4 = DateTime(2024, 1, 1, 11, 0); // 11:00 AM - should not be active (end time)

      expect(activity.isActiveAt(testTime1), isTrue);
      expect(activity.isActiveAt(testTime2), isTrue);
      expect(activity.isActiveAt(testTime3), isFalse);
      expect(activity.isActiveAt(testTime4), isFalse);
    });
  });
}