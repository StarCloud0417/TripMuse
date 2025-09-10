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
  Future<ApiResponseWrapper<Trip>> generateTrip(TripRequest request) async {
    try {
      final trip = await _apiClient.generateTrip(request);
      return ApiResponseWrapper.success(trip, message: '行程生成成功');
    } catch (e) {
      return ApiResponseWrapper.error(
        e.toString(),
        message: '行程生成失敗'
      );
    }
  }

  @override
  Future<ApiResponseWrapper<Trip>> getTrip(String tripId) async {
    try {
      final response = await _apiClient.get('/api/v1/trips/$tripId');
      if (response['success'] == true) {
        final tripData = response['trip'];
        final trip = Trip.fromJson(tripData);
        return ApiResponseWrapper.success(trip, message: '取得行程成功');
      } else {
        return ApiResponseWrapper.error(response['error'] ?? '取得行程失敗');
      }
    } catch (e) {
      return ApiResponseWrapper.error('取得行程時發生錯誤: $e');
    }
  }

  @override
  Future<ApiResponseWrapper<Trip>> updateTrip(Trip trip) async {
    try {
      final response = await _apiClient.put(
        '/api/v1/trips/${trip.id}',
        data: trip.toJson(),
      );

      if (response['success'] == true) {
        final tripData = response['trip'];
        final updatedTrip = Trip.fromJson(tripData);
        return ApiResponseWrapper.success(updatedTrip, message: '更新行程成功');
      } else {
        return ApiResponseWrapper.error(response['error'] ?? '更新行程失敗');
      }
    } catch (e) {
      return ApiResponseWrapper.error('更新行程時發生錯誤: $e');
    }
  }

  @override
  Future<ApiResponseWrapper<void>> deleteTrip(String tripId) async {
    try {
      final response = await _apiClient.delete('/api/v1/trips/$tripId');

      if (response['success'] == true) {
        return ApiResponseWrapper.success(null, message: '行程已刪除');
      } else {
        return ApiResponseWrapper.error(response['error'] ?? '刪除行程失敗');
      }
    } catch (e) {
      return ApiResponseWrapper.error('刪除行程時發生錯誤: $e');
    }
  }

  @override
  Future<ApiResponseWrapper<List<Trip>>> getUserTrips({
    int? limit,
    int? offset,
    String? status,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (limit != null) queryParameters['limit'] = limit;
      if (offset != null) queryParameters['offset'] = offset;
      if (status != null) queryParameters['status'] = status;

      final response = await _apiClient.get(
        '/api/v1/trips',
        queryParameters: queryParameters,
      );

      if (response['success'] == true) {
        final tripsData = response['trips'] as List;
        final trips = tripsData
            .cast<Map<String, dynamic>>()
            .map((json) => Trip.fromJson(json))
            .toList();

        return ApiResponseWrapper.success(trips, message: '取得行程列表成功');
      } else {
        return ApiResponseWrapper.error(response['error'] ?? '取得行程列表失敗');
      }
    } catch (e) {
      return ApiResponseWrapper.error('取得行程列表時發生錯誤: $e');
    }
  }
}