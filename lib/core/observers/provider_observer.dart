import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/logger_service.dart';

/// Observer for monitoring provider state changes and debugging
class AppProviderObserver extends ProviderObserver {
  final LoggerService _logger;
  
  AppProviderObserver(this._logger);
  
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    _logger.debug('Provider added: ${provider.name ?? provider.runtimeType}');
  }
  
  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    _logger.debug('Provider disposed: ${provider.name ?? provider.runtimeType}');
  }
  
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    _logger.debug(
      'Provider updated: ${provider.name ?? provider.runtimeType} '
      'from $previousValue to $newValue',
    );
  }
  
  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    _logger.error(
      'Provider failed: ${provider.name ?? provider.runtimeType}',
      error,
      stackTrace,
    );
  }
}