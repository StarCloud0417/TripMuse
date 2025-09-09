# Implementation Plan

## 基於 MapBox 範例的專案重構

- [ ] 1. 重構現有 MapBox 專案為 TripMuse 應用
  - 將 mapbox_maps_example 重新命名為 TripMuse
  - 更新 pubspec.yaml 的應用名稱、描述和版本
  - 清理不需要的範例文件，保留有用的工具函數
  - 建立新的應用圖示和啟動畫面
  - _Requirements: 10.1_

- [ ] 1.1 整合狀態管理和核心依賴
  - 在 pubspec.yaml 中添加核心依賴：
    * 狀態管理：flutter_riverpod
    * 網路請求：dio
    * 本地儲存：hive, hive_flutter, flutter_secure_storage
    * 資料模型：freezed, json_annotation
    * Firebase：firebase_core, firebase_auth, google_sign_in, cloud_firestore
    * PDF 生成：pdf, printing
  - 建立 lib/core/ 目錄結構（models, services, providers, utils）
  - 設定 Riverpod 作為狀態管理解決方案
  - 建立全域錯誤處理和日誌系統
  - _Requirements: 10.1, 9.5_

- [ ] 1.2 建立核心資料模型
  - 在 lib/core/models/ 建立 Trip, DayPlan, Activity 等資料模型
  - 使用 Freezed 和 json_annotation 實作序列化
  - 建立 UserPreferenceAnalysis 和相關 enum 類型
  - 撰寫資料模型的單元測試
  - _Requirements: 2.2, 2.3_

- [ ] 1.3 設定本地儲存系統
  - 配置 Hive 作為本地資料庫，建立 TypeAdapter
  - 設定 Flutter Secure Storage 用於敏感資料
  - 實作 Repository 模式的資料存取層
  - 建立離線資料同步機制
  - _Requirements: 8.1, 8.3, 10.2_

## 主應用架構和導航

- [ ] 2. 建立主應用架構和導航系統
  - 重構 main.dart，移除範例列表，建立 TripMuse 主應用
  - 建立底部導航欄（地圖、行程列表、設定）
  - 實作頁面路由和狀態管理
  - 建立應用主題和樣式系統
  - _Requirements: 7.4_

- [ ] 2.1 建立簡化的使用者系統（MVP 版本）
  - 實作 Guest 模式的本地使用者管理
  - 建立簡單的使用者偏好設定頁面
  - 實作本地資料的使用者隔離（如果需要）
  - 為 Firebase Authentication 預留介面和資料結構
  - _Requirements: 7.1, 7.2_

- [ ] 2.2 建立行程列表頁面
  - 設計並實作行程列表主頁面
  - 建立行程卡片組件顯示預覽資訊
  - 實作 FAB 建立新行程按鈕
  - 建立行程搜尋和篩選功能
  - _Requirements: 7.4_

## 行程建立與輸入系統

- [ ] 3. 建立行程建立介面
  - 設計並實作建立行程頁面 UI
  - 整合 Google Places API 實作目的地自動補全
  - 建立日期選擇器和天數設定功能
  - 實作旅行描述輸入框和範例提示
  - _Requirements: 1.1, 1.2, 1.3, 1.4_

- [ ] 3.1 實作旅行偏好設定
  - 建立預算範圍滑桿和旅伴數量選擇
  - 實作表單驗證和錯誤處理
  - 建立 TripRequest 資料模型和序列化
  - 加入「智能生成行程」按鈕和狀態管理
  - _Requirements: 1.5, 1.6_

- [ ] 3.2 建立 API 客戶端和網路層
  - 實作 ApiClient 使用 Dio 處理 HTTP 請求
  - 設定請求攔截器處理認證和錯誤
  - 實作重試機制和網路狀態檢測
  - 建立標準化的 API 請求/回應格式
  - _Requirements: 2.1, 9.1, 9.4, 10.3_

## AI 行程生成系統

- [ ] 4. 實作行程生成服務
  - 建立 TripGenerationService 處理 AI 行程生成
  - 實作兩階段 LLM 請求（偏好分析 + 行程生成）
  - 建立請求快取機制避免重複呼叫
  - 實作 JSON Schema 驗證和錯誤處理
  - _Requirements: 2.2, 2.3, 2.4, 2.6, 10.4_

- [ ] 4.1 整合 Google Places API 資料補強
  - 實作 Places API 客戶端取得地點詳細資訊
  - 建立地理座標驗證和補齊機制
  - 實作地點照片和評分資料獲取
  - 處理 API 限制和錯誤回應
  - _Requirements: 2.5, 4.4_

- [ ] 4.2 建立行程生成 UI 和狀態管理
  - 實作生成進度指示器和載入動畫
  - 建立取消生成功能和超時處理
  - 實作生成結果的狀態管理和快取
  - 加入生成失敗的重試機制和錯誤提示
  - _Requirements: 9.2, 9.3_

