# TripMuse

**Version 0.0.5**

一個基於 AI 的智能旅行規劃應用，使用 Flutter 開發的跨平台解決方案。

## 功能特色

- 🤖 **AI 行程生成**：基於自然語言描述智能生成個人化旅行行程
- 🗺️ **互動式地圖**：支援 Google Maps 整合，提供精美的地圖視圖
- 📅 **時間軸視圖**：清晰的每日行程安排和時間管理
- 🔐 **安全認證**：支援 Google 登入和訪客模式
- 💾 **本地儲存**：使用 Hive 提供離線資料儲存
- 📄 **PDF 匯出**：支援行程匯出為精美 PDF 文件
- 🌐 **跨平台支援**：完美支援 iOS、Android 和其他 Flutter 平台

## 技術架構

- **狀態管理**：Riverpod 2.x
- **網路請求**：Dio 5.x
- **本地儲存**：Hive + Flutter Secure Storage
- **認證**：Google Sign-In + Firebase Auth
- **資料模型**：Freezed + JSON 序列化
- **地圖服務**：Google Maps Flutter
- **PDF 生成**：PDF 套件

## 專案結構

```
lib/
├── core/
│   ├── models/          # 核心資料模型 (Trip, DayPlan, Activity, etc.)
│   ├── services/        # 核心服務 (Logger, ErrorHandler, Cache, etc.)
│   ├── providers/       # Riverpod 狀態管理
│   ├── widgets/         # 核心 UI 組件
│   └── exceptions/      # 自定義異常類型
├── widgets/             # 應用 UI 組件
├── screens/             # 應用頁面
└── utils/               # 工具函數
```

## 快速開始

### 環境需求

- Flutter 3.9.0+
- Dart 3.0+
- Android Studio 或 VS Code

### 安裝依賴

```bash
flutter pub get
```

### 配置 API 金鑰

1. **Google Maps API**
   - 前往 [Google Cloud Console](https://console.cloud.google.com/)
   - 啟用 Maps SDK for Android 和 Maps SDK for iOS
   - 創建 API 金鑰
   - 在 `android/app/build.gradle.kts` 中設置：
   ```gradle
   manifestPlaceholders["com.google.android.geo.API_KEY"] = "YOUR_API_KEY"
   ```

2. **Google Places API**
   - 在 Google Cloud Console 中啟用 Places API
   - 使用相同的 API 金鑰

### 運行應用

```bash
# 調試模式
flutter run --debug

# 發行模式
flutter run --release

# 構建 APK
flutter build apk --release
```

## 開發狀態

目前版本：**0.0.4** - 本地儲存初始化問題已修復

### 已完成
- ✅ Flutter 專案基礎架構
- ✅ 核心依賴套件配置
- ✅ Android/iOS 平台配置
- ✅ 狀態管理和資料層
- ✅ 認證和儲存系統
- ✅ 地圖整合準備
- ✅ **Hive 本地儲存初始化問題修復**
- ✅ **TypeId 衝突解決**

### 修復內容 (v0.0.4)
- 🔧 修復 Hive typeId 衝突 (User 和 ActivityCategory 都使用 typeId 4)
- 🔧 修復本地儲存初始化順序問題 ("本地儲存尚未初始化" 錯誤)
- 🔧 更新 repository 實作以使用延遲 box 存取
- 🔧 清理未使用的 Hive 匯入
- 🔧 重新生成 Hive 適配器

### 開發中
- 🚧 AI 行程生成服務
- 🚧 用戶介面設計
- 🚧 行程管理功能

## 貢獻指南

歡迎參與 TripMuse 的開發！請遵循以下步驟：

1. Fork 此專案
2. 創建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 開啟 Pull Request

## 授權

此專案採用 MIT 授權 - 詳見 [LICENSE](LICENSE) 文件

## 聯絡方式

- 專案維護者：StarCloud0417
- 問題回報：[GitHub Issues](https://github.com/StarCloud0417/TripMuse/issues)

---

**TripMuse** - 讓旅行規劃變得更智能、更簡單！
