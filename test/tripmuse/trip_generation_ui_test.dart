/// TripMuse 行程生成 UI 和狀態管理測試
/// 
/// 測試行程生成的進度指示器、取消功能、超時處理和重試機制

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:mapbox_maps_example/tripmuse/models/models.dart';
import 'package:mapbox_maps_example/tripmuse/services/services.dart';
import 'package:mapbox_maps_example/tripmuse/providers/trip_generation_provider.dart';
import 'package:mapbox_maps_example/tripmuse/widgets/trip_generation_progress_widget.dart';
import 'package:mapbox_maps_example/tripmuse/widgets/trip_generation_error_widget.dart';

// 生成 Mock 類別
@GenerateMocks([
  TripGenerationService,
  TripRepositoryImpl,
])
import 'trip_generation_ui_test.mocks.dart';

void main() {
  group('TripMuse 行程生成 UI 測試', () {
    late MockTripGenerationService mockGenerationService;
    late MockTripRepositoryImpl mockTripRepository;
    late ProviderContainer container;

    setUp(() {
      mockGenerationService = MockTripGenerationService();
      mockTripRepository = MockTripRepositoryImpl();
      
      container = ProviderContainer(
        overrides: [
          tripGenerationServiceProvider.overrideWithValue(mockGenerationService),
          tripRepositoryProvider.overrideWithValue(mockTripRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('TripGenerationProgressDialog 測試', () {
      testWidgets('應該顯示進度對話框', (WidgetTester tester) async {
        final request = TripRequest(
          destination: '台北',
          days: 3,
          description: '美食之旅',
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              tripGenerationServiceProvider.overrideWithValue(mockGenerationService),
              tripRepositoryProvider.overrideWithValue(mockTripRepository),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: TripGenerationProgressDialog(
                  request: request,
                ),
              ),
            ),
          ),
        );

        // 驗證對話框元素
        expect(find.text('正在為您規劃行程'), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
        expect(find.text('取消'), findsOneWidget);
        expect(find.text('重新生成'), findsOneWidget);
      });

      testWidgets('應該顯示生成進度', (WidgetTester tester) async {
        final request = TripRequest(
          destination: '台北',
          days: 3,
          description: '美食之旅',
        );

        // 模擬進度更新
        when(mockGenerationService.generateTrip(
          any,
          onProgress: anyNamed('onProgress'),
          useCache: anyNamed('useCache'),
        )).thenAnswer((invocation) async {
          final onProgress = invocation.namedArguments[#onProgress] as Function(TripGenerationProgress)?;
          
          // 模擬進度更新
          onProgress?.call(const TripGenerationProgress(
            phase: TripGenerationPhase.analyzingPreferences,
            progress: 0.3,
            message: '正在分析您的旅行偏好...',
          ));

          await Future.delayed(const Duration(milliseconds: 100));

          onProgress?.call(const TripGenerationProgress(
            phase: TripGenerationPhase.generatingItinerary,
            progress: 0.7,
            message: '正在為您規劃精彩行程...',
          ));

          return _createMockTrip();
        });

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              tripGenerationServiceProvider.overrideWithValue(mockGenerationService),
              tripRepositoryProvider.overrideWithValue(mockTripRepository),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: TripGenerationProgressDialog(
                  request: request,
                ),
              ),
            ),
          ),
        );

        await tester.pump();

        // 驗證進度顯示
        expect(find.text('分析旅行偏好'), findsOneWidget);
        expect(find.text('30%'), findsOneWidget);
      });

      testWidgets('應該處理取消操作', (WidgetTester tester) async {
        final request = TripRequest(
          destination: '台北',
          days: 3,
          description: '美食之旅',
        );

        bool cancelCalled = false;

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              tripGenerationServiceProvider.overrideWithValue(mockGenerationService),
              tripRepositoryProvider.overrideWithValue(mockTripRepository),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: TripGenerationProgressDialog(
                  request: request,
                  onCancel: () => cancelCalled = true,
                ),
              ),
            ),
          ),
        );

        // 點擊取消按鈕
        await tester.tap(find.text('取消'));
        await tester.pump();

        expect(cancelCalled, isTrue);
      });

      testWidgets('應該處理生成成功', (WidgetTester tester) async {
        final request = TripRequest(
          destination: '台北',
          days: 3,
          description: '美食之旅',
        );

        final mockTrip = _createMockTrip();
        Trip? successTrip;

        when(mockGenerationService.generateTrip(
          any,
          onProgress: anyNamed('onProgress'),
          useCache: anyNamed('useCache'),
        )).thenAnswer((invocation) async {
          final onProgress = invocation.namedArguments[#onProgress] as Function(TripGenerationProgress)?;
          
          onProgress?.call(TripGenerationProgress(
            phase: TripGenerationPhase.completed,
            progress: 1.0,
            trip: mockTrip,
            message: '行程生成完成！',
          ));

          return mockTrip;
        });

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              tripGenerationServiceProvider.overrideWithValue(mockGenerationService),
              tripRepositoryProvider.overrideWithValue(mockTripRepository),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: TripGenerationProgressDialog(
                  request: request,
                  onSuccess: (trip) => successTrip = trip,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(successTrip, isNotNull);
        expect(successTrip?.id, equals(mockTrip.id));
      });

      testWidgets('應該處理生成錯誤', (WidgetTester tester) async {
        final request = TripRequest(
          destination: '台北',
          days: 3,
          description: '美食之旅',
        );

        String? errorMessage;

        when(mockGenerationService.generateTrip(
          any,
          onProgress: anyNamed('onProgress'),
          useCache: anyNamed('useCache'),
        )).thenThrow(Exception('網路連線錯誤'));

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              tripGenerationServiceProvider.overrideWithValue(mockGenerationService),
              tripRepositoryProvider.overrideWithValue(mockTripRepository),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: TripGenerationProgressDialog(
                  request: request,
                  onError: (error) => errorMessage = error,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(errorMessage, contains('網路連線錯誤'));
      });
    });

    group('TripGenerationController 測試', () {
      test('應該正確管理生成狀態', () async {
        final controller = TripGenerationController(
          mockGenerationService,
          mockTripRepository,
        );

        final request = TripRequest(
          destination: '台北',
          days: 3,
          description: '美食之旅',
        );

        // 初始狀態
        expect(controller.state.isIdle, isTrue);

        // 模擬成功生成
        final mockTrip = _createMockTrip();
        when(mockGenerationService.generateTrip(
          any,
          onProgress: anyNamed('onProgress'),
          useCache: anyNamed('useCache'),
        )).thenAnswer((_) async => mockTrip);

        when(mockTripRepository.saveTrip(any)).thenAnswer((_) async => null);

        // 開始生成
        final resultFuture = controller.generateTrip(request);

        // 檢查載入狀態
        expect(controller.state.isLoading, isTrue);
        expect(controller.state.canCancel, isTrue);

        // 等待完成
        final result = await resultFuture;

        // 檢查成功狀態
        expect(controller.state.isSuccess, isTrue);
        expect(controller.state.trip, equals(mockTrip));
        expect(result, equals(mockTrip));
      });

      test('應該處理取消操作', () async {
        final controller = TripGenerationController(
          mockGenerationService,
          mockTripRepository,
        );

        final request = TripRequest(
          destination: '台北',
          days: 3,
          description: '美食之旅',
        );

        // 模擬長時間生成
        when(mockGenerationService.generateTrip(
          any,
          onProgress: anyNamed('onProgress'),
          useCache: anyNamed('useCache'),
        )).thenAnswer((_) async {
          await Future.delayed(const Duration(seconds: 5));
          return _createMockTrip();
        });

        // 開始生成
        final resultFuture = controller.generateTrip(request);

        // 等待一下然後取消
        await Future.delayed(const Duration(milliseconds: 100));
        await controller.cancelGeneration();

        // 等待結果
        final result = await resultFuture;

        // 檢查取消狀態
        expect(controller.state.isCancelled, isTrue);
        expect(result, isNull);
      });

      test('應該處理重試機制', () async {
        final controller = TripGenerationController(
          mockGenerationService,
          mockTripRepository,
        );

        final request = TripRequest(
          destination: '台北',
          days: 3,
          description: '美食之旅',
        );

        // 第一次失敗
        when(mockGenerationService.generateTrip(
          any,
          onProgress: anyNamed('onProgress'),
          useCache: anyNamed('useCache'),
        )).thenThrow(Exception('網路錯誤'));

        // 嘗試生成
        await controller.generateTrip(request);

        // 檢查錯誤狀態
        expect(controller.state.isError, isTrue);
        expect(controller.state.canRetry, isTrue);
        expect(controller.state.retryCount, equals(0));

        // 模擬第二次成功
        final mockTrip = _createMockTrip();
        when(mockGenerationService.generateTrip(
          any,
          onProgress: anyNamed('onProgress'),
          useCache: anyNamed('useCache'),
        )).thenAnswer((_) async => mockTrip);

        when(mockTripRepository.saveTrip(any)).thenAnswer((_) async => null);

        // 重試
        final result = await controller.retryGeneration(request);

        // 檢查成功狀態
        expect(controller.state.isSuccess, isTrue);
        expect(controller.state.retryCount, equals(1));
        expect(result, equals(mockTrip));
      });

      test('應該處理超時', () async {
        final controller = TripGenerationController(
          mockGenerationService,
          mockTripRepository,
        );

        final request = TripRequest(
          destination: '台北',
          days: 3,
          description: '美食之旅',
        );

        // 模擬超時
        when(mockGenerationService.generateTrip(
          any,
          onProgress: anyNamed('onProgress'),
          useCache: anyNamed('useCache'),
        )).thenAnswer((_) async {
          await Future.delayed(const Duration(minutes: 10)); // 超過預設超時時間
          return _createMockTrip();
        });

        // 使用短超時時間進行測試
        final result = await controller.generateTrip(
          request,
          timeout: const Duration(milliseconds: 100),
        );

        // 檢查超時狀態
        expect(controller.state.isTimeout, isTrue);
        expect(controller.state.canRetry, isTrue);
        expect(result, isNull);
      });
    });

    group('TripGenerationErrorWidget 測試', () {
      testWidgets('應該顯示網路錯誤', (WidgetTester tester) async {
        final errorDetails = TripGenerationErrorDetails.fromError('網路連線錯誤');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TripGenerationErrorWidget(
                errorDetails: errorDetails,
              ),
            ),
          ),
        );

        expect(find.text('網路連線錯誤'), findsOneWidget);
        expect(find.text('請檢查網路連線後重試'), findsOneWidget);
        expect(find.byIcon(Icons.wifi_off), findsOneWidget);
        expect(find.text('重試'), findsOneWidget);
      });

      testWidgets('應該顯示超時錯誤', (WidgetTester tester) async {
        final errorDetails = TripGenerationErrorDetails.fromError('請求超時');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TripGenerationErrorWidget(
                errorDetails: errorDetails,
              ),
            ),
          ),
        );

        expect(find.text('請求超時'), findsOneWidget);
        expect(find.text('請稍後再試，或檢查網路連線'), findsOneWidget);
        expect(find.byIcon(Icons.access_time), findsOneWidget);
      });

      testWidgets('應該處理重試操作', (WidgetTester tester) async {
        final errorDetails = TripGenerationErrorDetails.fromError('網路連線錯誤');
        bool retryPressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TripGenerationErrorWidget(
                errorDetails: errorDetails,
                onRetry: () => retryPressed = true,
              ),
            ),
          ),
        );

        await tester.tap(find.text('重試'));
        await tester.pump();

        expect(retryPressed, isTrue);
      });

      testWidgets('應該顯示聯絡客服選項', (WidgetTester tester) async {
        final errorDetails = TripGenerationErrorDetails.fromError('伺服器錯誤');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TripGenerationErrorWidget(
                errorDetails: errorDetails,
                showContactSupport: true,
              ),
            ),
          ),
        );

        expect(find.text('聯絡客服'), findsOneWidget);

        // 點擊聯絡客服
        await tester.tap(find.text('聯絡客服'));
        await tester.pumpAndSettle();

        expect(find.text('📧 Email: support@tripmuse.com'), findsOneWidget);
      });
    });

    group('錯誤類型解析測試', () {
      test('應該正確解析網路錯誤', () {
        final errorDetails = TripGenerationErrorDetails.fromError('網路連線失敗');
        
        expect(errorDetails.type, equals(TripGenerationErrorType.network));
        expect(errorDetails.canRetry, isTrue);
        expect(errorDetails.suggestion, contains('網路連線'));
      });

      test('應該正確解析超時錯誤', () {
        final errorDetails = TripGenerationErrorDetails.fromError('請求超時');
        
        expect(errorDetails.type, equals(TripGenerationErrorType.timeout));
        expect(errorDetails.canRetry, isTrue);
        expect(errorDetails.retryAfter, equals(const Duration(seconds: 30)));
      });

      test('應該正確解析 API 限制錯誤', () {
        final errorDetails = TripGenerationErrorDetails.fromError('API 使用限制');
        
        expect(errorDetails.type, equals(TripGenerationErrorType.apiLimit));
        expect(errorDetails.canRetry, isTrue);
        expect(errorDetails.retryAfter, equals(const Duration(minutes: 5)));
      });

      test('應該正確解析驗證錯誤', () {
        final errorDetails = TripGenerationErrorDetails.fromError('資料驗證失敗');
        
        expect(errorDetails.type, equals(TripGenerationErrorType.validation));
        expect(errorDetails.canRetry, isFalse);
      });

      test('應該正確解析伺服器錯誤', () {
        final errorDetails = TripGenerationErrorDetails.fromError('伺服器內部錯誤 500');
        
        expect(errorDetails.type, equals(TripGenerationErrorType.server));
        expect(errorDetails.canRetry, isTrue);
        expect(errorDetails.retryAfter, equals(const Duration(minutes: 1)));
      });

      test('應該正確解析未知錯誤', () {
        final errorDetails = TripGenerationErrorDetails.fromError('未知的錯誤訊息');
        
        expect(errorDetails.type, equals(TripGenerationErrorType.unknown));
        expect(errorDetails.canRetry, isTrue);
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
    preferenceAnalysis: const UserPreferenceAnalysis(
      primaryFocus: '美食探索',
      travelPace: TravelPace.slow,
      budgetRange: BudgetRange.mid,
      interests: ['美食', '文化'],
      avoidances: [],
      mood: '探索新奇',
      keywords: ['美食', '傳統'],
      confidence: 0.8,
      analyzedAt: null,
    ),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}