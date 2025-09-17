/// TripMuse 行程編輯工具欄組件
///
/// 提供編輯模式的切換和相關操作按鈕

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/trip_edit_mode_provider.dart';

class TripEditToolbar extends ConsumerWidget {
  final String tripId;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;

  const TripEditToolbar({
    super.key,
    required this.tripId,
    this.onSave,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = ref.watch(isEditingTripProvider(tripId));
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isEditMode ? 60 : 0,
      child: isEditMode
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade50,
                    Colors.blue.shade100,
                  ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.blue.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // 編輯模式指示器
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6),
                        Text(
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
                  
                  // 提示文字
                  Expanded(
                    child: Text(
                      '拖拉活動調整順序，長按編輯內容',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  // 操作按鈕
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 儲存按鈕
                      TextButton.icon(
                        onPressed: () {
                          onSave?.call();
                          ref.read(tripEditModeProvider.notifier).exitEditMode();
                        },
                        icon: const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.green,
                        ),
                        label: const Text(
                          '完成',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      // 取消按鈕
                      TextButton.icon(
                        onPressed: () {
                          onCancel?.call();
                          ref.read(tripEditModeProvider.notifier).exitEditMode();
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.red,
                        ),
                        label: const Text(
                          '取消',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

/// 浮動編輯按鈕組件
class FloatingEditButton extends ConsumerWidget {
  final String tripId;
  final VoidCallback? onPressed;

  const FloatingEditButton({
    super.key,
    required this.tripId,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = ref.watch(isEditingTripProvider(tripId));

    return AnimatedScale(
      scale: isEditMode ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: FloatingActionButton(
        onPressed: isEditMode ? null : () {
          ref.read(tripEditModeProvider.notifier).enterEditMode(tripId);
          onPressed?.call();
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.edit),
      ),
    );
  }
}

/// AppBar 編輯按鈕組件
class AppBarEditButton extends ConsumerWidget {
  final String tripId;

  const AppBarEditButton({
    super.key,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = ref.watch(isEditingTripProvider(tripId));

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            final wasEditMode = isEditMode;
            ref.read(tripEditModeProvider.notifier).toggleEditMode(tripId);
            // 顯示編輯模式切換的提示
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(wasEditMode ? '已退出編輯模式' : '已進入編輯模式'),
                backgroundColor: wasEditMode ? Colors.orange : Colors.blue,
                duration: const Duration(seconds: 2),
              ),
            );
            break;
          case 'share':
            // 分享功能
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('分享功能開發中...'),
                backgroundColor: Colors.orange,
              ),
            );
            break;
          case 'export':
            // 匯出功能
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('匯出功能開發中...'),
                backgroundColor: Colors.orange,
              ),
            );
            break;
          case 'delete':
            // 刪除功能
            _showDeleteConfirmation(context, ref);
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                isEditMode ? Icons.edit_off : Icons.edit,
                color: isEditMode ? Colors.red : Colors.blue,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                isEditMode ? '退出編輯' : '編輯行程',
                style: TextStyle(
                  color: isEditMode ? Colors.red : Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'share',
          child: Row(
            children: [
              Icon(Icons.share, color: Colors.green, size: 20),
              SizedBox(width: 12),
              Text('分享行程', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'export',
          child: Row(
            children: [
              Icon(Icons.download, color: Colors.orange, size: 20),
              SizedBox(width: 12),
              Text('匯出 PDF', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red, size: 20),
              SizedBox(width: 12),
              Text('刪除行程', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('刪除行程'),
        content: const Text('確定要刪除這個行程嗎？此操作無法復原。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // 這裡應該實作刪除邏輯
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('刪除功能開發中...'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('刪除'),
          ),
        ],
      ),
    );
  }
}