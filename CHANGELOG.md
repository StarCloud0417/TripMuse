# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.2] - 2025-09-16

### Added
- 🎯 **活動拖拉功能** - 新增完整的活動拖拉和重新排序功能 (Added complete activity drag and reorder functionality)
- 📝 **活動編輯系統** - 新增活動編輯 provider 和服務，支援即時編輯 (Added activity editing provider and service with real-time editing support)
- 🗂️ **活動管理功能** - 新增活動刪除、移動到其他日期、替換等管理功能 (Added activity management features: delete, move to other days, replace)
- 🎨 **拖拉視覺回饋** - 新增拖拉過程中的視覺效果和動畫 (Added visual feedback and animations during drag operations)
- 📅 **跨日期活動移動** - 支援將活動移動到其他日期的功能 (Added cross-day activity movement functionality)

### Enhanced
- 🔄 **時間軸組件重構** - 重構 DayTimelineCard 為 ConsumerWidget，整合狀態管理 (Refactored DayTimelineCard to ConsumerWidget with integrated state management)
- 🎯 **拖拉觸發優化** - 優化拖拉觸發機制，提供更好的用戶體驗 (Optimized drag trigger mechanism for better user experience)
- 📱 **響應式設計改進** - 改善拖拉操作的響應式設計和觸摸體驗 (Improved responsive design for drag operations and touch experience)
- 🔔 **操作回饋增強** - 新增操作成功/失敗的視覺和觸覺回饋 (Enhanced operation feedback with visual and haptic feedback)

### Technical
- 🏗️ **狀態管理架構** - 新增 ActivityEditProvider 進行活動編輯狀態管理 (Added ActivityEditProvider for activity editing state management)
- 🔧 **服務層擴展** - 新增 ActivityEditService 處理活動編輯業務邏輯 (Added ActivityEditService for activity editing business logic)
- 🎯 **組件模組化** - 將拖拉功能封裝到獨立的 DraggableActivityCard 組件 (Modularized drag functionality into separate DraggableActivityCard component)
- 📦 **依賴注入優化** - 優化 Riverpod provider 的依賴注入和狀態同步 (Optimized Riverpod provider dependency injection and state synchronization)

### 中文
- 🎯 **活動拖拉功能** - 新增完整的活動拖拉和重新排序功能
- 📝 **活動編輯系統** - 新增活動編輯 provider 和服務，支援即時編輯
- 🗂️ **活動管理功能** - 新增活動刪除、移動到其他日期、替換等管理功能
- 🎨 **拖拉視覺回饋** - 新增拖拉過程中的視覺效果和動畫
- 📅 **跨日期活動移動** - 支援將活動移動到其他日期的功能

### 技術改進
- 🔄 **時間軸組件重構** - 重構 DayTimelineCard 為 ConsumerWidget，整合狀態管理
- 🎯 **拖拉觸發優化** - 優化拖拉觸發機制，提供更好的用戶體驗
- 📱 **響應式設計改進** - 改善拖拉操作的響應式設計和觸摸體驗
- 🔔 **操作回饋增強** - 新增操作成功/失敗的視覺和觸覺回饋

### 檔案變更
- 新增: `lib/tripmuse/providers/activity_edit_provider.dart` - 活動編輯狀態管理
- 新增: `lib/tripmuse/services/activity_edit_service.dart` - 活動編輯業務邏輯
- 新增: `lib/tripmuse/widgets/activity_drop_target.dart` - 拖拉目標組件
- 修改: `lib/tripmuse/widgets/day_timeline_card.dart` - 重構為 ConsumerWidget，添加拖拉功能
- 修改: `lib/tripmuse/widgets/draggable_activity_card.dart` - 優化拖拉觸發機制
- 修改: `lib/tripmuse/widgets/timeline_widget.dart` - 整合拖拉功能支援
- 修改: `lib/tripmuse/providers/providers.dart` - 添加活動編輯 provider
- 修改: `lib/tripmuse/services/services.dart` - 添加活動編輯服務導出
- 修改: `lib/tripmuse/widgets/widgets.dart` - 添加新組件導出

## [0.3.1] - 2025-09-16

### Added
- 🖼️ **目的地圖片服務** - 新增專門的圖片服務根據目的地城市獲取高品質風景圖片 (Added DestinationImageService for fetching high-quality destination images based on cities)
- 🏙️ **城市圖片數據庫** - 擴展支援的城市圖片數據庫，涵蓋亞洲、歐洲、美洲等多個地區 (Expanded city image database supporting multiple regions including Asia, Europe, and Americas)
- 📸 **Unsplash 圖片整合** - 整合 Unsplash API 獲取無版權的高品質旅遊景點圖片 (Integrated Unsplash API for fetching copyright-free high-quality travel destination images)

### Enhanced
- 🎨 **行程卡片視覺優化** - 改進行程卡片的視覺效果，使用真實目的地圖片替代漸層背景 (Enhanced trip card visuals by replacing gradient backgrounds with real destination images)
- 📱 **我的行程頁面UI優化** - 優化TabBar樣式，增加圓角和陰影效果，提升視覺一致性 (Optimized My Trips page UI with improved TabBar styling, rounded corners, and shadow effects)
- 🔄 **圖片載入體驗** - 新增圖片載入狀態指示器和錯誤處理，提供更好的用戶體驗 (Added image loading indicators and error handling for better user experience)

