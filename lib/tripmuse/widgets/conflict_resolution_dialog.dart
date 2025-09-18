/// TripMuse 衝突解決對話框
/// 
/// 提供使用者介面來解決同步衝突

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/conflict_resolution_service.dart';
import '../services/offline_edit_manager.dart';

/// 衝突解決對話框
class ConflictResolutionDialog extends ConsumerStatefulWidget {
  const ConflictResolutionDialog({super.key});

  @override
  ConsumerState<ConflictResolutionDialog> createState() => _ConflictResolutionDialogState();
}

class _ConflictResolutionDialogState extends ConsumerState<ConflictResolutionDialog> {
  int _currentConflictIndex = 0;
  bool _isResolving = false;

  @override
  Widget build(BuildContext context) {
    final conflicts = ref.watch(conflictResolutionProvider);
    final unresolvedConflicts = conflicts.where((c) => !c.isResolved).toList();
    
    if (unresolvedConflicts.isEmpty) {
      return AlertDialog(
        title: const Text('同步衝突'),
        content: const Text('沒有需要解決的衝突'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('關閉'),
          ),
        ],
      );
    }
    
    final currentConflict = unresolvedConflicts[_currentConflictIndex];
    
    return AlertDialog(
      title: Text('解決衝突 (${_currentConflictIndex + 1}/${unresolvedConflicts.length})'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentConflict.description,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            _buildConflictDetails(currentConflict),
            const SizedBox(height: 16),
            _buildResolutionOptions(currentConflict),
          ],
        ),
      ),
      actions: [
        if (unresolvedConflicts.length > 1) ...[
          TextButton(
            onPressed: _currentConflictIndex > 0 ? _previousConflict : null,
            child: const Text('上一個'),
          ),
          TextButton(
            onPressed: _currentConflictIndex < unresolvedConflicts.length - 1 ? _nextConflict : null,
            child: const Text('下一個'),
          ),
        ],
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
      ],
    );
  }
  
  /// 建立衝突詳情
  Widget _buildConflictDetails(SyncConflict conflict) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '衝突時間: ${_formatDateTime(conflict.detectedAt)}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildVersionCard(
                '本地版本',
                conflict.localModifiedAt,
                conflict.localData,
                conflict.isLocalNewer,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildVersionCard(
                '雲端版本',
                conflict.remoteModifiedAt,
                conflict.remoteData,
                conflict.isRemoteNewer,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  /// 建立版本卡片
  Widget _buildVersionCard(
    String title,
    DateTime modifiedAt,
    Map<String, dynamic> data,
    bool isNewer,
  ) {
    return Card(
      color: isNewer ? Colors.green.shade50 : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                if (isNewer) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.new_releases,
                    size: 16,
                    color: Colors.green.shade600,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '修改時間: ${_formatDateTime(modifiedAt)}',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            _buildDataPreview(data),
          ],
        ),
      ),
    );
  }
  
  /// 建立資料預覽
  Widget _buildDataPreview(Map<String, dynamic> data) {
    if (data.isEmpty) {
      return const Text(
        '已刪除',
        style: TextStyle(
          color: Colors.red,
          fontStyle: FontStyle.italic,
        ),
      );
    }
    
    final title = data['title'] as String? ?? data['name'] as String? ?? '未知';
    final description = data['description'] as String?;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (description != null) ...[
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
  
  /// 建立解決選項
  Widget _buildResolutionOptions(SyncConflict conflict) {
    final suggestedStrategy = ref.read(conflictResolutionProvider.notifier)
        .getSuggestedStrategy(conflict);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '選擇解決方式:',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        _buildResolutionButton(
          conflict,
          ConflictResolutionStrategy.useLocal,
          '使用本地版本',
          Icons.phone_android,
          suggestedStrategy == ConflictResolutionStrategy.useLocal,
        ),
        _buildResolutionButton(
          conflict,
          ConflictResolutionStrategy.useRemote,
          '使用雲端版本',
          Icons.cloud,
          suggestedStrategy == ConflictResolutionStrategy.useRemote,
        ),
        if (!conflict.isDeletionConflict) ...[
          _buildResolutionButton(
            conflict,
            ConflictResolutionStrategy.merge,
            '合併版本',
            Icons.merge,
            suggestedStrategy == ConflictResolutionStrategy.merge,
          ),
          _buildResolutionButton(
            conflict,
            ConflictResolutionStrategy.createCopy,
            '建立副本',
            Icons.content_copy,
            false,
          ),
        ],
      ],
    );
  }
  
  /// 建立解決按鈕
  Widget _buildResolutionButton(
    SyncConflict conflict,
    ConflictResolutionStrategy strategy,
    String label,
    IconData icon,
    bool isRecommended,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ElevatedButton.icon(
        onPressed: _isResolving ? null : () => _resolveConflict(conflict, strategy),
        icon: Icon(icon),
        label: Row(
          children: [
            Text(label),
            if (isRecommended) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '建議',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isRecommended ? Colors.green.shade50 : null,
          foregroundColor: isRecommended ? Colors.green.shade700 : null,
        ),
      ),
    );
  }
  
  /// 解決衝突
  Future<void> _resolveConflict(SyncConflict conflict, ConflictResolutionStrategy strategy) async {
    setState(() {
      _isResolving = true;
    });
    
    try {
      final result = await ref.read(offlineEditStateProvider.notifier)
          .resolveConflict(conflict.id, strategy);
      
      if (result != null && !result.requiresUserAction) {
        // 解決成功，移動到下一個衝突或關閉對話框
        final conflicts = ref.read(conflictResolutionProvider);
        final unresolvedConflicts = conflicts.where((c) => !c.isResolved).toList();
        
        if (unresolvedConflicts.length <= 1) {
          // 沒有更多衝突，關閉對話框
          if (mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('所有衝突已解決'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          // 移動到下一個衝突
          setState(() {
            if (_currentConflictIndex >= unresolvedConflicts.length - 1) {
              _currentConflictIndex = 0;
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('解決衝突失敗: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResolving = false;
        });
      }
    }
  }
  
  /// 上一個衝突
  void _previousConflict() {
    setState(() {
      _currentConflictIndex = (_currentConflictIndex - 1).clamp(0, double.infinity).toInt();
    });
  }
  
  /// 下一個衝突
  void _nextConflict() {
    final conflicts = ref.read(conflictResolutionProvider);
    final unresolvedConflicts = conflicts.where((c) => !c.isResolved).toList();
    
    setState(() {
      _currentConflictIndex = (_currentConflictIndex + 1).clamp(0, unresolvedConflicts.length - 1);
    });
  }
  
  /// 格式化日期時間
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

/// 衝突列表對話框
class ConflictListDialog extends ConsumerWidget {
  const ConflictListDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conflicts = ref.watch(conflictResolutionProvider);
    final unresolvedConflicts = conflicts.where((c) => !c.isResolved).toList();
    
    return AlertDialog(
      title: Text('同步衝突 (${unresolvedConflicts.length})'),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: unresolvedConflicts.isEmpty
            ? const Center(child: Text('沒有需要解決的衝突'))
            : ListView.builder(
                itemCount: unresolvedConflicts.length,
                itemBuilder: (context, index) {
                  final conflict = unresolvedConflicts[index];
                  return _buildConflictListItem(context, ref, conflict);
                },
              ),
      ),
      actions: [
        if (unresolvedConflicts.isNotEmpty)
          TextButton(
            onPressed: () => _resolveAllConflicts(context, ref),
            child: const Text('自動解決全部'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('關閉'),
        ),
      ],
    );
  }
  
  /// 建立衝突列表項目
  Widget _buildConflictListItem(BuildContext context, WidgetRef ref, SyncConflict conflict) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          _getConflictIcon(conflict.type),
          color: Colors.red.shade600,
        ),
        title: Text(conflict.description),
        subtitle: Text(
          '檢測時間: ${_formatDateTime(conflict.detectedAt)}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => _showConflictResolutionDialog(context, conflict),
        ),
      ),
    );
  }
  
  /// 取得衝突圖示
  IconData _getConflictIcon(ConflictType type) {
    switch (type) {
      case ConflictType.tripModified:
        return Icons.edit;
      case ConflictType.activityModified:
        return Icons.event;
      case ConflictType.dayPlanModified:
        return Icons.schedule;
      case ConflictType.tripDeleted:
        return Icons.delete;
      case ConflictType.activityDeleted:
        return Icons.delete_outline;
    }
  }
  
  /// 顯示衝突解決對話框
  void _showConflictResolutionDialog(BuildContext context, SyncConflict conflict) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) => const ConflictResolutionDialog(),
    );
  }
  
  /// 自動解決所有衝突
  Future<void> _resolveAllConflicts(BuildContext context, WidgetRef ref) async {
    final conflicts = ref.read(conflictResolutionProvider);
    final unresolvedConflicts = conflicts.where((c) => !c.isResolved).toList();
    
    try {
      for (final conflict in unresolvedConflicts) {
        final suggestedStrategy = ref.read(conflictResolutionProvider.notifier)
            .getSuggestedStrategy(conflict);
        
        await ref.read(offlineEditStateProvider.notifier)
            .resolveConflict(conflict.id, suggestedStrategy);
      }
      
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('所有衝突已自動解決'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('自動解決衝突失敗: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  /// 格式化日期時間
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}