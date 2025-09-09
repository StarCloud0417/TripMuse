/// TripMuse 行程 API 服務實作
/// 
/// 實作行程相關的 API 呼叫

import '../models/models.dart';
import 'api_client.dart';
import 'api_service.dart';

class TripApiServiceImpl implements TripApiService {
  TripApiServiceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<ApiResponse<Trip>> generateTrip(TripRequest request) async {
    try {
      // 驗證請求
      if (!request.isValid) {
        return ApiResponse.error('請求資料無效');
      }

      // 發送 API 請求
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/v1/trips/generate',
        data: request.toApiRequest(),
      );

      if (response.success && response.data != null) {
        // 解析回應資料
        final tripData = response.data!;
        final trip = Trip.fromJson(tripData);
        
        return ApiResponse.success(trip, message: response.message);
      } else {
        return ApiResponse.error(response.error ?? '生成行程失敗');
      }
    } catch (e) {
      return ApiResponse.error('生成行程時發生錯誤: $e');
    }
  }

  @override
  Future<ApiResponse<Trip>> getTrip(String tripId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v1/trips/$tripId',
      );

      if (response.success && response.data != null) {
        final trip = Trip.fromJson(response.data!);
        return ApiResponse.success(trip);
      } else {
        return ApiResponse.error(response.error ?? '取得行程失敗');
      }
    } catch (e) {
      return ApiResponse.error('取得行程時發生錯誤: $e');
    }
  }

  @override
  Future<ApiResponse<Trip>> updateTrip(Trip trip) async {
    try {
      final response = await _apiClient.put<Map<String, dynamic>>(
        '/api/v1/trips/${trip.id}',
        data: trip.toJson(),
      );

      if (response.success && response.data != null) {
        final updatedTrip = Trip.fromJson(response.data!);
        return ApiResponse.success(updatedTrip);
      } else {
        return ApiResponse.error(response.error ?? '更新行程失敗');
      }
    } catch (e) {
      return ApiResponse.error('更新行程時發生錯誤: $e');
    }
  }

  @override
  Future<ApiResponse<void>> deleteTrip(String tripId) async {
    try {
      final response = await _apiClient.delete<void>(
        '/api/v1/trips/$tripId',
      );

      if (response.success) {
        return ApiResponse.success(null, message: '行程已刪除');
      } else {
        return ApiResponse.error(response.error ?? '刪除行程失敗');
      }
    } catch (e) {
      return ApiResponse.error('刪除行程時發生錯誤: $e');
    }
  }

  @override
  Future<ApiResponse<List<Trip>>> getUserTrips({
    int? limit,
    int? offset,
    String? status,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (limit != null) queryParameters['limit'] = limit;
      if (offset != null) queryParameters['offset'] = offset;
      if (status != null) queryParameters['status'] = status;

      final response = await _apiClient.get<List<dynamic>>(
        '/api/v1/trips',
        queryParameters: queryParameters,
      );

      if (response.success && response.data != null) {
        final trips = response.data!
            .cast<Map<String, dynamic>>()
            .map((json) => Trip.fromJson(json))
            .toList();
        
        return ApiResponse.success(trips);
      } else {
        return ApiResponse.error(response.error ?? '取得行程列表失敗');
      }
    } catch (e) {
      return ApiResponse.error('取得行程列表時發生錯誤: $e');
    }
  }
}