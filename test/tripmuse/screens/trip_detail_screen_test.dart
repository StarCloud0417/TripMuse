import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../lib/tripmuse/screens/trip_detail_screen.dart';
import '../../../lib/tripmuse/models/models.dart';

void main() {
  group('TripDetailScreen Tests', () {
    testWidgets('TripDetailScreen displays trip information correctly', (WidgetTester tester) async {
      // 創建測試數據
      final testTrip = Trip(
        id: 'test-trip-1',
        title: '東京探索之旅',
        destination: Destination(
          name: '東京',
          city: '東京',
          country: '日本',
          lat: 35.6762,
          lng: 139.6503,
        ),
        days: [
          DayPlan(
            dayIndex: 1,
            date: DateTime(2025, 1, 1),
            theme: '城市探索',
            activities: [
              Activity(
                id: 'activity-1',
                name: '東京鐵塔',
                description: '參觀東京鐵塔，俯瞰東京市景',
                lat: 35.6586,
                lng: 139.7454,
                timeFrom: '10:00',
                timeTo: '12:00',
                category: ActivityCategory.sightseeing,
                priority: ActivityPriority.high,
                estimatedCost: 'NT\$ 200',
                tips: '建議早上前往避開人潮',
              ),
            ],
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: TripStatus.draft,
        preferenceAnalysis: UserPreferenceAnalysis(
          primaryFocus: '文化體驗',
          travelPace: TravelPace.medium,
          budgetRange: BudgetRange.mid,
          interests: ['文化', '美食'],
          avoidances: ['人潮'],
          mood: '輕鬆愉快',
          keywords: ['東京', '文化'],
        ),
      );

      // 建立測試環境
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TripDetailScreen(trip: testTrip),
          ),
        ),
      );

      // 等待組件渲染完成
      await tester.pumpAndSettle();

      // 驗證基本資訊顯示
      expect(find.text('東京探索之旅'), findsOneWidget);
      expect(find.text('東京'), findsOneWidget);
      expect(find.text('1 天行程'), findsOneWidget);

      // 驗證偏好分析顯示
      expect(find.text('旅行偏好'), findsOneWidget);
      expect(find.text('預算: 中等'), findsOneWidget);
      expect(find.text('節奏: 適中'), findsOneWidget);

      // 驗證每日行程顯示
      expect(find.text('每日行程'), findsOneWidget);
      expect(find.text('第 1 天'), findsOneWidget);
      expect(find.text('城市探索'), findsOneWidget);

      // 驗證活動顯示
      expect(find.text('東京鐵塔'), findsOneWidget);
      expect(find.text('參觀東京鐵塔，俯瞰東京市景'), findsOneWidget);
    });

    testWidgets('TripDetailScreen handles trips without preference analysis', (WidgetTester tester) async {
      // 創建沒有偏好分析的測試數據
      final testTrip = Trip(
        id: 'test-trip-2',
        title: '簡單旅行',
        destination: Destination(
          name: '台北',
          city: '台北',
          country: '台灣',
          lat: 25.0330,
          lng: 121.5654,
        ),
        days: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: TripStatus.draft,
      );

      // 建立測試環境
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TripDetailScreen(trip: testTrip),
          ),
        ),
      );

      // 等待組件渲染完成
      await tester.pumpAndSettle();

      // 驗證基本資訊顯示
      expect(find.text('簡單旅行'), findsOneWidget);
      expect(find.text('台北'), findsOneWidget);
      expect(find.text('0 天行程'), findsOneWidget);

      // 驗證沒有偏好分析區塊
      expect(find.text('旅行偏好'), findsNothing);
    });

    testWidgets('TripDetailScreen back button works', (WidgetTester tester) async {
      final testTrip = Trip(
        id: 'test-trip-3',
        title: '測試行程',
        destination: Destination(
          name: '測試',
          city: '測試',
          country: '測試',
          lat: 0.0,
          lng: 0.0,
        ),
        days: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: TripStatus.draft,
      );

      // 建立測試環境
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TripDetailScreen(trip: testTrip),
                      ),
                    );
                  },
                  child: const Text('前往詳情頁面'),
                ),
              ),
            ),
          ),
        ),
      );

      // 點擊按鈕前往詳情頁面
      await tester.tap(find.text('前往詳情頁面'));
      await tester.pumpAndSettle();

      // 驗證已導航到詳情頁面
      expect(find.text('測試行程'), findsOneWidget);

      // 點擊返回按鈕
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // 驗證已返回上一頁
      expect(find.text('測試行程'), findsNothing);
      expect(find.text('前往詳情頁面'), findsOneWidget);
    });
  });
}
