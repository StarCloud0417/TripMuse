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
  logger.info('Firebase Admin 初始化成功');
} catch (error) {
  logger.warn('Firebase Admin 初始化失敗:', error.message);
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
    logger.error(`獲取 secret ${secretName} 失敗:`, error);
    throw new Error(`Secret ${secretName} 不存在`);
  }
}

// 認證中介軟體
async function authenticateUser(req, res, next) {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ 
        success: false, 
        error: '無效的授權標頭' 
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
    logger.error('認證失敗:', error);
    res.status(401).json({ 
      success: false, 
      error: '無效的認證令牌' 
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

// 統一活動類別為支持的值
function normalizeActivityCategory(category) {
  const categoryMap = {
    'food': 'food',
    'restaurant': 'food',
    '美食': 'food',
    'dining': 'food',
    'sightseeing': 'sightseeing',
    '景點': 'sightseeing',
    'attraction': 'sightseeing',
    'tourist': 'sightseeing',
    'culture': 'culture',
    '文化': 'culture',
    'historical': 'culture',
    'museum': 'culture',
    'nature': 'nature',
    '自然': 'nature',
    'park': 'nature',
    'outdoor': 'nature',
    'shopping': 'shopping',
    '購物': 'shopping',
    'market': 'shopping',
    'mall': 'shopping',
    'outdoor': 'outdoor',
    '戶外': 'outdoor',
    'adventure': 'outdoor',
    'transportation': 'transportation',
    '交通': 'transportation',
    'travel': 'transportation'
  };

  return categoryMap[category.toLowerCase()] || 'sightseeing'; // 預設值
}

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
        error: '請求資料無效',
        details: error.details
      });
    }

    const { destination, days, description, preferences = {} } = value;
    const userId = req.user.uid;

    logger.info('正在生成行程', { userId, destination, days });

    // 建立 Gemini 模型
    const model = genAI.getGenerativeModel({ model: 'gemini-2.5-flash' });

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
    "budgetRange": "mid",
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
      logger.info('清理後回應長度:', cleanedText.length);
      
      tripData = JSON.parse(cleanedText);
      
      // 統一活動類別
      if (tripData.days && Array.isArray(tripData.days)) {
        tripData.days.forEach(day => {
          if (day.activities && Array.isArray(day.activities)) {
            day.activities.forEach(activity => {
              if (activity.category) {
                activity.category = normalizeActivityCategory(activity.category);
              }
            });
          }
        });
      }
      
      // 確保 preferenceAnalysis 有 budgetRange
      if (tripData.preferenceAnalysis && !tripData.preferenceAnalysis.budgetRange) {
        tripData.preferenceAnalysis.budgetRange = 'mid';
      }
    } catch (parseError) {
      logger.error('LLM 回應解析失敗:', parseError.message);
      logger.error('原始回應預覽:', generatedText.substring(0, 200) + '...');
      logger.error('清理後文字預覽:', cleanedText ? cleanedText.substring(0, 200) + '...' : 'null');
      
      // 如果解析失敗，返回預設的行程結構
      logger.warn('由於解析失敗，使用備用行程結構');
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
          budgetRange: "mid",
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

    logger.info('行程生成成功', { 
      userId, 
      tripId: enhancedTrip.id,
      activitiesCount: enhancedTrip.days.reduce((sum, day) => sum + day.activities.length, 0)
    });

    res.json({
      success: true,
      trip: enhancedTrip,
      analysis: enhancedTrip.preferenceAnalysis
    });

  } catch (error) {
    logger.error('行程生成失敗:', error);
    res.status(500).json({
      success: false,
      error: '行程生成失敗',
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
        error: '查詢參數為必填'
      });
    }

    // 從環境變數獲取 Google Places API Key
    const placesApiKey = process.env.GOOGLE_PLACES_API_KEY;
    if (!placesApiKey) {
      logger.error('GOOGLE_PLACES_API_KEY 環境變數為必填');
      return res.status(500).json({
        success: false,
        error: 'Google Places API 金鑰未配置',
        message: '請在環境變數中配置 GOOGLE_PLACES_API_KEY'
      });
    }
    
    let url = `https://maps.googleapis.com/maps/api/place/textsearch/json?query=${encodeURIComponent(query)}&key=${placesApiKey}`;
    
    if (location) {
      url += `&location=${location}&radius=${radius}`;
    }

    logger.info(`發送 Places API 請求: ${url.replace(placesApiKey, '***API_KEY***')}`);

    const response = await axios.get(url);
    const data = response.data;

    logger.info(`Places API 回應狀態: ${data.status}, 結果數量: ${data.results ? data.results.length : 0}`);

    if (data.status !== 'OK' && data.status !== 'ZERO_RESULTS') {
      logger.error(`Places API 錯誤: ${data.status}`, {
        error_message: data.error_message,
        url: url.replace(placesApiKey, '***API_KEY***')
      });
      throw new Error(`Places API 錯誤: ${data.status} - ${data.error_message || '未知錯誤'}`);
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
    logger.error('地點搜尋失敗:', error);
    res.status(500).json({
      success: false,
      error: '地點搜尋失敗',
      message: error.message
    });
  }
});

