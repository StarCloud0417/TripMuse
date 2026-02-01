import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../repositories/cache_repository.dart';
import '../repositories/trip_repository.dart';
import '../repositories/user_repository.dart';
import '../repositories/implementations/hive_trip_repository.dart';
import '../repositories/implementations/hive_user_repository.dart';
import '../services/api_client.dart';
import '../services/cache_manager.dart';
import '../services/connectivity_service.dart';
import '../services/error_handler.dart';
import '../services/local_storage_service.dart';
import '../services/logger_service.dart';
import '../services/offline_sync_service.dart';
import '../services/secure_storage_service.dart';

// Core Infrastructure Providers
final loggerProvider = Provider<LoggerService>((ref) {
  return LoggerService();
});

final errorHandlerProvider = Provider<ErrorHandler>((ref) {
  final logger = ref.watch(loggerProvider);
  return ErrorHandler(logger);
});

final connectivityProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService(Connectivity());
});

// Storage Providers
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
});

final hiveProvider = Provider<HiveInterface>((ref) {
  return Hive;
});

final localStorageProvider = Provider<LocalStorageService>((ref) {
  final logger = ref.watch(loggerProvider);
  return LocalStorageService(logger);
});

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final logger = ref.watch(loggerProvider);
  return SecureStorageService(secureStorage, logger);
});

final cacheManagerProvider = Provider<CacheManager>((ref) {
  final hive = ref.watch(hiveProvider);
  final logger = ref.watch(loggerProvider);
  return CacheManager(hive, logger);
});

final cacheRepositoryProvider = Provider<CacheRepository>((ref) {
  return ref.watch(cacheManagerProvider);
});

// Network Providers
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final logger = ref.watch(loggerProvider);
  final errorHandler = ref.watch(errorHandlerProvider);
  
  // Add interceptors
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    logPrint: (obj) => logger.debug(obj.toString()),
  ));
  
  dio.interceptors.add(InterceptorsWrapper(
    onError: (error, handler) {
      errorHandler.handleDioError(error);
      handler.next(error);
    },
  ));
  
  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final logger = ref.watch(loggerProvider);
  return ApiClient(dio, secureStorage, logger);
});

// Repository Providers
final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final localStorage = ref.watch(localStorageProvider);
  final logger = ref.watch(loggerProvider);
  
  return HiveTripRepository(
    localStorage,
    logger,
  );
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final localStorage = ref.watch(localStorageProvider);
  final secureStorageService = ref.watch(secureStorageServiceProvider);
  final logger = ref.watch(loggerProvider);
  
  return HiveUserRepository(
    localStorage,
    secureStorageService,
    logger,
  );
});

// Sync Service Provider
final offlineSyncServiceProvider = Provider<OfflineSyncService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final cacheManager = ref.watch(cacheManagerProvider);
  final connectivityService = ref.watch(connectivityProvider);
  final logger = ref.watch(loggerProvider);
  final tripRepository = ref.watch(tripRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  
  final syncService = OfflineSyncService(
    apiClient,
    cacheManager,
    connectivityService,
    logger,
    tripRepository,
    userRepository,
  );
  
  // Set the sync service in the trip repository to avoid circular dependency
  if (tripRepository is HiveTripRepository) {
    tripRepository.setSyncService(syncService);
  }
  
  return syncService;
});

// App State Providers
final appInitializationProvider = FutureProvider<void>((ref) async {
  final logger = ref.watch(loggerProvider);
  final localStorage = ref.watch(localStorageProvider);
  final cacheManager = ref.watch(cacheManagerProvider);
  final syncService = ref.watch(offlineSyncServiceProvider);
  
  logger.info('Initializing app...');
  
  try {
    // Initialize local storage (includes Hive initialization)
    await localStorage.initialize();
    
    // Initialize cache manager
    await cacheManager.initialize();
    
    // Initialize sync service
    await syncService.initialize();
    
    logger.info('App initialization completed successfully');
  } catch (e) {
    logger.error('App initialization failed', e);
    rethrow;
  }
});

// Connectivity State Provider
final connectivityStateProvider = StreamProvider<ConnectivityResult>((ref) {
  final connectivityService = ref.watch(connectivityProvider);
  return connectivityService.connectivityStream;
});

final isOnlineProvider = Provider<bool>((ref) {
  final connectivityState = ref.watch(connectivityStateProvider);
  return connectivityState.when(
    data: (result) => result != ConnectivityResult.none,
    loading: () => true, // Assume online while loading
    error: (_, __) => false,
  );
});