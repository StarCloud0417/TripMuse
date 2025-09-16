# Implementation Plan

## 方案 4：最小侵入式開發 - 在現有基礎上新增功能

- [X] 1. 最小化設定 TripMuse 開發環境

  - **完全保留**現有專案結構和所有檔案不動
  - 僅在 pubspec.yaml 中**新增**必要的依賴套件
  - 在 main.dart 的範例列表中**新增** TripMuse 選項
  - 創建 lib/tripmuse/ 目錄存放所有新功能
  - 直接引用現有的 utils.dart 和範例程式碼
  - _Requirements: 10.1_

- [x] 1.1 新增必要依賴套件（不修改現有配置）


  - 在 pubspec.yaml 中**僅新增**以下依賴：
    * 狀態管理：flutter_riverpod
    * 網路請求：dio
    * 本地儲存：hive, hive_flutter, flutter_secure_storage
    * 資料模型：freezed, json_annotation
    * Firebase：firebase_core, firebase_auth, google_sign_in, cloud_firestore
    * PDF 生成：pdf, printing
  - **僅創建** lib/tripmuse/ 目錄結構：
    * lib/tripmuse/models/
    * lib/tripmuse/services/
    * lib/tripmuse/screens/
    * lib/tripmuse/widgets/
  - **不修改**現有任何檔案和目錄
  - _Requirements: 10.1, 9.5_

- [x] 1.2 建立 TripMuse 資料模型
  - 在 lib/tripmuse/models/ 建立 Trip, DayPlan, Activity 等資料模型
  - 使用 Freezed 和 json_annotation 實作序列化
  - 建立 UserPreferenceAnalysis 和相關 enum 類型
  - 撰寫資料模型的單元測試
  - _Requirements: 2.2, 2.3_

- [x] 1.3 設定 TripMuse 儲存系統
  - 在 lib/tripmuse/services/ 配置 Hive 作為本地資料庫，建立 TypeAdapter
  - 設定 Flutter Secure Storage 用於敏感資料
  - 實作 Repository 模式的資料存取層
  - 建立離線資料同步機制
  - _Requirements: 8.1, 8.3, 10.2_

## TripMuse 應用入口

- [x] 2. 建立 TripMuse 應用入口（不修改 main.dart 結構）
  - 在 main.dart 的現有範例列表中**新增一行** TripMuse 選項
  - 創建 lib/tripmuse/tripmuse_app.dart 作為 TripMuse 主頁面
  - 在 TripMuse 內建立底部導航欄（地圖、行程列表、設定）
  - 實作 TripMuse 內部的頁面路由和狀態管理
  - 建立 TripMuse 專用的主題和樣式
  - _Requirements: 7.4_


- [x] 2.1 建立簡化的使用者系統（MVP 版本）
  - 實作 Guest 模式的本地使用者管理
  - 建立簡單的使用者偏好設定頁面
  - 實作本地資料的使用者隔離（如果需要）
  - 為 Firebase Authentication 預留介面和資料結構
  - _Requirements: 7.1, 7.2_


- [x] 2.2 建立行程列表頁面
  - 設計並實作行程列表主頁面
  - 建立行程卡片組件顯示預覽資訊
  - 實作 FAB 建立新行程按鈕
  - 建立行程搜尋和篩選功能
  - _Requirements: 7.4_

## 行程建立與輸入系統

- [X] 3. 建立行程建立介面

  - 設計並實作建立行程頁面 UI
  - 整合 Google Places API 實作目的地自動補全
  - 建立日期選擇器和天數設定功能
  - 實作旅行描述輸入框和範例提示
  - _Requirements: 1.1, 1.2, 1.3, 1.4_

- [x] 3.1 實作旅行偏好設定

  - 建立預算範圍滑桿和旅伴數量選擇
  - 實作表單驗證和錯誤處理
  - 建立 TripRequest 資料模型和序列化
  - 加入「智能生成行程」按鈕和狀態管理
  - _Requirements: 1.5, 1.6_