### Technical
- 🔄 **圖片服務架構重構** - 重構圖片獲取邏輯，統一使用 DestinationImageService，提高代碼可維護性 (Refactored image service architecture to use DestinationImageService consistently, improving code maintainability)
- 🏗️ **服務導出優化** - 更新 services.dart 導出文件，統一圖片服務的訪問方式 (Updated services.dart export file for unified image service access)
- 📦 **模組化設計** - 將圖片獲取邏輯封裝到獨立的服務類中，提高代碼組織性和可測試性 (Modularized image fetching logic into separate service class for better code organization and testability)

### 中文
- 🖼️ **目的地圖片服務** - 新增專門的圖片服務根據目的地城市獲取高品質風景圖片
- 🏙️ **城市圖片數據庫** - 擴展支援的城市圖片數據庫，涵蓋亞洲、歐洲、美洲等多個地區
- 📸 **Unsplash 圖片整合** - 整合 Unsplash API 獲取無版權的高品質旅遊景點圖片

### 技術改進
- 🎨 **行程卡片視覺優化** - 改進行程卡片的視覺效果，使用真實目的地圖片替代漸層背景
- 📱 **我的行程頁面UI優化** - 優化TabBar樣式，增加圓角和陰影效果，提升視覺一致性
- 🔄 **圖片載入體驗** - 新增圖片載入狀態指示器和錯誤處理，提供更好的用戶體驗

### 檔案變更
- 新增: `lib/tripmuse/services/destination_image_service.dart` - 目的地圖片服務核心實現
- 新增: `lib/tripmuse/services/README_destination_images.md` - 圖片服務使用說明文檔
- 新增: `test/tripmuse/destination_image_service_test.dart` - 圖片服務單元測試
- 修改: `lib/tripmuse/screens/home_screen_new.dart` - 整合圖片服務，移除硬編碼圖片邏輯
- 修改: `lib/tripmuse/screens/my_trips_screen.dart` - 優化UI樣式，使用圖片服務
- 修改: `lib/tripmuse/services/services.dart` - 添加圖片服務導出
- 修改: `pubspec.yaml` - 版本號更新為 0.3.1

## [0.2.1] - 2025-09-12

### Added
- 🔍 **地圖搜索功能** - 新增完整的地點搜索功能，支援即時搜索和結果展示 (Added complete place search functionality with real-time search and results display)
- 🧭 **導航功能整合** - 在搜索結果中整合導航功能，支援一鍵導航到選定地點 (Integrated navigation functionality in search results, support one-click navigation to selected places)

### Fixed
- 🐛 **導航啟動失敗** - 修復導航功能無法啟動的問題，替換棄用的canLaunchUrl函數 (Fixed navigation launch failure by replacing deprecated canLaunchUrl function)
- 🔧 **導航異常處理** - 改善導航功能的異常處理，提供多層備用方案 (Improved navigation error handling with multiple fallback options)
- 📱 **地圖應用相容性** - 增強與不同地圖應用的相容性，支援Google Maps、Apple Maps等 (Enhanced compatibility with different map applications)

### Technical
- 🔄 **URL啟動機制** - 更新URL啟動機制，使用新的launchUrl API (Updated URL launch mechanism using new launchUrl API)
- 🛡️ **錯誤處理強化** - 強化錯誤處理機制，提供更清晰的錯誤訊息 (Strengthened error handling mechanism with clearer error messages)
- 📋 **多平台支援** - 改善多平台導航支援，適配Android和iOS (Improved multi-platform navigation support for Android and iOS)

### 中文
- 🔍 **地圖搜索功能** - 新增完整的地點搜索功能，支援即時搜索和結果展示
- 🧭 **導航功能整合** - 在搜索結果中整合導航功能，支援一鍵導航到選定地點

### 問題修復
- 🐛 **導航啟動失敗** - 修復導航功能無法啟動的問題，替換棄用的canLaunchUrl函數
- 🔧 **導航異常處理** - 改善導航功能的異常處理，提供多層備用方案
- 📱 **地圖應用相容性** - 增強與不同地圖應用的相容性，支援Google Maps、Apple Maps等

### 技術改進
- 🔄 **URL啟動機制** - 更新URL啟動機制，使用新的launchUrl API
- 🛡️ **錯誤處理強化** - 強化錯誤處理機制，提供更清晰的錯誤訊息
- 📋 **多平台支援** - 改善多平台導航支援，適配Android和iOS

### 檔案變更
- 修改: `lib/tripmuse/services/navigation_helper.dart` - 修復導航功能，替換canLaunchUrl
- 修改: `lib/tripmuse/services/location_service.dart` - 修復openNavigation方法
- 修改: `lib/tripmuse/screens/map_screen.dart` - 新增地圖搜索功能和導航整合

## [0.2.0] - 2025-09-12

## [0.2.0] - 2025-09-12

