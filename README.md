# TripMuse 🧳

**Version 0.1.1**

TripMuse is an AI-powered intelligent travel planning application built with Flutter and MapBox Maps SDK. Transform your travel ideas into personalized itineraries with the power of artificial intelligence.

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

**Version 0.1.1** - Trip List Management Complete / 行程列表管理完成

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
🚧 AI trip generation service in progress / AI 行程生成服務開發進行中 

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
