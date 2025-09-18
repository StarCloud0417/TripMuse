/// TripMuse 行程編輯工具欄組件
///
/// 提供編輯模式的切換和相關操作按鈕

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/trip_edit_mode_provider.dart';
import '../providers/transport_provider.dart';
import '../providers/trip_provider.dart';
import '../models/enums.dart';
import '../services/transport_service.dart';
import 'pdf_export_dialog.dart';

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
      height: isEditMode ? 140 : 0, // 增加高度以容納交通方式選擇器
      child: isEditMode
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.blue.shade100,
                    Colors.blue.shade50,
                  ],
                ),
                border: Border(
                  top: BorderSide(
                    color: Colors.blue.shade200,
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Column(
                    children: [
                      // 第一行：編輯模式指示器和操作按鈕
                      Row(
                        children: [
                          // 編輯模式指示器
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '編輯模式',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
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
                          
                          const SizedBox(width: 16),
                          
                          // 操作按鈕
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 完成按鈕
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withValues(alpha: 0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TextButton.icon(
                                  onPressed: () {
                                    onSave?.call();
                                    ref.read(tripEditModeProvider.notifier).exitEditMode();
                                  },
                                  icon: const Icon(
                                    Icons.check,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    '完成',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ),
                              
                              const SizedBox(width: 12),
                              
                              // 取消按鈕
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.red, width: 1.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: TextButton.icon(
                                  onPressed: () {
                                    onCancel?.call();
                                    ref.read(tripEditModeProvider.notifier).exitEditMode();
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                  label: const Text(
                                    '取消',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // 第二行：全域交通方式選擇器
                      GlobalTransportSelector(tripId: tripId),
                    ],
                  ),
                ),
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

/// 全域交通方式選擇器組件
class GlobalTransportSelector extends ConsumerStatefulWidget {
  final String tripId;

  const GlobalTransportSelector({
    super.key,
    required this.tripId,
  });

  @override
  ConsumerState<GlobalTransportSelector> createState() => _GlobalTransportSelectorState();
}

class _GlobalTransportSelectorState extends ConsumerState<GlobalTransportSelector> {
  TransportMode selectedMode = TransportMode.walking; // 預設為步行

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showTransportModeSelector,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.blue.shade300,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 交通方式圖標和文字
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    TransportService.getTransportModeInfo(selectedMode)['icon'],
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    selectedMode.displayName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 12),
            
            // 說明文字
            Expanded(
              child: Text(
                '點擊更改所有交通方式',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            
            // 下拉箭頭
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.blue.shade600,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showTransportModeSelector() async {
    final selectedTransportMode = await showModalBottomSheet<TransportMode>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // 標題
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.directions,
                    color: Colors.blue.shade600,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      '選擇全域交通方式',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            // 交通方式列表
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: TransportMode.values.length,
                itemBuilder: (context, index) {
                  final mode = TransportMode.values[index];
                  final modeInfo = TransportService.getTransportModeInfo(mode);
                  final isSelected = mode == selectedMode;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? Colors.blue.shade100 
                            : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            modeInfo['icon'],
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      title: Text(
                        modeInfo['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.blue.shade700 : null,
                        ),
                      ),
                      subtitle: Text(
                        '${modeInfo['avgSpeed']} • ${modeInfo['cost']}',
                        style: TextStyle(
                          color: isSelected 
                            ? Colors.blue.shade600 
                            : Colors.grey.shade600,
                        ),
                      ),
                      trailing: isSelected 
                        ? Icon(
                            Icons.check_circle,
                            color: Colors.blue.shade600,
                          )
                        : null,
                      onTap: () => Navigator.pop(context, mode),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: isSelected 
                        ? Colors.blue.shade50 
                        : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (selectedTransportMode != null && selectedTransportMode != selectedMode) {
      setState(() {
        selectedMode = selectedTransportMode;
      });
      
      // 更新所有交通方式
      final success = await ref.read(transportProvider.notifier).updateAllTransportModes(
        tripId: widget.tripId,
        newMode: selectedTransportMode,
      );
      
      if (success) {
        // 刷新行程資料
        ref.invalidate(tripProvider(widget.tripId));
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('已將所有交通方式更新為 ${selectedTransportMode.displayName}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          final error = ref.read(transportErrorProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error ?? '更新交通方式失敗'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
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
            // 匯出 PDF 功能
            _showPdfExportDialog(context, ref);
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

  void _showPdfExportDialog(BuildContext context, WidgetRef ref) async {
    try {
      // 顯示載入指示器
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      
      // 取得行程資料
      final trip = await ref.read(tripProvider(tripId).future);
      
      // 關閉載入指示器
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      
      if (trip != null && context.mounted) {
        showDialog(
          context: context,
          builder: (context) => PdfExportDialog(trip: trip),
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('無法載入行程資料'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // 關閉載入指示器（如果還在顯示）
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('載入行程資料失敗：$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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