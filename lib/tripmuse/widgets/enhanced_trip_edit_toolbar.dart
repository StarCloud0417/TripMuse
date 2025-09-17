/// TripMuse 增強版行程編輯工具欄組件
///
/// 提供完整的編輯功能，包括自動儲存、路線最佳化等

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/trip_edit_mode_provider.dart';
import '../providers/activity_edit_provider.dart';
import '../providers/transport_provider.dart';
import '../providers/trip_provider.dart';
import '../services/auto_save_service.dart';

import '../models/enums.dart';


class EnhancedTripEditToolbar extends ConsumerStatefulWidget {
  final String tripId;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;

  const EnhancedTripEditToolbar({
    super.key,
    required this.tripId,
    this.onSave,
    this.onCancel,
  });

  @override
  ConsumerState<EnhancedTripEditToolbar> createState() => _EnhancedTripEditToolbarState();
}

class _EnhancedTripEditToolbarState extends ConsumerState<EnhancedTripEditToolbar> {
  
  TransportMode _selectedTransportMode = TransportMode.walking;
  bool _showAdvancedOptions = false;



  @override
  Widget build(BuildContext context) {
    final isEditMode = ref.watch(isEditingTripProvider(widget.tripId));
    // 暫時禁用自動儲存狀態監聽
    // final autoSaveState = ref.watch(autoSaveProvider);
    final activityEditState = ref.watch(activityEditProvider);
    


    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isEditMode ? null : 0,
      child: isEditMode ? Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.white,
              Colors.white.withValues(alpha: 0.95),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 主要工具欄
              _buildMainToolbar(context, isEditMode, null, activityEditState),
              
              // 進階選項（可展開）
              if (_showAdvancedOptions) _buildAdvancedOptions(context),
            ],
          ),
        ),
      ) : const SizedBox.shrink(),
    );
  }

  Widget _buildMainToolbar(
    BuildContext context,
    bool isEditMode,
    AutoSaveState? autoSaveState,
    ActivityEditState activityEditState,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
      child: Column(
        children: [
          // 第一行：編輯模式指示器和自動儲存狀態
          Row(
            children: [
              // 編輯模式指示器
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '編輯模式',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // 自動儲存狀態（暫時禁用）
              if (autoSaveState != null) _buildAutoSaveIndicator(autoSaveState),
              
              const Spacer(),
              
              // 進階選項切換
              IconButton(
                onPressed: () {
                  setState(() {
                    _showAdvancedOptions = !_showAdvancedOptions;
                  });
                },
                icon: AnimatedRotation(
                  turns: _showAdvancedOptions ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.expand_more),
                ),
                tooltip: '進階選項',
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // 第二行：交通方式選擇
          Row(
            children: [
              // 交通方式選擇
              _buildTransportModeSelector(),
              
              const Spacer(),
              
              // 進階選項提示
              Text(
                '更多選項',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 10),
          
          // 第三行：操作按鈕（兩行佈局）
          Column(
            children: [
              // 第一行按鈕：快速操作
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.directions,
                      label: '生成交通',
                      color: Colors.purple,
                      onPressed: activityEditState.isLoading ? null : () => _generateTransport(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.route,
                      label: '路線最佳化',
                      color: Colors.orange,
                      onPressed: activityEditState.isLoading ? null : () => _optimizeRoute(),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // 第二行按鈕：主要操作
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.check,
                      label: '完成編輯',
                      color: Colors.green,
                      onPressed: () => _saveAndExit(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.close,
                      label: '取消編輯',
                      color: Colors.red,
                      isOutlined: true,
                      onPressed: () => _cancelEdit(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedOptions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '進階編輯選項',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 進階操作按鈕
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildAdvancedButton(
                icon: Icons.auto_awesome,
                label: '智能交通',
                onPressed: () => _autoRecommendTransport(),
              ),
              _buildAdvancedButton(
                icon: Icons.auto_fix_high,
                label: '智能排序',
                onPressed: () => _smartSort(),
              ),
              _buildAdvancedButton(
                icon: Icons.schedule,
                label: '調整時間',
                onPressed: () => _adjustTiming(),
              ),
              _buildAdvancedButton(
                icon: Icons.clear_all,
                label: '清除交通',
                onPressed: () => _clearTransport(),
              ),
              _buildAdvancedButton(
                icon: Icons.analytics,
                label: '行程統計',
                onPressed: () => _showStatistics(),
              ),
              _buildAdvancedButton(
                icon: Icons.backup,
                label: '立即儲存',
                onPressed: () => _saveImmediately(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAutoSaveIndicator(AutoSaveState autoSaveState) {
    if (autoSaveState.isSaving) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '儲存中...',
            style: TextStyle(
              fontSize: 11,
              color: Colors.blue.shade600,
            ),
          ),
        ],
      );
    }

    if (autoSaveState.lastError != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 12,
            color: Colors.red.shade600,
          ),
          const SizedBox(width: 4),
          Text(
            '儲存失敗',
            style: TextStyle(
              fontSize: 11,
              color: Colors.red.shade600,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.cloud_done,
          size: 12,
          color: Colors.green.shade600,
        ),
        const SizedBox(width: 4),
        Text(
          autoSaveState.formattedLastSaveTime,
          style: TextStyle(
            fontSize: 11,
            color: Colors.green.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildTransportModeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TransportMode>(
          value: _selectedTransportMode,
          isDense: true,
          icon: const Icon(Icons.arrow_drop_down, size: 16),
          style: const TextStyle(fontSize: 12, color: Colors.black87),
          onChanged: (TransportMode? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedTransportMode = newValue;
              });
            }
          },
          items: TransportMode.values.map<DropdownMenuItem<TransportMode>>((TransportMode mode) {
            return DropdownMenuItem<TransportMode>(
              value: mode,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_getTransportIcon(mode), size: 14),
                  const SizedBox(width: 4),
                  Text(mode.displayName),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }



  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    bool isOutlined = false,
    VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : color,
        borderRadius: BorderRadius.circular(20),
        border: isOutlined ? Border.all(color: color, width: 1.5) : null,
        boxShadow: isOutlined ? null : [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isOutlined ? color : Colors.white,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isOutlined ? color : Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedButton({
    required IconData icon,
    required String label,
    VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getTransportIcon(TransportMode mode) {
    switch (mode) {
      case TransportMode.walking:
        return Icons.directions_walk;
      case TransportMode.cycling:
        return Icons.directions_bike;
      case TransportMode.driving:
        return Icons.directions_car;
      case TransportMode.transit:
        return Icons.directions_bus;
      case TransportMode.taxi:
        return Icons.local_taxi;
      case TransportMode.metro:
        return Icons.subway;
    }
  }

  void _generateTransport() async {
    final transportNotifier = ref.read(transportProvider.notifier);
    final success = await transportNotifier.generateTransportForTrip(
      tripId: widget.tripId,
      defaultMode: _selectedTransportMode,
    );

    if (mounted) {
      if (success) {
        // 刷新行程資料
        ref.invalidate(tripProvider(widget.tripId));
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已生成 ${_selectedTransportMode.displayName} 交通信息'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final error = ref.read(transportErrorProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? '生成交通信息失敗'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _optimizeRoute() async {
    final activityEditNotifier = ref.read(activityEditProvider.notifier);
    final success = await activityEditNotifier.optimizeTripRoute(
      widget.tripId,
      transportMode: _selectedTransportMode,
      preserveTimeConstraints: true,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '路線已最佳化' : '最佳化失敗'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  void _adjustTiming() async {
    final activityEditNotifier = ref.read(activityEditProvider.notifier);
    final success = await activityEditNotifier.autoAdjustTripTiming(
      widget.tripId,
      _selectedTransportMode,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '時間已自動調整' : '調整失敗'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  void _autoRecommendTransport() async {
    final transportNotifier = ref.read(transportProvider.notifier);
    final success = await transportNotifier.autoRecommendTransports(widget.tripId);

    if (mounted) {
      if (success) {
        // 刷新行程資料
        ref.invalidate(tripProvider(widget.tripId));
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('已自動推薦最適合的交通方式'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final error = ref.read(transportErrorProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? '自動推薦失敗'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _clearTransport() async {
    final transportNotifier = ref.read(transportProvider.notifier);
    final success = await transportNotifier.clearAllTransports(widget.tripId);

    if (mounted) {
      if (success) {
        // 刷新行程資料
        ref.invalidate(tripProvider(widget.tripId));
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('已清除所有交通信息'),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        final error = ref.read(transportErrorProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? '清除失敗'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _smartSort() {
    // 智能排序功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('智能排序功能開發中...'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showStatistics() {
    // 顯示行程統計
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('行程統計功能開發中...'),
        backgroundColor: Colors.purple,
      ),
    );
  }

  void _saveImmediately() async {
    // 暫時禁用自動儲存功能
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('立即儲存功能暫時禁用'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _saveAndExit() {
    widget.onSave?.call();
    ref.read(tripEditModeProvider.notifier).exitEditMode();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('編輯已完成'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _cancelEdit() {
    widget.onCancel?.call();
    ref.read(tripEditModeProvider.notifier).exitEditMode();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已取消編輯'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}