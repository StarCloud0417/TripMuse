# TripMind Core Architecture

This document describes the core architecture and state management system implemented for the TripMind application.

## Overview

The core system provides a robust foundation for the TripMind app with:
- **Riverpod** state management
- **Dependency injection** container
- **Global error handling** system
- **Logging** infrastructure
- **Network layer** with automatic retry and token refresh
- **Local caching** system
- **Connectivity monitoring**

## Architecture Components

### 1. State Management (Riverpod)

**Location**: `lib/core/providers/app_providers.dart`

The app uses Riverpod for state management with the following key providers:

- `loggerProvider` - Provides logging service
- `errorHandlerProvider` - Provides error handling service
- `connectivityProvider` - Provides connectivity monitoring
- `secureStorageProvider` - Provides secure storage
- `cacheManagerProvider` - Provides cache management
- `apiClientProvider` - Provides HTTP client with authentication
- `appInitializationProvider` - Handles app initialization
- `connectivityStateProvider` - Monitors network connectivity
- `isOnlineProvider` - Provides online/offline status

### 2. Error Handling System

**Location**: `lib/core/services/error_handler.dart`

Comprehensive error handling with:
- **Typed exceptions** for different error categories
- **User-friendly error messages** in Traditional Chinese
- **Automatic retry mechanisms** for retryable errors
- **Rate limiting handling** with wait time indicators
- **Authentication error handling** with login prompts

**Exception Types**:
- `NetworkException` - Network connectivity issues
- `ServerException` - Server-side errors
- `AuthException` - Authentication failures
- `ValidationException` - Input validation errors
- `RateLimitException` - API rate limiting
- `LLMGenerationException` - AI generation failures
- `CacheException` - Cache operation failures
- `UnknownException` - Unexpected errors

### 3. Logging System

**Location**: `lib/core/services/logger_service.dart`

Features:
- **Multiple log levels** (debug, info, warning, error)
- **Structured logging** with timestamps
- **Stack trace support** for errors
- **Developer-friendly** output using `dart:developer`
- **Extensible** for remote logging in production

### 4. Network Layer

**Location**: `lib/core/services/api_client.dart`

Advanced HTTP client with:
- **Automatic authentication** token injection
- **Token refresh** mechanism for expired tokens
- **Request/response interceptors** for logging
- **Standardized error handling** with typed exceptions
- **Base URL configuration** for different environments
- **Retry logic** for failed requests

### 5. Cache Management

**Location**: `lib/core/services/cache_manager.dart`

Local caching system with:
- **TTL (Time To Live)** support for automatic expiration
- **JSON serialization** for complex objects
- **Memory-efficient** storage using Hive
- **Automatic cleanup** of expired entries
- **Cache size monitoring** and management
- **Error-resilient** operations

### 6. Connectivity Service

**Location**: `lib/core/services/connectivity_service.dart`

Network monitoring with:
- **Real-time connectivity** status updates
- **Connection type detection** (WiFi, mobile, none)
- **Stream-based** connectivity changes
- **Offline/online** state management

## Widgets

### 1. Error Boundary

**Location**: `lib/core/widgets/error_boundary.dart`

Global error catching widget that:
- **Catches unhandled exceptions** throughout the app
- **Displays user-friendly error screens** with recovery options
- **Provides retry mechanisms** for recoverable errors
- **Logs errors** for debugging and monitoring

### 2. App Initializer

**Location**: `lib/core/widgets/app_initializer.dart`

Handles app initialization with:
- **Loading screens** during initialization
- **Error handling** for initialization failures
- **Retry mechanisms** for failed initialization
- **Smooth transitions** to main app content

## Utilities

### 1. Cache Keys

**Location**: `lib/core/utils/cache_keys.dart`

Centralized cache key management for:
- **Trip data** caching
- **User profile** caching
- **API response** caching
- **Places API** data caching
- **Map tiles** and route caching

### 2. Context Extensions

**Location**: `lib/core/extensions/context_extensions.dart`

Convenient extensions for:
- **Theme access** shortcuts
- **Snackbar helpers** for success/error messages
- **Media query** shortcuts
- **Provider access** helpers

## Testing

The core system includes comprehensive tests:

- **Provider tests** - Verify dependency injection works correctly
- **Service tests** - Test individual service functionality
- **Exception tests** - Verify error handling behavior
- **Widget tests** - Test UI components

**Test Coverage**:
- ✅ All providers can be instantiated
- ✅ Logger service works correctly
- ✅ Exception types have correct properties
- ✅ Basic widget rendering works

## Usage Examples

### 1. Using the Logger

```dart
class MyService extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = ref.read(loggerProvider);
    
    logger.info('Service initialized');
    logger.error('Something went wrong', error, stackTrace);
    
    return Container();
  }
}
```

### 2. Handling Errors

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        try {
          await someAsyncOperation();
        } catch (e) {
          final errorHandler = ref.read(errorHandlerProvider);
          final appException = errorHandler.handleException(e, StackTrace.current);
          errorHandler.showError(context, appException);
        }
      },
      child: Text('Do Something'),
    );
  }
}
```

### 3. Using the Cache

```dart
class DataService {
  final CacheManager _cache;
  
  DataService(this._cache);
  
  Future<String> getData(String key) async {
    // Try cache first
    final cached = await _cache.get<String>(key);
    if (cached != null) return cached;
    
    // Fetch from API
    final data = await fetchFromApi(key);
    
    // Cache for 1 hour
    await _cache.set(key, data, ttl: Duration(hours: 1));
    
    return data;
  }
}
```

### 4. Monitoring Connectivity

```dart
class NetworkAwareWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    
    return Column(
      children: [
        if (!isOnline)
          Container(
            color: Colors.red,
            child: Text('Offline - Some features may not work'),
          ),
        // Rest of your widget
      ],
    );
  }
}
```

## Configuration

### Environment Variables

The system supports different configurations for different environments:

- `API_BASE_URL` - Base URL for API calls
- `JWT_SECRET` - Secret for JWT token validation
- `LOG_LEVEL` - Minimum log level to output

### Provider Overrides

For testing, providers can be overridden:

```dart
testWidgets('test with mock', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        apiClientProvider.overrideWithValue(mockApiClient),
      ],
      child: MyApp(),
    ),
  );
});
```

## Next Steps

This core architecture provides the foundation for implementing the remaining TripMind features:

1. **Authentication system** (OAuth 2.0 Google login)
2. **Trip generation service** (LLM integration)
3. **Map integration** (Mapbox)
4. **Local storage** (Trip data persistence)
5. **PDF generation** (Export functionality)

The modular design ensures that each feature can be developed independently while leveraging the shared core infrastructure.