const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const { GoogleGenerativeAI } = require('@google/generative-ai');
const { SecretManagerServiceClient } = require('@google-cloud/secret-manager');
const admin = require('firebase-admin');
const axios = require('axios');
const Joi = require('joi');
const winston = require('winston');

// 載入環境變數
require('dotenv').config();

// 設定日誌
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.Console(),
  ],
});

const app = express();
const port = process.env.PORT || 8080;
const projectId = 'tripmuse-app';

// 初始化 Gemini AI
if (!process.env.GEMINI_API_KEY) {
  logger.error('GEMINI_API_KEY environment variable is required');
  process.exit(1);
}
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

const secretClient = new SecretManagerServiceClient();

// 初始化 Firebase Admin（如果有服務帳戶金鑰）
try {
  admin.initializeApp();
  logger.info('Firebase Admin initialized successfully');
} catch (error) {
  logger.warn('Firebase Admin initialization failed:', error.message);
}

// 中介軟體
app.use(helmet());
app.use(compression());
app.use(cors({
  origin: process.env.NODE_ENV === 'production' 
    ? ['https://your-app-domain.com'] 
    : true,
  credentials: true
}));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// 請求日誌中介軟體
app.use((req, res, next) => {
  logger.info(`${req.method} ${req.path}`, {
    ip: req.ip,
    userAgent: req.get('User-Agent')
  });
  next();
});

// 快取 secrets
const secretsCache = new Map();

// 獲取 Secret Manager 中的值
async function getSecret(secretName) {
  if (secretsCache.has(secretName)) {
    return secretsCache.get(secretName);
  }

  try {
    const [version] = await secretClient.accessSecretVersion({
      name: `projects/${projectId}/secrets/${secretName}/versions/latest`,
    });
    
    const secretValue = version.payload.data.toString();
    secretsCache.set(secretName, secretValue);
    return secretValue;
  } catch (error) {
    logger.error(`Failed to get secret ${secretName}:`, error);
    throw new Error(`Secret ${secretName} not found`);
  }
}

// 認證中介軟體
async function authenticateUser(req, res, next) {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ 
        success: false, 
        error: 'No valid authorization header' 
      });
    }

    const token = authHeader.replace('Bearer ', '');
    
    // 在開發環境或 GCP 環境中，可以跳過 Firebase 驗證
    if ((process.env.NODE_ENV === 'development' || process.env.K_SERVICE) && token === 'dev-token') {
      req.user = { uid: 'dev-user', email: 'dev@example.com' };
      return next();
    }

    // 驗證 Firebase ID Token
    const decodedToken = await admin.auth().verifyIdToken(token);
    req.user = decodedToken;
    next();
  } catch (error) {
    logger.error('Authentication failed:', error);
    res.status(401).json({ 
      success: false, 
      error: 'Invalid authentication token' 
    });
  }
}

// 驗證 schemas
const tripRequestSchema = Joi.object({
  destination: Joi.string().required().min(1).max(100),
  days: Joi.number().integer().min(1).max(30).required(),
  description: Joi.string().required().min(10).max(1000),
  preferences: Joi.object({
    budget: Joi.string().valid('low', 'medium', 'high'),
    pace: Joi.string().valid('slow', 'medium', 'fast'),
    interests: Joi.array().items(Joi.string()),
    companions: Joi.number().integer().min(1).max(20)
  }).optional()
});

// 健康檢查端點
app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy', 
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

