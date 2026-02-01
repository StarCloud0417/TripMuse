import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';

import '../services/cache_manager.dart';
import '../services/api_client.dart';

/// Extensions for BuildContext to provide easy access to common functionality
extension ContextExtensions on BuildContext {
  /// Get the current theme
  ThemeData get theme => Theme.of(this);
  
  /// Get the current color scheme
  ColorScheme get colorScheme => theme.colorScheme;
  
  /// Get the current text theme
  TextTheme get textTheme => theme.textTheme;
  
  /// Get the media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  
  /// Get the screen size
  Size get screenSize => mediaQuery.size;
  
  /// Check if the device is in dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;
  
  /// Show a snackbar with the given message
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }
  
  /// Show an error snackbar
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }
  
  /// Show a success snackbar
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

/// Extensions for WidgetRef to provide easy access to providers and error handling
extension WidgetRefExtensions on WidgetRef {
  
  /// Log a message using the logger service
  void log(String message, {Object? error, StackTrace? stackTrace}) {
    final logger = read(loggerProvider);
    if (error != null) {
      logger.error(message, error, stackTrace);
    } else {
      logger.info(message);
    }
  }
  
  /// Check if the device is online
  bool get isOnline => read(isOnlineProvider);
  
  /// Get the cache manager
  CacheManager get cacheManager => read(cacheManagerProvider);
  
  /// Get the API client
  ApiClient get apiClient => read(apiClientProvider);
}