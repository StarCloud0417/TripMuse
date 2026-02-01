/// Base class for all application exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final bool isRetryable;
  
  const AppException(this.message, {this.code, this.isRetryable = false});
  
  @override
  String toString() => 'AppException: $message';
}

/// Network related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message) : 
    super(code: 'NETWORK_ERROR', isRetryable: true);
}

/// Server related exceptions
class ServerException extends AppException {
  const ServerException(super.message) : 
    super(code: 'SERVER_ERROR', isRetryable: true);
}

/// Authentication related exceptions
class AuthException extends AppException {
  const AuthException(super.message) : 
    super(code: 'AUTH_ERROR', isRetryable: false);
}

/// Validation related exceptions
class ValidationException extends AppException {
  const ValidationException(super.message) : 
    super(code: 'VALIDATION_ERROR', isRetryable: false);
}

/// Rate limiting exceptions
class RateLimitException extends AppException {
  final int retryAfterSeconds;
  
  const RateLimitException(super.message, this.retryAfterSeconds) : 
    super(code: 'RATE_LIMIT_EXCEEDED', isRetryable: true);
}

/// LLM generation related exceptions
class LLMGenerationException extends AppException {
  const LLMGenerationException(super.message) : 
    super(code: 'LLM_GENERATION_FAILED', isRetryable: true);
}

/// Cache related exceptions
class CacheException extends AppException {
  const CacheException(super.message) : 
    super(code: 'CACHE_ERROR', isRetryable: false);
}

/// Storage related exceptions
class StorageException extends AppException {
  const StorageException(super.message) : 
    super(code: 'STORAGE_ERROR', isRetryable: false);
}

/// Sync related exceptions
class SyncException extends AppException {
  const SyncException(super.message) : 
    super(code: 'SYNC_ERROR', isRetryable: true);
}

/// Unknown exceptions
class UnknownException extends AppException {
  const UnknownException(super.message) : 
    super(code: 'UNKNOWN_ERROR', isRetryable: false);
}