// 地點詳細資訊 API
app.get('/api/v1/places/details', authenticateUser, async (req, res) => {
  try {
    const { place_id } = req.query;
    
    if (!place_id) {
      return res.status(400).json({
        success: false,
        error: '地點 ID 為必填'
      });
    }

    const placesApiKey = await getSecret('google-places-api-key');
    
    const url = `https://maps.googleapis.com/maps/api/place/details/json?place_id=${place_id}&fields=place_id,name,formatted_address,geometry,rating,price_level,types,photos,opening_hours,website,formatted_phone_number&key=${placesApiKey}`;

    const response = await axios.get(url);
    const data = response.data;

    if (data.status !== 'OK') {
      throw new Error(`Places API 錯誤: ${data.status}`);
    }

    const place = data.result;
    const placeDetails = {
      id: place.place_id,
      name: place.name,
      address: place.formatted_address,
      location: place.geometry.location,
      rating: place.rating,
      priceLevel: place.price_level,
      types: place.types,
      photos: place.photos ? place.photos.slice(0, 5).map(photo => ({
        reference: photo.photo_reference,
        width: photo.width,
        height: photo.height
      })) : [],
      openingHours: place.opening_hours ? {
        openNow: place.opening_hours.open_now,
        weekdayText: place.opening_hours.weekday_text
      } : null,
      website: place.website,
      phoneNumber: place.formatted_phone_number
    };

    res.json({
      success: true,
      place: placeDetails
    });

  } catch (error) {
    logger.error('地點詳情獲取失敗:', error);
    res.status(500).json({
      success: false,
      error: '獲取地點詳情失敗',
      message: error.message
    });
  }
});

// 地點照片 API
app.get('/api/v1/places/photo', authenticateUser, async (req, res) => {
  try {
    const { reference, maxwidth = 400, maxheight } = req.query;
    
    if (!reference) {
      return res.status(400).json({
        success: false,
        error: 'Photo reference is required'
      });
    }

    const placesApiKey = await getSecret('google-places-api-key');
    
    let url = `https://maps.googleapis.com/maps/api/place/photo?photoreference=${reference}&key=${placesApiKey}`;
    
    if (maxwidth) url += `&maxwidth=${maxwidth}`;
    if (maxheight) url += `&maxheight=${maxheight}`;

    // 重定向到 Google 照片 URL
    res.redirect(url);

  } catch (error) {
    logger.error('Place photo failed:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to get place photo',
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
    logger.error('獲取地圖配置失敗:', error);
    res.status(500).json({
      success: false,
      error: '獲取地圖配置失敗'
    });
  }
});

// Clean and validate activity category
function cleanActivityCategory(category) {
  if (!category || typeof category !== 'string') {
    return 'sightseeing'; // Default value
  }

  // Remove whitespace and convert to lowercase
  const cleaned = category.trim().toLowerCase();

  // If contains comma, take first value
  const firstCategory = cleaned.split(',')[0].trim();

  // Fix common spelling errors and expand mappings
  const categoryMap = {
    'food': 'food',
    'restaurant': 'food',
    '美食': 'food',
    'dining': 'food',
    'sightseeing': 'sightseeing',
    '觀光': 'sightseeing',
    '景點': 'sightseeing',
    'attraction': 'sightseeing',
    'tourist': 'sightseeing',
    'culture': 'culture',
    '文化': 'culture',
    '歷史': 'culture',
    'historical': 'culture',
    'museum': 'culture',
    'nature': 'nature',
    '自然': 'nature',
    'park': 'nature',
    'natuure': 'nature', // Fix spelling error
    'shopping': 'shopping',
    '購物': 'shopping',
    'market': 'shopping',
    'mall': 'shopping',
    'outdoor': 'outdoor',
    '戶外': 'outdoor',
    'adventure': 'outdoor',
    'transportation': 'transportation',
    '交通': 'transportation',
    'travel': 'transportation'
  };

  return categoryMap[firstCategory] || 'sightseeing'; // Return default if no match found
}

// Clean and validate activity priority
function cleanActivityPriority(priority) {
  if (!priority || typeof priority !== 'string') {
    return 'medium'; // Default value
  }

  const cleaned = priority.trim().toLowerCase();
  const priorityMap = {
    'high': 'high',
    '高': 'high',
    'medium': 'medium',
    '中': 'medium',
    'low': 'low',
    '低': 'low'
  };

  return priorityMap[cleaned] || 'medium'; // Return default if no match found
}

// 使用 Google Places API 補強行程地點資訊
async function enhanceTripWithPlacesAPI(tripData) {
  try {
    const placesApiKey = process.env.GOOGLE_PLACES_API_KEY;
    if (!placesApiKey) {
      logger.warn('GOOGLE_PLACES_API_KEY 不可用，跳過地點增強');
      return tripData;
    }
    
    for (const day of tripData.days) {
      for (const activity of day.activities) {
        // 清理和驗證活動數據
        activity.category = cleanActivityCategory(activity.category);
        activity.priority = cleanActivityPriority(activity.priority);
        
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
            logger.warn(`增強地點 ${activity.name} 失敗:`, placeError.message);
          }
        }
      }
    }
  } catch (error) {
    logger.error('使用 Places API 補強行程失敗:', error);
  }
  
  return tripData;
}

