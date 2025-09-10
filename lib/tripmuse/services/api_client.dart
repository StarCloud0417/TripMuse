import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/models.dart';
import 'api_config.dart';

// API 客戶端異常類別
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? code;

  const ApiException(this.message, {this.statusCode, this.code});

  @override
  String toString() => 'ApiException: $message';
}

class NetworkException extends ApiException {
  const NetworkException(String message) : super(message, code: 'NETWORK_ERROR');

  @override
  String toString() => 'NetworkException: $message';
}

class ServerException extends ApiException {
  const ServerException(String message, {int? statusCode})
      : super(message, statusCode: statusCode, code: 'SERVER_ERROR');
}

// API 客戶端服務
class ApiClient {
  late final Dio _dio;
  
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // 添加攔截器
    _dio.interceptors.add(_createInterceptor());
    
    // 開發模式日誌
    if (ApiConfig.isDevelopment) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
      ));
    }
  }

  // 建立請求攔截器
  InterceptorsWrapper _createInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 檢查網路連線
        final connectivity = await Connectivity().checkConnectivity();
        if (connectivity == ConnectivityResult.none) {
          throw const NetworkException('無網路連線');
        }

        // 在開發模式中添加測試 token
        if (ApiConfig.isDevelopment) {
          options.headers['Authorization'] = 'Bearer ${ApiConfig.devToken}';
        }

        print('🌐 API Request: ${options.method} ${options.uri}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ API Response: ${response.statusCode} ${response.requestOptions.uri}');
        handler.next(response);
      },
      onError: (error, handler) {
        print('❌ API Error: ${error.message}');
        final apiException = _handleDioError(error);
        handler.reject(DioException(
          requestOptions: error.requestOptions,
          error: apiException,
          message: apiException.message,
        ));
      },
    );
  }

  // 處理 Dio 錯誤
  ApiException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('請求超時，請檢查網路連線');
      
      case DioExceptionType.connectionError:
        return const NetworkException('網路連線錯誤');
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['error'] ?? '伺服器錯誤';
        return ServerException(message, statusCode: statusCode);
      
      case DioExceptionType.cancel:
        return const ApiException('請求已取消');
      
      default:
        return ApiException('未知錯誤: ${error.message}');
    }
  }

  // 健康檢查
  Future<HealthResponse> checkHealth() async {
    try {
      final response = await _dio.get(ApiConfig.healthEndpoint);
      return HealthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw e.error as ApiException;
    }
  }

  // 生成行程
  Future<Trip> generateTrip(TripRequest request) async {
    try {
      print('🎯 Generating trip for: ${request.destination}, ${request.days} days');
      
      final response = await _dio.post(
        ApiConfig.generateTripEndpoint,
        data: request.toJson(),
      );

      if (response.data['success'] == true) {
        final tripData = response.data['trip'];
        print('📋 Trip data received: ${tripData.toString().substring(0, 200)}...');
        
        try {
          return Trip.fromJson(tripData);
        } catch (parseError, stackTrace) {
          print('❌ JSON parsing error: $parseError');
          print('Stack trace: $stackTrace');
          print('Raw trip data: $tripData');
          throw ApiException('JSON 解析失敗: $parseError');
        }
      } else {
        throw ServerException(response.data['error'] ?? '行程生成失敗');
      }
    } on DioException catch (e) {
      throw e.error as ApiException;
    }
  }

  // 搜尋地點
  Future<List<Place>> searchPlaces(String query, {String? location, int? radius}) async {
    try {
      print('🔍 Searching places: $query');
      
      final queryParams = <String, dynamic>{
        'q': query,
      };
      
      if (location != null) queryParams['location'] = location;
      if (radius != null) queryParams['radius'] = radius;

      final response = await _dio.get(
        ApiConfig.searchPlacesEndpoint,
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        final placesData = response.data['places'] as List;
        return placesData.map((json) => Place.fromJson(json)).toList();
      } else {
        throw ServerException(response.data['error'] ?? '地點搜尋失敗');
      }
    } on DioException catch (e) {
      throw e.error as ApiException;
    }
  }

  // 取得地圖配置
  Future<MapConfig> getMapConfig() async {
    try {
      print('🗺️ Getting map config');
      
      final response = await _dio.get(ApiConfig.mapConfigEndpoint);

      if (response.data['success'] == true) {
        final configData = response.data['config'];
        return MapConfig.fromJson(configData);
      } else {
        throw ServerException(response.data['error'] ?? '地圖配置取得失敗');
      }
    } on DioException catch (e) {
      throw e.error as ApiException;
    }
  }

  // 通用 GET 方法
  Future<Map<String, dynamic>> get(String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw e.error as ApiException;
    }
  }

  // 通用 POST 方法
  Future<Map<String, dynamic>> post(String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(endpoint, data: data, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw e.error as ApiException;
    }
  }

  // 通用 PUT 方法
  Future<Map<String, dynamic>> put(String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put(endpoint, data: data, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw e.error as ApiException;
    }
  }

  // 通用 DELETE 方法
  Future<Map<String, dynamic>> delete(String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete(endpoint, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw e.error as ApiException;
    }
  }
}

// Riverpod Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});