## 基於現有範例的地圖功能開發

- [ ] 5. 建立 TripMuse 專用地圖組件
  - 基於 simple_map_example.dart 建立 TripMapWidget
  - 參考 point_annotations_example.dart 實作景點標記功能
  - 利用現有的 utils.dart 工具函數
  - 建立地圖狀態管理和控制器
  - _Requirements: 3.2_

- [ ] 5.1 實作行程可視化功能
  - 基於 PointAnnotationManager 建立美化的景點標記
  - 參考 polyline_annotations_example.dart 實作路線顯示
  - 為每日行程使用不同顏色主題
  - 實作標記點擊事件和資訊彈窗
  - _Requirements: 3.2, 3.3, 3.5_

- [ ] 5.2 整合位置服務和導航
  - 利用現有的 location_example.dart 實作位置追蹤
  - 建立旅程進度指示器
  - 實作當前景點高亮顯示
  - 加入外部導航應用連結
  - _Requirements: 3.4, 3.9, 4.5_

- [ ] 5.3 實作地圖互動和動畫
  - 參考 animation_example.dart 實作平滑切換動畫
  - 建立日期篩選控制項
  - 實作地圖視角自動調整
  - 加入標記和路線的動畫效果
  - _Requirements: 3.7, 3.8_

## 時間軸視圖系統

- [ ] 6. 建立時間軸視圖組件
  - 設計並實作 TimelineWidget 主要組件
  - 建立 DayTimelineCard 顯示每日行程
  - 實作 ActivityCard 顯示個別活動資訊
  - 建立地圖和時間軸視圖的切換功能
  - _Requirements: 3.1, 3.6_

- [ ] 6.1 實作活動拖拉和編輯功能
  - 建立 DraggableActivityCard 支援拖拉操作
  - 實作活動時間段變更和驗證邏輯
  - 建立長按選單（刪除、移動、替換）
  - 實作活動編輯後的地圖同步更新
  - _Requirements: 5.1, 5.2, 5.3, 5.4_

- [ ] 6.2 建立活動詳情展示
  - 實作 BottomSheet 顯示地點詳細資訊
  - 顯示 LLM 生成描述、類型、停留時間
  - 整合交通建議和距離資訊顯示
  - 實作地點照片展示和外部連結
  - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_

## 行程編輯和本地儲存

- [ ] 7. 實作行程編輯功能
  - 建立行程自動儲存機制
  - 實作活動刪除和地圖更新邏輯
  - 建立跨日期活動移動功能
  - 實作路線重新計算和最佳化
  - _Requirements: 5.5_

- [ ] 7.1 建立離線編輯和同步機制
  - 實作離線編輯佇列管理
  - 建立網路恢復時的自動同步
  - 實作同步衝突檢測和解決策略
  - 建立編輯歷史和復原功能
  - _Requirements: 8.3, 8.4, 8.5_

## PDF 匯出和分享系統

- [ ] 8. 實作 PDF 生成功能
  - 配置 pdf 和 printing 套件
  - 建立 PDF 模板和樣式設計
  - 實作封面頁、概覽頁、每日詳情頁生成
  - 建立地圖截圖和圖片處理功能
  - _Requirements: 6.2, 6.3_

- [ ] 8.1 建立 PDF 匯出 UI 和功能
  - 實作 PDF 匯出選項和預覽功能
  - 建立多語言支援（繁體/簡體/英文）
  - 實作 PDF 儲存到裝置和分享功能
  - 加入離線 PDF 生成支援
  - _Requirements: 6.1, 6.4, 6.7, 6.8_

- [ ] 8.2 實作分享連結功能
  - 建立分享連結生成和管理系統
  - 實作唯讀網頁分享頁面
  - 建立分享連結的安全性和過期機制
  - 實作分享統計和管理功能
  - _Requirements: 6.5, 6.6_

## 行程管理和列表功能

- [ ] 9. 建立行程列表和管理
  - 設計並實作主頁面行程列表
  - 建立行程卡片顯示（預覽地圖、天數、時間）
  - 實作 FAB 建立新行程按鈕
  - 建立行程搜尋和篩選功能
  - _Requirements: 7.4_

- [ ] 9.1 實作雲端同步功能
  - 建立行程雲端儲存和同步機制
  - 實作本地優先的資料同步策略
  - 建立同步狀態指示和錯誤處理
  - 實作 Guest 模式和登入模式的資料遷移
  - _Requirements: 7.3, 7.5, 8.1, 8.2_

## 錯誤處理和使用者體驗

- [ ] 10. 建立全域錯誤處理系統
  - 實作 AppException 錯誤分類系統
  - 建立 ErrorHandler 中介軟體
  - 實作友善的錯誤訊息和重試機制
  - 建立錯誤日誌和回報功能
  - _Requirements: 9.1, 9.5_

