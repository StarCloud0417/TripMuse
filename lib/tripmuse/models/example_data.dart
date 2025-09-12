/// TripMuse 資料模型範例資料
/// 
/// 提供測試和開發用的範例資料

import 'models.dart';

/// 範例資料工廠類別
class ExampleData {
  /// 建立範例目的地 - 台北
  static Destination get taipeiDestination => const Destination(
    name: '台北',
    city: '台北',
    country: '台灣',
    lat: 25.0330,
    lng: 121.5654,
    placeId: 'ChIJraeqmjOpQjQRPwMskbmIIjw',
    fullAddress: '台北市, 台灣',
    timezone: 'Asia/Taipei',
    currencyCode: 'TWD',
    languageCode: 'zh-TW',
  );

  /// 建立範例目的地 - 東京
  static Destination get tokyoDestination => const Destination(
    name: '東京',
    city: '東京',
    country: '日本',
    lat: 35.6762,
    lng: 139.6503,
    placeId: 'ChIJ51cu8IcbXWARiRtXIothAS4',
    fullAddress: '東京都, 日本',
    timezone: 'Asia/Tokyo',
    currencyCode: 'JPY',
    languageCode: 'ja',
  );

  /// 建立範例活動列表 - 台北第一天
  static List<Activity> get taipeiDay1Activities => [
    const Activity(
      id: 'taipei-activity-1',
      name: '鼎泰豐',
      description: '世界知名的小籠包餐廳，品嚐正宗台式點心',
      lat: 25.0418,
      lng: 121.5654,
      timeFrom: '08:30',
      timeTo: '10:00',
      category: ActivityCategory.food,
      priority: ActivityPriority.high,
      estimatedCost: 'NT\$800-1200',
      tips: '建議提早到達或預約，避免排隊等候',
      placeId: 'ChIJraeqmjOpQjQRPwMskbmIIjw',
      address: '台北市信義區信義路二段194號',
      rating: 4.5,
      suggestedDurationMinutes: 90,
    ),
    const Activity(
      id: 'taipei-activity-2',
      name: '台北101',
      description: '台北地標性摩天大樓，89樓觀景台可俯瞰整個台北市',
      lat: 25.0330,
      lng: 121.5654,
      timeFrom: '10:30',
      timeTo: '12:30',
      category: ActivityCategory.sightseeing,
      priority: ActivityPriority.high,
      estimatedCost: 'NT\$600',
      tips: '建議購買快速通關票券，避免排隊時間',
      placeId: 'ChIJraeqmjOpQjQRPwMskbmIIjw',
      address: '台北市信義區信義路五段7號',
      rating: 4.3,
      suggestedDurationMinutes: 120,
    ),
    const Activity(
      id: 'taipei-activity-3',
      name: '象山步道',
      description: '輕鬆的登山步道，可拍攝台北101的最佳角度',
      lat: 25.0230,
      lng: 121.5710,
      timeFrom: '15:00',
      timeTo: '17:00',
      category: ActivityCategory.nature,
      priority: ActivityPriority.medium,
      estimatedCost: '免費',
      tips: '建議穿著舒適的運動鞋，攜帶充足的水',
      address: '台北市信義區信義路五段150巷',
      rating: 4.2,
      suggestedDurationMinutes: 120,
    ),
    const Activity(
      id: 'taipei-activity-4',
      name: '饒河街夜市',
      description: '台北知名夜市，品嚐各種台灣小吃和街頭美食',
      lat: 25.0515,
      lng: 121.5776,
      timeFrom: '18:30',
      timeTo: '21:00',
      category: ActivityCategory.food,
      priority: ActivityPriority.high,
      estimatedCost: 'NT\$300-500',
      tips: '建議空腹前往，嘗試胡椒餅和藥燉排骨',
      address: '台北市松山區饒河街',
      rating: 4.1,
      suggestedDurationMinutes: 150,
    ),
  ];

