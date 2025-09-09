# Requirements Document

## Introduction

TripMuse 是一個基於 AI 的智能旅行規劃應用，使用 Flutter 開發跨平台支援 iOS/Android。核心價值是讓使用者輸入簡單的旅行條件（目的地、天數、偏好），透過 LLM 生成可視化的行程規劃，包含地圖視圖和時間軸視圖，並支援互動調整與匯出分享功能。

**開發策略：** 基於現有的 MapBox Flutter 範例專案進行開發，充分利用已有的地圖功能和範例代碼。本規格專注於 MVP（最小可行產品）階段，目標是快速驗證核心功能和使用者體驗。

**技術基礎：** 
- 基於 mapbox_maps_example 專案結構
- 已整合 MapBox Maps Flutter SDK
- 現有範例包含：地圖顯示、標記、動畫、離線地圖等功能
- 可直接利用現有的地圖組件和工具函數

## Requirements

### Requirement 1: 行程建立與輸入

**User Story:** 作為一個旅行者，我想要輸入基本的旅行資訊和我的旅行願望描述，以便系統能夠理解我的需求並生成個人化的行程。

#### Acceptance Criteria

1. WHEN 使用者開啟建立行程頁面 THEN 系統 SHALL 提供目的地自動補全輸入欄位（使用 Google Places API）
2. WHEN 使用者選擇目的地 THEN 系統 SHALL 要求輸入出發/結束日期或總天數
3. WHEN 使用者設定日期 THEN 系統 SHALL 提供「描述你想要的旅行體驗」文字輸入框
4. WHEN 使用者輸入旅行描述 THEN 系統 SHALL 提供範例提示（如：「我想要一趟放鬆的美食之旅」、「希望體驗當地文化和歷史」）
5. WHEN 使用者完成基本資訊 THEN 系統 SHALL 提供選擇性的旅伴數量和預算範圍設定
6. WHEN 所有必要欄位填寫完成 THEN 系統 SHALL 啟用「智能生成行程」按鈕

### Requirement 2: AI 行程生成與自然語言分析

**User Story:** 作為一個使用者，我想要系統根據我的基本資訊和旅行描述自動生成個人化的詳細旅行行程，以便獲得符合我期望的旅行體驗。

#### Acceptance Criteria

1. WHEN 使用者點擊生成行程 THEN APP SHALL 將標準化請求發送到雲端 Server 而非直接呼叫 LLM API
2. WHEN 雲端 Server 收到 APP 請求 THEN Server SHALL 先使用 LLM 分析使用者的旅行描述，提取關鍵偏好和情感傾向
3. WHEN Server 完成描述分析 THEN Server SHALL 使用分析結果和基本資訊構建個人化的結構化 prompt
4. WHEN Server 呼叫 LLM 生成行程 THEN Server SHALL 要求 LLM 根據分析的偏好重點規劃行程
5. WHEN LLM API 回傳資料到 Server THEN Server SHALL 驗證 JSON schema 並使用 Google Places API 補齊地理資訊
6. IF LLM API 回傳非 JSON 格式 THEN Server SHALL 自動重試或使用 fallback prompt
7. WHEN Server 處理完成 THEN Server SHALL 回傳完整行程資料到 APP 顯示

### Requirement 3: 行程可視化展示與地圖美化

**User Story:** 作為一個使用者，我想要以精美的地圖和時間軸兩種方式查看我的行程，並獲得清晰的旅途進程引導，以便更好地理解空間和時間安排。

#### Acceptance Criteria

