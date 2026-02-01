import 'package:flutter_test/flutter_test.dart';
import 'package:tripmuse/core/services/logger_service.dart';

void main() {
  group('LoggerService Tests', () {
    late LoggerService logger;
    
    setUp(() {
      logger = LoggerService();
    });
    
    test('should log debug messages', () {
      expect(() => logger.debug('Test debug message'), returnsNormally);
    });
    
    test('should log info messages', () {
      expect(() => logger.info('Test info message'), returnsNormally);
    });
    
    test('should log warning messages', () {
      expect(() => logger.warning('Test warning message'), returnsNormally);
    });
    
    test('should log error messages', () {
      expect(() => logger.error('Test error message'), returnsNormally);
    });
    
    test('should log error messages with exception', () {
      final exception = Exception('Test exception');
      expect(
        () => logger.error('Test error with exception', exception),
        returnsNormally,
      );
    });
    
    test('should log error messages with stack trace', () {
      final exception = Exception('Test exception');
      final stackTrace = StackTrace.current;
      expect(
        () => logger.error('Test error with stack trace', exception, stackTrace),
        returnsNormally,
      );
    });
  });
}