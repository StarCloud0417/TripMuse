/// TripMuse API 服務介面
/// 
/// 定義所有 API 服務的抽象介面

import '../models/models.dart';

/// 行程 API 服務介面
abstract class TripApiService {
  /// 生成行程
  Future<ApiResponseWrapper<Trip>> generateTrip(TripRequest request);

  /// 取得行程詳情
  Future<ApiResponseWrapper<Trip>> getTrip(String tripId);

  /// 更新行程
  Future<ApiResponseWrapper<Trip>> updateTrip(Trip trip);

  /// 刪除行程
  Future<ApiResponseWrapper<void>> deleteTrip(String tripId);

  /// 取得使用者所有行程
  Future<ApiResponseWrapper<List<Trip>>> getUserTrips({
    int? limit,
    int? offset,
    String? status,
  });
}

/// 使用者 API 服務介面
abstract class UserApiService {
  /// 使用者註冊
  Future<ApiResponseWrapper<User>> register(Map<String, dynamic> userData);

  /// 使用者登入
  Future<ApiResponseWrapper<User>> login(String email, String password);

  /// Google 登入
  Future<ApiResponseWrapper<User>> loginWithGoogle(String idToken);

  /// 登出
  Future<ApiResponseWrapper<void>> logout();

  /// 取得使用者資料
  Future<ApiResponseWrapper<User>> getProfile();

  /// 更新使用者資料
  Future<ApiResponseWrapper<User>> updateProfile(User user);

  /// 更新使用者偏好
  Future<ApiResponseWrapper<UserPreferences>> updatePreferences(UserPreferences preferences);
}

/// Places API 服務介面
abstract class PlacesApiService {
  /// 搜尋地點
  Future<ApiResponseWrapper<List<Destination>>> searchPlaces(String query, {
    String? language,
    String? region,
  });

  /// 取得地點詳情
  Future<ApiResponseWrapper<Destination>> getPlaceDetails(String placeId);

  /// 自動補全
  Future<ApiResponseWrapper<List<Destination>>> autocomplete(String input, {
    String? language,
    String? region,
  });
}

/// 分析 API 服務介面
abstract class AnalyticsApiService {
  /// 記錄事件
  Future<ApiResponseWrapper<void>> logEvent(String eventName, Map<String, dynamic> parameters);

  /// 記錄頁面瀏覽
  Future<ApiResponseWrapper<void>> logPageView(String pageName);

  /// 記錄錯誤
  Future<ApiResponseWrapper<void>> logError(String error, Map<String, dynamic>? context);
}