import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/models.dart';
import 'pdf_localization_service.dart';

/// PDF 生成服務
/// 
/// 負責將行程資料轉換為格式化的 PDF 文件
/// 支援多語言和離線功能
class PdfService {
  static const double _pageMargin = 40.0;
  static const double _sectionSpacing = 20.0;
  static const double _itemSpacing = 12.0;

  /// 生成行程 PDF
  static Future<Uint8List> generateTripPdf(Trip trip, {String? language}) async {
    print('📄 開始生成 PDF: ${trip.title}');
    print('🌐 語言設定: ${language ?? "預設"}');
    
    final pdf = pw.Document();
    
    // 載入支援中文的字體
    print('🔤 載入字體中...');
    final fonts = await _loadFonts();
    final font = fonts['regular']!;
    final boldFont = fonts['bold']!;
    final emojiFont = fonts['emoji']!;
    print('✅ 字體載入完成');

    // 封面頁
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(_pageMargin),
        build: (pw.Context context) => _buildCoverPage(trip, font, boldFont, emojiFont, language),
      ),
    );

    // 概覽頁
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(_pageMargin),
        build: (pw.Context context) => _buildOverviewPage(trip, font, boldFont, emojiFont, language),
      ),
    );

    // 每日詳情頁
    for (int i = 0; i < trip.days.length; i++) {
      final day = trip.days[i];
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(_pageMargin),
          build: (pw.Context context) => _buildDayDetailPage(day, font, boldFont, emojiFont, language),
        ),
      );
    }

    return pdf.save();
  }

  /// 儲存 PDF 到裝置
  static Future<String> savePdfToDevice(Uint8List pdfData, String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsBytes(pdfData);
      return file.path;
    } catch (e) {
      throw Exception('儲存 PDF 失敗: $e');
    }
  }

  /// 檢查網路連線狀態
  static Future<bool> isOnline() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  /// 離線 PDF 生成（使用快取資料）
  static Future<Uint8List> generateOfflinePdf(Trip trip, {String? language}) async {
    // 離線模式下使用相同的生成邏輯，但不依賴網路資源
    return generateTripPdf(trip, language: language);
  }

  /// 載入字體（統一處理）
  static Future<Map<String, pw.Font>> _loadFonts() async {
    pw.Font regularFont;
    pw.Font boldFont;
    pw.Font? emojiFont;
    
    try {
      // 載入 Emoji 字體
      emojiFont = await _loadEmojiFont();
      print('✅ 成功載入 Emoji 字體');
    } catch (e) {
      print('⚠️ 無法載入 Emoji 字體: $e');
    }
    
    try {
      // 優先嘗試載入 assets 中的字體檔案
      regularFont = await _loadAssetChineseFont();
      boldFont = await _loadAssetChineseBoldFont();
      
      print('✅ 成功載入 Assets 中文字體');
      
    } catch (e) {
      print('⚠️ 無法載入 Assets 字體: $e');
      
      try {
        // 備用方案：嘗試載入系統中文字體
        regularFont = await _tryLoadSystemChineseFont();
        boldFont = await _tryLoadSystemChineseBoldFont();
        
        print('✅ 成功載入系統中文字體');
        
      } catch (e2) {
        print('⚠️ 無法載入系統中文字體: $e2');
        print('⚠️ 使用預設字體，中文字符可能顯示為方塊');
        
        // 最終備用方案：使用預設字體
        regularFont = pw.Font.helvetica();
        boldFont = pw.Font.helveticaBold();
      }
    }
    
    return {
      'regular': regularFont,
      'bold': boldFont,
      'emoji': emojiFont ?? regularFont,
    };
  }

  /// 載入 Emoji 字體
  static Future<pw.Font> _loadEmojiFont() async {
    try {
      print('🔍 載入 Emoji 字體: assets/fonts/NotoColorEmoji.ttf');
      final fontData = await rootBundle.load('assets/fonts/NotoColorEmoji.ttf');
      final font = pw.Font.ttf(fontData);
      print('✅ 成功載入 Emoji 字體');
      return font;
    } catch (e) {
      throw Exception('載入 Emoji 字體失敗: $e');
    }
  }

  /// 載入 Assets 中的中文字體
  static Future<pw.Font> _loadAssetChineseFont() async {
    try {
      // 嘗試載入 assets 中的字體檔案
      final fontPaths = [
        'assets/fonts/NotoSansTC-Regular.ttf',
        'assets/fonts/NotoSansCJK-Regular.ttf',
        'assets/fonts/SourceHanSans-Regular.ttf',
        'assets/fonts/chinese-font-regular.ttf',
      ];
      
      for (final path in fontPaths) {
        try {
          print('🔍 嘗試載入 Assets 字體: $path');
          final fontData = await rootBundle.load(path);
          final font = pw.Font.ttf(fontData);
          print('✅ 成功載入 Assets 字體: $path');
          return font;
        } catch (e) {
          print('❌ 載入 Assets 字體失敗 $path: $e');
          continue;
        }
      }
      
      throw Exception('找不到可用的 Assets 中文字體檔案');
      
    } catch (e) {
      throw Exception('載入 Assets 中文字體失敗: $e');
    }
  }

  /// 載入 Assets 中的中文粗體字體
  static Future<pw.Font> _loadAssetChineseBoldFont() async {
    try {
      final boldFontPaths = [
        'assets/fonts/NotoSansTC-Bold.ttf',
        'assets/fonts/NotoSansCJK-Bold.ttf',
        'assets/fonts/SourceHanSans-Bold.ttf',
        'assets/fonts/chinese-font-bold.ttf',
      ];
      
      for (final path in boldFontPaths) {
        try {
          final fontData = await rootBundle.load(path);
          return pw.Font.ttf(fontData);
        } catch (e) {
          continue;
        }
      }
      
      // 如果找不到粗體，使用一般字體
      return await _loadAssetChineseFont();
      
    } catch (e) {
      // 如果找不到粗體，使用一般字體
      return await _loadAssetChineseFont();
    }
  }

  /// 嘗試載入系統中文字體
  static Future<pw.Font> _tryLoadSystemChineseFont() async {
    if (Platform.isAndroid) {
      // Android 常見中文字體路徑
      final fontPaths = [
        '/system/fonts/NotoSansCJK-Regular.ttc',
        '/system/fonts/DroidSansFallback.ttf',
        '/system/fonts/NotoSansTC-Regular.otf',
        '/system/fonts/SourceHanSans-Regular.ttc',
        '/system/fonts/NotoSansTC-Regular.ttf',
      ];
      
      for (final path in fontPaths) {
        try {
          final file = File(path);
          if (await file.exists()) {
            print('🔍 嘗試載入字體: $path');
            final fontData = await file.readAsBytes();
            final font = pw.Font.ttf(fontData.buffer.asByteData());
            print('✅ 成功載入字體: $path');
            return font;
          }
        } catch (e) {
          print('❌ 載入字體失敗 $path: $e');
          continue;
        }
      }
    } else if (Platform.isIOS) {
      // iOS 系統字體（需要不同的處理方式）
      print('📱 iOS 平台暫不支援系統字體載入');
    }
    
    throw Exception('找不到可用的系統中文字體');
  }

  /// 嘗試載入系統中文粗體字體
  static Future<pw.Font> _tryLoadSystemChineseBoldFont() async {
    if (Platform.isAndroid) {
      final boldFontPaths = [
        '/system/fonts/NotoSansCJK-Bold.ttc',
        '/system/fonts/NotoSansTC-Bold.otf',
        '/system/fonts/SourceHanSans-Bold.ttc',
        '/system/fonts/NotoSansTC-Bold.ttf',
      ];
      
      for (final path in boldFontPaths) {
        try {
          final file = File(path);
          if (await file.exists()) {
            final fontData = await file.readAsBytes();
            return pw.Font.ttf(fontData.buffer.asByteData());
          }
        } catch (e) {
          continue;
        }
      }
    }
    
    // 如果找不到粗體，使用一般字體
    return await _tryLoadSystemChineseFont();
  }

  /// 建立包含 Emoji 的文字
  static pw.Widget _buildTextWithEmoji(
    String text, 
    pw.Font regularFont, 
    pw.Font emojiFont, {
    double fontSize = 12,
    PdfColor? color,
    pw.FontWeight? fontWeight,
    pw.TextAlign? textAlign,
  }) {
    // 檢查文字是否包含 emoji
    final emojiRegex = RegExp(r'[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|[\u{1F1E0}-\u{1F1FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]', unicode: true);
    
    if (emojiRegex.hasMatch(text)) {
      // 如果包含 emoji，分割文字並分別處理
      final parts = <pw.InlineSpan>[];
      final matches = emojiRegex.allMatches(text);
      int lastEnd = 0;
      
      for (final match in matches) {
        // 添加 emoji 前的文字
        if (match.start > lastEnd) {
          final beforeText = text.substring(lastEnd, match.start);
          if (beforeText.isNotEmpty) {
            parts.add(pw.TextSpan(
              text: beforeText,
              style: pw.TextStyle(
                font: regularFont,
                fontSize: fontSize,
                color: color,
                fontWeight: fontWeight,
              ),
            ));
          }
        }
        
        // 添加 emoji
        parts.add(pw.TextSpan(
          text: match.group(0)!,
          style: pw.TextStyle(
            font: emojiFont,
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
          ),
        ));
        
        lastEnd = match.end;
      }
      
      // 添加最後剩餘的文字
      if (lastEnd < text.length) {
        final remainingText = text.substring(lastEnd);
        if (remainingText.isNotEmpty) {
          parts.add(pw.TextSpan(
            text: remainingText,
            style: pw.TextStyle(
              font: regularFont,
              fontSize: fontSize,
              color: color,
              fontWeight: fontWeight,
            ),
          ));
        }
      }
      
      return pw.RichText(
        text: pw.TextSpan(children: parts),
        textAlign: textAlign ?? pw.TextAlign.left,
      );
    } else {
      // 如果不包含 emoji，使用一般字體
      return pw.Text(
        text,
        style: pw.TextStyle(
          font: regularFont,
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
        ),
        textAlign: textAlign,
      );
    }
  }

  /// 建立封面頁
  static pw.Widget _buildCoverPage(Trip trip, pw.Font font, pw.Font boldFont, pw.Font emojiFont, String? language) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Spacer(flex: 2),
        
        // 標題
        pw.Center(
          child: pw.Text(
            trip.title,
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 32,
              color: PdfColors.blue800,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ),
        
        pw.SizedBox(height: 30),
        
        // 目的地
        pw.Center(
          child: pw.Text(
            trip.destination.name,
            style: pw.TextStyle(
              font: font,
              fontSize: 20,
              color: PdfColors.grey700,
            ),
          ),
        ),
        
        pw.SizedBox(height: 40),
        
        // 行程資訊卡片
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(20),
          decoration: pw.BoxDecoration(
            color: PdfColors.blue50,
            borderRadius: pw.BorderRadius.circular(10),
            border: pw.Border.all(color: PdfColors.blue200),
          ),
          child: pw.Column(
            children: [
              _buildInfoRow(
                PdfLocalizationService.getText('cover_trip_days', language), 
                '${trip.totalDays}${PdfLocalizationService.getText('cover_days', language)}', 
                font, 
                boldFont
              ),
              pw.SizedBox(height: 10),
              _buildInfoRow(
                PdfLocalizationService.getText('cover_total_activities', language), 
                '${trip.totalActivities}${PdfLocalizationService.getText('cover_activities', language)}', 
                font, 
                boldFont
              ),
              pw.SizedBox(height: 10),
              if (trip.startDate != null)
                _buildInfoRow(
                  PdfLocalizationService.getText('cover_start_date', language), 
                  _formatDate(trip.startDate!, language), 
                  font, 
                  boldFont
                ),
              if (trip.endDate != null && trip.startDate != trip.endDate) ...[
                pw.SizedBox(height: 10),
                _buildInfoRow(
                  PdfLocalizationService.getText('cover_end_date', language), 
                  _formatDate(trip.endDate!, language), 
                  font, 
                  boldFont
                ),
              ],
            ],
          ),
        ),
        
        pw.Spacer(flex: 3),
        
        // 生成資訊
        pw.Center(
          child: pw.Text(
            PdfLocalizationService.getText('cover_generated_by', language),
            style: pw.TextStyle(
              font: font,
              fontSize: 12,
              color: PdfColors.grey600,
            ),
          ),
        ),
        
        pw.SizedBox(height: 10),
        
        pw.Center(
          child: pw.Text(
            '${PdfLocalizationService.getText('cover_generated_time', language)}${_formatDateTime(DateTime.now(), language)}',
            style: pw.TextStyle(
              font: font,
              fontSize: 10,
              color: PdfColors.grey500,
            ),
          ),
        ),
      ],
    );
  }

  /// 建立概覽頁
  static pw.Widget _buildOverviewPage(Trip trip, pw.Font font, pw.Font boldFont, pw.Font emojiFont, String? language) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // 頁面標題
        pw.Text(
          PdfLocalizationService.getText('overview_title', language),
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 24,
            color: PdfColors.blue800,
          ),
        ),
        
        pw.SizedBox(height: _sectionSpacing),
        
        // 目的地資訊
        _buildSection(
          PdfLocalizationService.getText('overview_destination_info', language),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildInfoRow(PdfLocalizationService.getText('overview_city', language), trip.destination.city, font, boldFont),
              pw.SizedBox(height: 8),
              _buildInfoRow(PdfLocalizationService.getText('overview_country', language), trip.destination.country, font, boldFont),
              if (trip.destination.fullAddress != null && trip.destination.fullAddress!.isNotEmpty) ...[
                pw.SizedBox(height: 8),
                pw.Text(
                  trip.destination.fullAddress!,
                  style: pw.TextStyle(font: font, fontSize: 12),
                ),
              ],
            ],
          ),
          font,
          boldFont,
        ),
        
        pw.SizedBox(height: _sectionSpacing),
        
        // 每日主題概覽
        _buildSection(
          PdfLocalizationService.getText('overview_daily_themes', language),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: trip.days.map((day) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 8),
              child: pw.Row(
                children: [
                  pw.Container(
                    width: 60,
                    child: pw.Text(
                      PdfLocalizationService.getText('overview_day', language).replaceAll('{}', '${day.dayIndex}'),
                      style: pw.TextStyle(font: boldFont, fontSize: 12),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      day.theme,
                      style: pw.TextStyle(font: font, fontSize: 12),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ),
          font,
          boldFont,
        ),
        
        pw.SizedBox(height: _sectionSpacing),
        
        // 活動統計
        _buildActivityStatistics(trip, font, boldFont, emojiFont, language),
        
        if (trip.notes != null && trip.notes!.isNotEmpty) ...[
          pw.SizedBox(height: _sectionSpacing),
          _buildSection(
            PdfLocalizationService.getText('overview_trip_notes', language),
            pw.Text(
              trip.notes!,
              style: pw.TextStyle(font: font, fontSize: 12),
            ),
            font,
            boldFont,
          ),
        ],
      ],
    );
  }

  /// 建立每日詳情頁
  static pw.Widget _buildDayDetailPage(DayPlan day, pw.Font font, pw.Font boldFont, pw.Font emojiFont, String? language) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // 日期標題
        pw.Row(
          children: [
            pw.Text(
              PdfLocalizationService.getText('day_detail_day', language).replaceAll('{}', '${day.dayIndex}'),
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 24,
                color: PdfColors.blue800,
              ),
            ),
            pw.Spacer(),
            pw.Text(
              day.formattedDate,
              style: pw.TextStyle(
                font: font,
                fontSize: 16,
                color: PdfColors.grey600,
              ),
            ),
          ],
        ),
        
        pw.SizedBox(height: 10),
        
        // 主題
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            color: PdfColors.blue50,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Text(
            day.theme,
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 14,
              color: PdfColors.blue800,
            ),
          ),
        ),
        
        pw.SizedBox(height: _sectionSpacing),
        
        // 活動列表
        pw.Text(
          PdfLocalizationService.getText('day_detail_activities', language),
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 16,
            color: PdfColors.grey800,
          ),
        ),
        
        pw.SizedBox(height: _itemSpacing),
        
        // 活動詳情
        ...day.activities.asMap().entries.map((entry) {
          final index = entry.key;
          final activity = entry.value;
          
          return pw.Column(
            children: [
              _buildActivityCard(activity, font, boldFont, emojiFont),
              
              // 交通資訊（如果有的話）
              if (index < day.transports.length) ...[
                pw.SizedBox(height: 8),
                _buildTransportInfo(day.transports[index], font, boldFont, emojiFont),
              ],
              
              pw.SizedBox(height: _itemSpacing),
            ],
          );
        }).toList(),
        
        // 當日備註
        if (day.notes != null && day.notes!.isNotEmpty) ...[
          pw.SizedBox(height: _sectionSpacing),
          _buildSection(
            PdfLocalizationService.getText('day_detail_daily_notes', language),
            pw.Text(
              day.notes!,
              style: pw.TextStyle(font: font, fontSize: 12),
            ),
            font,
            boldFont,
          ),
        ],
      ],
    );
  }

  /// 建立活動卡片
  static pw.Widget _buildActivityCard(Activity activity, pw.Font font, pw.Font boldFont, pw.Font emojiFont) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // 活動標題和時間
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Text(
                  activity.name,
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 14,
                    color: PdfColors.grey800,
                  ),
                ),
              ),
              pw.Text(
                activity.timeRange,
                style: pw.TextStyle(
                  font: font,
                  fontSize: 12,
                  color: PdfColors.blue600,
                ),
              ),
            ],
          ),
          
          pw.SizedBox(height: 6),
          
          // 活動描述
          pw.Text(
            activity.description,
            style: pw.TextStyle(
              font: font,
              fontSize: 11,
              color: PdfColors.grey700,
            ),
          ),
          
          pw.SizedBox(height: 8),
          
          // 活動詳情
          pw.Row(
            children: [
              _buildActivityTag(activity.category.displayName, PdfColors.green100, PdfColors.green800, font, emojiFont),
              pw.SizedBox(width: 8),
              _buildActivityTag(activity.priority.displayName, PdfColors.orange100, PdfColors.orange800, font, emojiFont),
              if (activity.estimatedCost != null) ...[
                pw.SizedBox(width: 8),
                _buildActivityTag('💰 ${activity.estimatedCost}', PdfColors.blue100, PdfColors.blue800, font, emojiFont),
              ],
            ],
          ),
          
          // 地址（如果有的話）
          if (activity.address != null && activity.address!.isNotEmpty) ...[
            pw.SizedBox(height: 6),
            _buildTextWithEmoji(
              '📍 ${activity.address!}',
              font,
              emojiFont,
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ],
          
          // 小貼士（如果有的話）
          if (activity.tips != null && activity.tips!.isNotEmpty) ...[
            pw.SizedBox(height: 6),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: PdfColors.yellow50,
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: _buildTextWithEmoji(
                '💡 ${activity.tips}',
                font,
                emojiFont,
                fontSize: 10,
                color: PdfColors.grey700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 建立交通資訊
  static pw.Widget _buildTransportInfo(TransportInfo transport, pw.Font font, pw.Font boldFont, pw.Font emojiFont) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.grey200),
      ),
      child: pw.Row(
        children: [
          _buildTextWithEmoji(
            '🚗 ',
            font,
            emojiFont,
            fontSize: 12,
          ),
          pw.Expanded(
            child: pw.Text(
              '${transport.mode.displayName} • ${transport.durationMinutes}${PdfLocalizationService.getText('day_detail_minutes')}',
              style: pw.TextStyle(
                font: font,
                fontSize: 11,
                color: PdfColors.grey700,
              ),
            ),
          ),
          if (transport.estimatedCost != null)
            pw.Text(
              transport.estimatedCost!,
              style: pw.TextStyle(
                font: font,
                fontSize: 11,
                color: PdfColors.grey600,
              ),
            ),
        ],
      ),
    );
  }

  /// 建立活動標籤
  static pw.Widget _buildActivityTag(String text, PdfColor bgColor, PdfColor textColor, pw.Font font, pw.Font emojiFont) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: pw.BoxDecoration(
        color: bgColor,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: _buildTextWithEmoji(
        text,
        font,
        emojiFont,
        fontSize: 9,
        color: textColor,
      ),
    );
  }

  /// 建立活動統計
  static pw.Widget _buildActivityStatistics(Trip trip, pw.Font font, pw.Font boldFont, pw.Font emojiFont, String? language) {
    final categoryStats = <String, int>{};
    for (final day in trip.days) {
      for (final activity in day.activities) {
        categoryStats[activity.category.displayName] = 
            (categoryStats[activity.category.displayName] ?? 0) + 1;
      }
    }

    return _buildSection(
      PdfLocalizationService.getText('overview_activity_stats', language),
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: categoryStats.entries.map((entry) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 4),
          child: pw.Row(
            children: [
              pw.Container(
                width: 80,
                child: pw.Text(
                  entry.key,
                  style: pw.TextStyle(font: font, fontSize: 12),
                ),
              ),
              pw.Text(
                '${entry.value}${PdfLocalizationService.getText('overview_activities_count', language)}',
                style: pw.TextStyle(font: boldFont, fontSize: 12),
              ),
            ],
          ),
        )).toList(),
      ),
      font,
      boldFont,
    );
  }

  /// 建立區段
  static pw.Widget _buildSection(String title, pw.Widget content, pw.Font font, pw.Font boldFont) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 16,
            color: PdfColors.grey800,
          ),
        ),
        pw.SizedBox(height: 8),
        content,
      ],
    );
  }

  /// 建立資訊行
  static pw.Widget _buildInfoRow(String label, String value, pw.Font font, pw.Font boldFont) {
    return pw.Row(
      children: [
        pw.Container(
          width: 80,
          child: pw.Text(
            label,
            style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.grey600),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: pw.TextStyle(font: boldFont, fontSize: 12),
          ),
        ),
      ],
    );
  }

  /// 格式化日期
  static String _formatDate(DateTime date, [String? language]) {
    final months = List.generate(12, (index) => 
      PdfLocalizationService.getText('month_${index + 1}', language)
    );
    
    final lang = language ?? PdfLocalizationService.getCurrentLanguage();
    if (lang == 'en') {
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } else {
      return '${date.year}年${months[date.month - 1]}${date.day}日';
    }
  }

  /// 格式化日期時間
  static String _formatDateTime(DateTime dateTime, [String? language]) {
    return '${_formatDate(dateTime, language)} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}