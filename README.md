# TripMuse 🧳

**Version 0.3.6**

TripMuse is an AI-powered intelligent travel planning application built with Flutter and MapBox Maps SDK. Transform your travel ideas into personalized itineraries with the power of artificial intelligence.

TripMuse 是一個基於 AI 的智能旅行規劃應用，使用 Flutter 和 MapBox Maps SDK 開發。透過人工智慧的力量，將您的旅行想法轉化為個人化的行程規劃。

## 📈 Latest Updates / 最新更新

### v0.3.3-patch (2025-09-17)
- 🐛 **編譯錯誤修復** | Compilation Error Fixes: 修復 TripDetailScreen 構造函數參數錯誤和相關的編譯問題
- 🔧 **Provider 參數修復** | Provider Parameter Fix: 修復 ActivityEditNotifier 構造函數參數問題
- 🔄 **狀態同步優化** | State Synchronization Enhancement: 優化 Provider 失效處理，確保 UI 即時更新
- 📱 **測試文件修復** | Test File Fixes: 修復測試文件中過時的構造函數調用

### v0.3.1 (2025-09-16)
- 🖼️ **目的地圖片服務** | Destination Image Service: 新增專門的圖片服務根據目的地城市獲取高品質風景圖片
- 🎨 **行程卡片視覺優化** | Trip Card Visual Enhancement: 改進行程卡片的視覺效果，使用真實目的地圖片替代漸層背景
- 🔄 **圖片服務架構重構** | Image Service Architecture Refactoring: 重構圖片獲取邏輯，統一使用 DestinationImageService
- 📱 **我的行程頁面UI優化** | My Trips Page UI Optimization: 優化TabBar樣式，增加圓角和陰影效果
- 🏙️ **城市圖片數據庫擴展** | City Image Database Expansion: 擴展支援的城市圖片數據庫，涵蓋亞洲、歐洲、美洲等多個地區

### v0.3.0 (2025-09-15)
- 🗺️ **地圖總覽功能** | Map Overview Feature: Auto-zoom out when entering trip to show complete trip overview
- 📹 **智能鏡頭控制** | Smart Camera Control: Automatic camera positioning for optimal trip visualization
- 🎯 **行程全貌展示** | Complete Trip Display: Show all trip activities and routes at once
- 🔍 **動態縮放動畫** | Dynamic Zoom Animation: Smooth zoom-out animation for better user experience
- 🧭 **導航體驗優化** | Navigation Experience Optimization: Enhanced map interaction when viewing trip details
- 🔄 **動態行程顯示** | Dynamic Trip Display: Replaced hardcoded sample data with real trip data loading
- 🖼️ **城市圖片動態選擇** | Dynamic City Image Selection: Automatically select appropriate images based on destination cities
- 🎨 **系統UI主題優化** | System UI Theme Optimization: Enhanced status bar and navigation bar styling for consistent theming

### v0.2.3 (2025-09-15)
- 🆕 **我的行程頁面** | My Trips Page: New dedicated page for managing all user trips with search and filter functionality
- ➕ **行程創建頁面** | Trip Creation Page: Enhanced trip creation interface with improved user experience
- 🗓️ **時間軸組件優化** | Timeline Components Optimization: Improved timeline widgets with better visual design and functionality
- 🧭 **導航系統完善** | Navigation System Enhancement: Complete routing system with dedicated pages for trip creation and management
- 🎨 **UI 組件更新** | UI Components Update: Enhanced day timeline cards, activity cards, and overall visual consistency
- 🔄 **路由系統重構** | Routing System Refactoring: Comprehensive route management for better navigation experience

### v0.2.2 (2025-09-15)
- 🤖 **AI 模型升級** | AI Model Upgrade: Upgraded from Gemini Pro to Gemini 2.5 Flash for enhanced performance and accuracy
- ⚡ **回應速度提升** | Response Speed Improvement: Faster trip generation with improved AI processing capabilities
- 🎯 **生成品質優化** | Generation Quality Enhancement: Better trip planning accuracy and richer detail generation
- 🔧 **設定頁面修復** | Settings Page Fix: Fixed settings screen import issues and improved UI consistency
- 🎨 **用戶介面改善** | UI Improvements: Enhanced user experience with better error handling and visual feedback

