/// TripMuse 行程生成進度指示器組件
/// 
/// 提供詳細的生成進度顯示、取消功能和錯誤處理

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../services/trip_generation_service.dart';

/// 行程生成進度對話框
class TripGenerationProgressDialog extends ConsumerStatefulWidget {
  final TripRequest request;
  final VoidCallback? onCancel;
  final Function(Trip)? onSuccess;
  final Function(String)? onError;

  const TripGenerationProgressDialog({
    super.key,
    required this.request,
    this.onCancel,
    this.onSuccess,
    this.onError,
  });

  @override
  ConsumerState<TripGenerationProgressDialog> createState() =>
      _TripGenerationProgressDialogState();
}

class _TripGenerationProgressDialogState
    extends ConsumerState<TripGenerationProgressDialog>
    with TickerProviderStateMixin {
  
  late AnimationController _progressAnimationController;
  late AnimationController _pulseAnimationController;
  // late Animation<double> _progressAnimation; // 暫時不使用
  late Animation<double> _pulseAnimation;
  
  Timer? _timeoutTimer;
  Timer? _retryTimer;
  bool _isCancelled = false;
  bool _isRetrying = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;
  static const Duration _generationTimeout = Duration(minutes: 5);
  static const Duration _retryDelay = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startGeneration();
  }

  void _initializeAnimations() {
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // _progressAnimation = Tween<double>(
    //   begin: 0.0,
    //   end: 1.0,
    // ).animate(CurvedAnimation(
    //   parent: _progressAnimationController,
    //   curve: Curves.easeInOut,
    // )); // 暫時不使用

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimationController.repeat(reverse: true);
  }

  void _startGeneration() {
    // 設定超時計時器
    _timeoutTimer = Timer(_generationTimeout, () {
      if (!_isCancelled && mounted) {
        _handleTimeout();
      }
    });

    // 開始生成行程
    _generateTrip();
  }

  Future<void> _generateTrip() async {
    if (_isCancelled) return;

    try {
      final progressNotifier = ref.read(tripGenerationProgressProvider.notifier);
      
      // 重置進度狀態
      progressNotifier.reset();
      
      // 開始生成
      await progressNotifier.generateTrip(widget.request);
      
      // 檢查最終結果
      final finalProgress = ref.read(tripGenerationProgressProvider);
      
      if (finalProgress.isCompleted && finalProgress.trip != null) {
        _handleSuccess(finalProgress.trip!);
      } else if (finalProgress.hasError) {
        _handleError(finalProgress.error!);
      }
      
    } catch (e) {
      if (!_isCancelled && mounted) {
        _handleError(e.toString());
      }
    }
  }

  void _handleSuccess(Trip trip) {
    if (_isCancelled) return;
    
    _timeoutTimer?.cancel();
    _progressAnimationController.forward();
    
    // 延遲一下讓使用者看到完成動畫
    Timer(const Duration(milliseconds: 500), () {
      if (mounted && !_isCancelled) {
        widget.onSuccess?.call(trip);
        Navigator.of(context).pop(trip);
      }
    });
  }

  void _handleError(String error) {
    if (_isCancelled) return;
    
    _timeoutTimer?.cancel();
    
    // 如果還有重試次數，自動重試
    if (_retryCount < _maxRetries) {
      _startRetry(error);
    } else {
      // 達到最大重試次數，顯示錯誤
      widget.onError?.call(error);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _handleTimeout() {
    if (_isCancelled) return;
    
    const timeoutError = '行程生成超時，請檢查網路連線後重試';
    
    if (_retryCount < _maxRetries) {
      _startRetry(timeoutError);
    } else {
      widget.onError?.call(timeoutError);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _startRetry(String lastError) {
    setState(() {
      _isRetrying = true;
      _retryCount++;
    });

    _retryTimer = Timer(_retryDelay, () {
      if (!_isCancelled && mounted) {
        setState(() {
          _isRetrying = false;
        });
        _startGeneration();
      }
    });
  }

  void _handleCancel() {
    setState(() {
      _isCancelled = true;
    });
    
    _timeoutTimer?.cancel();
    _retryTimer?.cancel();
    
    widget.onCancel?.call();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _pulseAnimationController.dispose();
    _timeoutTimer?.cancel();
    _retryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 防止意外返回
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(TripMuseSpacing.xl),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(TripMuseRadius.xl),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 51.0),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              const SizedBox(height: TripMuseSpacing.xl),
              _buildProgressSection(),
              const SizedBox(height: TripMuseSpacing.xl),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: TripMuseTheme.primaryColor.withValues(alpha: 51.0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  size: 40,
                  color: TripMuseTheme.primaryColor,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: TripMuseSpacing.lg),
        Text(
          _isRetrying ? '正在重試...' : '正在為您規劃行程',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: TripMuseTheme.textPrimary,
              ),
        ),
        const SizedBox(height: TripMuseSpacing.sm),
        Text(
          _isRetrying 
              ? '第 $_retryCount 次重試，請稍候...'
              : '請稍候，我們正在為您量身打造完美的旅程',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TripMuseTheme.textSecondary,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Consumer(
      builder: (context, ref, child) {
        final progress = ref.watch(tripGenerationProgressProvider);
        
        return Column(
          children: [
            // 進度條
            _buildProgressBar(progress),
            const SizedBox(height: TripMuseSpacing.lg),
            
            // 當前階段顯示
            _buildCurrentPhase(progress),
            
            // 重試資訊
            if (_isRetrying) _buildRetryInfo(),
          ],
        );
      },
    );
  }

  Widget _buildProgressBar(TripGenerationProgress progress) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              progress.phase.displayName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: TripMuseTheme.textPrimary,
              ),
            ),
            Text(
              '${(progress.progress * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: TripMuseTheme.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: TripMuseSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(TripMuseRadius.sm),
          child: LinearProgressIndicator(
            value: progress.progress,
            backgroundColor: TripMuseTheme.borderColor,
            valueColor: const AlwaysStoppedAnimation<Color>(
              TripMuseTheme.primaryColor,
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentPhase(TripGenerationProgress progress) {
    final phaseIcons = {
      TripGenerationPhase.idle: Icons.hourglass_empty,
      TripGenerationPhase.analyzingPreferences: Icons.psychology,
      TripGenerationPhase.generatingItinerary: Icons.route,
      TripGenerationPhase.enhancingPlaces: Icons.place,
      TripGenerationPhase.validating: Icons.check_circle_outline,
      TripGenerationPhase.completed: Icons.check_circle,
    };

    return Container(
      padding: const EdgeInsets.all(TripMuseSpacing.md),
      decoration: BoxDecoration(
        color: TripMuseTheme.surfaceColor,
        borderRadius: BorderRadius.circular(TripMuseRadius.lg),
        border: Border.all(color: TripMuseTheme.borderColor),
      ),
      child: Row(
        children: [
          Icon(
            phaseIcons[progress.phase] ?? Icons.hourglass_empty,
            color: TripMuseTheme.primaryColor,
            size: 24,
          ),
          const SizedBox(width: TripMuseSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  progress.phase.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: TripMuseTheme.textPrimary,
                  ),
                ),
                if (progress.message != null) ...[
                  const SizedBox(height: TripMuseSpacing.xs),
                  Text(
                    progress.message!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: TripMuseTheme.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (progress.isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  TripMuseTheme.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRetryInfo() {
    return Container(
      margin: const EdgeInsets.only(top: TripMuseSpacing.md),
      padding: const EdgeInsets.all(TripMuseSpacing.md),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(TripMuseRadius.lg),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.refresh,
            color: Colors.orange.shade700,
            size: 20,
          ),
          const SizedBox(width: TripMuseSpacing.sm),
          Expanded(
            child: Text(
              '正在重試 ($_retryCount/$_maxRetries)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _handleCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: TripMuseTheme.textSecondary,
              side: const BorderSide(color: TripMuseTheme.borderColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TripMuseRadius.lg),
              ),
              padding: const EdgeInsets.symmetric(vertical: TripMuseSpacing.md),
            ),
            child: const Text('取消'),
          ),
        ),
        const SizedBox(width: TripMuseSpacing.md),
        Expanded(
          child: ElevatedButton(
            onPressed: _retryCount < _maxRetries && !_isRetrying
                ? () {
                    setState(() {
                      _retryCount = 0;
                    });
                    _startGeneration();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: TripMuseTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TripMuseRadius.lg),
              ),
              padding: const EdgeInsets.symmetric(vertical: TripMuseSpacing.md),
            ),
            child: Text(_isRetrying ? '重試中...' : '重新生成'),
          ),
        ),
      ],
    );
  }
}

/// 簡化版進度指示器（用於內嵌顯示）
class TripGenerationProgressIndicator extends ConsumerWidget {
  final bool showDetails;
  final EdgeInsets? padding;

  const TripGenerationProgressIndicator({
    super.key,
    this.showDetails = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(tripGenerationProgressProvider);

    return Container(
      padding: padding ?? const EdgeInsets.all(TripMuseSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 進度條
          ClipRRect(
            borderRadius: BorderRadius.circular(TripMuseRadius.sm),
            child: LinearProgressIndicator(
              value: progress.progress,
              backgroundColor: TripMuseTheme.borderColor,
              valueColor: const AlwaysStoppedAnimation<Color>(
                TripMuseTheme.primaryColor,
              ),
              minHeight: 6,
            ),
          ),
          
          if (showDetails) ...[
            const SizedBox(height: TripMuseSpacing.md),
            
            // 階段資訊
            Row(
              children: [
                if (progress.isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        TripMuseTheme.primaryColor,
                      ),
                    ),
                  ),
                const SizedBox(width: TripMuseSpacing.sm),
                Expanded(
                  child: Text(
                    progress.message ?? progress.phase.displayName,
                    style: const TextStyle(
                      fontSize: 14,
                      color: TripMuseTheme.textSecondary,
                    ),
                  ),
                ),
                Text(
                  '${(progress.progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: TripMuseTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// 行程生成狀態管理擴展
extension TripGenerationProgressExtension on TripGenerationProgress {
  /// 取得階段顏色
  Color get phaseColor {
    switch (phase) {
      case TripGenerationPhase.idle:
        return Colors.grey;
      case TripGenerationPhase.analyzingPreferences:
        return Colors.blue;
      case TripGenerationPhase.generatingItinerary:
        return Colors.orange;
      case TripGenerationPhase.enhancingPlaces:
        return Colors.purple;
      case TripGenerationPhase.validating:
        return Colors.green;
      case TripGenerationPhase.completed:
        return TripMuseTheme.successColor;
    }
  }

  /// 取得階段圖示
  IconData get phaseIcon {
    switch (phase) {
      case TripGenerationPhase.idle:
        return Icons.hourglass_empty;
      case TripGenerationPhase.analyzingPreferences:
        return Icons.psychology;
      case TripGenerationPhase.generatingItinerary:
        return Icons.route;
      case TripGenerationPhase.enhancingPlaces:
        return Icons.place;
      case TripGenerationPhase.validating:
        return Icons.check_circle_outline;
      case TripGenerationPhase.completed:
        return Icons.check_circle;
    }
  }

  /// 是否可以取消
  bool get canCancel {
    return isLoading && phase != TripGenerationPhase.validating;
  }

  /// 是否可以重試
  bool get canRetry {
    return hasError || phase == TripGenerationPhase.idle;
  }
}