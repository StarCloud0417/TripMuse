import 'package:flutter/material.dart';
import '../models/models.dart';
import 'pdf_export_dialog.dart';

/// PDF 匯出按鈕組件
/// 
/// 提供一個按鈕來觸發PDF匯出對話框，並正確處理狀態管理
class PdfExportButton extends StatefulWidget {
  final Trip trip;
  final String? buttonText;
  final IconData? icon;
  final Color? color;

  const PdfExportButton({
    super.key,
    required this.trip,
    this.buttonText,
    this.icon,
    this.color,
  });

  @override
  State<PdfExportButton> createState() => _PdfExportButtonState();
}

class _PdfExportButtonState extends State<PdfExportButton> {
  bool _isDialogOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.color ?? Colors.red[600],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isDialogOpen ? null : _showPdfExportDialog,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon ?? Icons.picture_as_pdf,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  widget.buttonText ?? '匯出 PDF',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showPdfExportDialog() async {
    if (_isDialogOpen) return;
    
    setState(() {
      _isDialogOpen = true;
    });

    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false, // 防止點擊外部關閉對話框
        builder: (BuildContext context) {
          return PdfExportDialog(trip: widget.trip);
        },
      );
    } finally {
      // 確保對話框關閉後重置狀態
      if (mounted) {
        setState(() {
          _isDialogOpen = false;
        });
      }
    }
  }
}

/// PDF匯出輔助類
/// 
/// 提供靜態方法來顯示PDF匯出對話框
class PdfExportHelper {
  /// 顯示PDF匯出對話框
  static Future<void> showExportDialog(BuildContext context, Trip trip) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PdfExportDialog(trip: trip);
      },
    );
  }
}