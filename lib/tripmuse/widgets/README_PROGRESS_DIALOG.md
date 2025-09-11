# TripMuse 行程生成進度對話框

## 概述

`SimpleProgressDialog` 是一個整合了實際 GCP server API 請求的行程生成進度對話框，提供完整的使用者體驗，包含進度追蹤、錯誤處理和重試機制。

## 功能特色

### ✨ 核心功能
- **實時進度追蹤**：顯示 0-100% 的生成進度
- **階段性更新**：分析偏好 → 生成行程 → 補強地點 → 驗證資料 → 完成
- **動畫效果**：脈動圖示和流暢的進度條動畫
- **取消功能**：隨時可以取消生成過程
- **智能重試**：自動錯誤分類和重試建議

### 🔧 技術特色
- **真實 API 整合**：直接呼叫 GCP server 的行程生成 API
- **錯誤分類**：自動識別網路、超時、伺服器等不同錯誤類型
- **進度回調**：支援 `TripGenerationService` 的進度回調機制
- **本地儲存**：自動將生成的行程儲存到本地資料庫
- **超時處理**：3分鐘超時保護，避免無限等待

## 使用方式

### 基本用法

```dart
// 在需要生成行程的地方顯示對話框
final result = await showDialog<Trip>(
  context: context,
  barrierDismissible: false,
  builder: (context) => SimpleProgressDialog(
    request: tripRequest,
    onSuccess: (trip) {
      // 處理成功回調
      print('行程生成成功: ${trip.title}');
    },
    onError: (error) {
      // 處理錯誤回調
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('生成失敗: $error')),
      );
    },
    onCancel: () {
      // 處理取消回調
      print('使用者取消了行程生成');
    },
  ),
);
```

### 完整範例

```dart
Future<void> _generateTrip() async {
  final tripRequest = TripRequest(
    destination: '台北',
    days: 3,
    description: '我想要一趟放鬆的美食之旅',
    preferences: TripPreferences(
      budget: 'mid',
      pace: 'slow',
      interests: ['美食', '文化'],
      companions: 2,
    ),
  );

  final result = await showDialog<Trip>(
    context: context,
    barrierDismissible: false,
    builder: (context) => SimpleProgressDialog(
      request: tripRequest,
      onSuccess: (trip) async {
        // 儲存到本地
        final tripRepository = ref.read(tripRepositoryProvider);
        await tripRepository.saveTrip(trip);
        
        // 顯示成功訊息
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 ${trip.title} 生成成功！'),
            backgroundColor: Colors.green,
          ),
        );
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ 生成失敗：$error'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: '重試',
              onPressed: () => _generateTrip(),
            ),
          ),
        );
      },
      onCancel: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('行程生成已取消')),
        );
      },
    ),
  );

  if (result != null) {
    // 導航到行程詳情頁面
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripDetailScreen(trip: result),
      ),
    );
  }
}
```

## 進度階段說明

對話框會顯示以下階段的進度：

1. **分析偏好階段** (0-20%)
   - 文字：「正在分析您的旅行偏好...」
   - 處理：解析使用者的旅行描述和偏好設定

2. **生成行程階段** (20-70%)
   - 文字：「正在為您規劃精彩行程...」
   - 處理：呼叫 AI API 生成詳細行程

3. **補強地點階段** (70-90%)
   - 文字：「正在補強地點詳細資訊...」
   - 處理：使用 Google Places API 補強地點資料

4. **驗證資料階段** (90-95%)
   - 文字：「正在驗證行程資料...」
   - 處理：驗證生成的行程資料完整性

5. **完成階段** (100%)
   - 文字：「行程生成完成！」
   - 處理：最終確認和回調處理

## 錯誤處理

對話框會自動識別和處理以下錯誤類型：

### 網路錯誤
- **識別**：包含 `NetworkException` 或 `網路` 關鍵字
- **顯示**：「網路連線錯誤，請檢查網路後重試」
- **建議**：檢查網路連線

### 超時錯誤
- **識別**：包含 `timeout` 或 `超時` 關鍵字
- **顯示**：「請求超時，請稍後重試」
- **建議**：稍後重試或檢查網路速度

### 伺服器錯誤
- **識別**：包含 `ServerException` 或 `伺服器` 關鍵字
- **顯示**：「伺服器暫時無法處理請求，請稍後重試」
- **建議**：稍後重試

### API 錯誤
- **識別**：包含 `ApiException` 關鍵字
- **顯示**：移除 `ApiException:` 前綴後的錯誤訊息
- **建議**：根據具體錯誤內容

## 依賴需求

使用此對話框需要以下依賴：

```yaml
dependencies:
  flutter_riverpod: ^2.5.1  # 狀態管理
  
# 服務依賴
- TripService: 行程生成服務
- TripGenerationService: 增強的生成服務
- ApiClient: API 客戶端
- TripRepository: 本地儲存
```

## 自訂選項

### 超時時間
預設超時時間為 3 分鐘，可以在 `_generateTripWithRealAPI()` 方法中修改：

```dart
_timeoutTimer = Timer(const Duration(minutes: 5), () {
  // 自訂超時處理
});
```

### 進度更新頻率
進度更新基於 `TripGenerationService` 的回調，可以在服務層調整更新頻率。

### 視覺樣式
對話框使用 `TripMuseTheme` 的顏色和樣式，可以通過修改主題來自訂外觀。

## 測試

提供完整的測試覆蓋：

- **單元測試**：錯誤解析邏輯
- **Widget 測試**：UI 互動和狀態變化
- **整合測試**：與真實 API 的整合

執行測試：

```bash
flutter test test/tripmuse/real_api_integration_test.dart
```

## 故障排除

### 常見問題

1. **ProviderScope 錯誤**
   - 確保對話框在 `ProviderScope` 內使用
   - 檢查所有必要的 Provider 都已正確設定

2. **API 呼叫失敗**
   - 檢查網路連線
   - 確認 GCP server 正常運行
   - 檢查 API 端點配置

3. **進度不更新**
   - 確認 `TripGenerationService` 正確實作進度回調
   - 檢查 `onProgress` 參數是否正確傳遞

4. **儲存失敗**
   - 確認 `TripRepository` 已正確初始化
   - 檢查本地儲存權限

### 除錯技巧

啟用詳細日誌：

```dart
// 在 _generateTripWithRealAPI() 中添加
print('🎯 開始生成行程: ${widget.request.destination}');
print('📊 當前進度: ${(_progress * 100).toInt()}%');
print('📝 當前階段: $_currentPhase');
```

## 版本歷史

- **v1.0.0**: 初始版本，支援基本進度顯示
- **v1.1.0**: 整合真實 API 請求
- **v1.2.0**: 添加錯誤分類和重試機制
- **v1.3.0**: 支援本地儲存和完整測試覆蓋