- [x] 3.2 建立 API 客戶端和網路層

  - 實作 ApiClient 使用 Dio 處理 HTTP 請求
  - 設定請求攔截器處理認證和錯誤
  - 實作重試機制和網路狀態檢測
  - 建立標準化的 API 請求/回應格式
  - _Requirements: 2.1, 9.1, 9.4, 10.3_

## AI 行程生成系統

- [X] 4. 實作行程生成服務

  - 建立 TripGenerationService 處理 AI 行程生成
  - 實作兩階段 LLM 請求（偏好分析 + 行程生成）
  - 建立請求快取機制避免重複呼叫
  - 實作 JSON Schema 驗證和錯誤處理
  - _Requirements: 2.2, 2.3, 2.4, 2.6, 10.4_

- [x] 4.1 整合 Google Places API 資料補強

  - 實作 Places API 客戶端取得地點詳細資訊
  - 建立地理座標驗證和補齊機制
  - 實作地點照片和評分資料獲取
  - 處理 API 限制和錯誤回應
  - _Requirements: 2.5, 4.4_

- [x] 4.2 建立行程生成 UI 和狀態管理

  - 實作生成進度指示器和載入動畫
  - 建立取消生成功能和超時處理
  - 實作生成結果的狀態管理和快取
  - 加入生成失敗的重試機制和錯誤提示
  - _Requirements: 9.2, 9.3_

## 基於現有範例的地圖功能開發

- [X] 5. 建立 TripMuse 地圖組件


  - 創建 lib/tripmuse/widgets/trip_map_widget.dart，**複製並修改** simple_map_example.dart 的程式碼
  - **直接引用** point_annotations_example.dart 的標記功能程式碼
  - **直接使用**現有的 utils.dart 工具函數
  - 建立 TripMuse 專用的地圖狀態管理
  - _Requirements: 3.2_

- [x] 5.1 實作行程可視化功能

  - **複製** PointAnnotationManager 相關程式碼到 trip_map_widget.dart
  - **複製** polyline_annotations_example.dart 的路線顯示程式碼
  - 為每日行程使用不同顏色主題
  - 實作標記點擊事件和資訊彈窗
  - _Requirements: 3.2, 3.3, 3.5_

- [x] 5.2 整合位置服務和導航


  - **複製** location_example.dart 的位置追蹤程式碼
  - 建立旅程進度指示器
  - 實作當前景點高亮顯示
  - 加入外部導航應用連結
  - _Requirements: 3.4, 3.9, 4.5_

- [X] 5.3 實作地圖互動和動畫
  - **複製** animation_example.dart 的動畫程式碼
  - 建立日期篩選控制項
  - 實作地圖視角自動調整
  - 加入標記和路線的動畫效果
  - _Requirements: 3.7, 3.8_

## 時間軸視圖系統

- [X] 6. 建立時間軸視圖組件
  - 在 lib/tripmuse/widgets/ 設計並實作 TimelineWidget 主要組件
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
  - **直接使用**現有的 MapBox 最佳化實踐
  - **複製** cluster_example.dart 的標記聚合程式碼
  - 建立 TripMuse 專用的記憶體管理和快取清理機制
  - 實作圖片快取和壓縮功能
  - _Requirements: 10.1_

- [ ] 11.1 撰寫測試（基於現有測試結構）
  - 在 integration_test/ 目錄中建立完整的應用測試
  - 為核心資料模型撰寫單元測試
  - 建立 Service 和 Repository 的測試
  - 實作 Widget 測試覆蓋主要 UI 組件
  - _Requirements: 所有功能需求_

- [ ] 11.2 建立部署流程
  - 利用現有的 Android 和 iOS 配置
  - 更新應用簽名和發布設定為 TripMuse
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

## 方案 4 最小侵入式開發優勢總結

