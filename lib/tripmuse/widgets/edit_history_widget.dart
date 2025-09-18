/// TripMuse 編輯歷史 Widget
/// 
/// 提供復原(Undo)、重做(Redo)功能和編輯歷史查看

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/edit_history_service.dart';
import '../services/offline_edit_manager.dart';

/// 編輯歷史工具列
class EditHistoryToolbar extends ConsumerWidget {
  final String tripId;
  final VoidCallback? onUndo;
  final VoidCallback? onRedo;
  
  const EditHistoryToolbar({
    super.key,
    required this.tripId,
    this.onUndo,
    this.onRedo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(editHistoryProvider(tripId));
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: historyState.canUndo ? () => _performUndo(context, ref) : null,
          icon: const Icon(Icons.undo),
          tooltip: historyState.canUndo 
              ? '復原: ${historyState.nextUndoDescription}'
              : '無法復原',
        ),
        IconButton(
          onPressed: historyState.canRedo ? () => _performRedo(context, ref) : null,
          icon: const Icon(Icons.redo),
          tooltip: historyState.canRedo 
              ? '重做: ${historyState.nextRedoDescription}'
              : '無法重做',
        ),
        IconButton(
          onPressed: () => _showHistoryDialog(context, ref),
          icon: const Icon(Icons.history),
          tooltip: '編輯歷史',
        ),
      ],
    );
  }
  
  /// 執行復原
  Future<void> _performUndo(BuildContext context, WidgetRef ref) async {
    try {
      final result = await ref.read(offlineEditStateProvider.notifier).undoEdit(tripId);
      
      if (result != null) {
        onUndo?.call();
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('已復原'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('復原失敗: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  /// 執行重做
  Future<void> _performRedo(BuildContext context, WidgetRef ref) async {
    try {
      final result = await ref.read(offlineEditStateProvider.notifier).redoEdit(tripId);
      
      if (result != null) {
        onRedo?.call();
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('已重做'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('重做失敗: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  /// 顯示編輯歷史對話框
  void _showHistoryDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => EditHistoryDialog(tripId: tripId),
    );
  }
}

/// 編輯歷史對話框
class EditHistoryDialog extends ConsumerWidget {
  final String tripId;
  
  const EditHistoryDialog({
    super.key,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(editHistoryProvider(tripId));
    
    return AlertDialog(
      title: const Text('編輯歷史'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            _buildHistoryStats(historyState),
            const SizedBox(height: 16),
            Expanded(
              child: _buildHistoryList(historyState),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: historyState.undoStack.isNotEmpty || historyState.redoStack.isNotEmpty
              ? () => _clearHistory(context, ref)
              : null,
          child: const Text('清除歷史'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('關閉'),
        ),
      ],
    );
  }
  
  /// 建立歷史統計
  Widget _buildHistoryStats(EditHistoryState historyState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('可復原', historyState.undoStack.length.toString()),
            _buildStatItem('可重做', historyState.redoStack.length.toString()),
            _buildStatItem('記錄狀態', historyState.isRecording ? '開啟' : '暫停'),
          ],
        ),
      ),
    );
  }
  
  /// 建立統計項目
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
  
  /// 建立歷史列表
  Widget _buildHistoryList(EditHistoryState historyState) {
    final allActions = <EditAction>[];
    
    // 添加 undo 堆疊（倒序）
    allActions.addAll(historyState.undoStack.reversed);
    
    // 添加 redo 堆疊
    allActions.addAll(historyState.redoStack);
    
    if (allActions.isEmpty) {
      return const Center(
        child: Text('沒有編輯歷史'),
      );
    }
    
    return ListView.builder(
      itemCount: allActions.length,
      itemBuilder: (context, index) {
        final action = allActions[index];
        final isInUndoStack = index < historyState.undoStack.length;
        final isCurrentPosition = index == historyState.undoStack.length - 1;
        
        return _buildHistoryItem(action, isInUndoStack, isCurrentPosition);
      },
    );
  }
  
  /// 建立歷史項目
  Widget _buildHistoryItem(EditAction action, bool isInUndoStack, bool isCurrentPosition) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      color: isCurrentPosition 
          ? Colors.blue.shade50 
          : isInUndoStack 
              ? null 
              : Colors.grey.shade100,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isCurrentPosition 
              ? Colors.blue 
              : isInUndoStack 
                  ? Colors.green 
                  : Colors.grey,
          child: Icon(
            _getActionIcon(action.type),
            color: Colors.white,
            size: 16,
          ),
        ),
        title: Text(
          action.description,
          style: TextStyle(
            fontWeight: isCurrentPosition ? FontWeight.bold : null,
            color: isInUndoStack ? null : Colors.grey.shade600,
          ),
        ),
        subtitle: Text(
          _formatDateTime(action.timestamp),
          style: const TextStyle(fontSize: 12),
        ),
        trailing: isCurrentPosition 
            ? const Icon(Icons.arrow_forward, color: Colors.blue)
            : null,
      ),
    );
  }
  
  /// 取得動作圖示
  IconData _getActionIcon(EditActionType type) {
    switch (type) {
      case EditActionType.createTrip:
        return Icons.add;
      case EditActionType.updateTrip:
        return Icons.edit;
      case EditActionType.deleteTrip:
        return Icons.delete;
      case EditActionType.addActivity:
        return Icons.add_circle;
      case EditActionType.updateActivity:
        return Icons.edit_note;
      case EditActionType.deleteActivity:
        return Icons.remove_circle;
      case EditActionType.moveActivity:
        return Icons.swap_horiz;
      case EditActionType.reorderActivities:
        return Icons.reorder;
      case EditActionType.updateDayPlan:
        return Icons.schedule;
    }
  }
  
  /// 清除歷史
  Future<void> _clearHistory(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('確認清除'),
        content: const Text('確定要清除所有編輯歷史嗎？此操作無法復原。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('確定'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      try {
        await ref.read(editHistoryProvider(tripId).notifier).clearHistory();
        
        if (context.mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('編輯歷史已清除'),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('清除歷史失敗: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
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
}

/// 浮動復原/重做按鈕
class FloatingUndoRedoButtons extends ConsumerWidget {
  final String tripId;
  final VoidCallback? onUndo;
  final VoidCallback? onRedo;
  
  const FloatingUndoRedoButtons({
    super.key,
    required this.tripId,
    this.onUndo,
    this.onRedo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(editHistoryProvider(tripId));
    
    if (!historyState.canUndo && !historyState.canRedo) {
      return const SizedBox.shrink();
    }
    
    return Positioned(
      bottom: 80,
      right: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (historyState.canRedo)
            FloatingActionButton.small(
              onPressed: () => _performRedo(context, ref),
              heroTag: 'redo',
              child: const Icon(Icons.redo),
            ),
          if (historyState.canRedo && historyState.canUndo)
            const SizedBox(height: 8),
          if (historyState.canUndo)
            FloatingActionButton.small(
              onPressed: () => _performUndo(context, ref),
              heroTag: 'undo',
              child: const Icon(Icons.undo),
            ),
        ],
      ),
    );
  }
  
  /// 執行復原
  Future<void> _performUndo(BuildContext context, WidgetRef ref) async {
    try {
      final result = await ref.read(offlineEditStateProvider.notifier).undoEdit(tripId);
      
      if (result != null) {
        onUndo?.call();
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('已復原'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('復原失敗: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  /// 執行重做
  Future<void> _performRedo(BuildContext context, WidgetRef ref) async {
    try {
      final result = await ref.read(offlineEditStateProvider.notifier).redoEdit(tripId);
      
      if (result != null) {
        onRedo?.call();
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('已重做'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('重做失敗: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}