### Added
- 🎯 **完成的功能** - 時間軸視圖組件開發與真正的地圖功能整合 (Completed timeline view component development and real map functionality integration)
- 🗓️ **時間軸視圖組件** - TimelineWidget、DayTimelineCard、TimelineActivityCard (Timeline view components: TimelineWidget, DayTimelineCard, TimelineActivityCard)
- 🗺️ **真正的地圖視圖** - 整合 TripMapWidget 到行程詳情頁面，顯示完整的 MapBox 地圖 (Real map view: Integrated TripMapWidget into trip detail page, displaying full MapBox map)
- 📍 **景點標記和路線規劃** - 包含景點標記和路線規劃，支援點擊景點查看詳情 (Attraction markers and route planning, support clicking attractions for details)
- 🔄 **視圖切換功能** - 時間軸和地圖視圖之間的無縫切換，正確的按鈕狀態和文字顯示 (View switching: Seamless switching between timeline and map views, correct button states and text)

### Enhanced
- 🎨 **用戶界面優化** - 美觀的時間軸設計，包含日期圓點和連接線 (UI optimization: Beautiful timeline design with date dots and connecting lines)
- 📅 **每日行程卡片** - 顯示日期、主題和統計資訊 (Daily itinerary cards: Display date, theme, and statistics)
- 🏷️ **活動卡片** - 顯示時間、類別、描述和小貼士，不同活動類別有不同的顏色主題 (Activity cards: Display time, category, description, and tips, different color themes for categories)
- 🗺️ **地圖互動功能** - 支援地圖縮放、拖拽等互動功能 (Map interaction: Support zoom, drag, and other interactive features)
- 🔄 **視圖切換體驗** - 在時間軸和地圖之間自由切換，按鈕狀態正確反映當前視圖 (View switching experience: Free switching between timeline and map, button states correctly reflect current view)

### Fixed
- 🐛 **地圖視圖問題** - 地圖視圖不再顯示"規劃中"，而是顯示真正的 MapBox 地圖 (Map view issue: Map view no longer shows "Planning", but displays real MapBox map)

### Technical
- 🏗️ **無編譯錯誤和警告** - 所有代碼都通過了 Flutter 分析 (Zero compilation errors and warnings: All code passed Flutter analysis)
- 🧪 **完整測試覆蓋** - 包含單元測試確保功能正常 (Complete test coverage: Includes unit tests to ensure functionality)
- 📱 **響應式設計** - 適配不同螢幕尺寸 (Responsive design: Adapts to different screen sizes)
- 🎨 **美觀的 UI** - 遵循 Material Design 3 設計規範 (Beautiful UI: Follows Material Design 3 guidelines)
- 🗺️ **真正的地圖整合** - 使用 MapBox Maps Flutter SDK (Real map integration: Uses MapBox Maps Flutter SDK)
- 🔄 **互動功能** - 支援點擊查看詳情、地圖操作等 (Interactive features: Support clicking for details, map operations, etc.)

### 中文
- 🎯 **完成的功能** - 時間軸視圖組件開發與真正的地圖功能整合
- 🗓️ **時間軸視圖組件** - TimelineWidget、DayTimelineCard、TimelineActivityCard
- 🗺️ **真正的地圖視圖** - 整合 TripMapWidget 到行程詳情頁面，顯示完整的 MapBox 地圖
- 📍 **景點標記和路線規劃** - 包含景點標記和路線規劃，支援點擊景點查看詳情
- 🔄 **視圖切換功能** - 時間軸和地圖視圖之間的無縫切換，正確的按鈕狀態和文字顯示

### 技術改進
- 🎨 **用戶界面優化** - 美觀的時間軸設計，包含日期圓點和連接線
- 📅 **每日行程卡片** - 顯示日期、主題和統計資訊
- 🏷️ **活動卡片** - 顯示時間、類別、描述和小貼士，不同活動類別有不同的顏色主題
- 🗺️ **地圖互動功能** - 支援地圖縮放、拖拽等互動功能
- 🔄 **視圖切換體驗** - 在時間軸和地圖之間自由切換，按鈕狀態正確反映當前視圖

### 檔案變更
- 新增: `lib/tripmuse/widgets/timeline_widget.dart` - 主要時間軸組件
- 新增: `lib/tripmuse/widgets/day_timeline_card.dart` - 每日行程卡片
- 新增: `lib/tripmuse/widgets/timeline_activity_card.dart` - 活動詳情卡片
- 修改: `lib/tripmuse/screens/trip_detail_screen.dart` - 整合 TripMapWidget 和視圖切換功能
- 修改: `pubspec.yaml` - 版本號更新為 0.2.0

## [0.1.9] - 2025-09-12

## [0.1.9] - 2025-09-12

