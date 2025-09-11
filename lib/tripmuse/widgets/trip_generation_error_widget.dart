/// TripMuse 行程生成錯誤處理組件
/// 
/// 提供友善的錯誤顯示和重試機制

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../providers/trip_generation_provider.dart';

/// 行程生成錯誤類型
enum TripGenerationErrorType {
  network('網路連線錯誤'),
  timeout('請求超時'),
  apiLimit('API 使用限制'),
  validation('資料驗證錯誤'),
  server('伺服器錯誤'),
  unknown('未知錯誤');

  const TripGenerationErrorType(this.displayName);
  final String displayName;
}

/// 錯誤詳情
class TripGenerationErrorDetails {
  final TripGenerationErrorType type;
  final String message;
  final String? suggestion;
  final bool canRetry;
  final Duration? retryAfter;
  final Map<String, dynamic>? metadata;

  const TripGenerationErrorDetails({
    required this.type,
    required this.message,
    this.suggestion,
    this.canRetry = true,
    this.retryAfter,
    this.metadata,
  });

  /// 從錯誤訊息解析錯誤類型
  factory TripGenerationErrorDetails.fromError(String error) {
    if (error.contains('網路') || error.contains('連線') || error.contains('network')) {
      return TripGenerationErrorDetails(
        type: TripGenerationErrorType.network,
        message: error,
        suggestion: '請檢查網路連線後重試',
        canRetry: true,
      );
    } else if (error.contains('超時') || error.contains('timeout')) {
      return TripGenerationErrorDetails(
        type: TripGenerationErrorType.timeout,
        message: error,
        suggestion: '請稍後再試，或檢查網路連線',
        canRetry: true,
        retryAfter: const Duration(seconds: 30),
      );
    } else if (error.contains('限制') || error.contains('limit') || error.contains('quota')) {
      return TripGenerationErrorDetails(
        type: TripGenerationErrorType.apiLimit,
        message: error,
        suggestion: '已達使用限制，請稍後再試',
        canRetry: true,
        retryAfter: const Duration(minutes: 5),
      );
    } else if (error.contains('驗證') || error.contains('validation')) {
      return TripGenerationErrorDetails(
        type: TripGenerationErrorType.validation,
        message: error,
        suggestion: '請檢查輸入資料是否正確',
        canRetry: false,
      );
    } else if (error.contains('伺服器') || error.contains('server') || error.contains('500')) {
      return TripGenerationErrorDetails(
        type: TripGenerationErrorType.server,
        message: error,
        suggestion: '伺服器暫時無法處理請求，請稍後重試',
        canRetry: true,
        retryAfter: const Duration(minutes: 1),
      );
    } else {
      return TripGenerationErrorDetails(
        type: TripGenerationErrorType.unknown,
        message: error,
        suggestion: '發生未知錯誤，請重試或聯絡客服',
        canRetry: true,
      );
    }
  }
}

/// 行程生成錯誤顯示組件
class TripGenerationErrorWidget extends ConsumerStatefulWidget {
  final TripGenerationErrorDetails errorDetails;
  final TripRequest? originalRequest;
  final VoidCallback? onRetry;
  final VoidCallback? onCancel;
  final bool showRetryButton;
  final bool showContactSupport;

  const TripGenerationErrorWidget({
    super.key,
    required this.errorDetails,
    this.originalRequest,
    this.onRetry,
    this.onCancel,
    this.showRetryButton = true,
    this.showContactSupport = true,
  });

  @override
  ConsumerState<TripGenerationErrorWidget> createState() =>
      _TripGenerationErrorWidgetState();
}