  /// 建立範例活動列表 - 台北第二天
  static List<Activity> get taipeiDay2Activities => [
    const Activity(
      id: 'taipei-activity-5',
      name: '龍山寺',
      description: '台北最古老的寺廟之一，體驗傳統宗教文化',
      lat: 25.0367,
      lng: 121.4999,
      timeFrom: '09:00',
      timeTo: '10:30',
      category: ActivityCategory.culture,
      priority: ActivityPriority.high,
      estimatedCost: '免費',
      tips: '建議保持安靜，尊重宗教儀式',
      address: '台北市萬華區廣州街211號',
      rating: 4.4,
      suggestedDurationMinutes: 90,
    ),
    const Activity(
      id: 'taipei-activity-6',
      name: '華西街夜市',
      description: '歷史悠久的傳統夜市，品嚐道地台灣小吃',
      lat: 25.0374,
      lng: 121.4997,
      timeFrom: '11:00',
      timeTo: '13:00',
      category: ActivityCategory.food,
      priority: ActivityPriority.high,
      estimatedCost: 'NT\$400-600',
      tips: '嘗試蚵仔煎和臭豆腐等經典小吃',
      address: '台北市萬華區華西街',
      rating: 4.0,
      suggestedDurationMinutes: 120,
    ),
    const Activity(
      id: 'taipei-activity-7',
      name: '中正紀念堂',
      description: '台北重要的歷史建築，欣賞壯觀的建築設計',
      lat: 25.0361,
      lng: 121.5200,
      timeFrom: '14:30',
      timeTo: '16:30',
      category: ActivityCategory.culture,
      priority: ActivityPriority.medium,
      estimatedCost: '免費',
      tips: '整點有衛兵交接儀式，值得觀看',
      address: '台北市中正區中山南路21號',
      rating: 4.3,
      suggestedDurationMinutes: 120,
    ),
    const Activity(
      id: 'taipei-activity-8',
      name: '永康街',
      description: '文青聚集地，品嚐創意料理和傳統美食',
      lat: 25.0294,
      lng: 121.5287,
      timeFrom: '17:30',
      timeTo: '20:00',
      category: ActivityCategory.food,
      priority: ActivityPriority.high,
      estimatedCost: 'NT\$800-1200',
      tips: '必嚐芒果冰和牛肉麵',
      address: '台北市大安區永康街',
      rating: 4.2,
      suggestedDurationMinutes: 150,
    ),
  ];

  /// 建立範例活動列表 - 台北第三天
  static List<Activity> get taipeiDay3Activities => [
    const Activity(
      id: 'taipei-activity-9',
      name: '陽明山國家公園',
      description: '台北近郊的自然風光，欣賞火山地形和溫泉',
      lat: 25.1629,
      lng: 121.5654,
      timeFrom: '09:00',
      timeTo: '12:00',
      category: ActivityCategory.nature,
      priority: ActivityPriority.high,
      estimatedCost: '免費',
      tips: '建議穿著舒適的登山鞋，注意天氣變化',
      address: '台北市北投區竹子湖路',
      rating: 4.5,
      suggestedDurationMinutes: 180,
    ),
    const Activity(
      id: 'taipei-activity-10',
      name: '北投溫泉',
      description: '享受天然溫泉，放鬆身心',
      lat: 25.1372,
      lng: 121.5076,
      timeFrom: '13:30',
      timeTo: '16:00',
      category: ActivityCategory.outdoor,
      priority: ActivityPriority.high,
      estimatedCost: 'NT\$1200-1800',
      tips: '建議攜帶毛巾和換洗衣物',
      address: '台北市北投區中山路',
      rating: 4.4,
      suggestedDurationMinutes: 150,
    ),
    const Activity(
      id: 'taipei-activity-11',
      name: '淡水老街',
      description: '歷史悠久的老街，欣賞淡水河夕陽',
      lat: 25.1677,
      lng: 121.4406,
      timeFrom: '17:00',
      timeTo: '19:30',
      category: ActivityCategory.culture,
      priority: ActivityPriority.medium,
      estimatedCost: 'NT\$300-500',
      tips: '最佳夕陽觀賞時間約在18:00-18:30',
      address: '新北市淡水區中正路',
      rating: 4.1,
      suggestedDurationMinutes: 150,
    ),
    const Activity(
      id: 'taipei-activity-12',
      name: '士林夜市',
      description: '台北最大的夜市，品嚐各種台灣小吃',
      lat: 25.0881,
      lng: 121.5240,
      timeFrom: '20:00',
      timeTo: '22:30',
      category: ActivityCategory.food,
      priority: ActivityPriority.high,
      estimatedCost: 'NT\$500-800',
      tips: '必嚐大腸包小腸和雞排',
      address: '台北市士林區大東路、大南路',
      rating: 4.0,
      suggestedDurationMinutes: 150,
    ),
  ];

