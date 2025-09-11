# TripMuse API Client Request Examples

這個目錄包含了 TripMuse 應用中 CLIENT 端傳送給 SERVER 端的 JSON 請求範例。

## 檔案說明

### `client-request-examples.json`
完整的 API 請求範例集合，包含所有支援的端點：
- `/api/v1/generate-trip` - 生成旅行行程
- `/api/v1/places/search` - 地點搜尋
- `/api/v1/places/details` - 地點詳細資訊
- `/api/v1/places/photo` - 地點照片
- `/api/v1/map/config` - 地圖配置
- `/health` - 健康檢查

### `generate-trip-examples.json`
專門針對行程生成 API 的詳細範例，包含：
- 請求格式說明
- 多種使用情境的範例
- 驗證規則
- 成功/錯誤回應範例

## 使用方法

### 1. 基本請求格式
所有 POST 請求都需要包含：
```json
{
  "Content-Type": "application/json",
  "Authorization": "Bearer <firebase-auth-token>"
}
```

### 2. 行程生成請求
最基本的請求只需要三個必要欄位：
```json
{
  "destination": "東京",
  "days": 3,
  "description": "我想去東京體驗日本文化"
}
```

### 3. 完整請求範例
包含所有偏好設定的完整請求：
```json
{
  "destination": "巴黎",
  "days": 5,
  "description": "浪漫的巴黎之旅，希望能體驗法國美食、藝術和建築",
  "preferences": {
    "budget": "medium",
    "pace": "slow",
    "interests": ["藝術", "美食", "歷史", "購物"],
    "companions": 2
  }
}
```

## 支援的選項

### 預算等級 (budget)
- `"low"` - 經濟型
- `"medium"` - 中等
- `"high"` - 豪華型

### 旅行節奏 (pace)
- `"slow"` - 放鬆
- `"medium"` - 適中
- `"fast"` - 緊湊

### 常見興趣 (interests)
- 美食
- 文化
- 歷史
- 藝術
- 自然
- 冒險
- 購物
- 夜生活
- SPA
- 水上活動
- 登山
- 攝影

## 驗證規則

- `destination`: 必填，1-100 字元
- `days`: 必填，1-30 天
- `description`: 必填，10-1000 字元
- `preferences`: 選填物件
- `companions`: 選填，1-20 人

## 注意事項

1. **認證**: 所有 API 請求都需要有效的 Firebase 認證令牌
2. **頻率限制**: 請注意 API 調用頻率限制，避免過度請求
3. **語言支援**: 支援中文和英文請求
4. **座標格式**: 經緯度使用 `"latitude,longitude"` 格式

## 測試建議

使用這些範例來測試 API：
1. 使用 curl 或 Postman 發送請求
2. 確認所有必要欄位都已填寫
3. 測試不同偏好設定的組合
4. 驗證錯誤處理是否正確

## 相關檔案

- `../server.js` - SERVER 端實現
- `../package.json` - 專案依賴
- `../../lib/` - CLIENT 端 Flutter 程式碼