// 錯誤處理中介軟體
app.use((error, req, res, next) => {
  logger.error('未處理的錯誤:', error);
  res.status(500).json({
    success: false,
    error: '內部服務器錯誤'
  });
});

// 404 處理
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    error: '端點不存在'
  });
});

// 啟動伺服器
app.listen(port, () => {
  logger.info(`TripMuse API 服務器運行在端口 ${port}`);
  logger.info(`環境: ${process.env.NODE_ENV || 'development'}`);
});

// 計算兩點間距離 (公里)
function calculateDistance(lat1, lng1, lat2, lng2) {
  const R = 6371; // 地球半徑 (公里)
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLng = (lng2 - lng1) * Math.PI / 180;
  const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLng/2) * Math.sin(dLng/2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  return R * c;
}

// 處理 Places API 錯誤
function handlePlacesApiError(res, status, errorMessage) {
  logger.error(`Places API error: ${status} - ${errorMessage}`);
  
  switch (status) {
    case 'ZERO_RESULTS':
      return res.status(404).json({
        success: false,
        error: 'NO_RESULTS',
        message: '找不到符合條件的地點'
      });
      
    case 'OVER_QUERY_LIMIT':
      return res.status(429).json({
        success: false,
        error: 'QUOTA_EXCEEDED',
        message: 'Places API 配額已用盡，請稍後再試',
        retryAfter: 3600 // 建議 1 小時後重試
      });
      
    case 'REQUEST_DENIED':
      return res.status(403).json({
        success: false,
        error: 'ACCESS_DENIED',
        message: 'Places API 存取被拒絕，請檢查 API 金鑰設定'
      });
      
    case 'INVALID_REQUEST':
      return res.status(400).json({
        success: false,
        error: 'INVALID_REQUEST',
        message: '請求參數無效'
      });
      
    case 'NOT_FOUND':
      return res.status(404).json({
        success: false,
        error: 'NOT_FOUND',
        message: '指定的地點不存在'
      });
      
    default:
      return res.status(500).json({
        success: false,
        error: 'PLACES_API_ERROR',
        message: errorMessage || `Places API 錯誤: ${status}`
      });
  }
}

// Places API 請求重試機制
async function makeRetryableRequest(url, maxRetries = 3) {
  let lastError;
  
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      const response = await axios.get(url, {
        timeout: 10000, // 10 秒超時
      });
      
      return response.data;
    } catch (error) {
      lastError = error;
      
      // 如果是網路錯誤且還有重試機會
      if (error.code === 'ECONNRESET' || error.code === 'ETIMEDOUT') {
        if (attempt < maxRetries) {
          const delay = Math.pow(2, attempt - 1) * 1000; // 指數退避
          logger.warn(`Request failed (attempt ${attempt}/${maxRetries}), retrying in ${delay}ms...`);
          await new Promise(resolve => setTimeout(resolve, delay));
          continue;
        }
      }
      
      // 其他錯誤直接拋出
      throw error;
    }
  }
  
  throw lastError;
}