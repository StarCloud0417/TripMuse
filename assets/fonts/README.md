# 中文字體檔案設定指南

為了讓 PDF 正確顯示中文字符，您需要在此目錄下放置中文字體檔案。

## 推薦字體

### 1. Noto Sans TC (Google 免費字體)
- **下載位置**: https://fonts.google.com/noto/specimen/Noto+Sans+TC
- **檔案名稱**: 
  - `NotoSansTC-Regular.ttf` (一般字體)
  - `NotoSansTC-Bold.ttf` (粗體字體)

### 2. Source Han Sans (Adobe 免費字體)
- **下載位置**: https://github.com/adobe-fonts/source-han-sans
- **檔案名稱**:
  - `SourceHanSans-Regular.ttf`
  - `SourceHanSans-Bold.ttf`

## 安裝步驟

1. 下載上述任一字體的 TTF 檔案
2. 將檔案放置在 `assets/fonts/` 目錄下
3. 確保檔案名稱正確（或修改程式碼中的路徑）
4. 執行 `flutter pub get` 重新載入 assets
5. 重新編譯應用程式

## 檔案結構

```
assets/fonts/
├── NotoSansTC-Regular.ttf    # 一般字體
├── NotoSansTC-Bold.ttf       # 粗體字體
└── README.md                 # 此說明檔案
```

## 注意事項

- 字體檔案通常較大（10-20MB），請確保有足夠的儲存空間
- 如果只有一般字體，程式會自動使用一般字體代替粗體
- 程式會按順序嘗試載入不同的字體檔案，直到找到可用的為止

## 測試

安裝字體後，請測試 PDF 匯出功能，確認中文字符能正確顯示。