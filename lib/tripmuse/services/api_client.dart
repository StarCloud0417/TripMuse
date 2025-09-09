/// TripMuse API 客戶端
/// 
/// 處理所有 HTTP 請求，包含認證、錯誤處理和重試機制

import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// API 回應包裝類別
class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.message,
  });

  final bool success;
  final T? data;
  final String? error;
  final String? message;

  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
    );
  }

  factory ApiResponse.error(String error, {String? message}) {
    return ApiResponse(
      success: false,
      error: error,
      message: message,
    );
  }
}

/// API 異常類別
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode, this.data});

  final String message;
  final int? statusCode;
  final dynamic data;

  @override
  String toString() => 'ApiException: $message';
}

/// 網路異常類別
class NetworkException implements Exception {
  const NetworkException(this.message);

  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

/// API 客戶端
class ApiClient {
  ApiClient({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
  }) : _dio = Dio() {
    _baseUrl = baseUrl ?? 'https://api.tripmuse.app';
    
    // 設定 Dio 配置
    _dio.options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: connectTimeout ?? const Duration(seconds: 30),
      receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // 添加攔截器
    _dio.interceptors.addAll([
      _AuthInterceptor(_secureStorage),
      _ErrorInterceptor(),
      _LogInterceptor(),
      RetryInterceptor(), // 添加重試攔截器
    ]);
  }

  final Dio _dio;
  late final String _baseUrl;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final Connectivity _connectivity = Connectivity();

  /// 檢查網路連線狀態
  Future<bool> get isConnected async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.mobile) ||
           connectivityResult.contains(ConnectivityResult.wifi) ||
           connectivityResult.contains(ConnectivityResult.ethernet);
  }

  /// 設定認證 Token
  Future<void> setAuthToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  /// 清除認證 Token
  Future<void> clearAuthToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  /// GET 請求
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      await _checkConnectivity();
      
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// POST 請求
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      await _checkConnectivity();
      
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// PUT 請求
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      await _checkConnectivity();
      
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// DELETE 請求
  Future<ApiResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      await _checkConnectivity();
      
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// 檢查網路連線
  Future<void> _checkConnectivity() async {
    if (!await isConnected) {
      throw const NetworkException('無網路連線');
    }
  }

  /// 處理回應
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    final data = response.data;
    
    if (response.statusCode != null && 
        response.statusCode! >= 200 && 
        response.statusCode! < 300) {
      
      if (data is Map<String, dynamic>) {
        // 標準 API 回應格式
        if (data.containsKey('success') && data['success'] == true) {
          final responseData = data['data'];
          
          if (fromJson != null && responseData is Map<String, dynamic>) {
            return ApiResponse.success(
              fromJson(responseData),
              message: data['message'],
            );
          } else {
            return ApiResponse.success(
              responseData as T,
              message: data['message'],
            );
          }
        } else {
          return ApiResponse.error(
            data['error'] ?? '未知錯誤',
            message: data['message'],
          );
        }
      } else {
        // 直接回傳資料
        return ApiResponse.success(data as T);
      }
    } else {
      throw ApiException(
        'HTTP ${response.statusCode}: ${response.statusMessage}',
        statusCode: response.statusCode,
        data: data,
      );
    }
  }

  /// 處理錯誤
  ApiResponse<T> _handleError<T>(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ApiResponse.error('請求超時，請檢查網路連線');
          
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data?['message'] ?? 
                         error.response?.statusMessage ?? 
                         '伺服器錯誤';
          return ApiResponse.error('HTTP $statusCode: $message');
          
        case DioExceptionType.cancel:
          return ApiResponse.error('請求已取消');
          
        case DioExceptionType.connectionError:
          return ApiResponse.error('網路連線錯誤');
          
        case DioExceptionType.badCertificate:
          return ApiResponse.error('SSL 憑證錯誤');
          
        case DioExceptionType.unknown:
          return ApiResponse.error('未知網路錯誤: ${error.message}');
      }
    } else if (error is NetworkException) {
      return ApiResponse.error(error.message);
    } else if (error is ApiException) {
      return ApiResponse.error(error.message);
    } else {
      return ApiResponse.error('未知錯誤: $error');
    }
  }
}

/// 認證攔截器
class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 添加認證 Token
    final token = await _secureStorage.read(key: 'auth_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // 添加請求 ID
    options.headers['X-Request-ID'] = 'req_${DateTime.now().millisecondsSinceEpoch}';

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 處理新的 Token
    final newToken = response.headers.value('X-New-Token');
    if (newToken != null) {
      _secureStorage.write(key: 'auth_token', value: newToken);
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 處理認證錯誤
    if (err.response?.statusCode == 401) {
      _secureStorage.delete(key: 'auth_token');
    }

    handler.next(err);
  }
}

/// 錯誤攔截器
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 記錄錯誤
    print('API Error: ${err.type} - ${err.message}');
    if (err.response != null) {
      print('Response: ${err.response?.statusCode} - ${err.response?.data}');
    }

    handler.next(err);
  }
}

/// 日誌攔截器
class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('API Request: ${options.method} ${options.uri}');
    if (options.data != null) {
      print('Request Data: ${options.data}');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('API Response: ${response.statusCode} ${response.requestOptions.uri}');
    print('Response Data: ${response.data}');

    handler.next(response);
  }
}

/// 重試攔截器
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  final int maxRetries;
  final Duration retryDelay;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;
    
    // 檢查是否應該重試
    if (_shouldRetry(err) && _getRetryCount(requestOptions) < maxRetries) {
      // 增加重試計數
      _incrementRetryCount(requestOptions);
      
      // 等待後重試
      await Future.delayed(retryDelay * _getRetryCount(requestOptions));
      
      try {
        final response = await Dio().fetch(requestOptions);
        handler.resolve(response);
      } catch (e) {
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    // 只重試特定類型的錯誤
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.connectionError ||
           (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }

  int _getRetryCount(RequestOptions options) {
    return options.extra['retry_count'] ?? 0;
  }

  void _incrementRetryCount(RequestOptions options) {
    options.extra['retry_count'] = _getRetryCount(options) + 1;
  }
}