**最小侵入式開發的優勢：**
- ✅ **零風險**：完全不修改現有專案結構，避免破壞性變更
- ✅ **高效率**：直接複製和引用現有程式碼，無需重新實作
- ✅ **快速開發**：MapBox SDK 已完整配置，立即可用
- ✅ **穩定基礎**：Android/iOS 平台配置已完成且經過測試
- ✅ **程式碼重用**：現有工具函數和範例程式碼可直接使用
- ✅ **漸進式開發**：在 lib/tripmuse/ 目錄中獨立開發新功能
- ✅ **易於維護**：新功能與現有範例完全分離
- ✅ **學習友善**：可隨時參考現有範例的實作方式
- ✅ **回退安全**：出問題時可輕易移除 tripmuse 目錄
- ✅ **團隊協作**：不影響其他人使用現有範例進行開發
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

## 方案 4 最小侵入式開發實作策略

### 目錄結構規劃（完全不動現有結構）

```
lib/
├── main.dart                    # 僅新增一行：TripMuse 選項
├── mapbox_maps_example.dart     # 完全不動
├── example/                     # 完全不動：所有現有範例
│   ├── simple_map_example.dart
│   ├── point_annotations_example.dart
│   ├── polyline_annotations_example.dart
│   └── ...
├── utils.dart                   # 完全不動：直接引用使用
└── tripmuse/                    # 新增：TripMuse 專用目錄
    ├── tripmuse_app.dart        # TripMuse 主應用
    ├── models/                  # 資料模型
    ├── services/                # 服務層
    ├── screens/                 # 頁面
    └── widgets/                 # 組件
```

### main.dart 最小修改策略

```dart
// 在現有的範例列表中僅新增一個 ListTile
// 找到現有的 ListView children，新增：
ListTile(
  title: Text('🧳 TripMuse App'),
  subtitle: Text('AI 智能旅行規劃應用'),
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => TripMuseApp()),
  ),
),
// 其他現有程式碼完全不動
```

### 開發流程建議

1. **第一階段**：建立基礎架構
   - 創建 lib/tripmuse/ 目錄結構
   - 實作基本的 TripMuseApp 入口
   - 設定狀態管理和依賴注入

2. **第二階段**：參考範例實作地圖功能
   - 複製 simple_map_example.dart 的核心邏輯到 trip_map_widget.dart
   - 參考 point_annotations_example.dart 實作標記功能
   - 利用現有 utils.dart 的工具函數

3. **第三階段**：逐步添加 TripMuse 特有功能
   - 實作行程生成和 AI 整合
   - 建立時間軸視圖
   - 添加 PDF 匯出功能

4. **第四階段**：測試和優化
   - 在 integration_test/ 中添加 TripMuse 測試
   - 參考現有範例的效能最佳化實踐
   - 準備發布配置

### 程式碼重用策略（直接複製和引用）

```dart
// 直接引用現有工具函數
import '../utils.dart';

// 直接複製 simple_map_example.dart 的程式碼並修改
class TripMapWidget extends StatefulWidget {
  @override
  _TripMapWidgetState createState() => _TripMapWidgetState();
}

class _TripMapWidgetState extends State<TripMapWidget> {
  MapboxMap? mapboxMap;

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      key: ValueKey("mapWidget"),
      resourceOptions: ResourceOptions(
        accessToken: ACCESS_TOKEN, // 直接使用 utils.dart 的常數
      ),
      onMapCreated: _onMapCreated,
    );
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    // 直接複製 simple_map_example.dart 的初始化程式碼
  }
}
```

### 測試策略

```dart
// 在 integration_test/ 中添加 TripMuse 測試
void main() {
  group('TripMuse Integration Tests', () {
    testWidgets('should navigate to TripMuse from main menu', (tester) async {
      await tester.pumpWidget(MyApp());
      
      // 點擊 TripMuse 選項
      await tester.tap(find.text('🧳 TripMuse App'));
      await tester.pumpAndSettle();
      
      // 驗證進入 TripMuse 應用
      expect(find.byType(TripMuseApp), findsOneWidget);
    });
  });
}
```

這種並行開發策略確保了：
- 現有範例完全不受影響，可隨時參考和測試
- TripMuse 功能獨立開發，降低風險
- 可以逐步建立功能，隨時回退到穩定狀態
- 團隊成員可以同時學習 MapBox 用法和開發 TripMuse 功能