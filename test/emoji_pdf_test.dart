import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  group('Emoji PDF Support Tests', () {
    testWidgets('Should load emoji font successfully', (WidgetTester tester) async {
      // 測試載入 Emoji 字體
      try {
        final fontData = await rootBundle.load('assets/fonts/NotoColorEmoji.ttf');
        final emojiFont = pw.Font.ttf(fontData);
        
        expect(emojiFont, isNotNull);
        print('✅ Emoji 字體載入成功');
      } catch (e) {
        fail('載入 Emoji 字體失敗: $e');
      }
    });

    testWidgets('Should create PDF with emoji content', (WidgetTester tester) async {
      try {
        // 載入字體
        final emojiData = await rootBundle.load('assets/fonts/NotoColorEmoji.ttf');
        final chineseData = await rootBundle.load('assets/fonts/NotoSansTC-Regular.ttf');
        
        final emojiFont = pw.Font.ttf(emojiData);
        final chineseFont = pw.Font.ttf(chineseData);
        
        // 建立 PDF
        final pdf = pw.Document();
        
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.RichText(
                    text: pw.TextSpan(
                      children: [
                        pw.TextSpan(
                          text: '🎉',
                          style: pw.TextStyle(font: emojiFont, fontSize: 20),
                        ),
                        pw.TextSpan(
                          text: ' 歡迎使用 TripMuse！',
                          style: pw.TextStyle(font: chineseFont, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.RichText(
                    text: pw.TextSpan(
                      children: [
                        pw.TextSpan(
                          text: '📍',
                          style: pw.TextStyle(font: emojiFont, fontSize: 14),
                        ),
                        pw.TextSpan(
                          text: ' 地點：台北 101',
                          style: pw.TextStyle(font: chineseFont, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  pw.RichText(
                    text: pw.TextSpan(
                      children: [
                        pw.TextSpan(
                          text: '💰',
                          style: pw.TextStyle(font: emojiFont, fontSize: 14),
                        ),
                        pw.TextSpan(
                          text: ' 費用：NT\$ 500',
                          style: pw.TextStyle(font: chineseFont, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  pw.RichText(
                    text: pw.TextSpan(
                      children: [
                        pw.TextSpan(
                          text: '💡',
                          style: pw.TextStyle(font: emojiFont, fontSize: 14),
                        ),
                        pw.TextSpan(
                          text: ' 小貼士：記得帶相機！',
                          style: pw.TextStyle(font: chineseFont, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  pw.RichText(
                    text: pw.TextSpan(
                      children: [
                        pw.TextSpan(
                          text: '🚗',
                          style: pw.TextStyle(font: emojiFont, fontSize: 14),
                        ),
                        pw.TextSpan(
                          text: ' 交通：捷運',
                          style: pw.TextStyle(font: chineseFont, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
        
        final pdfBytes = await pdf.save();
        expect(pdfBytes.isNotEmpty, true);
        print('✅ 包含 Emoji 的 PDF 建立成功，大小: ${pdfBytes.length} bytes');
        
      } catch (e) {
        fail('建立包含 Emoji 的 PDF 失敗: $e');
      }
    });
  });
}