### Added
- 🗓️ **日期篩選面板優化** - 調整日期篩選面板位置，不再遮擋地圖內容 (Optimized date filter panel position to avoid blocking map content)
- 🎯 **智能地圖視角切換** - 選擇日期時自動飛行到該天第一個景點 (Smart map view switching - automatically fly to the first attraction of selected day)
- ✈️ **3D 飛行動畫** - 實現平滑的 3D 地圖飛行動畫，包含縮放和俯仰角調整 (Implemented smooth 3D map flight animation with zoom and pitch adjustments)
- 📍 **座標驗證機制** - 添加智能座標驗證，確保飛行動畫的穩定性 (Added smart coordinate validation to ensure flight animation stability)
- 🔄 **狀態同步優化** - 優化地圖狀態與UI狀態的同步機制 (Optimized synchronization between map state and UI state)

### Enhanced
- 🎨 **用戶界面優化** - 日期篩選面板緊貼頂部控制欄，視覺效果更協調 (Enhanced UI - date filter panel aligned with top control bar for better visual harmony)
- ⚡ **動畫效果提升** - 3秒平滑飛行動畫，16倍縮放，45度俯視角 (Enhanced animation effects - 3-second smooth flight, 16x zoom, 45-degree pitch)
- 🎯 **交互體驗改善** - 選擇日期後立即獲得視覺反饋和地圖定位 (Improved interaction experience - immediate visual feedback and map positioning after date selection)
- 📱 **響應式設計** - 面板位置適應不同螢幕尺寸，不影響地圖瀏覽 (Responsive design - panel position adapts to different screen sizes without affecting map browsing)

### Fixed
- 🐛 **面板遮擋問題** - 修復日期篩選面板遮擋地圖內容的問題 (Fixed date filter panel blocking map content issue)
- 🔧 **動畫觸發機制** - 修復地圖視角切換的觸發時機和狀態管理 (Fixed map view switching trigger timing and state management)
- 📍 **座標處理錯誤** - 修復無效座標導致的動畫失敗問題 (Fixed animation failures caused by invalid coordinates)

### Technical
- 🏗️ **地圖組件優化** - 增強地圖組件的狀態監聽和動畫響應能力 (Enhanced map component state listening and animation response capabilities)
- 🔄 **Provider 狀態管理** - 優化 Riverpod Provider 的狀態更新和通知機制 (Optimized Riverpod Provider state updates and notification mechanisms)
- 🧪 **測試覆蓋** - 確保所有新功能都有完整的測試覆蓋 (Ensured complete test coverage for all new features)
- ✅ **代碼品質** - 零編譯錯誤零警告，所有測試通過 (Zero compilation errors and warnings, all tests passing)

### 中文
- 🗓️ **日期篩選面板優化** - 調整日期篩選面板位置，不再遮擋地圖內容
- 🎯 **智能地圖視角切換** - 選擇日期時自動飛行到該天第一個景點
- ✈️ **3D 飛行動畫** - 實現平滑的 3D 地圖飛行動畫，包含縮放和俯仰角調整
- 📍 **座標驗證機制** - 添加智能座標驗證，確保飛行動畫的穩定性
- 🔄 **狀態同步優化** - 優化地圖狀態與UI狀態的同步機制

### 技術改進
- 🎨 **用戶界面優化** - 日期篩選面板緊貼頂部控制欄，視覺效果更協調
- ⚡ **動畫效果提升** - 3秒平滑飛行動畫，16倍縮放，45度俯視角
- 🎯 **交互體驗改善** - 選擇日期後立即獲得視覺反饋和地圖定位
- 📱 **響應式設計** - 面板位置適應不同螢幕尺寸，不影響地圖瀏覽

### 檔案變更
- 修改: `lib/tripmuse/screens/map_screen.dart` - 優化日期篩選面板位置和添加自動飛行功能
- 修改: `lib/tripmuse/widgets/trip_map_widget.dart` - 增強地圖組件的狀態監聽和飛行動畫
- 修改: `pubspec.yaml` - 版本號更新為 0.1.9
- 新增: `日期篩選優化完成報告.md` - 功能開發完成報告

## [0.1.8] - 2025-09-11

### Fixed
- 🐛 **JSON 解析錯誤修復** - 修復 Client 端解析 Server 回應時的格式不匹配問題 (Fixed JSON parsing errors when Client parses Server responses due to format mismatches)
- 🔧 **budgetRange 欄位缺失** - 添加缺失的 budgetRange 欄位到 UserPreferenceAnalysis 模型 (Added missing budgetRange field to UserPreferenceAnalysis model)
- 📊 **活動類別統一** - 統一活動類別映射，確保所有類別都符合 Client 端支持的值 (Unified activity category mapping to ensure all categories match Client-side supported values)
- 🔄 **Server 回應格式** - 修復 Server 端回應格式，添加 analysis 欄位 (Fixed Server response format by adding analysis field)

### Enhanced
- ⚡ **靈活的 budgetRange 解析** - 實現靈活的 budgetRange 值解析，支持多種變體寫法 (Implemented flexible budgetRange parsing supporting multiple variant formats)
- 🎯 **活動類別映射擴展** - 擴展活動類別映射，支持更多 LLM 生成的類別變體 (Extended activity category mapping to support more LLM-generated category variants)
- 📝 **JSON 格式兼容性** - 大幅提升 Client-Server JSON 格式的兼容性 (Significantly improved Client-Server JSON format compatibility)