### v0.2.1 (2025-09-12)
- 🗑️ **行程刪除功能修復** | Trip Deletion Fix: Fixed recent trips deletion functionality with proper async handling and UI refresh
- 🛤️ **路線曲度優化** | Route Curvature Optimization: Reduced route curvature for straighter, more natural-looking paths on map
- 🔄 **UI 狀態同步** | UI State Synchronization: Improved UI refresh after trip deletion operations
- ⚡ **異步處理優化** | Async Handling Optimization: Enhanced async/await patterns for better deletion reliability
- 🎯 **用戶體驗改善** | User Experience Enhancement: Added loading indicators and error handling for deletion operationsntelligence.

TripMuse 是一個基於 AI 的智能旅行規劃應用，使用 Flutter 和 MapBox Maps SDK 開發。透過人工智慧的力量，將您的旅行想法轉化為個人化的行程規劃。

## ✨ Features / 功能特色

### 🎯 Planned Features / 規劃功能
- 🤖 **AI Trip Generation** - Generate personalized itineraries using natural language descriptions
- 🗺️ **Interactive Maps** - Beautiful map visualization with route planning
- 📅 **Timeline View** - Organized daily schedules with drag-and-drop editing
- 📱 **Cross-Platform** - iOS and Android support
- 🔄 **Offline Support** - Access your trips without internet connection
- 📄 **PDF Export** - Generate beautiful travel guides
- 🔗 **Trip Sharing** - Share itineraries with friends and family
- 🔐 **Google Sign-In** - Secure authentication and cloud sync

### 🤖 規劃功能
- 🤖 **AI 行程生成** - 使用自然語言描述生成個人化行程
- 🗺️ **互動式地圖** - 美觀的地圖視覺化與路線規劃
- 📅 **時間軸視圖** - 有組織的每日行程，支援拖拉編輯
- 📱 **跨平台支援** - 支援 iOS 和 Android
- 🔄 **離線支援** - 無網路連線時也能存取行程
- 📄 **PDF 匯出** - 生成精美的旅行手冊
- 🔗 **行程分享** - 與朋友和家人分享行程
- 🔐 **Google 登入** - 安全認證和雲端同步

## 🚀 Current Status / 目前狀態

**Version 0.3.0** - Map Overview Enhancement / 地圖總覽功能增強