  /// 建立範例使用者偏好分析
  static UserPreferenceAnalysis get foodLoverAnalysis => UserPreferenceAnalysis(
    primaryFocus: '美食體驗',
    travelPace: TravelPace.slow,
    budgetRange: BudgetRange.mid,
    interests: const ['當地小吃', '傳統市場', '米其林餐廳', '夜市文化'],
    avoidances: const ['趕行程', '人擠人景點', '長時間排隊'],
    mood: '放鬆悠閒的美食探索',
    keywords: const ['美食', '放鬆', '文化', '傳統'],
    confidence: 0.92,
    analyzedAt: DateTime(2025, 1, 7, 10, 30),
  );

  /// 建立範例每日計畫
  static DayPlan get taipeiDay1Plan => DayPlan(
    dayIndex: 1,
    date: DateTime(2025, 10, 1),
    theme: '台北美食與地標探索',
    activities: taipeiDay1Activities,
    notes: '第一天以輕鬆的節奏探索台北，重點體驗當地美食文化',
    estimatedTotalCost: 'NT\$1700-2300',
  );

  /// 建立第二天行程
  static DayPlan get taipeiDay2Plan => DayPlan(
    dayIndex: 2,
    date: DateTime(2025, 10, 2),
    theme: '文化古蹟與傳統市場',
    activities: taipeiDay2Activities,
    notes: '第二天深入體驗台北的歷史文化和傳統市場',
    estimatedTotalCost: 'NT\$1200-1800',
  );

  /// 建立第三天行程
  static DayPlan get taipeiDay3Plan => DayPlan(
    dayIndex: 3,
    date: DateTime(2025, 10, 3),
    theme: '自然風光與溫泉體驗',
    activities: taipeiDay3Activities,
    notes: '第三天享受台北近郊的自然風光和溫泉放鬆',
    estimatedTotalCost: 'NT\$2000-2800',
  );

  /// 建立範例完整行程
  static Trip get taipeiTripExample => Trip(
    id: 'taipei-trip-example',
    title: '台北美食文化3日遊',
    destination: taipeiDestination,
    days: [taipeiDay1Plan, taipeiDay2Plan, taipeiDay3Plan],
    preferenceAnalysis: foodLoverAnalysis,
    createdAt: DateTime(2025, 1, 7, 10, 0),
    updatedAt: DateTime(2025, 1, 7, 10, 30),
    status: TripStatus.draft,
    generatedBy: 'gpt-4o',
    notes: '專為美食愛好者設計的台北深度體驗行程',
    isFavorite: false,
  );

  /// 建立範例行程請求
  static TripRequest get taipeiTripRequest => TripRequest(
    destination: taipeiDestination.name,
    days: 3,
    description: '我想要一趟放鬆的美食之旅，希望能品嚐當地特色小吃和傳統料理，不要太趕行程，喜歡慢慢體驗當地文化',
    preferences: TripPreferences(
      budget: 'mid',
      pace: 'slow',
      interests: ['food', 'culture'],
      companions: 2,
    ),
  );

  /// 建立文化愛好者的偏好分析
  static UserPreferenceAnalysis get cultureLoverAnalysis => const UserPreferenceAnalysis(
    primaryFocus: '文化體驗',
    travelPace: TravelPace.medium,
    budgetRange: BudgetRange.mid,
    interests: ['博物館', '歷史古蹟', '傳統建築', '藝術展覽'],
    avoidances: ['商業化景點', '過度觀光化'],
    mood: '深度文化探索',
    keywords: ['文化', '歷史', '藝術', '傳統'],
    confidence: 0.88,
  );

  /// 建立自然愛好者的偏好分析
  static UserPreferenceAnalysis get natureLoverAnalysis => const UserPreferenceAnalysis(
    primaryFocus: '自然體驗',
    travelPace: TravelPace.medium,
    budgetRange: BudgetRange.mid,
    interests: ['登山健行', '自然景觀', '生態觀察', '戶外活動'],
    avoidances: ['室內活動', '都市景點'],
    mood: '親近自然的戶外探險',
    keywords: ['自然', '戶外', '健行', '生態'],
    confidence: 0.85,
  );
}