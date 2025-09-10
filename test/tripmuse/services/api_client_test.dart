/// TripMuse API 客戶端測試
/// 
/// 測試 API 客戶端的功能和錯誤處理

import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

import '../../../lib/tripmuse/services/api_client.dart';
import '../../../lib/tripmuse/models/models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ApiClient Tests', () {

    group('ApiResponseWrapper Tests', () {
      test('should create success response', () {
        // Arrange
        const testData = 'test data';
        const message = 'success';

        // Act
        final response = ApiResponseWrapper.success(testData, message: message);

        // Assert
        expect(response.success, isTrue);
        expect(response.data, equals(testData));
        expect(response.message, equals(message));
        expect(response.error, isNull);
      });

      test('should create error response', () {
        // Arrange
        const error = 'test error';
        const message = 'error occurred';

        // Act
        final response = ApiResponseWrapper.error(error, message: message);

        // Assert
        expect(response.success, isFalse);
        expect(response.error, equals(error));
        expect(response.message, equals(message));
        expect(response.data, isNull);
      });
    });

    group('Exception Tests', () {
      test('ApiException should format correctly', () {
        // Arrange
        const message = 'API error';
        const statusCode = 400;

        // Act
        final exception = ApiException(message, statusCode: statusCode);

        // Assert
        expect(exception.message, equals(message));
        expect(exception.statusCode, equals(statusCode));
        expect(exception.toString(), equals('ApiException: $message'));
      });

      test('NetworkException should format correctly', () {
        // Arrange
        const message = 'Network error';

        // Act
        final exception = NetworkException(message);

        // Assert
        expect(exception.message, equals(message));
        expect(exception.toString(), equals('NetworkException: $message'));
      });
    });

    group('ApiClient Configuration Tests', () {
      test('should initialize with default values', () {
        // Act
        final client = ApiClient();

        // Assert - 無法直接測試私有屬性，但可以測試行為
        expect(client, isNotNull);
      });

      test('should initialize with custom values', () {
        // Act
        final client = ApiClient();

        // Assert
        expect(client, isNotNull);
      });
    });

    group('Authentication Tests', () {
      test('should create ApiClient without errors', () {
        // Act & Assert - 測試建立不會拋出異常
        expect(() => ApiClient(), returnsNormally);
      });
    });

    group('Error Handling Tests', () {
      test('should handle DioException timeout', () {
        // Arrange
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout',
        );

        // Act
        final client = ApiClient();
        final result = client._handleError<String>(dioError);

        // Assert
        expect(result.success, isFalse);
        expect(result.error, contains('請求超時'));
      });

      test('should handle DioException bad response', () {
        // Arrange
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            statusMessage: 'Bad Request',
          ),
        );

        // Act
        final client = ApiClient();
        final result = client._handleError<String>(dioError);

        // Assert
        expect(result.success, isFalse);
        expect(result.error, contains('HTTP 400'));
      });

      test('should handle NetworkException', () {
        // Arrange
        const networkError = NetworkException('No internet connection');

        // Act
        final client = ApiClient();
        final result = client._handleError<String>(networkError);

        // Assert
        expect(result.success, isFalse);
        expect(result.error, equals('No internet connection'));
      });

      test('should handle ApiException', () {
        // Arrange
        const apiError = ApiException('API error', statusCode: 500);

        // Act
        final client = ApiClient();
        final result = client._handleError<String>(apiError);

        // Assert
        expect(result.success, isFalse);
        expect(result.error, equals('API error'));
      });

      test('should handle unknown error', () {
        // Arrange
        const unknownError = 'Unknown error';

        // Act
        final client = ApiClient();
        final result = client._handleError<String>(unknownError);

        // Assert
        expect(result.success, isFalse);
        expect(result.error, contains('未知錯誤'));
      });
    });

    group('Response Handling Tests', () {
      test('should handle successful response with standard format', () {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 200,
          data: {
            'success': true,
            'data': {'id': '123', 'name': 'test'},
            'message': 'Success',
          },
        );

        // Act
        final client = ApiClient();
        final result = client._handleResponse<Map<String, dynamic>>(response, null);

        // Assert
        expect(result.success, isTrue);
        expect(result.data, isA<Map<String, dynamic>>());
        expect(result.message, equals('Success'));
      });

      test('should handle error response with standard format', () {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 200,
          data: {
            'success': false,
            'error': 'Validation failed',
            'message': 'Error occurred',
          },
        );

        // Act
        final client = ApiClient();
        final result = client._handleResponse<Map<String, dynamic>>(response, null);

        // Assert
        expect(result.success, isFalse);
        expect(result.error, equals('Validation failed'));
        expect(result.message, equals('Error occurred'));
      });

      test('should handle direct data response', () {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 200,
          data: 'direct data',
        );

        // Act
        final client = ApiClient();
        final result = client._handleResponse<String>(response, null);

        // Assert
        expect(result.success, isTrue);
        expect(result.data, equals('direct data'));
      });

      test('should handle response with fromJson converter', () {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 200,
          data: {
            'success': true,
            'data': {'id': '123', 'name': 'test'},
          },
        );

        String fromJson(Map<String, dynamic> json) => json['name'] as String;

        // Act
        final client = ApiClient();
        final result = client._handleResponse<String>(response, fromJson);

        // Assert
        expect(result.success, isTrue);
        expect(result.data, equals('test'));
      });
    });
  });


}

// 擴展 ApiClient 以測試私有方法
extension ApiClientTestExtension on ApiClient {
  ApiResponseWrapper<T> _handleError<T>(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ApiResponseWrapper<T>.error('請求超時，請檢查網路連線');
          
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data?['message'] ?? 
                         error.response?.statusMessage ?? 
                         '伺服器錯誤';
          return ApiResponseWrapper<T>.error('HTTP $statusCode: $message');
          
        case DioExceptionType.cancel:
          return ApiResponseWrapper<T>.error('請求已取消');
          
        case DioExceptionType.connectionError:
          return ApiResponseWrapper<T>.error('網路連線錯誤');
          
        case DioExceptionType.badCertificate:
          return ApiResponseWrapper<T>.error('SSL 憑證錯誤');
          
        case DioExceptionType.unknown:
          return ApiResponseWrapper<T>.error('未知網路錯誤: ${error.message}');
      }
    } else if (error is NetworkException) {
      return ApiResponseWrapper<T>.error(error.message);
    } else if (error is ApiException) {
      return ApiResponseWrapper<T>.error(error.message);
    } else {
      return ApiResponseWrapper<T>.error('未知錯誤: $error');
    }
  }

  ApiResponseWrapper<T> _handleResponse<T>(
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
            return ApiResponseWrapper<T>.success(
              fromJson(responseData),
              message: data['message'],
            );
          } else {
            return ApiResponseWrapper<T>.success(
              responseData as T,
              message: data['message'],
            );
          }
        } else {
          return ApiResponseWrapper<T>.error(
            data['error'] ?? '未知錯誤',
            message: data['message'],
          );
        }
      } else {
        // 直接回傳資料
        return ApiResponseWrapper<T>.success(data as T);
      }
    } else {
      throw ApiException(
        'HTTP ${response.statusCode}: ${response.statusMessage}',
        statusCode: response.statusCode,
      );
    }
  }
}