### Added
- ✅ **budgetRange 靈活解析** - 添加對 "cheap", "expensive", "luxury" 等 budgetRange 變體的支持 (Added support for budgetRange variants like "cheap", "expensive", "luxury")
- 🔧 **活動類別自動映射** - 實現活動類別的自動映射和標準化 (Implemented automatic activity category mapping and normalization)
- 📋 **API 範例文件** - 創建完整的 Client-Server API 請求範例文件 (Created comprehensive Client-Server API request example files)
- 🧪 **JSON 解析測試** - 添加靈活 budgetRange 解析的單元測試 (Added unit tests for flexible budgetRange parsing)

### Technical
- 🏗️ **UserPreferenceAnalysis 模型** - 優化 UserPreferenceAnalysis 的 fromJson 方法 (Optimized UserPreferenceAnalysis fromJson method)
- 🔧 **Server 端清理函數** - 更新 cleanActivityCategory 函數以支持更多映射 (Updated cleanActivityCategory function to support more mappings)
- 📦 **範例文件結構** - 重新組織 gcp-backend/examples 目錄結構 (Reorganized gcp-backend/examples directory structure)
- 🧪 **測試覆蓋率** - 增加 JSON 解析相關的測試覆蓋率 (Increased test coverage for JSON parsing related functionality)

### 中文
- 🐛 **JSON 解析錯誤修復** - 修復 Client 端解析 Server 回應時的格式不匹配問題
- 🔧 **budgetRange 欄位缺失** - 添加缺失的 budgetRange 欄位到 UserPreferenceAnalysis 模型
- 📊 **活動類別統一** - 統一活動類別映射，確保所有類別都符合 Client 端支持的值
- 🔄 **Server 回應格式** - 修復 Server 端回應格式，添加 analysis 欄位

### 技術改進
- ⚡ **靈活的 budgetRange 解析** - 實現靈活的 budgetRange 值解析，支持多種變體寫法
- 🎯 **活動類別映射擴展** - 擴展活動類別映射，支持更多 LLM 生成的類別變體
- 📝 **JSON 格式兼容性** - 大幅提升 Client-Server JSON 格式的兼容性

### 檔案變更
- 修改: `lib/tripmuse/models/user_preference_analysis.dart` - 添加靈活的 budgetRange 解析邏輯
- 修改: `gcp-backend/server.js` - 添加 budgetRange 欄位和活動類別映射
- 修改: `gcp-backend/examples/generate-trip-examples.json` - 更新範例格式
- 修改: `gcp-backend/examples/client-request-examples.json` - 新增完整 API 範例
- 修改: `pubspec.yaml` - 版本號更新為 0.1.8
- 新增: `gcp-backend/examples/README.md` - API 範例使用說明
- 修改: `test/tripmuse/models/models_test.dart` - 添加 budgetRange 解析測試

## [0.1.7] - 2025-01-11

### Fixed
- 🐛 **儲存系統初始化問題** - 修復 StorageManager 初始化時序問題 (Fixed StorageManager initialization timing issues)
- 🔧 **行程儲存錯誤** - 解決行程生成後無法儲存的問題 (Resolved trip saving failures after generation)
- 🗄️ **Provider 作用域問題** - 修復不同 ProviderScope 間的實例共享問題 (Fixed instance sharing between different ProviderScopes)
- 📱 **應用啟動初始化** - 在應用啟動時就初始化儲存系統 (Initialize storage system at app startup)
- 🔄 **Widget 生命週期** - 修復 Widget 銷毀後使用 ref 的錯誤 (Fixed using ref after widget disposal)

### Enhanced
- ⚡ **儲存系統穩定性** - 大幅提升儲存系統的穩定性和可靠性 (Significantly improved storage system stability and reliability)
- 🎯 **錯誤處理改善** - 增強儲存相關的錯誤處理和使用者回饋 (Enhanced storage-related error handling and user feedback)
- 📊 **初始化日誌** - 添加詳細的初始化過程日誌記錄 (Added detailed initialization process logging)
- 🔍 **除錯資訊** - 提供更清晰的除錯資訊和狀態追蹤 (Provided clearer debugging information and status tracking)

### Added
- ✅ **收藏功能實作** - 完成行程收藏功能的本地儲存實作 (Completed local storage implementation for trip favorites feature)
- 💾 **自動儲存檢查** - 在儲存前自動檢查並初始化 StorageManager (Automatic StorageManager initialization check before saving)
- 🔄 **容錯機制** - 添加儲存失敗時的容錯和重試機制 (Added fault tolerance and retry mechanism for storage failures)

### Technical
- 🏗️ **架構優化** - 重構儲存系統初始化架構 (Refactored storage system initialization architecture)
- 📦 **依賴管理** - 優化 Riverpod Provider 的依賴管理 (Optimized Riverpod Provider dependency management)
- 🧪 **測試改善** - 更新相關測試以反映架構變更 (Updated related tests to reflect architecture changes)
- 🔧 **程式碼清理** - 移除未使用的程式碼和改善程式碼品質 (Removed unused code and improved code quality)

