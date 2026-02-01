import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'core/widgets/error_boundary.dart';
import 'core/widgets/app_initializer.dart';
import 'core/providers/app_providers.dart';
import 'core/observers/provider_observer.dart';
import 'core/services/logger_service.dart';
import 'core/exceptions/app_exceptions.dart';
import 'widgets/mapbox_map_screen.dart';

void main() {
  // Ensure Flutter binding is initialized before any other initialization
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize logger for provider observer
  final logger = LoggerService();
  
  // Initialize Mapbox
  MapboxOptions.setAccessToken("YOUR_MAPBOX_ACCESS_TOKEN");
  
  runApp(
    ProviderScope(
      observers: [AppProviderObserver(logger)],
      child: const ErrorBoundary(
        child: TripMuseApp(),
      ),
    ),
  );
}

class TripMuseApp extends ConsumerWidget {
  const TripMuseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppInitializer(
      child: MaterialApp(
        title: 'TripMind',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch connectivity status
    final isOnline = ref.watch(isOnlineProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('TripMind'),
        actions: [
          // Connectivity indicator
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              isOnline ? Icons.wifi : Icons.wifi_off,
              color: isOnline ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to TripMind',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('AI 智能旅行規劃助手'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapboxMapScreen()),
                );
              },
              child: const Text('Open Mapbox Map'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _testErrorHandling(ref),
              child: const Text('Test Error Handling'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _testCacheManager(ref),
              child: const Text('Test Cache Manager'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _testErrorHandling(WidgetRef ref) {
    // Test different types of errors
    final errorHandler = ref.read(errorHandlerProvider);
    final context = ref.context;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Test Error Types'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Network Error'),
              onTap: () {
                Navigator.pop(context);
                errorHandler.showError(
                  context,
                  const NetworkException('測試網路錯誤'),
                );
              },
            ),
            ListTile(
              title: const Text('Validation Error'),
              onTap: () {
                Navigator.pop(context);
                errorHandler.showError(
                  context,
                  const ValidationException('測試驗證錯誤'),
                );
              },
            ),
            ListTile(
              title: const Text('Rate Limit Error'),
              onTap: () {
                Navigator.pop(context);
                errorHandler.showError(
                  context,
                  const RateLimitException('測試限制錯誤', 30),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _testCacheManager(WidgetRef ref) async {
    final cacheManager = ref.read(cacheManagerProvider);
    final logger = ref.read(loggerProvider);
    final context = ref.context;
    final messenger = ScaffoldMessenger.of(context);
    final errorHandler = ref.read(errorHandlerProvider);
    
    try {
      // Test cache operations
      await cacheManager.set('test_key', 'Hello, Cache!', ttl: const Duration(minutes: 5));
      final cachedValue = await cacheManager.get<String>('test_key');
      
      logger.info('Cache test result: $cachedValue');
      
      messenger.showSnackBar(
        SnackBar(content: Text('Cache test successful: $cachedValue')),
      );
    } catch (e) {
      logger.error('Cache test failed', e);
      if (context.mounted) {
        errorHandler.showError(context, CacheException('快取測試失敗'));
      }
    }
  }
}
