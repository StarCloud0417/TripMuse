import 'dart:developer' as developer;

enum LogLevel { debug, info, warning, error }

class LoggerService {
  static const String _tag = 'TripMind';
  
  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.debug, message, error, stackTrace);
  }
  
  void info(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.info, message, error, stackTrace);
  }
  
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.warning, message, error, stackTrace);
  }
  
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, error, stackTrace);
  }
  
  void _log(LogLevel level, String message, Object? error, StackTrace? stackTrace) {
    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.name.toUpperCase();
    final logMessage = '[$timestamp] [$levelStr] $_tag: $message';
    
    // Use developer.log for better debugging experience
    developer.log(
      logMessage,
      name: _tag,
      level: _getLevelValue(level),
      error: error,
      stackTrace: stackTrace,
    );
    
    // In production, you might want to send logs to a remote service
    // _sendToRemoteLogging(level, message, error, stackTrace);
  }
  
  int _getLevelValue(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
    }
  }
  
  // Future method for remote logging in production
  // void _sendToRemoteLogging(LogLevel level, String message, Object? error, StackTrace? stackTrace) {
  //   // Implementation for remote logging service
  // }
}