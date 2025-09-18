import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../models/models.dart';
import '../services/pdf_service.dart';
import '../services/pdf_localization_service.dart';

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
  String _selectedLanguage = PdfLocalizationService.getCurrentLanguage();
  bool _saveToDevice = true;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  @override
  void dispose() {
    // 確保在對話框關閉時重置生成狀態
    _isGenerating = false;
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final isOnline = await PdfService.isOnline();
    if (mounted) {
      setState(() {
        _isOnline = isOnline;
      });
    }
  }

  /// 處理對話框關閉
  void _handleClose() {
    if (_isGenerating) {
      // 如果正在生成，顯示確認對話框
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('確認取消'),
          content: const Text('PDF 正在生成中，確定要取消嗎？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('繼續等待'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 關閉確認對話框
                Navigator.of(context).pop(); // 關閉PDF匯出對話框
              },
              child: const Text('確定取消'),
            ),
          ],
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isGenerating,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _isGenerating) {
          _handleClose();
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 標題欄
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red[600],
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        PdfLocalizationService.getText('export_title', _selectedLanguage),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _handleClose(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              
              // 可滾動內容
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 行程資訊
                      _buildTripInfo(),
                      
                      const SizedBox(height: 16),
                      
                      // 語言選擇和選項
                      _buildLanguageAndOptions(),
                      
                      const SizedBox(height: 16),
                      
                      // 連線狀態提示
                      if (!_isOnline) _buildOfflineNotice(),
                      
                      if (!_isOnline) const SizedBox(height: 12),
                      
                      // PDF 內容說明
                      _buildContentDescription(),
                    ],
                  ),
                ),
              ),
              
              // 底部按鈕
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isGenerating ? null : _previewPdf,
                        icon: const Icon(Icons.preview),
                        label: Text(PdfLocalizationService.getText('export_preview', _selectedLanguage)),
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
                        label: Text(_isGenerating 
                          ? PdfLocalizationService.getText('export_generating', _selectedLanguage)
                          : PdfLocalizationService.getText('export_export', _selectedLanguage)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripInfo() {
    return Container(
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
    );
  }

  Widget _buildLanguageAndOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 語言選擇
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
                '語言設定',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildLanguageOption('繁體中文', 'zh_TW'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildLanguageOption('English', 'en'),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        
        // 匯出選項
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '匯出選項',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                title: const Text('儲存到裝置'),
                subtitle: const Text('將 PDF 檔案儲存到本地裝置'),
                value: _saveToDevice,
                onChanged: (value) {
                  setState(() {
                    _saveToDevice = value ?? true;
                  });
                },
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageOption(String label, String languageCode) {
    final isSelected = _selectedLanguage == languageCode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = languageCode;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[600] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildOfflineNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.orange[600], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '離線模式：將使用本地資料生成 PDF',
              style: TextStyle(
                color: Colors.orange[700],
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentDescription() {
    return Container(
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
            PdfLocalizationService.getText('export_content_description', _selectedLanguage),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          _buildContentItem(Icons.article, PdfLocalizationService.getText('export_cover_page', _selectedLanguage)),
          _buildContentItem(Icons.summarize, PdfLocalizationService.getText('export_overview', _selectedLanguage)),
          _buildContentItem(Icons.schedule, PdfLocalizationService.getText('export_daily_schedule', _selectedLanguage)),
          _buildContentItem(Icons.directions, PdfLocalizationService.getText('export_transport_info', _selectedLanguage)),
          _buildContentItem(Icons.tips_and_updates, PdfLocalizationService.getText('export_travel_tips', _selectedLanguage)),
        ],
      ),
    );
  }

  Widget _buildContentItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
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
    if (_isGenerating) return;
    
    setState(() {
      _isGenerating = true;
    });

    try {
      final pdfData = _isOnline 
        ? await PdfService.generateTripPdf(widget.trip, language: _selectedLanguage)
        : await PdfService.generateOfflinePdf(widget.trip, language: _selectedLanguage);
      
      if (!mounted) return;
      
      // 重置生成狀態
      setState(() {
        _isGenerating = false;
      });
      
      // 關閉對話框
      Navigator.of(context).pop();
      
      // 開啟 PDF 預覽
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PdfPreviewScreen(
            trip: widget.trip,
            pdfData: pdfData,
            language: _selectedLanguage,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${PdfLocalizationService.getText('export_preview_failed', _selectedLanguage)}$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _exportPdf() async {
    if (_isGenerating) return;
    
    setState(() {
      _isGenerating = true;
    });

    try {
      final pdfData = _isOnline 
        ? await PdfService.generateTripPdf(widget.trip, language: _selectedLanguage)
        : await PdfService.generateOfflinePdf(widget.trip, language: _selectedLanguage);
      
      if (!mounted) return;
      
      // 重置生成狀態
      setState(() {
        _isGenerating = false;
      });
      
      // 關閉對話框
      Navigator.of(context).pop();
      
      String? savedPath;
      
      // 儲存到裝置（如果選擇）
      if (_saveToDevice) {
        try {
          final filename = '${widget.trip.title}_${DateTime.now().millisecondsSinceEpoch}.pdf';
          savedPath = await PdfService.savePdfToDevice(pdfData, filename);
        } catch (e) {
          // 儲存失敗，但仍可分享
          print('儲存 PDF 失敗: $e');
        }
      }
      
      // 使用 printing 套件的分享功能
      await Printing.sharePdf(
        bytes: pdfData,
        filename: '${widget.trip.title}_行程.pdf',
      );
      
      // 顯示成功訊息
      if (mounted) {
        String message = PdfLocalizationService.getText('export_success', _selectedLanguage);
        if (savedPath != null) {
          message += '\n已儲存至: ${savedPath.split('/').last}';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${PdfLocalizationService.getText('export_failed', _selectedLanguage)}$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// PDF 預覽畫面
class PdfPreviewScreen extends StatelessWidget {
  final Trip trip;
  final Uint8List pdfData;
  final String? language;

  const PdfPreviewScreen({
    super.key,
    required this.trip,
    required this.pdfData,
    this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${trip.title}${PdfLocalizationService.getText('preview_title_suffix', language)}'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _sharePdf(context),
            icon: const Icon(Icons.share),
            tooltip: PdfLocalizationService.getText('preview_share', language),
          ),
          IconButton(
            onPressed: () => _printPdf(context),
            icon: const Icon(Icons.print),
            tooltip: PdfLocalizationService.getText('preview_print', language),
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
            content: Text('${PdfLocalizationService.getText('preview_share_failed', language)}$e'),
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
            content: Text('${PdfLocalizationService.getText('preview_print_failed', language)}$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}