import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/models.dart';

/// PDF 生成服務
/// 
/// 負責將行程資料轉換為格式化的 PDF 文件
class PdfService {
  static const double _pageMargin = 40.0;
  static const double _sectionSpacing = 20.0;
  static const double _itemSpacing = 12.0;

  /// 生成行程 PDF
  static Future<Uint8List> generateTripPdf(Trip trip) async {
    final pdf = pw.Document();
    
    // 使用預設字體
    final font = pw.Font.helvetica();
    final boldFont = pw.Font.helveticaBold();

    // 封面頁
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(_pageMargin),
        build: (pw.Context context) => _buildCoverPage(trip, font, boldFont),
      ),
    );

    // 概覽頁
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(_pageMargin),
        build: (pw.Context context) => _buildOverviewPage(trip, font, boldFont),
      ),
    );

    // 每日詳情頁
    for (int i = 0; i < trip.days.length; i++) {
      final day = trip.days[i];
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(_pageMargin),
          build: (pw.Context context) => _buildDayDetailPage(day, font, boldFont),
        ),
      );
    }

    return pdf.save();
  }

  /// 建立封面頁
  static pw.Widget _buildCoverPage(Trip trip, pw.Font font, pw.Font boldFont) {
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
              _buildInfoRow('行程天數', '${trip.totalDays} 天', font, boldFont),
              pw.SizedBox(height: 10),
              _buildInfoRow('活動總數', '${trip.totalActivities} 個', font, boldFont),
              pw.SizedBox(height: 10),
              if (trip.startDate != null)
                _buildInfoRow('開始日期', _formatDate(trip.startDate!), font, boldFont),
              if (trip.endDate != null && trip.startDate != trip.endDate) ...[
                pw.SizedBox(height: 10),
                _buildInfoRow('結束日期', _formatDate(trip.endDate!), font, boldFont),
              ],
            ],
          ),
        ),
        
        pw.Spacer(flex: 3),
        
        // 生成資訊
        pw.Center(
          child: pw.Text(
            '由 TripMuse AI 智能旅行規劃應用生成',
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
            '生成時間：${_formatDateTime(DateTime.now())}',
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
  static pw.Widget _buildOverviewPage(Trip trip, pw.Font font, pw.Font boldFont) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // 頁面標題
        pw.Text(
          '行程概覽',
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 24,
            color: PdfColors.blue800,
          ),
        ),
        
        pw.SizedBox(height: _sectionSpacing),
        
        // 目的地資訊
        _buildSection(
          '目的地資訊',
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildInfoRow('城市', trip.destination.city, font, boldFont),
              pw.SizedBox(height: 8),
              _buildInfoRow('國家', trip.destination.country, font, boldFont),
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
          '每日主題',
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: trip.days.map((day) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 8),
              child: pw.Row(
                children: [
                  pw.Container(
                    width: 60,
                    child: pw.Text(
                      '第${day.dayIndex}天',
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
        _buildActivityStatistics(trip, font, boldFont),
        
        if (trip.notes != null && trip.notes!.isNotEmpty) ...[
          pw.SizedBox(height: _sectionSpacing),
          _buildSection(
            '行程備註',
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
  static pw.Widget _buildDayDetailPage(DayPlan day, pw.Font font, pw.Font boldFont) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // 日期標題
        pw.Row(
          children: [
            pw.Text(
              '第${day.dayIndex}天',
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
          '活動安排',
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
              _buildActivityCard(activity, font, boldFont),
              
              // 交通資訊（如果有的話）
              if (index < day.transports.length) ...[
                pw.SizedBox(height: 8),
                _buildTransportInfo(day.transports[index], font, boldFont),
              ],
              
              pw.SizedBox(height: _itemSpacing),
            ],
          );
        }).toList(),
        
        // 當日備註
        if (day.notes != null && day.notes!.isNotEmpty) ...[
          pw.SizedBox(height: _sectionSpacing),
          _buildSection(
            '當日備註',
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
  static pw.Widget _buildActivityCard(Activity activity, pw.Font font, pw.Font boldFont) {
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
              _buildActivityTag(activity.category.displayName, PdfColors.green100, PdfColors.green800, font),
              pw.SizedBox(width: 8),
              _buildActivityTag(activity.priority.displayName, PdfColors.orange100, PdfColors.orange800, font),
              if (activity.estimatedCost != null) ...[
                pw.SizedBox(width: 8),
                _buildActivityTag('💰 ${activity.estimatedCost}', PdfColors.blue100, PdfColors.blue800, font),
              ],
            ],
          ),
          
          // 地址（如果有的話）
          if (activity.address != null && activity.address!.isNotEmpty) ...[
            pw.SizedBox(height: 6),
            pw.Row(
              children: [
                pw.Text(
                  '📍 ',
                  style: pw.TextStyle(font: font, fontSize: 10),
                ),
                pw.Expanded(
                  child: pw.Text(
                    activity.address!,
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 10,
                      color: PdfColors.grey600,
                    ),
                  ),
                ),
              ],
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
              child: pw.Text(
                '💡 ${activity.tips}',
                style: pw.TextStyle(
                  font: font,
                  fontSize: 10,
                  color: PdfColors.grey700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 建立交通資訊
  static pw.Widget _buildTransportInfo(TransportInfo transport, pw.Font font, pw.Font boldFont) {
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
          pw.Text(
            '🚗 ',
            style: pw.TextStyle(font: font, fontSize: 12),
          ),
          pw.Expanded(
            child: pw.Text(
              '${transport.mode.displayName} • ${transport.durationMinutes}分鐘',
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
  static pw.Widget _buildActivityTag(String text, PdfColor bgColor, PdfColor textColor, pw.Font font) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: pw.BoxDecoration(
        color: bgColor,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: font,
          fontSize: 9,
          color: textColor,
        ),
      ),
    );
  }

  /// 建立活動統計
  static pw.Widget _buildActivityStatistics(Trip trip, pw.Font font, pw.Font boldFont) {
    final categoryStats = <String, int>{};
    for (final day in trip.days) {
      for (final activity in day.activities) {
        categoryStats[activity.category.displayName] = 
            (categoryStats[activity.category.displayName] ?? 0) + 1;
      }
    }

    return _buildSection(
      '活動統計',
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
                '${entry.value} 個',
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
  static String _formatDate(DateTime date) {
    const months = ['一月', '二月', '三月', '四月', '五月', '六月', 
                   '七月', '八月', '九月', '十月', '十一月', '十二月'];
    return '${date.year}年${months[date.month - 1]}${date.day}日';
  }

  /// 格式化日期時間
  static String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}