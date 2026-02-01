import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../exceptions/app_exceptions.dart';
import 'logger_service.dart';

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final LoggerService _logger;
  
  static const String baseUrl = 'https://api.tripmind.app'; // Replace with actual API URL
  static const String _tokenKey = 'jwt_token';
  static const String _refreshTokenKey = 'refresh_token';
  
  ApiClient(this._dio, this._secureStorage, this._logger) {
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    // Request interceptor to add authentication token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add base URL
        if (!options.path.startsWith('http')) {
          options.path = '$baseUrl${options.path}';
        }
        
        // Add authentication token
        final token = await _secureStorage.read(key: _tokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        
        // Add common headers
        options.headers['Content-Type'] = 'application/json';
        options.headers['Accept'] = 'application/json';
        
        _logger.debug('API Request: ${options.method} ${options.path}');
        handler.next(options);
      },
      
      onResponse: (response, handler) {
        _logger.debug('API Response: ${response.statusCode} ${response.requestOptions.path}');
        handler.next(response);
      },
      
      onError: (error, handler) async {
        _logger.error('API Error: ${error.requestOptions.path}', error);
        
        // Handle token refresh for 401 errors
        if (error.response?.statusCode == 401) {
          final refreshed = await _refreshToken();
          if (refreshed) {
            // Retry the original request
            final options = error.requestOptions;
            final token = await _secureStorage.read(key: _tokenKey);
            options.headers['Authorization'] = 'Bearer $token';
            
            try {
              final response = await _dio.fetch(options);
              handler.resolve(response);
              return;
            } catch (e) {
              // If retry fails, continue with original error
            }
          }
        }
        
        handler.next(error);
      },
    ));
  }
  
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
      if (refreshToken == null) return false;
      
      final response = await _dio.post(
        '$baseUrl/api/v1/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {'Authorization': null}, // Don't include expired token
        ),
      );
      
      final newToken = response.data['jwt_token'];
      final newRefreshToken = response.data['refresh_token'];
      
      if (newToken != null) {
        await _secureStorage.write(key: _tokenKey, value: newToken);
        if (newRefreshToken != null) {
          await _secureStorage.write(key: _refreshTokenKey, value: newRefreshToken);
        }
        return true;
      }
    } catch (e) {
      _logger.error('Token refresh failed', e);
      // Clear invalid tokens
      await _clearTokens();
    }
    
    return false;
  }
  
  Future<void> _clearTokens() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }
  
  // HTTP Methods
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }
  
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }
  
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }
  
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }
  
  AppException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('連線逾時，請檢查網路連線');
      case DioExceptionType.badResponse:
        return _handleHttpError(e);
      case DioExceptionType.cancel:
        return NetworkException('請求已取消');
      case DioExceptionType.connectionError:
        return NetworkException('網路連線錯誤，請檢查網路設定');
      case DioExceptionType.badCertificate:
        return NetworkException('SSL 憑證錯誤');
      case DioExceptionType.unknown:
        return NetworkException('網路請求失敗：${e.message}');
    }
  }
  
  AppException _handleHttpError(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = error.response?.data?['message'] ?? error.message;
    
    switch (statusCode) {
      case 400:
        return ValidationException('請求參數錯誤：$message');
      case 401:
        return AuthException('認證失敗，請重新登入');
      case 403:
        return AuthException('權限不足');
      case 404:
        return NetworkException('請求的資源不存在');
      case 429:
        final retryAfter = _extractRetryAfter(error.response);
        return RateLimitException('請求過於頻繁，請稍後再試', retryAfter);
      case 500:
        return ServerException('伺服器內部錯誤');
      case 502:
      case 503:
      case 504:
        return ServerException('伺服器暫時無法使用，請稍後再試');
      default:
        return NetworkException('HTTP 錯誤 ($statusCode)：$message');
    }
  }
  
  int _extractRetryAfter(Response? response) {
    final retryAfterHeader = response?.headers['retry-after']?.first;
    if (retryAfterHeader != null) {
      return int.tryParse(retryAfterHeader) ?? 60;
    }
    return 60;
  }
}