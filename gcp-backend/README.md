# TripMuse API

[![Version](https://img.shields.io/badge/version-0.1.5-blue.svg)](https://github.com/StarCloud0417/TripMuse_mapbox)
[![Node.js](https://img.shields.io/badge/Node.js-18+-green.svg)](https://nodejs.org/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

**TripMuse AI Travel Planning API** - 一個使用 Google Gemini AI 的智慧旅行規劃服務，提供個人化的旅行行程生成。

## 🌟 功能特色

- 🤖 **AI 智慧規劃**: 使用 Google Gemini 1.5 Flash 模型生成個人化旅行行程
- 🗺️ **精確地點定位**: 提供準確的經緯度座標和詳細地點資訊
- 💰 **費用估算**: 包含活動費用和預算建議
- 🕐 **時間規劃**: 智能安排每日活動時間表
- 🔒 **安全部署**: GCP Secret Manager 保護 API 金鑰
- ⚡ **自動擴展**: Cloud Run 自動擴展以處理流量波動

## 🚀 快速開始

### 1. 環境準備

**系統需求:**
- Node.js 18+
- npm 或 yarn
- Google Cloud SDK (用於部署)

### 2. 獲取 Gemini API Key

1. 前往 [Google AI Studio](https://makersuite.google.com/app/apikey)
2. 登入 Google 帳戶
3. 點擊 "Create API Key"
4. 複製生成的 API Key

### 3. 本地開發設置

```bash
# 複製專案
git clone https://github.com/StarCloud0417/TripMuse_mapbox.git
cd TripMuse_mapbox/gcp-backend

# 安裝依賴項
npm install

# 配置環境變數
cp .env.example .env
# 編輯 .env 文件，設置你的 GEMINI_API_KEY
```

### 4. 本地測試

```bash
# 啟動開發服務器
npm run dev

# 或啟動生產服務器
npm start

# 測試健康檢查
curl http://localhost:8080/health

# 測試行程生成
curl -X POST http://localhost:8080/api/v1/generate-trip \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer dev-token" \
  -d '{
    "destination": "東京",
    "days": 3,
    "description": "想要體驗東京的現代科技、文化和美食，希望能夠參觀東京鐵塔、淺草寺，品嚐壽司和拉麵。",
    "preferences": {
      "budget": "medium",
      "pace": "medium",
      "interests": ["科技", "文化", "美食"],
      "companions": 2
    }
  }'
```

## 📦 GCP Cloud Run 部署

### 自動化部署腳本

我們提供了 PowerShell 部署腳本：

```powershell
# 執行部署腳本 (如果存在)
./deploy.ps1
```

### 手動部署步驟

#### 步驟 1: 配置 GCP 項目

```bash
# 設置 GCP 項目
gcloud config set project your-project-id

# 啟用必要 API
gcloud services enable run.googleapis.com
gcloud services enable secretmanager.googleapis.com
```

#### 步驟 2: 創建 Secret

```bash
# 創建 Gemini API Key secret
echo "your-gemini-api-key-here" | gcloud secrets create gemini-api-key --data-file=-

# 設置服務帳戶權限
gcloud secrets add-iam-policy-binding gemini-api-key \
  --member="serviceAccount:PROJECT_NUMBER-compute@developer.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor"
```

#### 步驟 3: 部署到 Cloud Run

```bash
# 部署服務
gcloud run deploy tripmuse-api \
  --source . \
  --region asia-east1 \
  --allow-unauthenticated \
  --set-secrets GEMINI_API_KEY=gemini-api-key:latest \
  --memory 1Gi \
  --cpu 1 \
  --min-instances 0 \
  --max-instances 10
```

### 環境變數配置

| 變數名稱 | 必需 | 說明 |
|---------|------|------|
| `GEMINI_API_KEY` | ✅ | Google Gemini API Key |
| `GOOGLE_PLACES_API_KEY` | ❌ | Google Places API Key (可選) |
| `NODE_ENV` | ❌ | 運行環境 (development/production) |
| `PORT` | ❌ | 服務端口 (默認: 8080) |

## 📡 API 端點

### 健康檢查
```http
GET /health
```

**回應:**
```json
{
  "status": "healthy",
  "timestamp": "2025-09-10T08:00:00.000Z",
  "version": "0.1.5"
}
```

### 生成旅行行程
```http
POST /api/v1/generate-trip
```

**請求範例:**
```json
{
  "destination": "東京",
  "days": 3,
  "description": "想要體驗東京的現代科技、文化和美食",
  "preferences": {
    "budget": "medium",
    "pace": "medium",
    "interests": ["科技", "文化", "美食"],
    "companions": 2
  }
}
```

**回應範例:**
```json
{
  "success": true,
  "trip": {
    "title": "東京科技文化美食之旅",
    "destination": {
      "name": "東京",
      "country": "日本",
      "city": "東京都"
    },
    "days": [
      {
        "dayIndex": 1,
        "date": "2024-01-01",
        "theme": "現代科技探索",
        "activities": [
          {
            "id": "activity-1",
            "name": "東京鐵塔",
            "description": "參觀東京的標誌性建築",
            "lat": 35.6586,
            "lng": 139.7454,
            "timeFrom": "10:00",
            "timeTo": "12:00",
            "category": "sightseeing",
            "priority": "high",
            "estimatedCost": "NT$ 800",
            "tips": "建議預約門票"
          }
        ]
      }
    ],
    "preferenceAnalysis": {
      "primaryFocus": "科技與文化體驗",
      "travelPace": "medium",
      "interests": ["科技", "文化", "美食"],
      "mood": "輕鬆愉快"
    }
  }
}
```

### 地點搜尋
```http
GET /api/v1/places/search?q={query}&location={lat,lng}&radius={meters}
```

## 🛠️ 開發與測試

### 開發模式

```bash
# 安裝開發依賴
npm install -g nodemon

# 啟動開發服務器 (自動重載)
npm run dev
```

### 測試腳本

```bash
# 運行所有測試
npm test

# 運行特定測試
npm run test:unit
npm run test:integration
```

### 代碼品質

```bash
# 代碼檢查
npm run lint

# 代碼格式化
npm run format

# 類型檢查 (如果使用 TypeScript)
npm run type-check
```

## � 故障排除

### 常見問題

#### 1. API Key 錯誤
```
錯誤: GEMINI_API_KEY environment variable is required
解決方案: 確保 .env 文件中設置了正確的 API Key
```

#### 2. 部署權限錯誤
```
錯誤: Permission denied on secret
解決方案: 為服務帳戶授予 Secret Manager 訪問權限
```

#### 3. 容器構建失敗
```
錯誤: Build failed
解決方案: 檢查 Dockerfile 和 .dockerignore 配置
```

### 性能優化

- **冷啟動優化**: 設置最小實例數為 1
- **記憶體配置**: 根據使用情況調整 CPU/記憶體
- **快取策略**: 實現回應快取以提升效能

## 📊 監控與日誌

### Cloud Logging

```bash
# 查看應用日誌
gcloud logging read "resource.type=cloud_run_revision" \
  --filter="resource.labels.service_name=tripmuse-api" \
  --limit=50
```

### Cloud Monitoring

- **回應時間**: 監控 API 回應延遲
- **錯誤率**: 追蹤失敗請求比例
- **資源使用**: CPU/記憶體使用情況
- **自訂指標**: 行程生成成功率等

## 🤝 貢獻指南

1. Fork 此專案
2. 創建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 開啟 Pull Request

### 開發規範

- 使用 ESLint 和 Prettier 進行代碼格式化
- 撰寫完整的測試用例
- 更新文檔以反映更改
- 遵循語意化版本控制

## 📄 授權

此專案採用 MIT 授權 - 詳見 [LICENSE](LICENSE) 文件

## � 聯絡資訊

- **專案維護者**: StarCloud0417
- **問題回報**: [GitHub Issues](https://github.com/StarCloud0417/TripMuse_mapbox/issues)
- **文檔**: [Wiki](https://github.com/StarCloud0417/TripMuse_mapbox/wiki)

## 🙏 致謝

- Google Gemini AI 提供強大的 AI 能力
- Google Cloud Platform 提供可靠的雲端服務
- 開源社群提供優秀的開發工具

---

**⭐ 如果這個專案對你有幫助，請給我們一個 Star！**
