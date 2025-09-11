/// TripMuse 行程卡片組件測試
/// 
/// 測試行程卡片的顯示和互動功能

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/tripmuse/widgets/trip_card.dart';
import '../../../lib/tripmuse/models/models.dart';
import '../../../lib/tripmuse/theme/app_theme.dart';

void main() {
  group('TripCard Widget Tests', () {
    late Trip testTrip;
    
    setUp(() {
      // 建立測試用的行程資料
      testTrip = Trip(
        id: 'test_trip_1',
        title: '台北美食3日遊',
        notes: '探索台北的美食和文化',
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
            date: DateTime(2024, 6, 1),
            theme: '夜市美食',
            activities: [
              Activity(
                id: 'activity_1',
                name: '士林夜市',
                description: '品嚐台灣小吃',
                lat: 25.0881,
                lng: 121.5240,
                timeFrom: '18:00',
                timeTo: '21:00',
                category: ActivityCategory.food,
                priority: ActivityPriority.high,
                estimatedCost: '500 TWD',
              ),
            ],
          ),
          DayPlan(
            dayIndex: 2,
            date: DateTime(2024, 6, 2),
            theme: '城市觀光',
            activities: [
              Activity(
                id: 'activity_2',
                name: '台北101',
                description: '參觀台北地標',
                lat: 25.0340,
                lng: 121.5645,
                timeFrom: '10:00',
                timeTo: '12:00',
                category: ActivityCategory.sightseeing,
                priority: ActivityPriority.medium,
                estimatedCost: '600 TWD',
              ),
            ],
          ),
        ],
        preferenceAnalysis: const UserPreferenceAnalysis(
          primaryFocus: '美食',
          travelPace: TravelPace.medium,
          budgetRange: BudgetRange.mid,
          mood: '輕鬆',
          keywords: ['美食', '文化', '購物'],
        ),
        createdAt: DateTime(2024, 5, 1),
        updatedAt: DateTime(2024, 5, 1),
      );
    });
    
    testWidgets('should display trip basic information', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: TripMuseTheme.primaryColor),
          ),
          home: Scaffold(
            body: TripCard(trip: testTrip),
          ),
        ),
      );
      
      // Assert
      expect(find.text('台北美食3日遊'), findsOneWidget);
      expect(find.text('台北, 台灣'), findsOneWidget);
      expect(find.text('2 天'), findsOneWidget);
      expect(find.text('2 個活動'), findsOneWidget);
    });
    
    testWidgets('should display trip status correctly for upcoming trip', (WidgetTester tester) async {
      // Arrange - 建立未來的行程
      final futureTrip = testTrip.copyWith(
        days: [
          DayPlan(
            dayIndex: 1,
            date: DateTime.now().add(const Duration(days: 30)),
            theme: '未來行程',
            activities: testTrip.days.first.activities,
          ),
        ],
      );
      
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: TripMuseTheme.primaryColor),
          ),
          home: Scaffold(
            body: TripCard(trip: futureTrip),
          ),
        ),
      );
      
      // Assert
      expect(find.text('即將開始'), findsOneWidget);
    });
    
    testWidgets('should display trip status correctly for completed trip', (WidgetTester tester) async {
      // Arrange - 建立過去的行程
      final pastTrip = testTrip.copyWith(
        days: [
          DayPlan(
            dayIndex: 1,
            date: DateTime.now().subtract(const Duration(days: 30)),
            theme: '過去行程',
            activities: testTrip.days.first.activities,
          ),
        ],
      );
      
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: TripMuseTheme.primaryColor),
          ),
          home: Scaffold(
            body: TripCard(trip: pastTrip),
          ),
        ),
      );
      
      // Assert
      expect(find.text('已完成'), findsOneWidget);
    });
    
    testWidgets('should handle tap events', (WidgetTester tester) async {
      // Arrange
      bool tapCalled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TripCard(
              trip: testTrip,
              onTap: () {
                tapCalled = true;
              },
            ),
          ),
        ),
      );
      
      // Act
      await tester.tap(find.byType(TripCard));
      await tester.pumpAndSettle();
      
      // Assert
      expect(tapCalled, isTrue);
    });
    
    testWidgets('should show popup menu with actions', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TripCard(trip: testTrip),
          ),
        ),
      );
      
      // Act
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.text('編輯'), findsOneWidget);
      expect(find.text('分享'), findsOneWidget);
      expect(find.text('刪除'), findsOneWidget);
    });
    
    testWidgets('should handle menu actions', (WidgetTester tester) async {
      // Arrange
      bool editCalled = false;
      bool shareCalled = false;
      bool deleteCalled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TripCard(
              trip: testTrip,
              onEdit: () => editCalled = true,
              onShare: () => shareCalled = true,
              onDelete: () => deleteCalled = true,
            ),
          ),
        ),
      );
      
      // Act & Assert - 測試編輯
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('編輯'));
      await tester.pumpAndSettle();
      expect(editCalled, isTrue);
      
      // Act & Assert - 測試分享
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('分享'));
      await tester.pumpAndSettle();
      expect(shareCalled, isTrue);
      
      // Act & Assert - 測試刪除
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('刪除'));
      await tester.pumpAndSettle();
      expect(deleteCalled, isTrue);
    });
    
    testWidgets('should display notes when available', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TripCard(trip: testTrip),
          ),
        ),
      );
      
      // Assert
      expect(find.text('探索台北的美食和文化'), findsOneWidget);
    });
    
    testWidgets('should not display notes when not available', (WidgetTester tester) async {
      // Arrange
      final tripWithoutNotes = testTrip.copyWith(notes: null);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TripCard(trip: tripWithoutNotes),
          ),
        ),
      );
      
      // Assert
      expect(find.text('探索台北的美食和文化'), findsNothing);
    });
  });
}