✅ Project structure established / 專案結構建立  
✅ Core dependencies integrated / 核心依賴整合  
✅ MapBox SDK configured / MapBox SDK 配置  
✅ TripMuse app entry point created / TripMuse 應用入口建立  
✅ **Complete data models with Freezed** / **使用 Freezed 完成資料模型**  
✅ **JSON serialization support** / **JSON 序列化支援**  
✅ **Comprehensive unit tests** / **完整單元測試**  
✅ **Example data and Chinese localization** / **範例資料和中文本地化**  
✅ **Complete storage system with Hive** / **使用 Hive 完成儲存系統**  
✅ **Offline-first sync service** / **離線優先同步服務**  
✅ **Repository pattern implementation** / **Repository 模式實作**  
✅ **Secure storage for sensitive data** / **敏感資料安全儲存**  
✅ **Complete TripMuse app UI** / **完成 TripMuse 應用 UI**  
✅ **Bottom navigation with three screens** / **三個畫面的底部導航**  
✅ **Material 3 theme system** / **Material 3 主題系統**  
✅ **Riverpod state management** / **Riverpod 狀態管理**  
✅ **AI Trip Generation with Gemini API** / **使用 Gemini API 的 AI 行程生成**  
✅ **GCP Cloud Run backend deployment** / **GCP Cloud Run 後端部署**  
✅ **Complete API integration and testing** / **完整 API 整合和測試**  
✅ **Google Places API data enhancement** / **Google Places API 資料補強**  
✅ **Geographic coordinate validation** / **地理座標驗證**  
✅ **Place photos and ratings integration** / **地點照片和評分整合**  
✅ **Complete API client and network layer** / **完整的 API 客戶端和網路層**  
✅ **Code quality improvements and linting fixes** / **程式碼品質提升和 linting 修復**  
✅ **User system with Guest mode** / **使用者系統與訪客模式**  
✅ **Trip list screen with search & filter** / **行程列表頁面含搜尋篩選**  
✅ **Trip card component** / **行程卡片組件**  
✅ **Trip status management** / **行程狀態管理**  
✅ **Complete API client and network layer** / **完整 API 客戶端和網路層**  
✅ **HTTP request handling with Dio** / **使用 Dio 處理 HTTP 請求**  
✅ **Smart retry mechanism** / **智能重試機制**  
✅ **Network status monitoring** / **網路狀態監控**  
✅ **Authentication interceptor** / **認證攔截器**  
✅ **Standardized API response format** / **標準化 API 回應格式**  
✅ **🧪 API Testing Features** / **🧪 API 測試功能**  
✅ **🔍 Real-time API Health Monitoring** / **🔍 即時 API 健康監控**  
✅ **🎯 Trip Generation Testing** / **🎯 行程生成測試**  
✅ **🗺️ Place Search Testing** / **🗺️ 地點搜尋測試**  
✅ **⚙️ Map Configuration Testing** / **⚙️ 地圖配置測試**  
✅ **💾 Storage System Stability** / **💾 儲存系統穩定性**  
✅ **🔧 Trip Saving Functionality** / **🔧 行程儲存功能**  
✅ **⭐ Trip Favorites Feature** / **⭐ 行程收藏功能**  
✅ **🗓️ Date Filter Panel Optimization** / **🗓️ 日期篩選面板優化**  
✅ **🎯 Smart Map View Switching** / **🎯  智能地圖視角切換**  
✅ **✈️ 3D Flight Animation** / **✈️ 3D 飛行動畫**  
✅ **📍 Coordinate Validation** / **📍 座標驗證機制**  
✅ **🗓️ Timeline View Component Development** / **🗓️ 時間軸視圖組件開發**  
✅ **🗺️ Real Map Integration** / **🗺️ 真正的地圖整合**  
✅ **🔄 View Switching Functionality** / **🔄 視圖切換功能**  
✅ **📍 Attraction Markers & Route Planning** / **📍 景點標記與路線規劃**  
✅ **🎨 Beautiful Timeline Design** / **🎨 美觀的時間軸設計**  
✅ **📱 Responsive Design & Material Design 3** / **📱 響應式設計與 Material Design 3**  
✅ **🧪 Complete Test Coverage** / **🧪 完整測試覆蓋**  
✅ **⚡ Zero Compilation Errors & Warnings** / **⚡ 無編譯錯誤和警告**  

🚧 Current attraction highlighting / 當前景點高亮顯示進行中  
🚧 External navigation app integration / 外部導航應用整合進行中  
🚧 Marker and route animation effects / 標記和路線動畫效果進行中 

## 🛠️ Tech Stack / 技術棧

- **Framework**: Flutter 3.x
- **Maps**: MapBox Maps Flutter SDK
- **State Management**: Riverpod
- **Backend**: Firebase (Auth, Firestore)
- **Local Storage**: Hive + Flutter Secure Storage
- **HTTP Client**: Dio
- **PDF Generation**: Flutter PDF
- **Authentication**: Google Sign-In

## 📱 Getting Started / 開始使用

### Prerequisites / 前置需求

- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- MapBox Access Token
- Firebase Project (for authentication)

### Installation / 安裝

1. **Clone the repository / 複製儲存庫**
   ```bash
   git clone https://github.com/your-username/tripmuse.git
   cd tripmuse
   ```

2. **Install dependencies / 安裝依賴**
   ```bash
   flutter pub get
   ```

3. **Set up MapBox Access Token / 設定 MapBox 存取權杖**
   ```bash
   flutter run --dart-define=ACCESS_TOKEN=YOUR_MAPBOX_TOKEN
   ```