1. WHEN 行程生成完成 THEN 系統 SHALL 提供地圖視圖和時間軸視圖的切換選項
2. WHEN 使用者選擇地圖視圖 THEN 系統 SHALL 使用 Mapbox 顯示美化的景點標記，每日使用不同顏色主題區分
3. WHEN 顯示路線 THEN 系統 SHALL 使用漸層色彩的 polyline 連接景點，並顯示方向箭頭指示旅行順序
4. WHEN 使用者查看地圖 THEN 系統 SHALL 提供旅程進度指示器，顯示當前位置和下一個目的地
5. WHEN 使用者點擊地圖標記 THEN 系統 SHALL 顯示動畫彈出的資訊卡片，包含景點預覽圖和關鍵資訊
6. WHEN 使用者選擇時間軸視圖 THEN 系統 SHALL 按日期顯示上午/下午/晚上的活動卡片
7. WHEN 使用者在地圖視圖 THEN 系統 SHALL 支援按日期篩選顯示（Day 1, Day 2...）並平滑切換動畫
8. WHEN 地圖載入 THEN 系統 SHALL 自動調整視角以最佳方式顯示所有景點
9. WHEN 使用者在旅途中 THEN 系統 SHALL 提供即時位置追蹤並高亮顯示當前應前往的景點

### Requirement 4: 地點詳情展示

**User Story:** 作為一個使用者，我想要查看每個景點的詳細資訊，以便了解該地點的特色和相關建議。

#### Acceptance Criteria

1. WHEN 使用者點擊任一活動 THEN 系統 SHALL 彈出 BottomSheet 顯示地點詳情
2. WHEN 顯示地點詳情 THEN 系統 SHALL 包含 LLM 生成的描述、地點類型、建議停留時間
3. WHEN 顯示地點詳情 THEN 系統 SHALL 提供交通建議和預估距離資訊
4. IF Places API 有照片資料 THEN 系統 SHALL 顯示地點相關圖片
5. WHEN 在地點詳情頁面 THEN 系統 SHALL 提供連結到外部導航應用（Google Maps/Apple Maps）或使用 Mapbox 內建導航

### Requirement 5: 行程編輯與調整

**User Story:** 作為一個使用者，我想要能夠調整和編輯生成的行程，以便符合我的個人需求和偏好。

#### Acceptance Criteria

1. WHEN 使用者在時間軸視圖 THEN 系統 SHALL 支援拖拉活動卡片改變時間段
2. WHEN 使用者長按活動卡片 THEN 系統 SHALL 提供刪除、移動、替換選項
3. WHEN 使用者刪除活動 THEN 系統 SHALL 更新地圖視圖和時間軸顯示
4. WHEN 使用者移動活動到不同日期 THEN 系統 SHALL 重新計算該日的路線規劃
5. WHEN 使用者進行編輯 THEN 系統 SHALL 自動儲存變更到本地儲存

### Requirement 6: 匯出與分享功能

**User Story:** 作為一個使用者，我想要能夠匯出精美的 PDF 旅行手冊或分享我的行程，以便與朋友分享或離線使用。

#### Acceptance Criteria

1. WHEN 使用者選擇匯出功能 THEN 系統 SHALL 提供 PDF 匯出選項和分享連結選項
2. WHEN 使用者選擇 PDF 匯出 THEN 系統 SHALL 在本地使用 Flutter PDF 套件生成精美的旅行手冊
3. WHEN 生成 PDF THEN 系統 SHALL 包含封面（目的地、日期、使用者偏好分析）、完整行程表、每日地圖截圖、景點詳情和實用資訊
4. WHEN PDF 生成完成 THEN 系統 SHALL 提供預覽、儲存到裝置、或直接分享選項
5. WHEN 使用者選擇分享連結 THEN 系統 SHALL 生成唯讀的網頁分享連結
6. WHEN 其他人開啟分享連結 THEN 系統 SHALL 顯示完整行程但不允許編輯
7. WHEN 匯出或分享 THEN 系統 SHALL 支援多語言選擇（繁體/簡體/英文）
8. WHEN 生成 PDF THEN 系統 SHALL 在離線狀態下仍能正常運作（使用已快取的地圖和資料）

### Requirement 7: 使用者帳戶與同步（MVP 簡化版）

**User Story:** 作為一個使用者，我想要能夠儲存我的行程，以便隨時存取我的旅行計畫。

#### Acceptance Criteria

