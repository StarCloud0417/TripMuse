import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tripmuse/core/providers/app_providers.dart';
import 'package:tripmuse/core/services/logger_service.dart';
import 'package:tripmuse/core/services/error_handler.dart';

void main() {
  group('App Providers Tests', () {
    late ProviderContainer container;
    
    setUp(() {
      container = ProviderContainer();
    });
    
    tearDown(() {
      container.dispose();
    });
    
    test('should provide logger service', () {
      final logger = container.read(loggerProvider);
      
      expect(logger, isA<LoggerService>());
    });
    
    test('should provide error handler', () {
      final errorHandler = container.read(errorHandlerProvider);
      
      expect(errorHandler, isA<ErrorHandler>());
    });
    
    test('should provide connectivity service', () {
      final connectivityService = container.read(connectivityProvider);
      
      expect(connectivityService, isNotNull);
    });
    
    test('should provide secure storage', () {
      final secureStorage = container.read(secureStorageProvider);
      
      expect(secureStorage, isNotNull);
    });
    
    test('should provide hive interface', () {
      final hive = container.read(hiveProvider);
      
      expect(hive, isNotNull);
    });
    
    test('should provide dio instance', () {
      final dio = container.read(dioProvider);
      
      expect(dio, isNotNull);
      expect(dio.interceptors.length, greaterThan(0));
    });
    
    test('should provide api client', () {
      final apiClient = container.read(apiClientProvider);
      
      expect(apiClient, isNotNull);
    });
    
    test('should provide cache manager', () {
      final cacheManager = container.read(cacheManagerProvider);
      
      expect(cacheManager, isNotNull);
    });
  });
}