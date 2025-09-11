/// TripMuse 行程生成 UI 演示頁面
/// 
/// 展示新的行程生成進度指示器、錯誤處理和設定功能

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../providers/trip_generation_provider.dart';
import '../widgets/widgets.dart';

class TripGenerationDemoScreen extends ConsumerStatefulWidget {
  const TripGenerationDemoScreen({super.key});

  @override
  ConsumerState<TripGenerationDemoScreen> createState() =>
      _TripGenerationDemoScreenState();
}

class _TripGenerationDemoScreenState
    extends ConsumerState<TripGenerationDemoScreen> {
  
  final _mockRequest = TripRequest(
    destination: '台北',
    days: 3,
    description: '我想要一趟放鬆的美食之旅，體驗當地文化和歷史',
    preferences: TripPreferences(
      budget: 'mid',
      pace: 'slow',
      interests: ['美食', '文化'],
      companions: 2,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('行程生成 UI 演示'),
        backgroundColor: TripMuseTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _showSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TripMuseSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: TripMuseSpacing.xl),
            _buildProgressDemo(),
            const SizedBox(height: TripMuseSpacing.xl),
            _buildErrorDemo(),
            const SizedBox(height: TripMuseSpacing.xl),
            _buildStateDemo(),
            const SizedBox(height: TripMuseSpacing.xl),
            _buildQuickSettings(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TripMuseSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: TripMuseTheme.primaryColor,
                  size: 28,
                ),
                const SizedBox(width: TripMuseSpacing.md),
                const Text(
                  '行程生成 UI 功能演示',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: TripMuseTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TripMuseSpacing.md),
            const Text(
              '這個頁面展示了新的行程生成 UI 功能，包含：\n'
              '• 詳細的進度指示器和載入動畫\n'
              '• 取消生成功能和超時處理\n'
              '• 智能錯誤處理和重試機制\n'
              '• 生成結果的狀態管理和快取',
              style: TextStyle(
                color: TripMuseTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TripMuseSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 進度指示器演示',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TripMuseTheme.textPrimary,
              ),
            ),
            const SizedBox(height: TripMuseSpacing.md),
            const Text(
              '展示完整的行程生成進度對話框',
              style: TextStyle(color: TripMuseTheme.textSecondary),
            ),
            const SizedBox(height: TripMuseSpacing.lg),
            
            // 進度指示器預覽
            const TripGenerationProgressIndicator(
              showDetails: true,
            ),
            
            const SizedBox(height: TripMuseSpacing.lg),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showProgressDialog,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('顯示進度對話框'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TripMuseTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: TripMuseSpacing.md),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _simulateGeneration,
                    icon: const Icon(Icons.science),
                    label: const Text('模擬生成'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TripMuseSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '❌ 錯誤處理演示',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TripMuseTheme.textPrimary,
              ),
            ),
            const SizedBox(height: TripMuseSpacing.md),
            const Text(
              '展示不同類型的錯誤處理和重試機制',
              style: TextStyle(color: TripMuseTheme.textSecondary),
            ),
            const SizedBox(height: TripMuseSpacing.lg),
            
            // 錯誤類型按鈕
            Wrap(
              spacing: TripMuseSpacing.sm,
              runSpacing: TripMuseSpacing.sm,
              children: [
                _buildErrorButton('網路錯誤', '網路連線失敗'),
                _buildErrorButton('超時錯誤', '請求超時'),
                _buildErrorButton('API 限制', 'API 使用限制'),
                _buildErrorButton('驗證錯誤', '資料驗證失敗'),
                _buildErrorButton('伺服器錯誤', '伺服器內部錯誤 500'),
                _buildErrorButton('未知錯誤', '未知的錯誤訊息'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorButton(String label, String error) {
    return ElevatedButton(
      onPressed: () => _showErrorDialog(error),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade50,
        foregroundColor: Colors.red.shade700,
        elevation: 0,
      ),
      child: Text(label),
    );
  }

  Widget _buildStateDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TripMuseSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔄 狀態管理演示',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TripMuseTheme.textPrimary,
              ),
            ),
            const SizedBox(height: TripMuseSpacing.md),
            
            // 當前狀態顯示
            Consumer(
              builder: (context, ref, child) {
                final generationState = ref.watch(tripGenerationControllerProvider);
                
                return Container(
                  padding: const EdgeInsets.all(TripMuseSpacing.md),
                  decoration: BoxDecoration(
                    color: TripMuseTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(TripMuseRadius.lg),
                    border: Border.all(color: TripMuseTheme.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getStateIcon(generationState.state),
                            color: _getStateColor(generationState.state),
                            size: 20,
                          ),
                          const SizedBox(width: TripMuseSpacing.sm),
                          Text(
                            '狀態: ${_getStateText(generationState.state)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: TripMuseTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      if (generationState.currentPhase != null) ...[
                        const SizedBox(height: TripMuseSpacing.xs),
                        Text(
                          '階段: ${generationState.currentPhase}',
                          style: const TextStyle(
                            color: TripMuseTheme.textSecondary,
                          ),
                        ),
                      ],
                      if (generationState.progress > 0) ...[
                        const SizedBox(height: TripMuseSpacing.xs),
                        Text(
                          '進度: ${(generationState.progress * 100).toInt()}%',
                          style: const TextStyle(
                            color: TripMuseTheme.textSecondary,
                          ),
                        ),
                      ],
                      if (generationState.retryCount > 0) ...[
                        const SizedBox(height: TripMuseSpacing.xs),
                        Text(
                          '重試次數: ${generationState.retryCount}',
                          style: const TextStyle(
                            color: TripMuseTheme.textSecondary,
                          ),
                        ),
                      ],
                      if (generationState.elapsedTime != null) ...[
                        const SizedBox(height: TripMuseSpacing.xs),
                        Text(
                          '已用時間: ${generationState.elapsedTime!.inSeconds}秒',
                          style: const TextStyle(
                            color: TripMuseTheme.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: TripMuseSpacing.lg),
            
            // 狀態控制按鈕
            Consumer(
              builder: (context, ref, child) {
                final controller = ref.read(tripGenerationControllerProvider.notifier);
                final state = ref.watch(tripGenerationControllerProvider);
                
                return Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: state.isLoading ? null : () => _startGeneration(controller),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('開始生成'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TripMuseTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: TripMuseSpacing.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: state.canCancel ? () => controller.cancelGeneration() : null,
                        icon: const Icon(Icons.stop),
                        label: const Text('取消'),
                      ),
                    ),
                    const SizedBox(width: TripMuseSpacing.sm),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: state.canRetry ? () => _retryGeneration(controller) : null,
                        icon: const Icon(Icons.refresh),
                        label: const Text('重試'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSettings() {
    return const TripGenerationQuickSettings();
  }

  // 事件處理方法
  void _showSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TripGenerationSettingsScreen(),
      ),
    );
  }

  void _showProgressDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TripGenerationProgressDialog(
        request: _mockRequest,
        onSuccess: (trip) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🎉 行程生成成功！${trip.title}'),
              backgroundColor: TripMuseTheme.successColor,
            ),
          );
        },
        onError: (error) {
          TripGenerationErrorSnackBar.show(context, error);
        },
        onCancel: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('行程生成已取消'),
              backgroundColor: TripMuseTheme.warningColor,
            ),
          );
        },
      ),
    );
  }

  void _simulateGeneration() async {
    final controller = ref.read(tripGenerationControllerProvider.notifier);
    
    try {
      await controller.generateTrip(_mockRequest);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('模擬生成完成'),
            backgroundColor: TripMuseTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        TripGenerationErrorSnackBar.show(context, e.toString());
      }
    }
  }

  void _showErrorDialog(String error) {
    final errorDetails = TripGenerationErrorDetails.fromError(error);
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: TripGenerationErrorWidget(
          errorDetails: errorDetails,
          originalRequest: _mockRequest,
          onRetry: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('重試中...'),
                backgroundColor: TripMuseTheme.primaryColor,
              ),
            );
          },
          onCancel: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _startGeneration(TripGenerationController controller) async {
    try {
      await controller.generateTrip(_mockRequest);
    } catch (e) {
      // 錯誤已在狀態中處理
    }
  }

  void _retryGeneration(TripGenerationController controller) async {
    try {
      await controller.retryGeneration(_mockRequest);
    } catch (e) {
      if (mounted) {
        TripGenerationErrorSnackBar.show(context, e.toString());
      }
    }
  }

  // 輔助方法
  IconData _getStateIcon(TripGenerationState state) {
    switch (state) {
      case TripGenerationState.idle:
        return Icons.hourglass_empty;
      case TripGenerationState.loading:
        return Icons.autorenew;
      case TripGenerationState.success:
        return Icons.check_circle;
      case TripGenerationState.error:
        return Icons.error;
      case TripGenerationState.cancelled:
        return Icons.cancel;
      case TripGenerationState.timeout:
        return Icons.access_time;
    }
  }

  Color _getStateColor(TripGenerationState state) {
    switch (state) {
      case TripGenerationState.idle:
        return Colors.grey;
      case TripGenerationState.loading:
        return TripMuseTheme.primaryColor;
      case TripGenerationState.success:
        return TripMuseTheme.successColor;
      case TripGenerationState.error:
        return TripMuseTheme.errorColor;
      case TripGenerationState.cancelled:
        return Colors.orange;
      case TripGenerationState.timeout:
        return Colors.amber;
    }
  }

  String _getStateText(TripGenerationState state) {
    switch (state) {
      case TripGenerationState.idle:
        return '待機中';
      case TripGenerationState.loading:
        return '生成中';
      case TripGenerationState.success:
        return '成功';
      case TripGenerationState.error:
        return '錯誤';
      case TripGenerationState.cancelled:
        return '已取消';
      case TripGenerationState.timeout:
        return '超時';
    }
  }
}