1. WHEN 使用者首次開啟應用 THEN 系統 SHALL 提供選擇性的簡單註冊/登入選項（Email 或 Guest 模式）
2. IF 使用者選擇 Guest 模式 THEN 系統 SHALL 將行程僅存在本地裝置
3. IF 使用者選擇註冊登入 THEN 系統 SHALL 將行程同步到雲端儲存
4. WHEN 使用者建立行程 THEN 系統 SHALL 優先存在本地，網路可用時才同步雲端
5. WHEN 網路連線恢復 THEN 系統 SHALL 自動同步本地變更到雲端

**注意：** MVP 階段暫不實作複雜的多裝置同步和衝突解決機制，專注於核心功能驗證。

### Requirement 8: 離線功能支援

**User Story:** 作為一個旅行者，我想要在沒有網路連線時仍能查看我的行程，以便在旅行中隨時參考。

#### Acceptance Criteria

1. WHEN 行程下載完成 THEN 系統 SHALL 將所有行程資料儲存到本地資料庫
2. WHEN 使用者離線時 THEN 系統 SHALL 仍能顯示已下載的行程和地圖
3. WHEN 使用者離線編輯行程 THEN 系統 SHALL 將變更加入同步佇列
4. WHEN 網路恢復 THEN 系統 SHALL 自動同步離線期間的所有變更
5. IF 發生同步衝突 THEN 系統 SHALL 採用最後編輯者優先的策略

### Requirement 9: 錯誤處理與使用者體驗

**User Story:** 作為一個使用者，我想要在系統發生錯誤時得到清楚的提示和解決方案，以便順利完成我的操作。

#### Acceptance Criteria

1. WHEN API 請求失敗 THEN 系統 SHALL 顯示友善的錯誤訊息並提供重試選項
2. WHEN LLM 生成超時 THEN 系統 SHALL 顯示進度指示器並允許使用者取消操作
3. WHEN 達到 API 使用限制 THEN 系統 SHALL 提示使用者稍後再試並顯示預估等待時間
4. WHEN 網路連線不穩定 THEN 系統 SHALL 自動重試並顯示連線狀態
5. WHEN 發生未預期錯誤 THEN 系統 SHALL 記錄錯誤資訊並提供回報機制

### Requirement 10: 效能與安全性

**User Story:** 作為一個使用者，我想要應用程式快速回應且保護我的個人資料，以便安心使用服務。

#### Acceptance Criteria

1. WHEN 應用啟動 THEN 系統 SHALL 在 3 秒內完成初始化並顯示主畫面
2. WHEN 儲存敏感資訊 THEN 系統 SHALL 使用加密儲存（flutter_secure_storage）
3. WHEN APP 與雲端 Server 通訊 THEN 系統 SHALL 使用 HTTPS 和 JWT token 驗證
4. WHEN 雲端 Server 收到相同參數的請求 THEN Server SHALL 快取結果避免重複呼叫 LLM API
5. WHEN 處理使用者資料 THEN 系統 SHALL 遵循 GDPR 和隱私權法規要求
##
 未來商業化功能考量（MVP 後階段）

以下功能將在 MVP 驗證成功後考慮，作為商業化和進階功能：

### 進階 AI 功能
- 自然語言互動調整行程（「把第二天安排放鬆一點」）
- 個人化推薦學習（基於使用者歷史偏好）
- 多種 LLM 模型選擇（GPT-4, Claude, Gemini Pro 等）

### 協作與社交功能
- 多人協作編輯同一行程
- 行程分享到社群媒體
- 使用者評價和推薦系統

### 商業整合功能
- 票券和飯店預訂整合（OTA 合作）
- 當地導遊和體驗預訂
- 餐廳訂位整合

### 進階地圖功能
- 完整離線地圖支援
- 即時交通資訊
- AR 導航功能

### 訂閱制功能
- 無限制行程生成（免費版限制每月 3 個行程）
- 進階 AI 模型使用權
- 優先客服支援
- 無廣告體驗

### 企業功能
- 團體旅行管理
- 差旅報銷整合
- 企業帳戶管理

