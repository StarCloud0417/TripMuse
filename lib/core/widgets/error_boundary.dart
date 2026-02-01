import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../exceptions/app_exceptions.dart';

/// Global error boundary widget that catches and handles unhandled errors
class ErrorBoundary extends ConsumerStatefulWidget {
  final Widget child;
  
  const ErrorBoundary({super.key, required this.child});
  
  @override
  ConsumerState<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends ConsumerState<ErrorBoundary> {
  AppException? _error;
  
  @override
  void initState() {
    super.initState();
    
    // Defer provider access to after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupErrorHandling();
    });
  }
  
  @override
  void dispose() {
    // Reset FlutterError.onError to default behavior
    FlutterError.onError = FlutterError.dumpErrorToConsole;
    super.dispose();
  }
  
  void _setupErrorHandling() {
    if (!mounted) return;
    
    try {
      final logger = ref.read(loggerProvider);
      final errorHandler = ref.read(errorHandlerProvider);
      
      // Set up global error handling
      FlutterError.onError = (FlutterErrorDetails details) {
        logger.error(
          'Flutter error caught by ErrorBoundary',
          details.exception,
          details.stack,
        );
        
        final appException = errorHandler.handleException(
          details.exception,
          details.stack ?? StackTrace.current,
        );
        
        // Schedule setState for next frame to avoid "Build scheduled during frame" error
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _error = appException;
            });
          }
        });
      };
    } catch (e) {
      // Fallback error handling if providers are not available
      FlutterError.onError = (FlutterErrorDetails details) {
        debugPrint('Error in ErrorBoundary setup: $e');
        debugPrint('Original error: ${details.exception}');
        
        // Schedule setState for next frame to avoid "Build scheduled during frame" error
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _error = UnknownException('應用程式發生錯誤，請重新啟動');
            });
          }
        });
      };
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _buildErrorWidget(_error!);
    }
    
    return widget.child;
  }
  
  Widget _buildErrorWidget(AppException error) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    minWidth: constraints.maxWidth,
                  ),
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            '應用程式發生錯誤',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            error.message,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 16.0,
                            runSpacing: 8.0,
                            children: [
                              if (error.isRetryable) ...[
                                SizedBox(
                                  width: 120,
                                  child: ElevatedButton(
                                    onPressed: _retry,
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(120, 44),
                                    ),
                                    child: const Text('重試'),
                                  ),
                                ),
                              ],
                              SizedBox(
                                width: 120,
                                child: OutlinedButton(
                                  onPressed: _restart,
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(120, 44),
                                  ),
                                  child: const Text('重新啟動'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  
  void _retry() {
    setState(() {
      _error = null;
    });
  }
  
  void _restart() {
    setState(() {
      _error = null;
    });
    // In a real app, you might want to restart the entire app
    // or navigate to the initial route
  }
}