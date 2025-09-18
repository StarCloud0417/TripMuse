# PDF 匯出按鈕樣式更新

## 更新概述
根據用戶提供的圖片需求，將現有的PDF匯出按鈕樣式更新為紅色圓角按鈕設計，符合圖片中顯示的樣式。

## 修改內容

### 1. 更新 PdfExportButton 組件 (`lib/tripmuse/widgets/pdf_export_button.dart`)

**修改前：**
- 使用 `ElevatedButton.icon` 標準按鈕樣式
- 方形邊角設計
- 標準的Material Design按鈕外觀

**修改後：**
- 使用自定義 `Container` + `InkWell` 設計
- 圓角設計 (`BorderRadius.circular(20)`)
- 紅色背景 (`Colors.red[600]`)
- 白色圖標和文字
- 更緊湊的內邊距設計
- 更小的圖標尺寸 (18px)
- 更小的字體尺寸 (14px)

### 2. 更新 TripCard 組件中的 PopupMenu 項目 (`lib/tripmuse/widgets/trip_card.dart`)

**修改內容：**
- 將 PopupMenuItem 中的PDF匯出選項樣式更新為圓角設計
- 調整內邊距和字體大小以保持一致性
- 使用與主按鈕相同的圓角半徑 (20px)
- 調整圖標和文字尺寸

## 視覺效果

### 新的按鈕特點：
1. **圓角設計**：使用 20px 圓角半徑，更現代化的外觀
2. **紅色主題**：使用 `Colors.red[600]` 作為背景色，突出PDF功能
3. **緊湊佈局**：減少內邊距，使按鈕更緊湊
4. **一致性**：在所有使用場景中保持相同的視覺風格

### 使用場景：
1. **時間軸視圖**：右上角的PDF匯出按鈕
2. **行程卡片**：PopupMenu中的PDF匯出選項

## 技術細節

### 按鈕結構：
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.red[600],
    borderRadius: BorderRadius.circular(20),
  ),
  child: Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(Icons.picture_as_pdf, color: Colors.white, size: 18),
            SizedBox(width: 6),
            Text('匯出 PDF', style: TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ),
    ),
  ),
)
```

### 優勢：
1. **自定義外觀**：完全控制按鈕的視覺設計
2. **觸摸反饋**：保留Material Design的觸摸漣漪效果
3. **可重用性**：組件化設計，可在多個地方使用
4. **一致性**：所有PDF匯出功能使用相同的視覺風格

## 測試

創建了 `test_pdf_button.dart` 測試文件來驗證新按鈕的外觀和功能。

## 兼容性

- 保持了原有的功能接口不變
- 所有現有的調用代碼無需修改
- 向後兼容現有的PDF匯出功能

## 未來改進建議

1. 可以考慮添加按鈕按下時的動畫效果
2. 可以根據主題色彩動態調整按鈕顏色
3. 可以添加無障礙功能支持