class _TripGenerationErrorWidgetState
    extends ConsumerState<TripGenerationErrorWidget>
    with TickerProviderStateMixin {
  
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  
  int _retryCountdown = 0;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startRetryCountdown();
  }

  void _initializeAnimations() {
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    // 播放震動動畫
    _shakeController.forward();
  }

  void _startRetryCountdown() {
    if (widget.errorDetails.retryAfter != null) {
      setState(() {
        _retryCountdown = widget.errorDetails.retryAfter!.inSeconds;
      });

      _updateCountdown();
    }
  }

  void _updateCountdown() {
    if (_retryCountdown > 0) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _retryCountdown--;
          });
          _updateCountdown();
        }
      });
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: _buildErrorContent(),
        );
      },
    );
  }

  Widget _buildErrorContent() {
    return Container(
      padding: const EdgeInsets.all(TripMuseSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TripMuseRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 51.0),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildErrorIcon(),
          const SizedBox(height: TripMuseSpacing.lg),
          _buildErrorTitle(),
          const SizedBox(height: TripMuseSpacing.md),
          _buildErrorMessage(),
          if (widget.errorDetails.suggestion != null) ...[
            const SizedBox(height: TripMuseSpacing.md),
            _buildSuggestion(),
          ],
          const SizedBox(height: TripMuseSpacing.xl),
          _buildActionButtons(),
          if (widget.showContactSupport) ...[
            const SizedBox(height: TripMuseSpacing.md),
            _buildContactSupport(),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorIcon() {
    final iconData = _getErrorIcon();
    final iconColor = _getErrorColor();

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 51.0),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        size: 40,
        color: iconColor,
      ),
    );
  }

  Widget _buildErrorTitle() {
    return Text(
      widget.errorDetails.type.displayName,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: _getErrorColor(),
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildErrorMessage() {
    return Text(
      widget.errorDetails.message,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: TripMuseTheme.textSecondary,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSuggestion() {
    return Container(
      padding: const EdgeInsets.all(TripMuseSpacing.md),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(TripMuseRadius.lg),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: Colors.blue.shade700,
            size: 20,
          ),
          const SizedBox(width: TripMuseSpacing.sm),
          Expanded(
            child: Text(
              widget.errorDetails.suggestion!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // 重試按鈕
        if (widget.showRetryButton && widget.errorDetails.canRetry)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _canRetry() ? _handleRetry : null,
              icon: _isRetrying
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.refresh),
              label: Text(_getRetryButtonText()),
              style: ElevatedButton.styleFrom(
                backgroundColor: TripMuseTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: TripMuseSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TripMuseRadius.lg),
                ),
              ),
            ),
          ),

        // 取消按鈕
        if (widget.onCancel != null) ...[
          const SizedBox(height: TripMuseSpacing.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: widget.onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: TripMuseTheme.textSecondary,
                side: const BorderSide(color: TripMuseTheme.borderColor),
                padding: const EdgeInsets.symmetric(vertical: TripMuseSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TripMuseRadius.lg),
                ),
              ),
              child: const Text('取消'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildContactSupport() {
    return TextButton.icon(
      onPressed: _contactSupport,
      icon: const Icon(
        Icons.support_agent,
        size: 16,
      ),
      label: const Text('聯絡客服'),
      style: TextButton.styleFrom(
        foregroundColor: TripMuseTheme.textSecondary,
      ),
    );
  }

  IconData _getErrorIcon() {
    switch (widget.errorDetails.type) {
      case TripGenerationErrorType.network:
        return Icons.wifi_off;
      case TripGenerationErrorType.timeout:
        return Icons.access_time;
      case TripGenerationErrorType.apiLimit:
        return Icons.block;
      case TripGenerationErrorType.validation:
        return Icons.error_outline;
      case TripGenerationErrorType.server:
        return Icons.dns;
      case TripGenerationErrorType.unknown:
        return Icons.help_outline;
    }
  }

  Color _getErrorColor() {
    switch (widget.errorDetails.type) {
      case TripGenerationErrorType.network:
        return Colors.orange;
      case TripGenerationErrorType.timeout:
        return Colors.amber;
      case TripGenerationErrorType.apiLimit:
        return Colors.red;
      case TripGenerationErrorType.validation:
        return Colors.deepOrange;
      case TripGenerationErrorType.server:
        return Colors.red;
      case TripGenerationErrorType.unknown:
        return Colors.grey;
    }
  }

  bool _canRetry() {
    return !_isRetrying && 
           widget.errorDetails.canRetry && 
           _retryCountdown <= 0;
  }

  String _getRetryButtonText() {
    if (_isRetrying) {
      return '重試中...';
    } else if (_retryCountdown > 0) {
      return '重試 ($_retryCountdown 秒後)';
    } else {
      return '重試';
    }
  }

  void _handleRetry() async {
    if (!_canRetry()) return;

    setState(() {
      _isRetrying = true;
    });

    try {
      // 如果有原始請求，使用增強的重試機制
      if (widget.originalRequest != null) {
        final controller = ref.read(tripGenerationControllerProvider.notifier);
        await controller.retryGeneration(widget.originalRequest!);
      } else {
        // 否則直接呼叫重試回調
        widget.onRetry?.call();
      }
    } catch (e) {
      // 重試失敗，顯示新的錯誤
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('重試失敗: $e'),
            backgroundColor: TripMuseTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRetrying = false;
        });
      }
    }
  }

  void _contactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('聯絡客服'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('如果問題持續發生，請聯絡我們的客服團隊：'),
            const SizedBox(height: TripMuseSpacing.md),
            const Text('📧 Email: support@tripmuse.com'),
            const Text('📱 LINE: @tripmuse'),
            const SizedBox(height: TripMuseSpacing.md),
            const Text('請提供以下錯誤資訊：'),
            const SizedBox(height: TripMuseSpacing.sm),
            Container(
              padding: const EdgeInsets.all(TripMuseSpacing.sm),
              decoration: BoxDecoration(
                color: TripMuseTheme.surfaceColor,
                borderRadius: BorderRadius.circular(TripMuseRadius.md),
              ),
              child: Text(
                '錯誤類型: ${widget.errorDetails.type.displayName}\n'
                '錯誤訊息: ${widget.errorDetails.message}',
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('關閉'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: 實作複製錯誤資訊到剪貼簿
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('錯誤資訊已複製到剪貼簿'),
                ),
              );
            },
            child: const Text('複製錯誤資訊'),
          ),
        ],
      ),
    );
  }
}

/// 簡化版錯誤顯示組件
class TripGenerationErrorSnackBar {
  static void show(
    BuildContext context,
    String error, {
    VoidCallback? onRetry,
    Duration duration = const Duration(seconds: 5),
  }) {
    final errorDetails = TripGenerationErrorDetails.fromError(error);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: TripMuseSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    errorDetails.type.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (errorDetails.suggestion != null)
                    Text(
                      errorDetails.suggestion!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: errorDetails.type == TripGenerationErrorType.network
            ? Colors.orange
            : TripMuseTheme.errorColor,
        duration: duration,
        action: errorDetails.canRetry && onRetry != null
            ? SnackBarAction(
                label: '重試',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }
}