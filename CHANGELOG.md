# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2025-01-09

### Added
- 🎉 Initial TripMuse project setup based on MapBox Flutter SDK
- 📱 TripMuse app entry point in main menu
- 🏗️ Project structure for TripMuse development
- 📦 Core dependencies for TripMuse features:
  - State management: flutter_riverpod
  - HTTP client: dio
  - Local storage: hive, flutter_secure_storage
  - Data models: freezed, json_annotation
  - Firebase integration: firebase_core, firebase_auth, google_sign_in, cloud_firestore
  - PDF generation: pdf, printing
- 📁 TripMuse directory structure:
  - `lib/tripmuse/models/` - Data models
  - `lib/tripmuse/services/` - Service layer
  - `lib/tripmuse/screens/` - UI screens
  - `lib/tripmuse/widgets/` - UI components
- 🧪 Development dependencies for code generation and testing

### Changed
- 📝 Updated project description to reflect TripMuse branding
- 🔧 Enhanced pubspec.yaml with TripMuse-specific dependencies

### Technical Details
- 🛠️ Minimal invasive development approach - all existing MapBox examples preserved
- 🎯 Zero-risk setup - new features isolated in separate directory
- ✅ All existing functionality remains intact and functional
- 🚀 Ready for TripMuse feature development

---

## [0.0.1] - 2025-01-09

### 新增功能
- 🎉 基於 MapBox Flutter SDK 的 TripMuse 專案初始化
- 📱 在主選單中新增 TripMuse 應用入口
- 🏗️ 建立 TripMuse 開發專案結構
- 📦 新增 TripMuse 核心依賴套件：
  - 狀態管理：flutter_riverpod
  - 網路請求：dio
  - 本地儲存：hive, flutter_secure_storage
  - 資料模型：freezed, json_annotation
  - Firebase 整合：firebase_core, firebase_auth, google_sign_in, cloud_firestore
  - PDF 生成：pdf, printing
- 📁 建立 TripMuse 目錄結構：
  - `lib/tripmuse/models/` - 資料模型
  - `lib/tripmuse/services/` - 服務層
  - `lib/tripmuse/screens/` - 使用者介面頁面
  - `lib/tripmuse/widgets/` - 使用者介面組件
- 🧪 新增開發依賴套件用於程式碼生成和測試

### 變更內容
- 📝 更新專案描述以反映 TripMuse 品牌
- 🔧 使用 TripMuse 專用依賴套件增強 pubspec.yaml

### 技術細節
- 🛠️ 採用最小侵入式開發方法 - 保留所有現有 MapBox 範例
- 🎯 零風險設定 - 新功能隔離在獨立目錄中
- ✅ 所有現有功能保持完整且正常運作
- 🚀 準備好進行 TripMuse 功能開發