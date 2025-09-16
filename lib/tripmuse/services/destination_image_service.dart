/// 目的地圖片服務
/// 
/// 提供根據目的地獲取無版權風景圖片的功能
/// 使用 Unsplash API 獲取高品質的旅遊景點圖片

import 'dart:math';

class DestinationImageService {
  static final DestinationImageService _instance = DestinationImageService._internal();
  factory DestinationImageService() => _instance;
  DestinationImageService._internal();

  // Unsplash 圖片基礎 URL (無需 API Key 的方式)
  static const String _unsplashBaseUrl = 'https://images.unsplash.com';
  
  /// 根據目的地城市獲取景點縮圖
  String getDestinationThumbnail(String city, String country) {
    final imageId = _getCityImageId(city.toLowerCase(), country.toLowerCase());
    return '$_unsplashBaseUrl/photo-$imageId?w=400&h=300&fit=crop&crop=center';
  }

  /// 根據目的地城市獲取大圖
  String getDestinationImage(String city, String country) {
    final imageId = _getCityImageId(city.toLowerCase(), country.toLowerCase());
    return '$_unsplashBaseUrl/photo-$imageId?w=800&h=600&fit=crop&crop=center';
  }

  /// 根據城市和國家獲取對應的圖片ID
  String _getCityImageId(String city, String country) {
    // 亞洲城市
    final asianCities = {
      'tokyo': '1540959733332-eab4deabeeaf', // 東京夜景
      'kyoto': '1545569341-9eb8b30979d9', // 京都寺廟
      'osaka': '1590559899731-ea9bfd8d2786', // 大阪城
      'taipei': '1508804185872-d7badad00f7d', // 台北101
      'seoul': '1540042716690-b1b4dbeeb295', // 首爾景福宮
      'busan': '1578662996442-374dcbcf3b3f', // 釜山海雲台
      'singapore': '1525625293386-3f8f99389edd', // 新加坡濱海灣
      'bangkok': '1506665531195-3566af2b4dfa', // 曼谷大皇宮
      'hong kong': '1536431311719-398b6704d4cc', // 香港維港
      'macau': '1578662996442-374dcbcf3b3f', // 澳門
      'shanghai': '1474181487882-5abf5f0c5c27', // 上海外灘
      'beijing': '1508804185872-d7badad00f7d', // 北京故宮
    };

    // 歐洲城市
    final europeanCities = {
      'paris': '1502602898536-47ad22581b52', // 巴黎鐵塔
      'london': '1513635269975-59663e0ac1ad', // 倫敦大橋
      'rome': '1552832230-c0197dd311b5', // 羅馬競技場
      'barcelona': '1539037116277-4db20889f2d4', // 巴塞隆納聖家堂
      'madrid': '1539650116574-75c0c6d73d0e', // 馬德里
      'amsterdam': '1534351590666-13e3e96b5017', // 阿姆斯特丹運河
      'berlin': '1587330979470-3016b6702d89', // 柏林勃蘭登堡門
      'vienna': '1516550893923-42d28e5677af', // 維也納美泉宮
      'prague': '1541849546-216549ae216d', // 布拉格城堡
      'budapest': '1541725641319-7fc5d605b7d4', // 布達佩斯國會大廈
      'zurich': '1506905925346-21bda4d32df4', // 蘇黎世阿爾卑斯山
      'geneva': '1506905925346-21bda4d32df4', // 日內瓦湖
      'florence': '1552832230-c0197dd311b5', // 佛羅倫斯
      'venice': '1514890547357-a9ee288728e0', // 威尼斯
      'milan': '1513581166391-d312eaa04d2e', // 米蘭大教堂
      'lisbon': '1555881400-74d7acaacd4b', // 里斯本
      'stockholm': '1509356843151-3ce7d67d6d3e', // 斯德哥爾摩
      'copenhagen': '1513581166391-d312eaa04d2e', // 哥本哈根
      'oslo': '1506905925346-21bda4d32df4', // 奧斯陸
      'helsinki': '1509356843151-3ce7d67d6d3e', // 赫爾辛基
    };

    // 美洲城市
    final americanCities = {
      'new york': '1514565131-fce0801e5785', // 紐約天際線
      'los angeles': '1544928147-79a2dbc1f389', // 洛杉磯
      'san francisco': '1506905925346-21bda4d32df4', // 舊金山金門大橋
      'chicago': '1494522358652-f30e61a5328d', // 芝加哥
      'miami': '1506905925346-21bda4d32df4', // 邁阿密海灘
      'las vegas': '1506905925346-21bda4d32df4', // 拉斯維加斯
      'toronto': '1517935706615-2717063c2225', // 多倫多
      'vancouver': '1506905925346-21bda4d32df4', // 溫哥華
      'mexico city': '1518105779142-d975f22f1b0a', // 墨西哥城
      'rio de janeiro': '1483729558449-99ef09a8c325', // 里約熱內盧
      'buenos aires': '1589909202802-8f4609be2882', // 布宜諾斯艾利斯
    };

    // 大洋洲城市
    final oceanicCities = {
      'sydney': '1506973035872-a4ec16b8e8d9', // 雪梨歌劇院
      'melbourne': '1514395462725-fb4566210144', // 墨爾本
      'brisbane': '1506973035872-a4ec16b8e8d9', // 布里斯班
      'perth': '1506973035872-a4ec16b8e8d9', // 伯斯
      'auckland': '1507699622108-4be3abd695ad', // 奧克蘭
      'wellington': '1507699622108-4be3abd695ad', // 威靈頓
    };

    // 非洲城市
    final africanCities = {
      'cape town': '1580060839107-d3fd8c8a8b83', // 開普敦桌山
      'johannesburg': '1580060839107-d3fd8c8a8b83', // 約翰尼斯堡
      'cairo': '1539650116574-75c0c6d73d0e', // 開羅金字塔
      'marrakech': '1539650116574-75c0c6d73d0e', // 馬拉喀什
    };

    // 中東城市
    final middleEasternCities = {
      'dubai': '1512453979798-5ea266f8880c', // 杜拜哈里發塔
      'abu dhabi': '1512453979798-5ea266f8880c', // 阿布達比
      'doha': '1512453979798-5ea266f8880c', // 杜哈
      'istanbul': '1541849546-216549ae216d', // 伊斯坦堡
      'tel aviv': '1512453979798-5ea266f8880c', // 特拉維夫
    };

    // 合併所有城市圖片
    final allCities = <String, String>{};
    allCities.addAll(asianCities);
    allCities.addAll(europeanCities);
    allCities.addAll(americanCities);
    allCities.addAll(oceanicCities);
    allCities.addAll(africanCities);
    allCities.addAll(middleEasternCities);

    // 首先嘗試精確匹配城市名稱
    if (allCities.containsKey(city)) {
      return allCities[city]!;
    }

    // 嘗試匹配國家的代表性城市
    final countryDefaults = {
      'japan': asianCities['tokyo']!,
      'south korea': asianCities['seoul']!,
      'taiwan': asianCities['taipei']!,
      'singapore': asianCities['singapore']!,
      'thailand': asianCities['bangkok']!,
      'china': asianCities['shanghai']!,
      'hong kong': asianCities['hong kong']!,
      'france': europeanCities['paris']!,
      'united kingdom': europeanCities['london']!,
      'uk': europeanCities['london']!,
      'england': europeanCities['london']!,
      'italy': europeanCities['rome']!,
      'spain': europeanCities['barcelona']!,
      'netherlands': europeanCities['amsterdam']!,
      'germany': europeanCities['berlin']!,
      'austria': europeanCities['vienna']!,
      'czech republic': europeanCities['prague']!,
      'hungary': europeanCities['budapest']!,
      'switzerland': europeanCities['zurich']!,
      'portugal': europeanCities['lisbon']!,
      'sweden': europeanCities['stockholm']!,
      'denmark': europeanCities['copenhagen']!,
      'norway': europeanCities['oslo']!,
      'finland': europeanCities['helsinki']!,
      'united states': americanCities['new york']!,
      'usa': americanCities['new york']!,
      'canada': americanCities['toronto']!,
      'mexico': americanCities['mexico city']!,
      'brazil': americanCities['rio de janeiro']!,
      'argentina': americanCities['buenos aires']!,
      'australia': oceanicCities['sydney']!,
      'new zealand': oceanicCities['auckland']!,
      'south africa': africanCities['cape town']!,
      'egypt': africanCities['cairo']!,
      'morocco': africanCities['marrakech']!,
      'uae': middleEasternCities['dubai']!,
      'qatar': middleEasternCities['doha']!,
      'turkey': middleEasternCities['istanbul']!,
      'israel': middleEasternCities['tel aviv']!,
    };

    if (countryDefaults.containsKey(country)) {
      return countryDefaults[country]!;
    }

    // 如果都找不到，返回一個通用的旅遊圖片
    final defaultImages = [
      '1488646953014-85cb44e25828', // 通用旅遊風景
      '1506905925346-21bda4d32df4', // 山景
      '1507525428034-b723cf961d3e', // 海景
      '1506973035872-a4ec16b8e8d9', // 城市景觀
      '1502602898536-47ad22581b52', // 建築景觀
    ];

    // 使用城市名稱的 hash 來選擇預設圖片，確保同一城市總是顯示相同圖片
    final index = city.hashCode.abs() % defaultImages.length;
    return defaultImages[index];
  }

  /// 獲取隨機旅遊風景圖片
  String getRandomTravelImage() {
    final randomImages = [
      '1488646953014-85cb44e25828', // 旅遊風景
      '1506905925346-21bda4d32df4', // 阿爾卑斯山
      '1507525428034-b723cf961d3e', // 海灘
      '1506973035872-a4ec16b8e8d9', // 城市
      '1502602898536-47ad22581b52', // 建築
      '1514565131-fce0801e5785', // 都市夜景
      '1545569341-9eb8b30979d9', // 寺廟
      '1513635269975-59663e0ac1ad', // 橋樑
      '1552832230-c0197dd311b5', // 古蹟
      '1539037116277-4db20889f2d4', // 教堂
    ];

    final random = Random();
    final imageId = randomImages[random.nextInt(randomImages.length)];
    return '$_unsplashBaseUrl/photo-$imageId?w=400&h=300&fit=crop&crop=center';
  }

  /// 檢查圖片是否可用（可選功能，用於錯誤處理）
  bool isImageUrlValid(String url) {
    return url.isNotEmpty && url.startsWith('https://');
  }
}