4. **Run the app / 運行應用**
   ```bash
   flutter run
   ```

### Usage / 使用方法

1. Launch the app / 啟動應用
2. Select "🧳 TripMuse App" from the main menu / 從主選單選擇 "🧳 TripMuse App"
3. Start exploring TripMuse features / 開始探索 TripMuse 功能

### 📱 How to Check New Features / 如何在 APP 中檢查新功能

#### 進入行程詳情頁面 / Enter Trip Detail Page:
- 在首頁點擊任何現有的行程卡片（如"雲林親子三天樂遊"） / Click any existing trip card on the home page (e.g., "Yunlin Parent-Child Three-Day Tour")
- 或者使用"行程生成測試"功能建立新行程 / Or create a new trip using the "Trip Generation Test" feature

#### 時間軸視圖（預設視圖） / Timeline View (Default View):
- 美觀的時間軸設計，包含日期圓點和連接線 / Beautiful timeline design with date dots and connecting lines
- 每日行程卡片顯示日期、主題和統計資訊 / Daily itinerary cards display date, theme, and statistics
- 活動卡片顯示時間、類別、描述和小貼士 / Activity cards display time, category, description, and tips
- 不同活動類別有不同的顏色主題 / Different activity categories have different color themes

#### 地圖視圖 / Map View:
- 點擊頂部的"地圖"按鈕切換到地圖視圖 / Click the "Map" button at the top to switch to map view
- 顯示真正的 MapBox 地圖（不再是佔位符） / Display real MapBox map (no longer placeholder)
- 可以看到所有景點的標記和路線 / Can see markers and routes for all attractions
- 點擊地圖上的景點標記可以查看詳細資訊 / Click attraction markers on the map to view details
- 支援地圖縮放、拖拽等互動功能 / Support map zoom, drag, and other interactive features

#### 視圖切換 / View Switching:
- 在時間軸和地圖之間自由切換 / Free switching between timeline and map
- 按鈕狀態正確反映當前視圖 / Button states correctly reflect current view
- 切換過程流暢無卡頓 / Smooth switching process without lag

### 🚀 Launch Command / 啟動命令
```bash
flutter run --dart-define ACCESS_TOKEN=YOUR_MAPBOX_ACCESS_TOKEN
```
現在您可以使用上述命令啟動應用程式，體驗完整的時間軸和地圖功能！ / Now you can use the above command to launch the application and experience the complete timeline and map features!

## 🧪 API Testing Features / API 測試功能

TripMuse 現在包含完整的 API 測試功能，讓您能夠輕鬆測試和驗證所有 API 端點的功能。

### 🔍 API Health Monitoring / API 健康監控
- **即時狀態檢查**: 實時監控 API 服務的健康狀態
- **視覺化指示器**: 清晰的狀態指示器顯示服務是否正常運作
- **錯誤診斷**: 詳細的錯誤訊息幫助快速定位問題

### 🎯 Trip Generation Testing / 行程生成測試
- **互動式測試介面**: 直觀的輸入介面測試行程生成功能
- **即時進度追蹤**: 測試過程中顯示生成進度百分比
- **結果驗證**: 完整顯示生成的行程資料結構

### 🗺️ Place Search Testing / 地點搜尋測試
- **關鍵字搜尋**: 測試地點搜尋 API 的功能
- **結果展示**: 以清單形式展示搜尋結果
- **詳細資訊**: 顯示地點的評分、地址等資訊

### ⚙️ Map Configuration Testing / 地圖配置測試
- **配置驗證**: 測試地圖配置 API 的回應
- **權杖管理**: 驗證 MapBox 存取權杖的配置
- **設定檢查**: 確認地圖的縮放限制和中心點設定

### 📱 Testing Interface / 測試介面
- **Material Design**: 現代化的 Material 3 設計風格
- **響應式佈局**: 適配不同螢幕尺寸的響應式設計
- **即時回饋**: 操作後立即顯示結果和狀態
- **錯誤處理**: 友好的錯誤提示和恢復機制

