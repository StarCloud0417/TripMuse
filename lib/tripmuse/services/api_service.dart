/// TripMuse API 服務介面
/// 
/// 定義所有 API 服務的抽象介面

import '../models/models.dart';
import 'api_client.dart';

/// 行程 API 服務介面
abstract class TripApiService {
  /// 生成行程
  Future<ApiResponse<Trip>> generateTrip(TripRequest request);
  
  /// 取得行程詳情
  Future<ApiResponse<Trip>> getTrip(String tripId);
  
  /// 更新行程
  Future<ApiResponse<Trip>> updateTrip(Trip trip);
  
  /// 刪除行程
  Future<ApiResponse<void>> deleteTrip(String tripId);
  
  /// 取得使用者所有行程
  Future<ApiResponse<List<Trip>>> getUserTrips({
    int? limit,
    int? offset,
    String? status,
  });
}

/// 使用者 API 服務介面
abstract class UserApiService {
  /// 使用者註冊
  Future<ApiResponse<User>> register(Map<String, dynamic> userData);
  
  /// 使用者登入
  Future<ApiResponse<User>> login(String email, String password);
  
  /// Google 登入
  Future<ApiResponse<User>> loginWithGoogle(String idToken);
  
  /// 登出
  Future<ApiResponse<void>> logout();
  
  /// 取得使用者資料
  Future<ApiResponse<User>> getProfile();
  
  /// 更新使用者資料
  Future<ApiResponse<User>> updateProfile(User user);
  
  /// 更新使用者偏好
  Future<ApiResponse<UserPreferences>> updatePreferences(UserPreferences preferences);
}

/// Places API 服務介面
abstract class PlacesApiService {
  /// 搜尋地點
  Future<ApiResponse<List<Destination>>> searchPlaces(String query, {
    String? language,
    String? region,
  });
  
  /// 取得地點詳情
  Future<ApiResponse<Destination>> getPlaceDetails(String placeId);
  
  /// 自動補全
  Future<ApiResponse<List<Destination>>> autocomplete(String input, {
    String? language,
    String? region,
  });
}

/// 分析 API 服務介面
abstract class AnalyticsApiService {
  /// 記錄事件
  Future<ApiResponse<void>> logEvent(String eventName, Map<String, dynamic> parameters);
  
  /// 記錄頁面瀏覽
  Future<ApiResponse<void>> logPageView(String pageName);
  
  /// 記錄錯誤
  Future<ApiResponse<void>> logError(String error, Map<String, dynamic>? context);
}