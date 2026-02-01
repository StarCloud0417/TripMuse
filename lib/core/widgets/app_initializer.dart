import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../exceptions/app_exceptions.dart';

/// Widget that handles app initialization and shows loading/error states
class AppInitializer extends ConsumerWidget {
  final Widget child;
  
  const AppInitializer({super.key, required this.child});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initializationState = ref.watch(appInitializationProvider);
    
    return initializationState.when(
      data: (_) => child,
      loading: () => const _LoadingScreen(),
      error: (error, stackTrace) => _ErrorScreen(
        error: error,
        onRetry: () => ref.invalidate(appInitializationProvider),
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 120,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.travel_explore,
                    size: 120,
                    color: Colors.blue,
                  );
                },
              ),
              const SizedBox(height: 32),
              Text(
                'TripMind',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'AI 智能旅行規劃助手',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                '正在初始化應用程式...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;
  
  const _ErrorScreen({
    required this.error,
    required this.onRetry,
  });
  
  @override
  Widget build(BuildContext context) {
    final errorMessage = error is AppException 
        ? (error as AppException).message
        : '應用程式初始化失敗';
    
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 24),
                Text(
                  '初始化失敗',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  errorMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('重試'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}