### 🚀 How to Access / 如何存取
1. 在應用中導航到 API 測試頁面
2. 選擇要測試的功能模組
3. 輸入必要的測試參數
4. 點擊測試按鈕開始驗證
5. 查看即時結果和狀態回饋

## 🏗️ Project Structure / 專案結構

```
lib/
├── main.dart                    # App entry point / 應用入口
├── example/                     # MapBox examples (preserved) / MapBox 範例（保留）
├── utils.dart                   # Utility functions / 工具函數
└── tripmuse/                    # TripMuse features / TripMuse 功能
    ├── tripmuse_app.dart        # TripMuse main app / TripMuse 主應用
    ├── models/                  # Data models / 資料模型
    ├── services/                # Service layer / 服務層
    ├── screens/                 # UI screens / 使用者介面頁面
    └── widgets/                 # UI components / 使用者介面組件
```

## 📈 Latest Updates / 最新更新

### v0.2.1 (2025-09-12)
- �️ **行程刪除功能修復** | Trip Deletion Fix: Fixed recent trips deletion functionality with proper async handling and UI refresh
- 🛤️ **路線曲度優化** | Route Curvature Optimization: Reduced route curvature for straighter, more natural-looking paths on map
- 🔄 **UI 狀態同步** | UI State Synchronization: Improved UI refresh after trip deletion operations
- ⚡ **異步處理優化** | Async Handling Optimization: Enhanced async/await patterns for better deletion reliability
- 🎯 **用戶體驗改善** | User Experience Enhancement: Added loading indicators and error handling for deletion operations

### v0.2.1 (2025-09-12)
- �🔍 **地圖搜索功能** | Map Search Functionality: Added complete place search with real-time results
- 🧭 **導航功能整合** | Navigation Integration: Integrated navigation in search results for one-click navigation
- 🐛 **導航修復** | Navigation Fix: Fixed navigation launch failure by updating deprecated API usage
- 🔧 **錯誤處理強化** | Enhanced Error Handling: Improved error handling with multiple fallback options
- 📱 **多平台支援** | Multi-Platform Support: Enhanced compatibility with Google Maps, Apple Maps, etc.

### v0.2.0 (2025-09-12)
- 🎯 **完成的功能** | Completed Features: Timeline view component development and real map functionality integration
- 🗓️ **時間軸視圖組件** | Timeline View Components: TimelineWidget, DayTimelineCard, TimelineActivityCard
- 🗺️ **真正的地圖視圖** | Real Map View: Integrated TripMapWidget into trip detail page, displaying full MapBox map
- 📍 **景點標記和路線規劃** | Attraction Markers & Route Planning: Include attraction markers and route planning, support clicking attractions for details
- 🔄 **視圖切換功能** | View Switching: Seamless switching between timeline and map views, correct button states and text
- 🎨 **美觀的時間軸設計** | Beautiful Timeline Design: Includes date dots and connecting lines
- 📱 **響應式設計** | Responsive Design: Adapts to different screen sizes
- 🧪 **完整測試覆蓋** | Complete Test Coverage: Includes unit tests to ensure functionality
- ⚡ **無編譯錯誤和警告** | Zero Compilation Errors & Warnings: All code passed Flutter analysis

### v0.1.9 (2025-09-12)
- 🗓️ **日期篩選面板優化** | Optimized date filter panel position to avoid blocking map content
- 🎯 **智能地圖視角切換** | Smart map view switching - automatically fly to selected day's first attraction
- ✈️ **3D 飛行動畫** | Smooth 3D map flight animation with zoom and pitch adjustments
- 📍 **座標驗證機制** | Smart coordinate validation for flight animation stability
- 🔄 **狀態同步優化** | Enhanced synchronization between map state and UI state
- 🎨 **用戶界面優化** | Enhanced UI with better visual harmony and responsive design
- ⚡ **動畫效果提升** | 3-second smooth flight with 16x zoom and 45-degree pitch
- 🧪 **測試覆蓋完整** | Complete test coverage with zero compilation errors

