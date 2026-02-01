import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../exceptions/app_exceptions.dart';
import 'logger_service.dart';

class ErrorHandler {
  final LoggerService _logger;
  
  ErrorHandler(this._logger);
  
  /// Handle Dio network errors and convert them to AppExceptions
  AppException handleDioError(DioException error) {
    _logger.error('Dio error occurred', error, error.stackTrace);
    
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('連線逾時，請檢查網路連線');
        
      case DioExceptionType.badResponse:
        return _handleHttpError(error);
        
      case DioExceptionType.cancel:
        return NetworkException('請求已取消');
        
      case DioExceptionType.connectionError:
        return NetworkException('網路連線錯誤，請檢查網路設定');
        
      case DioExceptionType.badCertificate:
        return NetworkException('SSL 憑證錯誤');
        
      case DioExceptionType.unknown:
        return NetworkException('網路請求失敗：${error.message}');
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
    return 60; // Default to 60 seconds
  }
  
  /// Handle general exceptions and convert them to AppExceptions
  AppException handleException(Object error, StackTrace stackTrace) {
    _logger.error('Unhandled exception occurred', error, stackTrace);
    
    if (error is AppException) {
      return error;
    }
    
    if (error is DioException) {
      return handleDioError(error);
    }
    
    return UnknownException('發生未知錯誤：${error.toString()}');
  }
  
  /// Show error to user with appropriate UI feedback
  void showError(BuildContext context, AppException error) {
    final messenger = ScaffoldMessenger.of(context);
    
    switch (error) {
      case NetworkException _:
        _showRetryableError(messenger, error);
        break;
      case RateLimitException _:
        _showRateLimitError(messenger, error);
        break;
      case ValidationException _:
        _showValidationError(messenger, error);
        break;
      case AuthException _:
        _showAuthError(context, error);
        break;
      default:
        _showGenericError(messenger, error);
    }
  }
  
  void _showRetryableError(ScaffoldMessengerState messenger, AppException error) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(error.message),
        action: SnackBarAction(
          label: '重試',
          onPressed: () {
            // Retry logic would be handled by the calling widget
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }
  
  void _showRateLimitError(ScaffoldMessengerState messenger, RateLimitException error) {
    messenger.showSnackBar(
      SnackBar(
        content: Text('${error.message}\n預估等待時間：${error.retryAfterSeconds} 秒'),
        duration: Duration(seconds: error.retryAfterSeconds.clamp(3, 10)),
      ),
    );
  }
  
  void _showValidationError(ScaffoldMessengerState messenger, AppException error) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(error.message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 4),
      ),
    );
  }
  
  void _showAuthError(BuildContext context, AppException error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('認證錯誤'),
        content: Text(error.message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to login screen
              // Navigator.of(context).pushReplacementNamed('/login');
            },
            child: const Text('重新登入'),
          ),
        ],
      ),
    );
  }
  
  void _showGenericError(ScaffoldMessengerState messenger, AppException error) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(error.message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}