**商業化策略建議：**
1. **Freemium 模式**：基本功能免費，進階功能付費
2. **使用量限制**：免費用戶每月限制生成行程數量
3. **廣告收入**：免費版顯示相關旅遊廣告
4. **合作分潤**：與 OTA、餐廳、景點合作獲得預訂分潤## API
 訊息格式規格

### APP -> Server 請求格式

```json
{
  "requestId": "uuid-v4",
  "timestamp": "2025-01-07T10:30:00Z",
  "userId": "user-uuid-or-null",
  "tripRequest": {
    "destination": {
      "name": "台北, 台灣",
      "placeId": "google-places-id",
      "coordinates": {
        "lat": 25.0330,
        "lng": 121.5654
      }
    },
    "duration": {
      "days": 3,
      "startDate": "2025-10-01",
      "endDate": "2025-10-03"
    },
    "travelDescription": "我想要一趟放鬆的美食之旅，希望能品嚐當地特色小吃，不要太趕行程",
    "basicPreferences": {
      "budget": "mid",
      "groupSize": 2,
      "travelStyle": "leisure"
    },
    "locale": "zh-TW"
  }
}
```

### Server -> LLM 第一階段請求（分析使用者描述）

```json
{
  "model": "gpt-4o",
  "messages": [
    {
      "role": "system",
      "content": "你是一個旅行偏好分析專家。分析使用者的旅行描述，提取關鍵偏好、情感傾向和重點需求。回傳 JSON 格式的分析結果。"
    },
    {
      "role": "user",
      "content": "分析這個旅行描述：「我想要一趟放鬆的美食之旅，希望能品嚐當地特色小吃，不要太趕行程」\n\n請回傳 JSON 格式：\n{\n  \"primaryFocus\": \"主要重點\",\n  \"travelPace\": \"slow/medium/fast\",\n  \"interests\": [\"興趣列表\"],\n  \"avoidances\": [\"要避免的事項\"],\n  \"mood\": \"旅行情調\",\n  \"keywords\": [\"關鍵字\"]\n}"
    }
  ],
  "response_format": { "type": "json_object" }
}
```

### Server -> LLM 第二階段請求（生成行程）

```json
{
  "model": "gpt-4o",
  "messages": [
    {
      "role": "system",
      "content": "你是一個專業的旅行規劃師。根據目的地、天數和使用者偏好分析結果，生成詳細的旅行行程。必須回傳嚴格的 JSON 格式。"
    },
    {
      "role": "user",
      "content": "為台北3天旅行生成行程。\n\n使用者偏好分析：\n- 主要重點：美食體驗\n- 旅行節奏：放鬆\n- 興趣：當地小吃、傳統市場\n- 避免：趕行程、人擠人景點\n\n請回傳此 JSON 格式：\n{\n  \"title\": \"行程標題\",\n  \"destination\": {\n    \"city\": \"台北\",\n    \"country\": \"台灣\"\n  },\n  \"days\": [\n    {\n      \"dayIndex\": 1,\n      \"date\": \"2025-10-01\",\n      \"theme\": \"當日主題\",\n      \"activities\": [\n        {\n          \"id\": \"activity-uuid\",\n          \"timeFrom\": \"09:00\",\n          \"timeTo\": \"11:00\",\n          \"name\": \"景點名稱\",\n          \"description\": \"簡短描述（最多60字）\",\n          \"category\": \"food/sightseeing/culture/nature/shopping\",\n          \"priority\": \"high/medium/low\",\n          \"estimatedCost\": \"預估花費\",\n          \"tips\": \"旅行小貼士\"\n        }\n      ]\n    }\n  ]\n}"
    }
  ],
  "response_format": { "type": "json_object" }
}
```

### Server -> APP 回應格式