- [ ] 10.1 實作網路狀態和 API 限制處理
  - 建立網路連線狀態監控
  - 實作 API 限制檢測和等待提示
  - 建立自動重試和指數退避機制
  - 實作連線狀態的 UI 指示器
  - _Requirements: 9.3, 9.4_

## 效能最佳化和測試

- [ ] 11. 實作效能最佳化
  - 利用現有的 MapBox 最佳化實踐
  - 參考 cluster_example.dart 實作標記聚合
  - 建立記憶體管理和快取清理機制
  - 實作圖片快取和壓縮功能
  - _Requirements: 10.1_

- [ ] 11.1 撰寫測試（基於現有測試結構）
  - 參考現有的 integration_test/ 目錄結構
  - 為核心資料模型撰寫單元測試
  - 建立 Service 和 Repository 的測試
  - 實作 Widget 測試覆蓋主要 UI 組件
  - _Requirements: 所有功能需求_

- [ ] 11.2 建立部署流程
  - 利用現有的 Android 和 iOS 配置
  - 更新應用簽名和發布設定
  - 建立版本管理和發布流程
  - 設定應用商店資產和描述
  - _Requirements: 10.1_

## Firebase Authentication 與 Google 登入

- [ ] 12. Firebase 專案設定和配置
  - 在 Firebase Console 建立新專案（TripMuse）
  - 設定 Android 應用並下載 google-services.json
  - 設定 iOS 應用並下載 GoogleService-Info.plist
  - 啟用 Authentication 服務和 Google 登入方式
  - 建立 Firestore 資料庫（測試模式）
  - _Requirements: 7.1, 10.3_

- [ ] 12.1 整合 Firebase SDK
  - 添加 firebase_core、firebase_auth、google_sign_in 依賴
  - 配置 Android build.gradle 檔案
  - 配置 iOS Runner 專案設定
  - 初始化 Firebase 並測試連線
  - _Requirements: 7.1, 7.2, 10.3_

- [ ] 12.2 實作 Google 登入功能
  - 建立 AuthService 處理 Google 登入流程
  - 實作登入狀態管理和持久化
  - 建立登入 UI 和使用者體驗
  - 處理登入錯誤和邊界情況
  - _Requirements: 7.1, 7.2, 7.3_

- [ ] 12.3 建立使用者管理系統
  - 設計並實作登入頁面（Google 登入按鈕）
  - 建立使用者資料同步機制（本地 ↔ Firebase）
  - 實作登出功能和資料清理
  - 加入使用者頭像和基本資訊顯示
  - _Requirements: 7.1, 7.3, 7.5_

- [ ] 12.4 實作雲端資料同步
  - 整合 Firestore 作為雲端資料庫
  - 建立行程資料的雲端同步機制
  - 實作離線優先的資料同步策略
  - 處理同步衝突和錯誤恢復
  - _Requirements: 7.4, 8.2, 8.4_

## 最終整合和發布準備

- [ ] 13. 系統整合和測試
  - 整合所有功能模組並測試完整流程
  - 利用現有的 integration_test 進行端到端測試
  - 進行 Android 和 iOS 平台測試
  - 優化應用效能和使用者體驗
  - _Requirements: 所有功能需求_

- [ ] 13.1 準備 MVP 發布
  - 更新應用圖示、名稱和版本資訊
  - 建立應用商店描述和截圖
  - 利用現有的 Android 和 iOS 配置進行打包
  - 準備使用者文件和支援資源
  - _Requirements: 10.5_

## 開發優勢總結

**基於現有 MapBox 範例的優勢：**
- ✅ MapBox SDK 已完整配置和測試
- ✅ 豐富的地圖功能範例可直接參考
- ✅ Android/iOS 平台配置已完成
- ✅ 現有的工具函數和最佳實踐
- ✅ 完整的測試框架和結構
- ✅ 可快速原型開發和驗證
#
# Firebase 設定詳細步驟

### Android 配置檢查清單
```gradle
// android/build.gradle (專案層級)
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}

// android/app/build.gradle
apply plugin: 'com.google.gms.google-services'

dependencies {
    implementation 'com.google.firebase:firebase-auth'
    implementation 'com.google.android.gms:play-services-auth'
}
```

### iOS 配置檢查清單
- 確保 `GoogleService-Info.plist` 在 Xcode 專案中
- 在 `ios/Runner/Info.plist` 中加入 URL Scheme
- 設定最低 iOS 版本為 10.0+

### 套件名稱一致性檢查
- Android: `android/app/build.gradle` 中的 `applicationId`
- iOS: Xcode 中的 Bundle Identifier
- Firebase 專案中註冊的套件名稱
- 三者必須完全一致

### 測試 Firebase 連線
```dart
// 在 main.dart 中測試
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print('Firebase initialized successfully!');
  runApp(MyApp());
}
```

**建議：** 在開始實作任務 12 之前，先完成 Firebase 專案的建立和基本配置，這樣可以避免後續的配置問題。