/// TripMuse 離線編輯狀態指示器 Widget
/// 
/// 顯示離線編輯狀態、同步進度和衝突提醒

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/offline_edit_manager.dart';

import 'conflict_resolution_dialog.dart';

/// 離線編輯狀態指示器
class OfflineEditStatusWidget extends ConsumerWidget {
  const OfflineEditStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offlineEditState = ref.watch(offlineEditStateProvider);
    
    if (!offlineEditState.needsAttention && offlineEditState.isOnline) {
      return const SizedBox.shrink();
    }
    
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Card(
        color: _getStatusColor(offlineEditState),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatusIcon(offlineEditState),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  offlineEditState.statusDescription,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (offlineEditState.hasUnresolvedConflicts)
                _buildConflictButton(context, ref),
              if (offlineEditState.hasPendingChanges && offlineEditState.isOnline)
                _buildSyncButton(context, ref),
            ],
          ),
        ),
      ),
    );
  }
  
  /// 取得狀態顏色
  Color _getStatusColor(OfflineEditState state) {
    if (state.hasUnresolvedConflicts) {
      return Colors.red.shade600;
    } else if (!state.isOnline) {
      return Colors.orange.shade600;
    } else if (state.hasPendingChanges) {
      return Colors.blue.shade600;
    } else {
      return Colors.green.shade600;
    }
  }
  
  /// 建立狀態圖示
  Widget _buildStatusIcon(OfflineEditState state) {
    if (state.isSyncing) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else if (state.hasUnresolvedConflicts) {
      return const Icon(
        Icons.warning,
        color: Colors.white,
        size: 16,
      );
    } else if (!state.isOnline) {
      return const Icon(
        Icons.cloud_off,
        color: Colors.white,
        size: 16,
      );
    } else if (state.hasPendingChanges) {
      return const Icon(
        Icons.cloud_upload,
        color: Colors.white,
        size: 16,
      );
    } else {
      return const Icon(
        Icons.cloud_done,
        color: Colors.white,
        size: 16,
      );
    }
  }
  
  /// 建立衝突解決按鈕
  Widget _buildConflictButton(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () => _showConflictResolutionDialog(context, ref),
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      child: const Text('解決'),
    );
  }
  
  /// 建立同步按鈕
  Widget _buildSyncButton(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () => _performManualSync(context, ref),
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      child: const Text('同步'),
    );
  }
  
  /// 顯示衝突解決對話框
  void _showConflictResolutionDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const ConflictResolutionDialog(),
    );
  }
  
  /// 執行手動同步
  Future<void> _performManualSync(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(offlineEditStateProvider.notifier).manualSync();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('同步完成'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('同步失敗: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// 簡化版離線狀態指示器（用於 AppBar）
class CompactOfflineStatusWidget extends ConsumerWidget {
  const CompactOfflineStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offlineEditState = ref.watch(offlineEditStateProvider);
    
    return IconButton(
      onPressed: () => _showStatusDialog(context, ref),
      icon: Stack(
        children: [
          _buildStatusIcon(offlineEditState),
          if (offlineEditState.needsAttention)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
      tooltip: offlineEditState.statusDescription,
    );
  }
  
  /// 建立狀態圖示
  Widget _buildStatusIcon(OfflineEditState state) {
    if (state.isSyncing) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else if (state.hasUnresolvedConflicts) {
      return const Icon(Icons.warning, color: Colors.red);
    } else if (!state.isOnline) {
      return const Icon(Icons.cloud_off, color: Colors.orange);
    } else if (state.hasPendingChanges) {
      return const Icon(Icons.cloud_upload, color: Colors.blue);
    } else {
      return const Icon(Icons.cloud_done, color: Colors.green);
    }
  }
  
  /// 顯示狀態對話框
  void _showStatusDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const OfflineEditStatusDialog(),
    );
  }
}

/// 離線編輯狀態詳細對話框
class OfflineEditStatusDialog extends ConsumerWidget {
  const OfflineEditStatusDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offlineEditState = ref.watch(offlineEditStateProvider);
    
    return AlertDialog(
      title: const Text('同步狀態'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusRow('網路狀態', offlineEditState.isOnline ? '已連線' : '離線'),
          _buildStatusRow('自動儲存', offlineEditState.isAutoSaveEnabled ? '已啟用' : '已停用'),
          _buildStatusRow('待同步變更', '${offlineEditState.pendingOperationsCount} 個'),
          _buildStatusRow('未解決衝突', '${offlineEditState.unresolvedConflictCount} 個'),
          if (offlineEditState.lastSyncTime != null)
            _buildStatusRow('最後同步', _formatDateTime(offlineEditState.lastSyncTime!)),
          if (offlineEditState.lastError != null)
            _buildErrorRow('最後錯誤', offlineEditState.lastError!),
        ],
      ),
      actions: [
        if (offlineEditState.hasUnresolvedConflicts)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showConflictResolutionDialog(context, ref);
            },
            child: const Text('解決衝突'),
          ),
        if (offlineEditState.hasPendingChanges && offlineEditState.isOnline)
          TextButton(
            onPressed: () => _performManualSync(context, ref),
            child: const Text('立即同步'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('關閉'),
        ),
      ],
    );
  }
  
  /// 建立狀態行
  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
  
  /// 建立錯誤行
  Widget _buildErrorRow(String label, String error) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Text(
              error,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 格式化日期時間
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return '剛剛';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} 分鐘前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} 小時前';
    } else {
      return '${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
  
  /// 顯示衝突解決對話框
  void _showConflictResolutionDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const ConflictResolutionDialog(),
    );
  }
  
  /// 執行手動同步
  Future<void> _performManualSync(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(offlineEditStateProvider.notifier).manualSync();
      
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('同步完成'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('同步失敗: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}