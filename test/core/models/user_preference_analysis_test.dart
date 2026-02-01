import 'package:flutter_test/flutter_test.dart';
import 'package:tripmuse/core/models/models.dart';

void main() {
  group('UserPreferenceAnalysis', () {
    test('should create user preference analysis from valid data', () {
      const analysis = UserPreferenceAnalysis(
        primaryFocus: '美食體驗',
        travelPace: TravelPace.slow,
        interests: ['當地小吃', '傳統市場'],
        avoidances: ['人擠人景點', '趕行程'],
        mood: '放鬆',
        keywords: ['美食', '放鬆', '當地'],
        detectedInterests: ['文化體驗'],
      );

      expect(analysis.primaryFocus, equals('美食體驗'));
      expect(analysis.travelPace, equals(TravelPace.slow));
      expect(analysis.interests, contains('當地小吃'));
      expect(analysis.avoidances, contains('人擠人景點'));
      expect(analysis.mood, equals('放鬆'));
      expect(analysis.keywords, contains('美食'));
      expect(analysis.detectedInterests, contains('文化體驗'));
    });

    test('should serialize to JSON correctly', () {
      const analysis = UserPreferenceAnalysis(
        primaryFocus: '美食體驗',
        travelPace: TravelPace.slow,
        interests: ['當地小吃'],
        avoidances: ['人擠人景點'],
        mood: '放鬆',
        keywords: ['美食'],
      );

      final json = analysis.toJson();

      expect(json['primaryFocus'], equals('美食體驗'));
      expect(json['travelPace'], equals('slow'));
      expect(json['interests'], equals(['當地小吃']));
      expect(json['avoidances'], equals(['人擠人景點']));
      expect(json['mood'], equals('放鬆'));
      expect(json['keywords'], equals(['美食']));
      expect(json['detectedInterests'], equals([]));
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'primaryFocus': '美食體驗',
        'travelPace': 'slow',
        'interests': ['當地小吃', '傳統市場'],
        'avoidances': ['人擠人景點'],
        'mood': '放鬆',
        'keywords': ['美食', '放鬆'],
        'detectedInterests': ['文化體驗'],
      };

      final analysis = UserPreferenceAnalysis.fromJson(json);

      expect(analysis.primaryFocus, equals('美食體驗'));
      expect(analysis.travelPace, equals(TravelPace.slow));
      expect(analysis.interests, equals(['當地小吃', '傳統市場']));
      expect(analysis.avoidances, equals(['人擠人景點']));
      expect(analysis.mood, equals('放鬆'));
      expect(analysis.keywords, equals(['美食', '放鬆']));
      expect(analysis.detectedInterests, equals(['文化體驗']));
    });
  });

  group('BasicPreferences', () {
    test('should create basic preferences from valid data', () {
      const preferences = BasicPreferences(
        budget: BudgetRange.mid,
        groupSize: 2,
        travelStyle: TravelStyle.leisure,
      );

      expect(preferences.budget, equals(BudgetRange.mid));
      expect(preferences.groupSize, equals(2));
      expect(preferences.travelStyle, equals(TravelStyle.leisure));
    });

    test('should serialize and deserialize correctly', () {
      const preferences = BasicPreferences(
        budget: BudgetRange.high,
        groupSize: 4,
        travelStyle: TravelStyle.adventure,
      );

      final json = preferences.toJson();
      final deserialized = BasicPreferences.fromJson(json);

      expect(deserialized.budget, equals(preferences.budget));
      expect(deserialized.groupSize, equals(preferences.groupSize));
      expect(deserialized.travelStyle, equals(preferences.travelStyle));
    });
  });
}