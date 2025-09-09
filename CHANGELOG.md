# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-01-09

### Added
- 📱 Complete TripMuse app UI with bottom navigation
- 🎨 Comprehensive theme system with Material 3 design:
  - Brand colors and visual identity
  - Light and dark theme support
  - Consistent spacing, radius, and shadow constants
  - Custom component themes (AppBar, Cards, Buttons, etc.)
- 🏠 Home screen with beautiful design:
  - SliverAppBar with gradient background
  - Quick action cards for creating new trips
  - Recent trips list with status indicators
  - Floating action button for easy access
- 🗺️ Map screen with interactive controls:
  - Map view placeholder with gradient design
  - Top search bar and layer controls
  - Right-side location and zoom controls
  - Bottom trip information card with progress indicator
- ⚙️ Settings screen with comprehensive options:
  - User profile section with guest mode support
  - General settings (language, theme, currency)
  - Map settings (style, location tracking, offline maps)
  - Notification preferences
  - Data and privacy controls
  - About and help sections
- 🔄 State management with Riverpod:
  - Page navigation state management
  - Storage system integration
  - Error handling and user feedback
- 📱 Responsive UI design:
  - Smooth page transitions with PageView
  - Consistent visual feedback
  - Placeholder content with development indicators

### Technical Features
- ✨ Material 3 design system implementation
- 🎨 Comprehensive theme architecture
- 📱 Bottom navigation with smooth transitions
- 🔄 Riverpod state management integration
- 🗄️ Storage system initialization and error handling
- 📐 Responsive design with consistent spacing
- 🎯 Modular screen architecture

---

## [0.1.0] - 2025-01-09

### 新增功能
- 📱 完整的 TripMuse 應用 UI 與底部導航
- 🎨 採用 Material 3 設計的完整主題系統：
  - 品牌色彩和視覺識別
  - 亮色和暗色主題支援
  - 一致的間距、圓角和陰影常數
  - 自訂組件主題（AppBar、卡片、按鈕等）
- 🏠 美觀設計的首頁：
  - 漸層背景的 SliverAppBar
  - 建立新行程的快速操作卡片
  - 帶狀態指示器的最近行程列表
  - 便於存取的浮動操作按鈕
- 🗺️ 具互動控制的地圖頁面：
  - 漸層設計的地圖視圖佔位
  - 頂部搜尋欄和圖層控制
  - 右側位置和縮放控制
  - 帶進度指示器的底部行程資訊卡片
- ⚙️ 功能完整的設定頁面：
  - 支援訪客模式的使用者資料區域
  - 一般設定（語言、主題、貨幣）
  - 地圖設定（樣式、位置追蹤、離線地圖）
  - 通知偏好設定
  - 資料和隱私控制
  - 關於和說明區域
- 🔄 使用 Riverpod 的狀態管理：
  - 頁面導航狀態管理
  - 儲存系統整合
  - 錯誤處理和使用者回饋
- 📱 響應式 UI 設計：
  - 使用 PageView 的流暢頁面切換
  - 一致的視覺回饋
  - 帶開發指示器的佔位內容

### 技術特色
- ✨ Material 3 設計系統實作
- 🎨 完整的主題架構
- 📱 流暢切換的底部導航
- 🔄 Riverpod 狀態管理整合
- 🗄️ 儲存系統初始化和錯誤處理
- 📐 一致間距的響應式設計
- 🎯 模組化畫面架構

## [0.0.3] - 2025-01-09

### Added
- 🗄️ Complete TripMuse storage system with offline-first architecture
- 📦 Hive local database integration:
  - Custom TypeAdapters for all data models
  - Automatic cache management with TTL support
  - Trip, settings, and cache data storage
- 🔐 Flutter Secure Storage for sensitive data:
  - JWT tokens and refresh tokens
  - Google authentication credentials
  - Cross-platform encrypted storage
- 🏗️ Repository pattern implementation:
  - `TripRepository` - Complete CRUD operations for trips
  - `UserRepository` - User data and preferences management
  - Advanced features: search, filtering, statistics
- 🔄 Offline-first sync service:
  - Automatic sync queue management
  - Network status monitoring with connectivity_plus
  - Retry mechanism with exponential backoff
  - Conflict resolution (last-writer-wins)
- 📊 Storage management system:
  - `StorageManager` - Unified storage service management
  - Riverpod providers for dependency injection
  - Storage statistics and monitoring
  - Data export/import functionality
- 🧪 Comprehensive test coverage:
  - 22+ test cases covering all storage components
  - Mock implementations for testing
  - Data model serialization validation

### Technical Features
- ✨ Type-safe Hive TypeAdapters for all models
- 🔄 Automatic offline sync with queue management
- 📈 Performance optimizations with caching
- 🛡️ Complete error handling and exception management
- 🧪 Interface separation for testability
- 🔧 Extensible architecture for future cloud integration

---

## [0.0.3] - 2025-01-09

### 新增功能
- 🗄️ 完整的 TripMuse 儲存系統，採用離線優先架構
- 📦 Hive 本地資料庫整合：
  - 為所有資料模型建立自訂 TypeAdapter
  - 支援 TTL 的自動快取管理
  - 行程、設定和快取資料儲存
- 🔐 Flutter Secure Storage 敏感資料儲存：
  - JWT token 和 refresh token
  - Google 認證憑證
  - 跨平台加密儲存
- 🏗️ Repository 模式實作：
  - `TripRepository` - 行程的完整 CRUD 操作
  - `UserRepository` - 使用者資料和偏好管理
  - 進階功能：搜尋、篩選、統計
- 🔄 離線優先同步服務：
  - 自動同步佇列管理
  - 使用 connectivity_plus 監控網路狀態
  - 指數退避重試機制
  - 衝突解決（最後寫入者優先）
- 📊 儲存管理系統：
  - `StorageManager` - 統一儲存服務管理
  - Riverpod provider 依賴注入
  - 儲存統計和監控
  - 資料匯出/匯入功能
- 🧪 完整測試覆蓋：
  - 22+ 個測試案例涵蓋所有儲存組件
  - 測試用模擬實作
  - 資料模型序列化驗證

### 技術特色
- ✨ 所有模型的類型安全 Hive TypeAdapter
- 🔄 佇列管理的自動離線同步
- 📈 快取效能最佳化
- 🛡️ 完整的錯誤處理和例外管理
- 🧪 介面分離提升可測試性
- 🔧 為未來雲端整合預留的可擴展架構

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