# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.5] - 2025-09-08

### Fixed
- Resolved "No Directionality widget found" error in ErrorBoundary by adding Directionality wrapper
- Fixed RenderFlex overflow issues in error boundary UI layout
- Improved error boundary layout with LayoutBuilder for responsive design
- Enhanced error handling with proper widget tree context management
- Fixed "Build scheduled during frame" error by deferring setState calls

### Changed
- Updated ErrorBoundary to use Scaffold directly instead of nested MaterialApp
- Improved error UI layout with SafeArea, SingleChildScrollView, and responsive constraints
- Enhanced button styling with minimum size constraints for better accessibility
- Optimized error boundary initialization with proper provider access timing

### Added
- Comprehensive error boundary testing and validation
- Mapbox integration verification and testing tools
- Enhanced debugging capabilities with detailed error logging
- Network connectivity checking for map functionality

### 中文描述
- 解決了 ErrorBoundary 中的 "No Directionality widget found" 錯誤，通過添加 Directionality 包裝器
- 修復了錯誤邊界 UI 佈局中的 RenderFlex 溢出問題
- 使用 LayoutBuilder 改進了響應式設計
- 增強了錯誤處理，包含適當的 widget 樹上下文管理
- 通過延遲 setState 調用修復了 "Build scheduled during frame" 錯誤

### 變更
- 更新 ErrorBoundary 以直接使用 Scaffold 而不是嵌套的 MaterialApp
- 使用 SafeArea、SingleChildScrollView 和響應式約束改進了錯誤 UI 佈局
- 使用最小尺寸約束增強了按鈕樣式以提高可訪問性
- 使用適當的 provider 訪問時機優化了錯誤邊界初始化

### 新增功能
- 全面的錯誤邊界測試和驗證
- Mapbox 整合驗證和測試工具
- 增強的調試功能，包含詳細的錯誤日誌記錄
- 地圖功能的網路連接檢查

## [0.0.4] - 2025-09-08

### Fixed
- Resolved Hive typeId conflict between User and ActivityCategory models (both using typeId 4)
- Fixed local storage initialization order issue causing "本地儲存尚未初始化" error
- Updated repository implementations to use lazy box access via LocalStorageService
- Cleaned up unused Hive imports in repository files
- Regenerated Hive adapters after typeId reassignment

### Changed
- Updated User model typeId from 4 to 15 to resolve conflict
- Modified HiveTripRepository and HiveUserRepository to accept LocalStorageService instead of Box references
- Updated app_providers.dart to pass LocalStorageService to repositories
- Updated hive_adapters.dart constants to reflect new typeId assignments

### 中文描述
- 解決了 User 和 ActivityCategory 模型之間的 Hive typeId 衝突（都使用 typeId 4）
- 修復了本地儲存初始化順序問題，解決了「本地儲存尚未初始化」錯誤
- 更新了 repository 實作以使用通過 LocalStorageService 的延遲 box 存取
- 清理了 repository 文件中未使用的 Hive 匯入
- 在 typeId 重新分配後重新生成了 Hive 適配器

### 變更
- 將 User 模型的 typeId 從 4 更新為 15 以解決衝突
- 修改了 HiveTripRepository 和 HiveUserRepository 以接受 LocalStorageService 而不是 Box 引用
- 更新了 app_providers.dart 以將 LocalStorageService 傳遞給 repositories
- 更新了 hive_adapters.dart 常數以反映新的 typeId 分配

## [0.0.3] - 2025-09-08

### Added
- Created core data models using Freezed: Trip, DayPlan, Activity, Destination, UserPreferenceAnalysis, TripRequest
- Implemented complete JSON serialization and deserialization for all models
- Added comprehensive enum types: ActivityCategory, ActivityPriority, TravelPace, BudgetRange, TravelStyle
- Comprehensive unit test coverage with 37 test cases for all data models
- Key features: Activity time validation, DayPlan filtering, Trip statistics, TripDuration date handling
- Supporting models: TripDuration, BasicPreferences, Coordinates

### 中文描述
- 使用 Freezed 建立核心資料模型：Trip、DayPlan、Activity、Destination、UserPreferenceAnalysis、TripRequest
- 實作完整的 JSON 序列化和反序列化
- 建立全面的 enum 類型：ActivityCategory、ActivityPriority、TravelPace、BudgetRange、TravelStyle
- 撰寫 37 個單元測試案例，涵蓋所有資料模型
- 關鍵特性：活動時間驗證、日程過濾、行程統計、日期處理
- 支援模型：TripDuration、BasicPreferences、Coordinates

## [0.0.2] - 2025-09-08

### Added
- Integrated Mapbox Maps Flutter v2.10.0 for map functionality
- Configured Mapbox access token for Android and iOS platforms
- Added MapboxMapScreen widget with Taipei marker example
- Created MAPBOX_CONFIG.md documentation for configuration details

### Changed
- Updated pubspec.yaml with Mapbox dependency and removed Google Maps
- Modified android/app/build.gradle.kts and AndroidManifest.xml for Mapbox integration
- Updated ios/Runner/Info.plist with Mapbox access token
- Updated main.dart to include navigation to the map screen

### Removed
- Removed Google Maps dependency from pubspec.yaml

## [0.0.1] - 2025-09-08

### Added
- Initial project setup and foundation
- Basic Flutter application structure
- Core dependency configuration
- Android and iOS platform setup
- Build configuration with Java 17 support
- Project documentation (README, CHANGELOG)
- Git repository initialization

### Fixed
- Java version compatibility issues
- Gradle build configuration errors
- Dependency resolution conflicts

### Infrastructure
- Flutter 3.35.2 with Dart 3.9.0
- Android SDK API 34 target
- Gradle 8.12 build system
- Clean build environment setup

## [0.1.0] - 2025-09-08

### Added
- Initial Flutter project setup with Android Studio structure
- State management with Riverpod 2.x
- HTTP client with Dio 5.x
- Local storage with Hive and Flutter Secure Storage
- Authentication with Google Sign-In and Firebase Auth
- Data models with Freezed and JSON serialization
- PDF generation with pdf package
- Google Maps integration (requires API key)
- Google Places API integration
- Permission handling with permission_handler
- Network connectivity monitoring
- Project structure with organized folders (models, services, providers, widgets, screens, utils)
- Android and iOS platform configurations
- Basic app architecture with ProviderScope and Riverpod
- Debug APK build configuration

### Dependencies
- flutter_riverpod: ^2.5.1
- dio: ^5.4.3+1
- hive: ^2.2.3
- hive_flutter: ^1.1.0
- flutter_secure_storage: ^9.2.2
- google_sign_in: ^6.2.1
- firebase_auth: ^4.19.6
- firebase_core: ^2.31.1
- freezed_annotation: ^2.4.1
- json_annotation: ^4.8.1
- pdf: ^3.8.4
- google_maps_flutter: ^2.6.1
- google_places_flutter: ^2.0.8
- permission_handler: ^11.3.1
- connectivity_plus: ^6.0.3

### Dev Dependencies
- build_runner: ^2.4.9
- freezed: ^2.4.1
- json_serializable: ^6.8.0
- hive_generator: ^2.0.1

### Infrastructure
- Flutter 3.9.0+ compatible
- Android API level support
- iOS platform support
- Cross-platform build configuration
- Gradle build system configuration

### Notes
- Mapbox integration temporarily disabled due to configuration complexity
- Google Maps API key required for map functionality
- Ready for core feature development (trip planning, AI integration, etc.)
