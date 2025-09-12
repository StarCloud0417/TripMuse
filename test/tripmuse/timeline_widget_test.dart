/// TripMuse 時間軸組件測試
/// 
/// 測試時間軸視圖組件的功能

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapbox_maps_example/tripmuse/widgets/timeline_widget.dart';
import 'package:mapbox_maps_example/tripmuse/models/models.dart';

void main() {
  group('TripMuse 時間軸組件測試', () {
    group('TimelineWidget 測試', () {
      testWidgets('應該顯示空狀態當沒有行程時', (WidgetTester tester) async {
        // 建立空行程
        final emptyTrip = Trip(
          id: 'empty-trip',
          title: '空行程',
          destination: const Destination(
            name: '測試目的地',
            city: '測試城市',
            country: '測試國家',
            lat: 0.0,
            lng: 0.0,
          ),
          days: [], // 空的行程
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: TimelineWidget(trip: emptyTrip),
              ),
            ),
          ),
        );

        // 驗證空狀態顯示
        expect(find.text('暫無行程安排'), findsOneWidget);
        expect(find.text('開始規劃您的精彩旅程吧！'), findsOneWidget);
        expect(find.byIcon(Icons.timeline), findsAtLeastNWidgets(1));
      });

      testWidgets('應該顯示視圖切換按鈕', (WidgetTester tester) async {
        // 建立測試行程
        final testTrip = Trip(
          id: 'test-trip',
          title: '測試行程',
          destination: const Destination(
            name: '測試目的地',
            city: '測試城市',
            country: '測試國家',
            lat: 0.0,
            lng: 0.0,
          ),
          days: [
            DayPlan(
              dayIndex: 1,
              date: DateTime.now(),
              theme: '測試主題',
              activities: [],
            ),
          ],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: TimelineWidget(trip: testTrip),
              ),
            ),
          ),
        );

        // 驗證視圖切換按鈕
        expect(find.text('時間軸'), findsOneWidget);
        expect(find.text('地圖'), findsOneWidget);
      });

      testWidgets('應該顯示行程內容', (WidgetTester tester) async {
        // 建立有內容的測試行程
        final testTrip = Trip(
          id: 'test-trip',
          title: '測試行程',
          destination: const Destination(
            name: '測試目的地',
            city: '測試城市',
            country: '測試國家',
            lat: 0.0,
            lng: 0.0,
          ),
          days: [
            DayPlan(
              dayIndex: 1,
              date: DateTime.now(),
              theme: '測試主題',
              activities: [
                const Activity(
                  id: 'test-activity',
                  name: '測試活動',
                  description: '測試活動描述',
                  timeFrom: '09:00',
                  timeTo: '10:00',
                  category: ActivityCategory.sightseeing,
                  priority: ActivityPriority.high,
                ),
              ],
            ),
          ],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: TimelineWidget(trip: testTrip),
              ),
            ),
          ),
        );

        // 驗證行程內容顯示
        expect(find.text('測試主題'), findsOneWidget);
        expect(find.text('測試活動'), findsOneWidget);
        expect(find.text('09:00 - 10:00'), findsAtLeastNWidgets(1));
      });
    });
  });
}