### 中文
- 🐛 **儲存系統初始化問題** - 修復 StorageManager 初始化時序問題
- 🔧 **行程儲存錯誤** - 解決行程生成後無法儲存的問題
- 🗄️ **Provider 作用域問題** - 修復不同 ProviderScope 間的實例共享問題
- 📱 **應用啟動初始化** - 在應用啟動時就初始化儲存系統
- 🔄 **Widget 生命週期** - 修復 Widget 銷毀後使用 ref 的錯誤

### 技術改進
- ⚡ **儲存系統穩定性** - 大幅提升儲存系統的穩定性和可靠性
- 🎯 **錯誤處理改善** - 增強儲存相關的錯誤處理和使用者回饋
- 📊 **初始化日誌** - 添加詳細的初始化過程日誌記錄
- 🔍 **除錯資訊** - 提供更清晰的除錯資訊和狀態追蹤

### 檔案變更
- 修改: `lib/main.dart` - 在應用啟動時初始化 StorageManager
- 修改: `lib/tripmuse/tripmuse_app.dart` - 簡化儲存系統檢查邏輯
- 修改: `lib/tripmuse/screens/create_trip_screen.dart` - 修復 ProviderScope 問題和儲存邏輯
- 修改: `lib/tripmuse/providers/trip_provider.dart` - 完成收藏功能的本地儲存實作
- 修改: `lib/tripmuse/widgets/simple_progress_dialog.dart` - 改善 JSON 解析錯誤處理
- 修改: `lib/tripmuse/models/activity.dart` - 修復可選欄位的處理

## [0.1.6] - 2025-09-10

### Added
- 🗺️ **Google Places API 整合** - 實作完整的 Google Places API 資料補強功能 (Implemented complete Google Places API data enhancement)
- 📍 **地點詳細資訊獲取** - 自動獲取地點的照片、評分、地址等詳細資訊 (Automatic retrieval of place photos, ratings, addresses)
- 🧭 **地理座標補齊** - 實作地理座標驗證和自動補齊機制 (Implemented geographic coordinate validation and auto-completion)
- 🖼️ **地點照片整合** - 整合地點照片參考和顯示功能 (Integrated place photo references and display)

### Fixed
- 🐛 **語法錯誤修復** - 修復 server.js 中的註釋語法錯誤 (Fixed comment syntax error in server.js)
- 🔧 **API Key 管理** - 統一 Google Places API Key 的獲取方式 (Unified Google Places API key retrieval method)
- 🛠️ **部署配置** - 更新 Cloud Run 部署配置以包含 Places API (Updated Cloud Run deployment configuration for Places API)

### Enhanced
- 📊 **資料豐富度** - 大幅提升行程資料的詳細程度和準確性 (Significantly improved trip data richness and accuracy)
- 🎯 **使用者體驗** - 提供更詳細的地點資訊和視覺內容 (Enhanced user experience with detailed place information and visuals)
- ⚡ **API 效能** - 優化 Places API 調用和快取機制 (Optimized Places API calls and caching mechanisms)

### Technical
- 🔗 **Places API 客戶端** - 實作專用的 Places API 服務客戶端 (Implemented dedicated Places API service client)
- 📏 **API 限制處理** - 實作 API 速率限制和錯誤處理機制 (Implemented API rate limiting and error handling)
- 🧪 **整合測試** - 添加 Places API 整合的測試覆蓋 (Added test coverage for Places API integration)

### 中文
- 🗺️ **Google Places API 整合** - 實作完整的 Google Places API 資料補強功能
- 📍 **地點詳細資訊獲取** - 自動獲取地點的照片、評分、地址等詳細資訊
- 🧭 **地理座標補齊** - 實作地理座標驗證和自動補齊機制
- 🖼️ **地點照片整合** - 整合地點照片參考和顯示功能

### 技術改進
- 🔧 **語法錯誤修復** - 修復 server.js 中的註釋語法錯誤
- 🔧 **API Key 管理** - 統一 Google Places API Key 的獲取方式
- 🛠️ **部署配置** - 更新 Cloud Run 部署配置以包含 Places API

### 檔案變更
- 修改: `gcp-backend/server.js` - 修復語法錯誤並優化 Places API 整合
- 修改: `gcp-backend/.env` - 添加 GOOGLE_PLACES_API_KEY 配置
- 修改: `gcp-backend/deploy.ps1` - 更新部署腳本包含 Places API secret
- 新增: `lib/tripmuse/services/places_service.dart` - Places API 服務
- 新增: `lib/tripmuse/utils/` - 工具函數目錄
- 新增: `test/places_api_test.dart` - Places API 測試
- 新增: `test/coordinate_validator_test.dart` - 座標驗證測試

## [0.1.5] - 2025-09-10

### Fixed
- 🐛 **JSON 解析錯誤修復** - 修復 Flutter 端 JSON 解析錯誤 (Fixed Flutter JSON parsing error)
- 🐛 **Destination 模型修復** - 修復 Destination 模型中 lat/lng 欄位問題 (Fixed Destination model lat/lng field issues)
- 🐛 **Freezed 序列化修復** - 修復 Trip 和 DayPlan 模型的序列化問題 (Fixed Trip and DayPlan model serialization issues)
- 🐛 **API 回應處理** - 改善 API 回應的錯誤處理和資料驗證 (Improved API response error handling and data validation)