```json
{
  "requestId": "uuid-v4",
  "status": "success",
  "timestamp": "2025-01-07T10:35:00Z",
  "processingTime": 5.2,
  "data": {
    "trip": {
      "id": "trip-uuid",
      "title": "台北放鬆美食3日遊",
      "destination": {
        "city": "台北",
        "country": "台灣",
        "lat": 25.0330,
        "lng": 121.5654
      },
      "userPreferenceAnalysis": {
        "primaryFocus": "美食體驗",
        "travelPace": "slow",
        "detectedInterests": ["當地小吃", "傳統市場", "文化體驗"]
      },
      "days": [
        {
          "dayIndex": 1,
          "date": "2025-10-01",
          "theme": "傳統市場美食探索",
          "activities": [
            {
              "id": "activity-1",
              "timeFrom": "09:00",
              "timeTo": "11:00",
              "name": "迪化街",
              "lat": 25.0540,
              "lng": 121.5128,
              "description": "百年老街品嚐傳統茶點和乾貨",
              "category": "food",
              "priority": "high",
              "estimatedCost": "NT$200-500",
              "tips": "建議早上前往，人潮較少且店家剛開始營業"
            }
          ]
        }
      ],
      "generatedBy": "gpt-4o",
      "createdAt": "2025-01-07T10:35:00Z"
    }
  }
}
```

### 錯誤回應格式

```json
{
  "requestId": "uuid-v4",
  "status": "error",
  "timestamp": "2025-01-07T10:35:00Z",
  "error": {
    "code": "LLM_GENERATION_FAILED",
    "message": "行程生成失敗，請稍後再試",
    "details": "LLM API 回傳格式錯誤，已重試 3 次",
    "retryable": true,
    "estimatedRetryTime": 30
  }
}
```## 
PDF 匯出技術規格

### PDF 生成方式
- **技術選擇**：Flutter 本地生成（使用 `pdf` + `printing` packages）
- **優勢**：快速、離線可用、成本低、格式穩定、可自訂設計

### PDF 內容結構

```
1. 封面頁
   - 行程標題
   - 目的地和日期
   - 使用者偏好分析摘要
   - 生成時間戳記

2. 行程概覽頁
   - 整體路線地圖（所有景點標記）
   - 行程亮點摘要
   - 預估總花費和建議攜帶物品

3. 每日詳細頁面（每天一頁）
   - 當日主題和地圖
   - 時間軸式活動列表
   - 每個景點的詳細資訊：
     * 名稱和地址
     * LLM 生成的描述
     * 建議停留時間和預估花費
     * 交通建議和小貼士
     * 景點照片（如果有）

4. 實用資訊頁
   - 緊急聯絡資訊
   - 當地交通資訊
   - 天氣建議
   - 文化注意事項

5. 備註頁
   - 空白頁面供使用者手寫筆記
```

### PDF 生成流程

```dart
// 範例 PDF 生成流程
Future<Uint8List> generateTripPDF(Trip trip) async {
  final pdf = pw.Document();
  
  // 1. 生成封面頁
  pdf.addPage(await _buildCoverPage(trip));
  
  // 2. 生成概覽頁（包含整體地圖截圖）
  final overviewMapImage = await _captureMapScreenshot(trip);
  pdf.addPage(_buildOverviewPage(trip, overviewMapImage));
  
  // 3. 為每一天生成詳細頁面
  for (final day in trip.days) {
    final dayMapImage = await _captureDayMapScreenshot(day);
    pdf.addPage(_buildDayPage(day, dayMapImage));
  }
  
  // 4. 生成實用資訊頁
  pdf.addPage(_buildUtilityPage(trip));
  
  // 5. 生成備註頁
  pdf.addPage(_buildNotesPage());
  
  return pdf.save();
}
```

### 地圖截圖處理
- 使用 Mapbox 的靜態地圖 API 或截圖功能
- 為整體行程和每日行程分別生成地圖圖片
- 確保地圖包含所有相關景點標記和路線
- 支援離線模式（使用快取的地圖圖片）

### PDF 樣式設計
- 使用一致的品牌色彩和字體
- 響應式佈局適應不同內容長度
- 包含圖標和視覺元素提升可讀性
- 支援多語言字體（中文、英文）

### 效能考量
- 異步生成避免阻塞 UI
- 顯示生成進度指示器
- 快取地圖截圖減少重複請求
- 壓縮圖片減少 PDF 檔案大小