import 'package:flutter_test/flutter_test.dart';
import 'package:tripmuse/core/exceptions/app_exceptions.dart';

void main() {
  group('App Exceptions Tests', () {
    test('NetworkException should have correct properties', () {
      const exception = NetworkException('Network error');
      
      expect(exception.message, equals('Network error'));
      expect(exception.code, equals('NETWORK_ERROR'));
      expect(exception.isRetryable, isTrue);
    });
    
    test('ServerException should have correct properties', () {
      const exception = ServerException('Server error');
      
      expect(exception.message, equals('Server error'));
      expect(exception.code, equals('SERVER_ERROR'));
      expect(exception.isRetryable, isTrue);
    });
    
    test('AuthException should have correct properties', () {
      const exception = AuthException('Auth error');
      
      expect(exception.message, equals('Auth error'));
      expect(exception.code, equals('AUTH_ERROR'));
      expect(exception.isRetryable, isFalse);
    });
    
    test('ValidationException should have correct properties', () {
      const exception = ValidationException('Validation error');
      
      expect(exception.message, equals('Validation error'));
      expect(exception.code, equals('VALIDATION_ERROR'));
      expect(exception.isRetryable, isFalse);
    });
    
    test('RateLimitException should have correct properties', () {
      const exception = RateLimitException('Rate limit error', 60);
      
      expect(exception.message, equals('Rate limit error'));
      expect(exception.code, equals('RATE_LIMIT_EXCEEDED'));
      expect(exception.isRetryable, isTrue);
      expect(exception.retryAfterSeconds, equals(60));
    });
    
    test('LLMGenerationException should have correct properties', () {
      const exception = LLMGenerationException('LLM error');
      
      expect(exception.message, equals('LLM error'));
      expect(exception.code, equals('LLM_GENERATION_FAILED'));
      expect(exception.isRetryable, isTrue);
    });
    
    test('CacheException should have correct properties', () {
      const exception = CacheException('Cache error');
      
      expect(exception.message, equals('Cache error'));
      expect(exception.code, equals('CACHE_ERROR'));
      expect(exception.isRetryable, isFalse);
    });
    
    test('UnknownException should have correct properties', () {
      const exception = UnknownException('Unknown error');
      
      expect(exception.message, equals('Unknown error'));
      expect(exception.code, equals('UNKNOWN_ERROR'));
      expect(exception.isRetryable, isFalse);
    });
  });
}