### Enhanced
- 🔧 **模型資料驗證** - 增強資料模型的類型安全和預設值處理 (Enhanced data model type safety and default value handling)
- 📊 **序列化效能** - 優化 JSON 序列化和反序列化效能 (Optimized JSON serialization and deserialization performance)
- 🛡️ **錯誤處理** - 改善應用程式的錯誤處理和使用者回饋 (Improved application error handling and user feedback)

### Technical
- 📁 **模型檔案更新** - 更新所有 Freezed 生成的模型檔案 (Updated all Freezed generated model files)
- 🔄 **序列化邏輯** - 修復嵌套物件的 JSON 序列化邏輯 (Fixed nested object JSON serialization logic)
- 🧪 **測試通過** - 確保所有資料模型測試通過 (Ensured all data model tests pass)

### 中文
- 🐛 **JSON 解析錯誤修復** - 修復 Flutter 端 JSON 解析錯誤
- 🐛 **Destination 模型修復** - 修復 Destination 模型中 lat/lng 欄位問題
- 🐛 **Freezed 序列化修復** - 修復 Trip 和 DayPlan 模型的序列化問題
- 🐛 **API 回應處理** - 改善 API 回應的錯誤處理和資料驗證

### 技術改進
- 🔧 **模型資料驗證** - 增強資料模型的類型安全和預設值處理
- 📊 **序列化效能** - 優化 JSON 序列化和反序列化效能
- 🛡️ **錯誤處理** - 改善應用程式的錯誤處理和使用者回饋

### 檔案變更
- 修改: `lib/tripmuse/models/destination.dart` - 修復 lat/lng 欄位
- 修改: `lib/tripmuse/models/trip.dart` - 添加 JSON 序列化配置
- 修改: `lib/tripmuse/models/day_plan.dart` - 添加 JSON 序列化配置
- 修改: `lib/tripmuse/models/activity.dart` - 優化模型定義
- 修改: `lib/tripmuse/models/trip.g.dart` - 修復序列化邏輯
- 修改: `lib/tripmuse/models/day_plan.g.dart` - 修復序列化邏輯
- 修改: `lib/tripmuse/models/destination.g.dart` - 更新生成代碼
- 修改: `gcp-backend/server.js` - 改善後端錯誤處理
- 新增: `lib/tripmuse/services/trip_generation_service.dart` - 行程生成服務
- 新增: `lib/tripmuse/screens/trip_generation_test_screen.dart` - 測試畫面
- 新增: `gcp-backend/deploy.ps1` - 部署腳本

## [0.1.4] - 2025-01-09

### Added
- 🧪 **API 測試功能** - 新增完整的 API 測試畫面 (Added comprehensive API testing screen)
- 🔍 **API 健康檢查** - 實時檢查 API 服務狀態 (Real-time API health monitoring)
- 🎯 **行程生成測試** - 測試行程生成功能 (Trip generation testing functionality)
- 🗺️ **地點搜尋測試** - 測試地點搜尋 API (Place search testing functionality)
- ⚙️ **地圖配置測試** - 測試地圖配置 API (Map configuration testing functionality)
- 📱 **測試 UI 介面** - 直觀的測試介面和即時回饋 (Intuitive testing UI with real-time feedback)
- 🔄 **即時狀態更新** - 測試過程中顯示進度指示器 (Real-time status updates with progress indicators)

### Enhanced
- 🏗️ **服務架構優化** - 重構服務層以支援測試功能 (Refactored service layer to support testing features)
- 📊 **錯誤處理改善** - 增強測試場景的錯誤處理 (Enhanced error handling for testing scenarios)
- 🎨 **UI/UX 改善** - 優化測試介面的使用者體驗 (Improved UI/UX for testing interface)

### Technical
- 📁 **新檔案結構** - 新增測試相關的服務和模型檔案 (New file structure for testing-related services and models)
- 🔧 **API 配置服務** - 新增 API 配置管理服務 (Added API configuration management service)
- 📋 **測試資料模型** - 新增測試專用的資料模型 (Added test-specific data models)

### 中文
- 🧪 **API 測試功能** - 新增完整的 API 測試畫面
- 🔍 **API 健康檢查** - 實時檢查 API 服務狀態
- 🎯 **行程生成測試** - 測試行程生成功能
- 🗺️ **地點搜尋測試** - 測試地點搜尋 API
- ⚙️ **地圖配置測試** - 測試地圖配置 API
- 📱 **測試 UI 介面** - 直觀的測試介面和即時回饋
- 🔄 **即時狀態更新** - 測試過程中顯示進度指示器

### 技術改進
- 🏗️ **服務架構優化** - 重構服務層以支援測試功能
- 📊 **錯誤處理改善** - 增強測試場景的錯誤處理
- 🎨 **UI/UX 改善** - 優化測試介面的使用者體驗

