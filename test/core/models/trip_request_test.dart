import 'package:flutter_test/flutter_test.dart';
import 'package:tripmuse/core/models/models.dart';

void main() {
  group('TripRequest', () {
    test('should create trip request from valid data', () {
      final tripRequest = TripRequest(
        destination: const Destination(
          name: '台北, 台灣',
          city: '台北',
          country: '台灣',
          lat: 25.0330,
          lng: 121.5654,
        ),
        duration: TripDuration(
          days: 3,
          startDate: DateTime(2024, 10, 1),
          endDate: DateTime(2024, 10, 3),
        ),
        travelDescription: '我想要一趟放鬆的美食之旅',
        basicPreferences: const BasicPreferences(
          budget: BudgetRange.mid,
          groupSize: 2,
          travelStyle: TravelStyle.leisure,
        ),
        locale: 'zh-TW',
      );

      expect(tripRequest.destination.name, equals('台北, 台灣'));
      expect(tripRequest.duration.days, equals(3));
      expect(tripRequest.travelDescription, equals('我想要一趟放鬆的美食之旅'));
      expect(tripRequest.basicPreferences.budget, equals(BudgetRange.mid));
      expect(tripRequest.locale, equals('zh-TW'));
    });

    test('should serialize and deserialize correctly', () {
      final tripRequest = TripRequest(
        destination: const Destination(
          name: '台北, 台灣',
          city: '台北',
          country: '台灣',
          lat: 25.0330,
          lng: 121.5654,
        ),
        duration: TripDuration(
          days: 3,
          startDate: DateTime(2024, 10, 1),
          endDate: DateTime(2024, 10, 3),
        ),
        travelDescription: '我想要一趟放鬆的美食之旅',
        basicPreferences: const BasicPreferences(
          budget: BudgetRange.mid,
          groupSize: 2,
          travelStyle: TravelStyle.leisure,
        ),
      );

      final json = tripRequest.toJson();
      
      // Convert nested objects to proper JSON format
      final jsonWithNested = Map<String, dynamic>.from(json);
      jsonWithNested['destination'] = tripRequest.destination.toJson();
      jsonWithNested['duration'] = tripRequest.duration.toJson();
      jsonWithNested['basicPreferences'] = tripRequest.basicPreferences.toJson();
      
      final deserialized = TripRequest.fromJson(jsonWithNested);

      expect(deserialized.destination.name, equals(tripRequest.destination.name));
      expect(deserialized.duration.days, equals(tripRequest.duration.days));
      expect(deserialized.travelDescription, equals(tripRequest.travelDescription));
      expect(deserialized.basicPreferences.budget, equals(tripRequest.basicPreferences.budget));
      expect(deserialized.locale, equals('zh-TW')); // default value
    });
  });

  group('TripDuration', () {
    test('should create trip duration from valid data', () {
      final duration = TripDuration(
        days: 3,
        startDate: DateTime(2024, 10, 1),
        endDate: DateTime(2024, 10, 3),
      );

      expect(duration.days, equals(3));
      expect(duration.startDate, equals(DateTime(2024, 10, 1)));
      expect(duration.endDate, equals(DateTime(2024, 10, 3)));
    });

    test('should validate duration consistency', () {
      final validDuration = TripDuration(
        days: 3,
        startDate: DateTime(2024, 10, 1),
        endDate: DateTime(2024, 10, 3),
      );

      final invalidDuration = TripDuration(
        days: 5, // Inconsistent with date range
        startDate: DateTime(2024, 10, 1),
        endDate: DateTime(2024, 10, 3),
      );

      expect(validDuration.isValid, isTrue);
      expect(invalidDuration.isValid, isFalse);
    });

    test('should generate correct date list', () {
      final duration = TripDuration(
        days: 3,
        startDate: DateTime(2024, 10, 1),
        endDate: DateTime(2024, 10, 3),
      );

      final dateList = duration.dateList;

      expect(dateList.length, equals(3));
      expect(dateList[0], equals(DateTime(2024, 10, 1)));
      expect(dateList[1], equals(DateTime(2024, 10, 2)));
      expect(dateList[2], equals(DateTime(2024, 10, 3)));
    });

    test('should handle single day trip', () {
      final duration = TripDuration(
        days: 1,
        startDate: DateTime(2024, 10, 1),
        endDate: DateTime(2024, 10, 1),
      );

      expect(duration.isValid, isTrue);
      expect(duration.dateList.length, equals(1));
      expect(duration.dateList[0], equals(DateTime(2024, 10, 1)));
    });
  });
}