// 行程生成 API
app.post('/api/v1/generate-trip', authenticateUser, async (req, res) => {
  try {
    // 驗證請求資料
    const { error, value } = tripRequestSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        error: 'Invalid request data',
        details: error.details
      });
    }

    const { destination, days, description, preferences = {} } = value;
    const userId = req.user.uid;

    logger.info('Generating trip', { userId, destination, days });

    // 建立 Gemini 模型
    const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });

    // 建構詳細的 prompt
    const prompt = `
你是一個專業的旅行規劃師。請為以下需求生成詳細的旅行行程：

目的地: ${destination}
天數: ${days} 天
旅行描述: ${description}
預算: ${preferences.budget || 'medium'}
旅行節奏: ${preferences.pace || 'medium'}
興趣: ${preferences.interests ? preferences.interests.join(', ') : '一般觀光'}
旅伴人數: ${preferences.companions || 2} 人

請以以下 JSON 格式回應，確保所有地點都有準確的座標：

{
  "title": "行程標題",
  "destination": {
    "name": "${destination}",
    "country": "國家",
    "city": "城市"
  },
  "days": [
    {
      "dayIndex": 1,
      "date": "2024-01-01",
      "theme": "當日主題",
      "activities": [
        {
          "id": "unique-id",
          "name": "景點名稱",
          "description": "詳細描述",
          "lat": 25.0330,
          "lng": 121.5654,
          "timeFrom": "09:00",
          "timeTo": "11:00",
          "category": "sightseeing",
          "priority": "high",
          "estimatedCost": "NT$ 200",
          "tips": "實用建議"
        }
      ]
    }
  ],
  "preferenceAnalysis": {
    "primaryFocus": "主要焦點",
    "travelPace": "medium",
    "interests": ["文化", "美食"],
    "avoidances": ["人潮"],
    "mood": "輕鬆愉快",
    "keywords": ["關鍵字"]
  }
}

請確保：
1. 每個活動都有準確的經緯度座標
2. 時間安排合理，考慮交通時間
3. 活動類型包括：food, sightseeing, culture, nature, shopping
4. 優先級包括：high, medium, low
5. 提供實用的旅行建議和預估費用
`;

    // 呼叫 Gemini API
    const result = await model.generateContent(prompt);
    const generatedText = result.response.text();
    
    // 解析 JSON 回應
    let tripData;
    try {
      // 清理回應文字，移除可能的 markdown 格式和多餘字符
      let cleanedText = generatedText
        .replace(/```json\s*/gi, '')  // 移除 ```json 標記
        .replace(/```\s*/gi, '')      // 移除 ``` 標記
        .replace(/[\u0000-\u001F\u007F-\u009F]/g, '') // 移除控制字符
        .trim();
      
      // 如果清理後的文字不是以 { 開頭，嘗試找到 JSON 的開始
      if (!cleanedText.startsWith('{')) {
        const jsonStart = cleanedText.indexOf('{');
        if (jsonStart !== -1) {
          cleanedText = cleanedText.substring(jsonStart);
        }
      }
      
      // 如果清理後的文字不是以 } 結尾，嘗試找到 JSON 的結束
      if (!cleanedText.endsWith('}')) {
        const jsonEnd = cleanedText.lastIndexOf('}');
        if (jsonEnd !== -1) {
          cleanedText = cleanedText.substring(0, jsonEnd + 1);
        }
      }
      
      // 記錄清理後的文字長度以便調試
      logger.info('Cleaned response length:', cleanedText.length);
      
      tripData = JSON.parse(cleanedText);
    } catch (parseError) {
      logger.error('Failed to parse LLM response:', parseError.message);
      logger.error('Raw response preview:', generatedText.substring(0, 200) + '...');
      logger.error('Cleaned text preview:', cleanedText ? cleanedText.substring(0, 200) + '...' : 'null');
      
      // 如果解析失敗，返回預設的行程結構
      logger.warn('Using fallback trip structure due to parsing failure');
      tripData = {
        title: `${destination} 探索之旅`,
        destination: {
          name: destination,
          country: "台灣",
          city: destination
        },
        days: [
          {
            dayIndex: 1,
            date: new Date().toISOString().split('T')[0],
            theme: "城市探索",
            activities: [
              {
                id: "activity-1",
                name: `${destination} 景點`,
                description: `探索 ${destination} 的著名景點和文化`,
                lat: 25.0330,
                lng: 121.5654,
                timeFrom: "09:00",
                timeTo: "12:00",
                category: "sightseeing",
                priority: "high",
                estimatedCost: "NT$ 200",
                tips: "建議早上前往避開人潮"
              }
            ]
          }
        ],
        preferenceAnalysis: {
          primaryFocus: "城市探索",
          travelPace: "medium",
          interests: ["文化", "美食"],
          mood: "輕鬆愉快"
        }
      };
    }

    // 使用 Google Places API 補強地點資訊
    const enhancedTrip = await enhanceTripWithPlacesAPI(tripData);

    // 添加生成資訊
    enhancedTrip.id = `trip_${userId}_${Date.now()}`;
    enhancedTrip.userId = userId;
    enhancedTrip.generatedBy = 'gemini-pro';
    enhancedTrip.createdAt = new Date().toISOString();
    enhancedTrip.updatedAt = new Date().toISOString();

    logger.info('Trip generated successfully', { 
      userId, 
      tripId: enhancedTrip.id,
      activitiesCount: enhancedTrip.days.reduce((sum, day) => sum + day.activities.length, 0)
    });

    res.json({
      success: true,
      trip: enhancedTrip
    });

  } catch (error) {
    logger.error('Trip generation failed:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to generate trip',
      message: error.message
    });
  }
});

