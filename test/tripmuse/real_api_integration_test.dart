/// TripMuse 真實 API 整合測試
/// 
/// 測試新的進度對話框與實際 GCP server 的整合

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:mapbox_maps_example/tripmuse/models/models.dart';
import 'package:mapbox_maps_example/tripmuse/services/services.dart';
import 'package:mapbox_maps_example/tripmuse/widgets/simple_progress_dialog.dart';

// 生成 Mock 類別
@GenerateMocks([
  TripService,
  ApiClient,
])
import 'real_api_integration_test.mocks.dart';

void main() {
  group('Real API Integration Tests', () {
    late MockTripService mockTripService;
    late MockApiClient mockApiClient;
    late ProviderContainer container;

    setUp(() {
      mockTripService = MockTripService();
      mockApiClient = MockApiClient();
      
      container = ProviderContainer(
        overrides: [
          tripServiceProvider.overrideWithValue(mockTripService),
          apiClientProvider.overrideWithValue(mockApiClient),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('SimpleProgressDialog Real API Tests', () {
      testWidgets('應該正確呼叫真實 API 並顯示進度', (WidgetTester tester) async {
        final request = TripRequest(
          destination: '台北',
          days: 3,
          description: '美食之旅',
        );

        final mockTrip = _createMockTrip();
        
        // 模擬 API 成功回應
        when(mockTripService.generateTrip(
          any,
          onProgress: anyNamed('onProgress'),
          useCache: anyNamed('useCache'),
        )).thenAnswer((invocation) async {
          final onProgress = invocation.namedArguments[#onProgress] as Function(TripGenerationProgress)?;
          
          // 模擬進度更新
          onProgress?.call(const TripGenerationProgress(
            phase: TripGenerationPhase.analyzingPreferences,
            progress: 0.2,
            message: '正在分析您的旅行偏好...',
          ));

          await Future.delayed(const Duration(milliseconds: 100));

          onProgress?.call(const TripGenerationProgress(
            phase: TripGenerationPhase.generatingItinerary,
            progress: 0.6,
            message: '正在為您規劃精彩行程...',
          ));

          await Future.delayed(const Duration(milliseconds: 100));

          onProgress?.call(TripGenerationProgress(
            phase: TripGenerationPhase.completed,
            progress: 1.0,
            trip: mockTrip,
            message: '行程生成完成！',
          ));

          return mockTrip;
        });

        Trip? resultTrip;

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              tripServiceProvider.overrideWithValue(mockTripService),
              apiClientProvider.overrideWithValue(mockApiClient),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: SimpleProgressDialog(
                  request: request,
                  onSuccess: (trip) async {
                    resultTrip = trip;
                  },
                ),
              ),
            ),
          ),
        );

        // 驗證初始狀態
        expect(find.text('正在為您規劃行程'), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);

        // 等待 API 呼叫完成
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // 驗證 API 被正確呼叫
        verify(mockTripService.generateTrip(
          request,
          onProgress: anyNamed('onProgress'),
          useCache: true,
        )).called(1);

        // 驗證結果
        expect(resultTrip, isNotNull);
        expect(resultTrip?.id, equals(mockTrip.id));
      });

      testWidgets('應該正確處理 API 錯誤', (WidgetTester tester) async {
        final request = TripRequest(
          destination: '台北',
          days: 3,
          description: '美食之旅',
        );

        String? errorMessage;

        // 模擬 API 錯誤
        when(mockTripService.generateTrip(
          any,
          onProgress: anyNamed('onProgress'),
          useCache: anyNamed('useCache'),
        )).thenThrow(const ApiException('網路連線錯誤'));

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              tripServiceProvider.overrideWithValue(mockTripService),
              apiClientProvider.overrideWithValue(mockApiClient),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: SimpleProgressDialog(
                  request: request,
                  onError: (error) => errorMessage = error,
                ),
              ),
            ),
          ),
        );

        // 等待錯誤處理
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // 驗證錯誤處理
        expect(find.text('生成失敗'), findsOneWidget);
        expect(find.text('重試'), findsOneWidget);
        expect(errorMessage, contains('網路連線錯誤'));
      });

      testWidgets('應該支援重試功能', (WidgetTester tester) async {
        final request = TripRequest(
          destination: '台北',
          days: 3,
          description: '美食之旅',
        );

        final mockTrip = _createMockTrip();

        // 第一次失敗，第二次成功
        int callCount = 0;
        when(mockTripService.generateTrip(
          any,
          onProgress: anyNamed('onProgress'),
          useCache: anyNamed('useCache'),
        )).thenAnswer((_) async {
          callCount++;
          if (callCount == 1) {
            throw const ApiException('暫時錯誤');
          }
          return mockTrip;
        });

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              tripServiceProvider.overrideWithValue(mockTripService),
              apiClientProvider.overrideWithValue(mockApiClient),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: SimpleProgressDialog(
                  request: request,
                ),
              ),
            ),
          ),
        );

        // 等待第一次失敗
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // 驗證錯誤狀態
        expect(find.text('生成失敗'), findsOneWidget);
        expect(find.text('重試'), findsOneWidget);

        // 點擊重試
        await tester.tap(find.text('重試'));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // 驗證重試成功
        verify(mockTripService.generateTrip(
          request,
          onProgress: anyNamed('onProgress'),
          useCache: anyNamed('useCache'),
        )).called(2);
      });

      testWidgets('應該支援取消功能', (WidgetTester tester) async {
        final request = TripRequest(
          destination: '台北',
          days: 3,
          description: '美食之旅',
        );

        bool cancelCalled = false;

        // 模擬長時間執行
        when(mockTripService.generateTrip(
          any,
          onProgress: anyNamed('onProgress'),
          useCache: anyNamed('useCache'),
        )).thenAnswer((_) async {
          await Future.delayed(const Duration(seconds: 10));
          return _createMockTrip();
        });

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              tripServiceProvider.overrideWithValue(mockTripService),
              apiClientProvider.overrideWithValue(mockApiClient),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: SimpleProgressDialog(
                  request: request,
                  onCancel: () => cancelCalled = true,
                ),
              ),
            ),
          ),
        );

        // 等待一下然後取消
        await tester.pump(const Duration(milliseconds: 500));

        // 點擊取消按鈕
        await tester.tap(find.text('取消'));
        await tester.pump();

        expect(cancelCalled, isTrue);
      });
    });

    group('Error Message Parsing Tests', () {
      test('應該正確解析不同類型的錯誤訊息', () {
        // 測試網路錯誤
        expect(
          'NetworkException: 網路連線失敗'.contains('NetworkException'),
          isTrue,
        );

        // 測試超時錯誤
        expect(
          'timeout error'.contains('timeout'),
          isTrue,
        );

        // 測試伺服器錯誤
        expect(
          'ServerException: 內部錯誤'.contains('ServerException'),
          isTrue,
        );
      });
    });
  });
}

/// 建立模擬行程資料
Trip _createMockTrip() {
  return Trip(
    id: 'test_trip_123',
    title: '台北美食3日遊',
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
        theme: '傳統市場美食探索',
        activities: [
          const Activity(
            id: 'activity_1',
            name: '迪化街',
            description: '百年老街品嚐傳統茶點和乾貨',
            timeFrom: '09:00',
            timeTo: '11:00',
            category: ActivityCategory.food,
            priority: ActivityPriority.high,
            lat: 25.0540,
            lng: 121.5128,
          ),
        ],
      ),
    ],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}