### v0.1.8 (2025-09-11)
- 🐛 **JSON 解析錯誤修復** | Fixed JSON parsing errors and format mismatches
- 🔧 **budgetRange 欄位修復** | Added missing budgetRange field to UserPreferenceAnalysis
- 📊 **活動類別統一** | Unified activity category mapping for consistency
- ⚡ **靈活解析機制** | Flexible budgetRange parsing supporting multiple variants
- 🎯 **活動類別映射擴展** | Extended activity category mapping for LLM variants
- 📝 **JSON 格式兼容性** | Significantly improved Client-Server JSON compatibility

### v0.1.7 (2025-01-11)
- 🐛 **儲存系統修復** | Fixed critical StorageManager initialization timing issues
- 💾 **行程儲存穩定** | Resolved trip saving failures and improved reliability
- 🔧 **Provider 作用域** | Fixed ProviderScope instance sharing problems
- 📱 **啟動初始化** | Initialize storage system at app startup for better stability
- ⭐ **收藏功能完成** | Completed trip favorites feature with local storage
- 🔄 **容錯機制** | Added fault tolerance and retry mechanisms

### v0.1.6 (2025-09-10)
- 🗺️ **Google Places API 整合** | Complete Google Places API integration for enhanced trip data
- 📍 **地點資料補強** | Automatic place details, photos, and ratings enrichment
- 🧭 **地理座標驗證** | Geographic coordinate validation and auto-completion
- 🖼️ **地點照片整合** | Place photo references and display integration
- 🔧 **後端語法修復** | Fixed server.js syntax errors and optimized Places API calls
- 🚀 **部署配置更新** | Updated Cloud Run deployment with Places API secrets

### v0.1.5 (2025-09-10)
- 🐛 **JSON 解析修復** | Fixed Flutter JSON parsing errors and model serialization
- 🔧 **資料模型優化** | Enhanced data model type safety and default value handling
- 📊 **序列化效能提升** | Optimized JSON serialization and deserialization performance
- 🛡️ **錯誤處理改善** | Improved error handling and user feedback

### v0.1.4 (2025-01-09)
- 🧪 **API 測試功能** | Complete API testing screen with real-time monitoring
- 🔍 **API 健康檢查** | Real-time API health status monitoring
- 🎯 **行程生成測試** | Trip generation testing with progress indicators
- 🗺️ **地點搜尋測試** | Place search testing functionality
- ⚙️ **地圖配置測試** | Map configuration testing capabilities
- 📱 **測試 UI 介面** | Intuitive testing interface with instant feedback
- 🔄 **即時狀態更新** | Real-time status updates during testing

### v0.1.3 (2025-01-09)
- 🌐 **完整 API 架構** | Complete API client and network layer architecture
- 🔄 **智能重試機制** | Smart retry mechanism with exponential backoff
- 📡 **網路狀態監控** | Real-time network connectivity monitoring
- 🔐 **認證攔截器** | Automatic Bearer token authentication
- 📊 **標準化回應** | Standardized API request/response format
- 🧪 **完整測試** | 19 unit tests with full coverage

### v0.1.1 (2025-01-09)
- 📋 **行程列表頁面** | Trip list screen with search and filter
- 🎴 **行程卡片組件** | Trip card component with status management
- 🔍 **搜尋篩選功能** | Advanced search and filter functionality

### v0.1.0 (2024-12-19)
- 🎉 **初始版本** | Initial release with basic architecture
- 🏗️ **基礎架構** | Core data models and storage system
- 👤 **使用者系統** | User system with Guest mode

## 🤝 Contributing / 貢獻

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

歡迎貢獻！請查看我們的[貢獻指南](CONTRIBUTING.md)了解詳情。

## 📄 License / 授權

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

本專案採用 MIT 授權 - 詳情請參閱 [LICENSE](LICENSE) 檔案。

## 📞 Support / 支援

If you have any questions or need help, please:
- Create an issue on GitHub
- Contact us at support@tripmuse.com

如果您有任何問題或需要幫助，請：
- 在 GitHub 上建立 issue
- 聯絡我們：support@tripmuse.com

---

**Built with ❤️ using Flutter and MapBox**  
**使用 Flutter 和 MapBox 用心打造**
