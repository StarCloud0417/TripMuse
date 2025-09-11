/// 簡化版行程生成進度對話框
/// 
/// 整合實際的 GCP server 請求功能

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../services/services.dart';

/// 簡化版進度對話框
class SimpleProgressDialog extends ConsumerStatefulWidget {
  final TripRequest request;
  final VoidCallback? onCancel;
  final Function(Trip)? onSuccess;
  final Function(String)? onError;

  const SimpleProgressDialog({
    super.key,
    required this.request,
    this.onCancel,
    this.onSuccess,
    this.onError,
  });

  @override
  ConsumerState<SimpleProgressDialog> createState() => _SimpleProgressDialogState();
}

class _SimpleProgressDialogState extends ConsumerState<SimpleProgressDialog>
    with TickerProviderStateMixin {
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  double _progress = 0.0;
  String _currentPhase = '準備開始生成...';
  bool _isCompleted = false;
  bool _hasError = false;
  String? _errorMessage;
  
  Timer? _progressTimer;
  Timer? _timeoutTimer;
  
  final List<String> _phases = [
    '正在分析您的旅行偏好...',
    '正在為您規劃精彩行程...',
    '正在補強地點詳細資訊...',
    '正在驗證行程資料...',
    '行程生成完成！',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSimulation();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  void _startSimulation() {
    // 使用實際的 API 請求
    _generateTripWithRealAPI();
  }

  Future<void> _generateTripWithRealAPI() async {
    try {
      // 設定超時
      _timeoutTimer = Timer(const Duration(minutes: 3), () {
        if (!mounted || _isCompleted) return;
        
        setState(() {
          _hasError = true;
          _errorMessage = '生成超時，請檢查網路連線後重試';
        });
        
        widget.onError?.call(_errorMessage!);
      });

      // 階段 1: 分析偏好 (0-20%)
      setState(() {
        _progress = 0.1;
        _currentPhase = _phases[0]; // '正在分析您的旅行偏好...'
      });

      await Future.delayed(const Duration(milliseconds: 500));

      // 階段 2: 生成行程 (20-70%)
      setState(() {
        _progress = 0.3;
        _currentPhase = _phases[1]; // '正在為您規劃精彩行程...'
      });

      // 實際呼叫 API
      final tripService = ref.read(tripServiceProvider);
      
      // 使用增強的生成服務，包含進度回調
      final trip = await tripService.generateTrip(
        widget.request,
        onProgress: (progress) {
          if (!mounted) return;
          
          setState(() {
            _progress = 0.3 + (progress.progress * 0.4); // 30% 到 70%
            
            // 根據生成階段更新顯示文字
            switch (progress.phase) {
              case TripGenerationPhase.analyzingPreferences:
                _currentPhase = _phases[0];
                break;
              case TripGenerationPhase.generatingItinerary:
                _currentPhase = _phases[1];
                break;
              case TripGenerationPhase.enhancingPlaces:
                _currentPhase = _phases[2];
                break;
              case TripGenerationPhase.validating:
                _currentPhase = _phases[3];
                break;
              case TripGenerationPhase.completed:
                _currentPhase = _phases[4];
                break;
              default:
                break;
            }
          });
        },
        useCache: true,
      );

      // 階段 3: 補強地點資訊 (70-90%)
      setState(() {
        _progress = 0.8;
        _currentPhase = _phases[2]; // '正在補強地點詳細資訊...'
      });

      await Future.delayed(const Duration(milliseconds: 300));

      // 階段 4: 驗證資料 (90-95%)
      setState(() {
        _progress = 0.95;
        _currentPhase = _phases[3]; // '正在驗證行程資料...'
      });

      await Future.delayed(const Duration(milliseconds: 200));

      // 完成 (100%)
      setState(() {
        _progress = 1.0;
        _isCompleted = true;
        _currentPhase = _phases[4]; // '行程生成完成！'
      });

      _timeoutTimer?.cancel();

      // 延遲一下讓使用者看到完成動畫
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted && !_hasError) {
          widget.onSuccess?.call(trip);
          Navigator.of(context).pop(trip);
        }
      });

    } catch (e) {
      _timeoutTimer?.cancel();
      
      if (!mounted) return;
      
      setState(() {
        _hasError = true;
        _errorMessage = _parseErrorMessage(e.toString());
      });
      
      widget.onError?.call(_errorMessage!);
    }
  }

  String _parseErrorMessage(String error) {
    if (error.contains('NetworkException') || error.contains('網路')) {
      return '網路連線錯誤，請檢查網路後重試';
    } else if (error.contains('timeout') || error.contains('超時')) {
      return '請求超時，請稍後重試';
    } else if (error.contains('ServerException') || error.contains('伺服器')) {
      return '伺服器暫時無法處理請求，請稍後重試';
    } else if (error.contains('ApiException')) {
      return error.replaceAll('ApiException: ', '');
    } else {
      return '生成失敗：$error';
    }
  }

  // 移除模擬資料生成方法，現在使用真實 API

  @override
  void dispose() {
    _pulseController.dispose();
    _progressTimer?.cancel();
    _timeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
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
                  color: _hasError 
                      ? Colors.red.withValues(alpha: 51.0)
                      : TripMuseTheme.primaryColor.withValues(alpha: 51.0),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _hasError 
                      ? Icons.error_outline
                      : _isCompleted 
                          ? Icons.check_circle
                          : Icons.auto_awesome,
                  size: 40,
                  color: _hasError 
                      ? Colors.red
                      : _isCompleted 
                          ? Colors.green
                          : TripMuseTheme.primaryColor,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: TripMuseSpacing.lg),
        Text(
          _hasError 
              ? '生成失敗'
              : _isCompleted 
                  ? '生成完成！'
                  : '正在為您規劃行程',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _hasError 
                    ? Colors.red
                    : TripMuseTheme.textPrimary,
              ),
        ),
        const SizedBox(height: TripMuseSpacing.sm),
        Text(
          _hasError 
              ? _errorMessage ?? '發生未知錯誤'
              : _isCompleted 
                  ? '您的專屬行程已準備就緒'
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
    if (_hasError) {
      return Container(
        padding: const EdgeInsets.all(TripMuseSpacing.md),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(TripMuseRadius.lg),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.shade700,
              size: 20,
            ),
            const SizedBox(width: TripMuseSpacing.sm),
            Expanded(
              child: Text(
                '請檢查網路連線後重試，或聯絡客服協助',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red.shade700,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // 進度條
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _currentPhase,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: TripMuseTheme.textPrimary,
              ),
            ),
            Text(
              '${(_progress * 100).toInt()}%',
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
            value: _progress,
            backgroundColor: TripMuseTheme.borderColor,
            valueColor: AlwaysStoppedAnimation<Color>(
              _isCompleted ? Colors.green : TripMuseTheme.primaryColor,
            ),
            minHeight: 8,
          ),
        ),
        
        const SizedBox(height: TripMuseSpacing.lg),
        
        // 當前階段顯示
        Container(
          padding: const EdgeInsets.all(TripMuseSpacing.md),
          decoration: BoxDecoration(
            color: TripMuseTheme.surfaceColor,
            borderRadius: BorderRadius.circular(TripMuseRadius.lg),
            border: Border.all(color: TripMuseTheme.borderColor),
          ),
          child: Row(
            children: [
              Icon(
                _isCompleted 
                    ? Icons.check_circle
                    : Icons.autorenew,
                color: _isCompleted 
                    ? Colors.green
                    : TripMuseTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: TripMuseSpacing.md),
              Expanded(
                child: Text(
                  _currentPhase,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: TripMuseTheme.textPrimary,
                  ),
                ),
              ),
              if (!_isCompleted && !_hasError)
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
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (_isCompleted) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.check),
          label: const Text('完成'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: TripMuseSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TripMuseRadius.lg),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              widget.onCancel?.call();
              Navigator.of(context).pop();
            },
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
        if (_hasError) ...[
          const SizedBox(width: TripMuseSpacing.md),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _errorMessage = null;
                  _progress = 0.0;
                  _currentPhase = '準備開始生成...';
                  _isCompleted = false;
                });
                _generateTripWithRealAPI();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TripMuseTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TripMuseRadius.lg),
                ),
                padding: const EdgeInsets.symmetric(vertical: TripMuseSpacing.md),
              ),
              child: const Text('重試'),
            ),
          ),
        ],
      ],
    );
  }
}