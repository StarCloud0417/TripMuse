import 'package:flutter_test/flutter_test.dart';
import '../lib/tripmuse/services/pdf_service.dart';
import '../lib/tripmuse/models/models.dart';

void main() {
  group('TripMuse Emoji PDF Tests', () {
    testWidgets('Should generate PDF with emoji for sample trip', (WidgetTester tester) async {
      // 建立測試行程資料
      final destination = Destination(
        name: '台北市',
        city: '台北',
        country: '台灣',
        fullAddress: '台北市信義區信義路五段7號',
        lat: 25.0330,
        lng: 121.5654,
      );

      final activities = <Activity>[
        Activity(
          id: '1',
          name: '台北 101 觀景台',
          description: '登上台北最高建築，俯瞰整個城市美景 🌆',
          category: ActivityCategory.sightseeing,
          priority: ActivityPriority.high,
          timeFrom: '09:00',
          timeTo: '11:00',
          estimatedCost: 'NT\$ 600',
          address: '台北市信義區信義路五段7號',
          tips: '建議提早購票，避免排隊等候 ⏰',
        ),
        Activity(
          id: '2',
          name: '象山步道健行',
          description: '輕鬆的登山步道，是拍攝台北 101 的絕佳地點 📸',
          category: ActivityCategory.outdoor,
          priority: ActivityPriority.medium,
          timeFrom: '14:00',
          timeTo: '16:00',
          estimatedCost: '免費',
          address: '台北市信義區信義路五段150巷',
          tips: '記得帶水和防曬用品 ☀️',
        ),
      ];

      final transports = [
        TransportInfo(
          mode: TransportMode.metro,
          durationMinutes: 15,
          estimatedCost: 'NT\$ 25',
        ),
      ];

      final dayPlan = DayPlan(
        dayIndex: 1,
        date: DateTime(2024, 3, 15),
        theme: '探索台北地標與自然美景 🏙️🌿',
        activities: activities,
        transports: transports,
        notes: '今天的行程結合了城市觀光和戶外活動，記得穿舒適的鞋子 👟',
      );

      final trip = Trip(
        id: 'test-trip-1',
        title: '台北週末小旅行 ✈️',
        destination: destination,
        days: [dayPlan],
        createdAt: DateTime(2024, 3, 15),
        updatedAt: DateTime(2024, 3, 15),
        notes: '這是一個充滿樂趣的台北一日遊，包含必訪景點和美食體驗 🍜🎉',
      );

      try {
        // 生成 PDF
        final pdfBytes = await PdfService.generateTripPdf(trip, language: 'zh');
        
        expect(pdfBytes.isNotEmpty, true);
        print('✅ TripMuse Emoji PDF 生成成功！');
        print('📄 PDF 大小: ${pdfBytes.length} bytes');
        print('🎯 包含 ${trip.totalActivities} 個活動');
        print('📍 目的地: ${trip.destination.name}');
        
        // 可選：儲存 PDF 到檔案系統進行手動檢查
        // final filePath = await PdfService.savePdfToDevice(pdfBytes, 'test_emoji_trip.pdf');
        // print('💾 PDF 已儲存至: $filePath');
        
      } catch (e) {
        fail('生成 TripMuse Emoji PDF 失敗: $e');
      }
    });
  });
}