# 選單PDF匯出按鈕樣式更新

## 更新說明
根據用戶要求，將選單中的「匯出 PDF」選項改為紅色按鈕樣式，與圖片中紅色圈圈標示的按鈕樣式一致。

## 修改內容

### 原始樣式
```dart
const PopupMenuItem(
  value: 'export_pdf',
  child: Row(
    children: [
      Icon(Icons.picture_as_pdf, size: 20, color: Colors.red),
      SizedBox(width: 8),
      Text('匯出 PDF'),
    ],
  ),
),
```

### 新的按鈕樣式
```dart
PopupMenuItem(
  value: 'export_pdf',
  child: Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red[600],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.picture_as_pdf, size: 18, color: Colors.white),
          SizedBox(width: 8),
          Text(
            '匯出 PDF',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
  ),
),
```

## 視覺效果

### 新樣式特點：
1. **紅色背景**：使用 `Colors.red[600]` 作為背景色
2. **白色文字和圖標**：提供良好的對比度
3. **圓角設計**：8px 圓角，現代化外觀
4. **陰影效果**：輕微的紅色陰影，增加立體感
5. **按鈕樣式**：看起來像一個真正的按鈕，而不是普通的選單項目

### 與其他選單項目的區別：
- **編輯**：普通選單項目樣式
- **分享**：普通選單項目樣式  
- **匯出 PDF**：紅色按鈕樣式 ✨
- **刪除**：紅色文字，但保持選單項目樣式

## 功能保持不變
- 點擊行為完全相同
- 仍然調用 `PdfExportHelper.showExportDialog(context, trip)`
- 狀態管理和錯誤處理保持不變

## 使用位置
這個新樣式應用在以下位置：
- 行程卡片的PopupMenu中的「匯出 PDF」選項
- 保持與時間軸視圖中紅色PDF匯出按鈕的視覺一致性

## 測試建議
1. 打開行程卡片的選單
2. 確認「匯出 PDF」選項顯示為紅色按鈕樣式
3. 點擊測試功能是否正常
4. 檢查與其他選單項目的視覺對比