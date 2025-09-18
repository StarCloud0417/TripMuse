# PDF匯出功能修復說明

## 問題描述
當用戶在行程中按下匯出PDF後再按返回時，會出現持續的忙碌圖案並且不會結束。

## 問題原因
1. **狀態管理問題**：當用戶在PDF生成過程中按下返回按鈕時，`_isGenerating` 狀態沒有被正確重置
2. **對話框關閉處理**：缺乏適當的對話框關閉處理機制
3. **異步操作取消**：沒有正確處理異步操作的取消

## 修復方案

### 1. 修復PDF匯出對話框 (`lib/tripmuse/widgets/pdf_export_dialog.dart`)

#### 主要修復點：
- **添加 `dispose()` 方法**：確保在對話框關閉時重置生成狀態
- **使用 `PopScope`**：替代已棄用的 `WillPopScope`，正確處理返回按鈕
- **添加 `_handleClose()` 方法**：提供確認對話框，讓用戶選擇是否取消正在進行的PDF生成
- **防止重複操作**：在方法開始時檢查 `_isGenerating` 狀態

#### 關鍵代碼：
```dart
@override
void dispose() {
  // 確保在對話框關閉時重置生成狀態
  _isGenerating = false;
  super.dispose();
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
      // ... 對話框內容
    ),
  );
}
```

### 2. 創建PDF匯出按鈕組件 (`lib/tripmuse/widgets/pdf_export_button.dart`)

#### 功能：
- **狀態管理**：防止重複點擊和狀態混亂
- **輔助類**：提供靜態方法方便在其他地方調用
- **錯誤處理**：確保對話框關閉後狀態正確重置

#### 關鍵代碼：
```dart
class _PdfExportButtonState extends State<PdfExportButton> {
  bool _isDialogOpen = false;

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
```

### 3. 整合到現有UI組件

#### 行程卡片 (`lib/tripmuse/widgets/trip_card.dart`)
- 在PopupMenu中添加PDF匯出選項
- 使用 `PdfExportHelper.showExportDialog()` 調用

#### 時間軸組件 (`lib/tripmuse/widgets/timeline_widget.dart`)
- 在視圖切換器下方添加PDF匯出按鈕
- 提供快速訪問PDF匯出功能

## 使用方法

### 1. 在行程卡片中使用
用戶可以點擊行程卡片右上角的選單按鈕，選擇「匯出 PDF」選項。

### 2. 在行程詳情頁面使用
在時間軸視圖中，用戶可以看到右上角的「匯出 PDF」按鈕。

### 3. 程式化調用
```dart
// 直接顯示PDF匯出對話框
await PdfExportHelper.showExportDialog(context, trip);

// 或使用按鈕組件
PdfExportButton(
  trip: trip,
  buttonText: '匯出 PDF',
  icon: Icons.picture_as_pdf,
  color: Colors.red[600],
)
```

## 測試建議

1. **正常流程測試**：
   - 點擊匯出PDF按鈕
   - 選擇語言和選項
   - 點擊匯出或預覽
   - 確認PDF正常生成

2. **取消操作測試**：
   - 點擊匯出PDF按鈕
   - 在生成過程中按返回按鈕
   - 確認出現確認對話框
   - 測試「繼續等待」和「確定取消」選項

3. **重複操作測試**：
   - 快速多次點擊匯出按鈕
   - 確認不會出現多個對話框

4. **狀態恢復測試**：
   - 在各種情況下關閉對話框
   - 確認UI狀態正確恢復

## 注意事項

1. **依賴檢查**：確保 `PdfService` 和 `PdfLocalizationService` 正常工作
2. **權限處理**：確保應用有適當的文件存儲權限
3. **錯誤處理**：PDF生成失敗時會顯示適當的錯誤訊息
4. **性能考慮**：大型行程的PDF生成可能需要較長時間

## 修復效果

修復後，用戶在PDF匯出過程中按返回按鈕時：
1. 如果PDF還在生成中，會看到確認對話框
2. 可以選擇繼續等待或取消操作
3. 無論選擇什麼，都不會出現持續的忙碌狀態
4. UI狀態會正確恢復到初始狀態