### Fixed
- 🐛 Fixed unused imports in api_client_test.dart (Removed unused flutter/services.dart and mockito imports)
- 🐛 Fixed unused local variables in api_client_test.dart (Removed unused apiClient and mockDio variables)
- 🐛 Fixed unreachable switch default in api_client_test.dart (Removed unreachable default clause)
- 🐛 Fixed unused field in tripmuse_app.dart (Removed _isStorageInitialized field)
- 🐛 Fixed linting issues in trip_provider.dart (Resolved all code analysis warnings)

### Technical
- 🧹 Code cleanup and linting fixes across multiple files
- 📝 Improved code quality and maintainability
- ✅ All flutter analyze checks passing

### 中文
- 🐛 修復 api_client_test.dart 中的未使用匯入 (移除未使用的 flutter/services.dart 和 mockito 匯入)
- 🐛 修復 api_client_test.dart 中的未使用區域變數 (移除未使用的 apiClient 和 mockDio 變數)
- 🐛 修復 api_client_test.dart 中的不可達 switch 預設值 (移除不可達的 default 子句)
- 🐛 修復 tripmuse_app.dart 中的未使用欄位 (移除 _isStorageInitialized 欄位)
- 🐛 修復 trip_provider.dart 中的程式碼品質問題 (解決所有程式碼分析警告)

### 技術改進
- 🧹 程式碼清理和多個檔案的 linting 修復
- 📝 提升程式碼品質和可維護性
- ✅ 所有 flutter analyze 檢查通過

## [0.1.3] - 2025-01-09

### Added
- 完整的 API 客戶端和網路層架構 (Complete API Client and Network Layer Architecture)
- 使用 Dio 實作 HTTP 請求處理 (HTTP request handling using Dio)
- 智能重試機制和網路狀態檢測 (Smart retry mechanism and network status detection)
- 標準化 API 請求/回應格式 (Standardized API request/response format)
- 認證攔截器自動處理 Bearer Token (Authentication interceptor for automatic Bearer Token handling)
- 錯誤攔截器和請求日誌記錄 (Error interceptor and request logging)
- 網路連線狀態監控服務 (Network connectivity monitoring service)
- 行程 API 服務實作 (Trip API service implementation)
- API Provider 整合 Riverpod 狀態管理 (API Provider integration with Riverpod state management)

### Enhanced
- 完善的錯誤處理和異常分類 (Comprehensive error handling and exception classification)
- 自動網路重連和指數退避策略 (Automatic network reconnection with exponential backoff)
- 安全的認證 Token 儲存機制 (Secure authentication token storage)
- 完整的測試覆蓋 (Complete test coverage)

### Technical
- ApiClient: 統一的 HTTP 客戶端 (Unified HTTP client)
- NetworkService: 網路狀態管理 (Network status management)
- RetryInterceptor: 智能重試邏輯 (Smart retry logic)
- ApiResponse<T>: 泛型回應包裝 (Generic response wrapper)
- 19 個單元測試全部通過 (19 unit tests all passing)

## [0.1.1] - 2025-01-09

### Added
- 📋 Complete trip list screen (TripListScreen) functionality
- 🎴 Trip card component (TripCard) displaying trip preview information
- 🔍 Trip search and filtering features (supports title and destination search)
- 📊 Trip status management (upcoming, ongoing, completed)
- ➕ FAB (Floating Action Button) for creating new trips
- 🏠 Integrated home screen navigation to trip list
- 🔄 Complete trip CRUD operations with Riverpod providers
- 📱 Pull-to-refresh and comprehensive error handling

### Enhanced
- 🔧 Optimized trip data models and state management
- ✨ Improved user experience and interface interactions
- 🧪 Enhanced test coverage with all tests passing
- 🐛 Fixed model definitions and compilation issues

### Technical
- 🏗️ Built comprehensive TripProvider with Riverpod state management
- 🔍 Implemented trip filtering and search logic
- 📈 Optimized trip statistics and status calculations
- 🔧 Fixed Destination, Activity, DayPlan model issues

---

## [0.1.1] - 2025-01-09

### 新增功能
- 📋 完成行程列表頁面 (TripListScreen) 功能
- 🎴 實作行程卡片組件 (TripCard) 顯示行程預覽資訊
- 🔍 建立行程搜尋和篩選功能（支援標題、目的地搜尋）
- 📊 實作行程狀態管理（即將開始、進行中、已完成）
- ➕ 添加 FAB 建立新行程按鈕
- 🏠 整合首頁導航到行程列表功能
- 🔄 建立完整的行程 CRUD 操作 Provider
- 📱 實作下拉刷新和完善的錯誤處理機制

### 優化改進
- 🔧 優化行程資料模型和狀態管理
- ✨ 改善用戶體驗和界面互動
- 🧪 完善測試覆蓋，所有測試通過
- 🐛 修復模型定義和編譯問題

### 技術改進
- 🏗️ 建立 TripProvider 完整的 Riverpod 狀態管理
- 🔍 實作行程篩選和搜尋邏輯
- 📈 優化行程統計和狀態計算
- 🔧 修復 Destination, Activity, DayPlan 等模型問題

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