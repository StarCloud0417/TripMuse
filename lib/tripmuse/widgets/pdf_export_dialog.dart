import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../models/models.dart';
import '../services/pdf_service.dart';

/// PDF 匯出對話框
/// 
/// 提供 PDF 匯出選項和預覽功能
class PdfExportDialog extends StatefulWidget {
  final Trip trip;

  const PdfExportDialog({
    super.key,
    required this.trip,
  });

  @override
  State<PdfExportDialog> createState() => _PdfExportDialogState();
}

class _PdfExportDialogState extends State<PdfExportDialog> {
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 標題
            Row(
              children: [
                Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red[600],
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '匯出 PDF',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // 行程資訊
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.trip.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.trip.destination.name,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.trip.totalDays} 天 • ${widget.trip.totalActivities} 個活動',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // PDF 內容說明
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PDF 將包含以下內容：',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildContentItem(Icons.article, '封面頁面'),
                  _buildContentItem(Icons.summarize, '行程概覽'),
                  _buildContentItem(Icons.schedule, '每日詳細行程'),
                  _buildContentItem(Icons.directions, '交通資訊'),
                  _buildContentItem(Icons.tips_and_updates, '旅行小貼士'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 操作按鈕
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isGenerating ? null : _previewPdf,
                    icon: const Icon(Icons.preview),
                    label: const Text('預覽'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isGenerating ? null : _exportPdf,
                    icon: _isGenerating 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.download),
                    label: Text(_isGenerating ? '生成中...' : '匯出'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.blue[600],
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _previewPdf() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      final pdfData = await PdfService.generateTripPdf(widget.trip);
      
      if (mounted) {
        Navigator.of(context).pop();
        
        // 開啟 PDF 預覽
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PdfPreviewScreen(
              trip: widget.trip,
              pdfData: pdfData,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF 預覽失敗：$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  Future<void> _exportPdf() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      final pdfData = await PdfService.generateTripPdf(widget.trip);
      
      if (mounted) {
        Navigator.of(context).pop();
        
        // 使用 printing 套件的分享功能
        await Printing.sharePdf(
          bytes: pdfData,
          filename: '${widget.trip.title}_行程.pdf',
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF 已成功匯出！'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF 匯出失敗：$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }
}

/// PDF 預覽畫面
class PdfPreviewScreen extends StatelessWidget {
  final Trip trip;
  final Uint8List pdfData;

  const PdfPreviewScreen({
    super.key,
    required this.trip,
    required this.pdfData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${trip.title} - PDF 預覽'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _sharePdf(context),
            icon: const Icon(Icons.share),
            tooltip: '分享 PDF',
          ),
          IconButton(
            onPressed: () => _printPdf(context),
            icon: const Icon(Icons.print),
            tooltip: '列印 PDF',
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) => Future.value(pdfData),
        allowPrinting: true,
        allowSharing: true,
        canChangePageFormat: false,
        canDebug: false,
      ),
    );
  }

  Future<void> _sharePdf(BuildContext context) async {
    try {
      await Printing.sharePdf(
        bytes: pdfData,
        filename: '${trip.title}_行程.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('分享失敗：$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _printPdf(BuildContext context) async {
    try {
      await Printing.layoutPdf(
        onLayout: (format) => Future.value(pdfData),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('列印失敗：$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}