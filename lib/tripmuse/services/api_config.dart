// API 配置檔案
class ApiConfig {
  // GCP Cloud Run 服務 URL
  static const String baseUrl = 'https://tripmuse-api-524082478309.asia-east1.run.app';
  
  // API 端點
  static const String healthEndpoint = '/health';
  static const String generateTripEndpoint = '/api/v1/generate-trip';
  static const String searchPlacesEndpoint = '/api/v1/places/search';
  static const String mapConfigEndpoint = '/api/v1/map/config';
  
  // 請求設定
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(minutes: 3); // 增加到 3 分鐘給 LLM 處理
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // 開發模式設定
  static const bool isDevelopment = true;
  static const String devToken = 'dev-token'; // 開發用 token
  
  // 完整 URL 建構器
  static String get healthUrl => '$baseUrl$healthEndpoint';
  static String get generateTripUrl => '$baseUrl$generateTripEndpoint';
  static String get searchPlacesUrl => '$baseUrl$searchPlacesEndpoint';
  static String get mapConfigUrl => '$baseUrl$mapConfigEndpoint';
}