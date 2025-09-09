# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.2] - 2025-01-09

### Added
- 📊 Complete TripMuse data models with Freezed and JSON serialization
- 🏗️ Core data structures:
  - `Trip` - Complete trip itinerary with destination, daily plans, and user preference analysis
  - `DayPlan` - Daily itinerary management with theme and activities
  - `Activity` - Activity/attraction data with location, time, and detailed information
  - `Destination` - Destination information with geographic location and details
  - `TripRequest` - Trip generation request data for API calls
  - `UserPreferenceAnalysis` - User preference analysis results from LLM
- 🎯 Comprehensive enum types:
  - `ActivityCategory` - Activity categories (food, sightseeing, culture, nature, shopping)
  - `ActivityPriority` - Activity priority levels (high, medium, low)
  - `TravelPace` - Travel pace (relaxed, moderate, fast)
  - `BudgetRange` - Budget ranges (economy, mid-range, luxury)
  - `TravelStyle` - Travel styles (leisure, adventure, cultural, business)
  - `TripStatus` - Trip status (draft, active, completed, archived)
- 🧪 Complete unit test coverage for all data models
- 📝 Rich extension methods for data manipulation and formatting
- 🌏 Chinese localization support with display names
- 📋 Example data factory with realistic Taipei travel examples
- 🔄 Automatic code generation with build_runner

### Technical Features
- ✨ Immutable data classes with Freezed
- 🔄 Automatic JSON serialization/deserialization
- 📊 Rich extension methods for calculations and formatting
- 🧪 Comprehensive test coverage with realistic scenarios
- 🌐 Localized display names and Chinese language support
- 📦 Unified export file for easy imports

---

## [0.0.2] - 2025-01-09

### 新增功能
- 📊 使用 Freezed 和 JSON 序列化完成 TripMuse 資料模型
- 🏗️ 核心資料結構：
  - `Trip` - 完整行程資料，包含目的地、每日計畫和使用者偏好分析
  - `DayPlan` - 每日行程管理，包含主題和活動
  - `Activity` - 活動/景點資料，包含位置、時間和詳細資訊
  - `Destination` - 目的地資訊，包含地理位置和詳細資料
  - `TripRequest` - 行程生成請求資料，用於 API 呼叫
  - `UserPreferenceAnalysis` - 來自 LLM 的使用者偏好分析結果
- 🎯 完整的列舉類型：
  - `ActivityCategory` - 活動類別（美食、觀光、文化、自然、購物）
  - `ActivityPriority` - 活動優先級（高、中、低）
  - `TravelPace` - 旅行節奏（放鬆、適中、緊湊）
  - `BudgetRange` - 預算範圍（經濟、中等、豪華）
  - `TravelStyle` - 旅行風格（休閒、冒險、文化、商務）
  - `TripStatus` - 行程狀態（草稿、進行中、已完成、已封存）
- 🧪 所有資料模型的完整單元測試覆蓋
- 📝 豐富的擴展方法用於資料操作和格式化
- 🌏 支援中文本地化和顯示名稱
- 📋 包含真實台北旅遊範例的範例資料工廠
- 🔄 使用 build_runner 自動生成程式碼

### 技術特色
- ✨ 使用 Freezed 的不可變資料類別
- 🔄 自動 JSON 序列化/反序列化
- 📊 豐富的擴展方法用於計算和格式化
- 🧪 包含真實場景的完整測試覆蓋
- 🌐 本地化顯示名稱和中文語言支援
- 📦 統一匯出檔案方便匯入

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