// 地點搜尋 API
app.get('/api/v1/places/search', authenticateUser, async (req, res) => {
  try {
    const { q: query, location, radius = 50000 } = req.query;
    
    if (!query) {
      return res.status(400).json({
        success: false,
        error: 'Query parameter is required'
      });
    }

    const placesApiKey = await getSecret('google-places-api-key');
    
    let url = `https://maps.googleapis.com/maps/api/place/textsearch/json?query=${encodeURIComponent(query)}&key=${placesApiKey}`;
    
    if (location) {
      url += `&location=${location}&radius=${radius}`;
    }

    const response = await axios.get(url);
    const data = response.data;

    if (data.status !== 'OK' && data.status !== 'ZERO_RESULTS') {
      throw new Error(`Places API error: ${data.status}`);
    }

    const places = data.results.map(place => ({
      id: place.place_id,
      name: place.name,
      address: place.formatted_address,
      location: place.geometry.location,
      rating: place.rating,
      priceLevel: place.price_level,
      types: place.types,
      photos: place.photos ? place.photos.slice(0, 3).map(photo => ({
        reference: photo.photo_reference,
        width: photo.width,
        height: photo.height
      })) : []
    }));

    res.json({
      success: true,
      places: places
    });

  } catch (error) {
    logger.error('Places search failed:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to search places',
      message: error.message
    });
  }
});

// 地圖配置 API
app.get('/api/v1/map/config', authenticateUser, async (req, res) => {
  try {
    const mapboxToken = await getSecret('mapbox-access-token');
    
    res.json({
      success: true,
      config: {
        accessToken: mapboxToken,
        style: 'mapbox://styles/mapbox/streets-v11',
        maxZoom: 18,
        minZoom: 1,
        defaultCenter: [121.5654, 25.0330], // 台北
        defaultZoom: 10
      }
    });

  } catch (error) {
    logger.error('Failed to get map config:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to get map configuration'
    });
  }
});

// 輔助函數：使用 Places API 補強地點資訊
async function enhanceTripWithPlacesAPI(tripData) {
  try {
    const placesApiKey = await getSecret('google-places-api-key');
    
    for (const day of tripData.days) {
      for (const activity of day.activities) {
        // 如果沒有座標，嘗試搜尋
        if (!activity.lat || !activity.lng) {
          try {
            const searchQuery = `${activity.name} ${tripData.destination.name}`;
            const searchUrl = `https://maps.googleapis.com/maps/api/place/textsearch/json?query=${encodeURIComponent(searchQuery)}&key=${placesApiKey}`;
            
            const searchResponse = await axios.get(searchUrl);
            const searchData = searchResponse.data;
            
            if (searchData.results && searchData.results.length > 0) {
              const place = searchData.results[0];
              activity.lat = place.geometry.location.lat;
              activity.lng = place.geometry.location.lng;
              activity.placeId = place.place_id;
              activity.rating = place.rating;
              activity.address = place.formatted_address;
              
              // 添加照片參考
              if (place.photos && place.photos.length > 0) {
                activity.photos = place.photos.slice(0, 2).map(photo => photo.photo_reference);
              }
            }
          } catch (placeError) {
            logger.warn(`Failed to enhance place ${activity.name}:`, placeError.message);
          }
        }
      }
    }
  } catch (error) {
    logger.error('Failed to enhance trip with Places API:', error);
  }
  
  return tripData;
}

// 錯誤處理中介軟體
app.use((error, req, res, next) => {
  logger.error('Unhandled error:', error);
  res.status(500).json({
    success: false,
    error: 'Internal server error'
  });
});

// 404 處理
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    error: 'Endpoint not found'
  });
});

// 啟動伺服器
app.listen(port, () => {
  logger.info(`TripMuse API server running on port ${port}`);
  logger.info(`Environment: ${process.env.NODE_ENV || 'development'}`);
});