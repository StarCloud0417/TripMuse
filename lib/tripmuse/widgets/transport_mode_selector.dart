import 'package:flutter/material.dart';
import '../models/enums.dart';
import '../services/transport_service.dart';

/// 交通方式選擇器
/// 
/// 讓用戶選擇活動之間的交通方式
class TransportModeSelector extends StatelessWidget {
  final TransportMode selectedMode;
  final ValueChanged<TransportMode> onModeChanged;
  final bool isCompact;

  const TransportModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompactSelector(context);
    } else {
      return _buildFullSelector(context);
    }
  }

  Widget _buildCompactSelector(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: TransportMode.values.length,
        itemBuilder: (context, index) {
          final mode = TransportMode.values[index];
          final isSelected = mode == selectedMode;
          final modeInfo = TransportService.getTransportModeInfo(mode);
          
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => onModeChanged(mode),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? theme.colorScheme.primary 
                    : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected 
                      ? theme.colorScheme.primary 
                      : theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      modeInfo['icon'],
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      modeInfo['name'],
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isSelected 
                          ? theme.colorScheme.onPrimary 
                          : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFullSelector(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '選擇交通方式',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        
        // 使用簡單的垂直列表佈局
        ...TransportMode.values.map((mode) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildTransportListItem(context, mode),
        )),
        
        const SizedBox(height: 16),
        _buildSelectedModeInfo(context),
      ],
    );
  }

  Widget _buildTransportListItem(BuildContext context, TransportMode mode) {
    final theme = Theme.of(context);
    final isSelected = mode == selectedMode;
    final modeInfo = TransportService.getTransportModeInfo(mode);
    
    return GestureDetector(
      onTap: () => onModeChanged(mode),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
            ? theme.colorScheme.primaryContainer 
            : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
              ? theme.colorScheme.primary 
              : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // 圖標
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected 
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  modeInfo['icon'],
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // 交通方式信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    modeInfo['name'],
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected 
                        ? theme.colorScheme.onPrimaryContainer 
                        : theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        modeInfo['avgSpeed'],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isSelected 
                            ? theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7) 
                            : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• ${modeInfo['cost']}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isSelected 
                            ? theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7) 
                            : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // 選中指示器
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedModeInfo(BuildContext context) {
    final theme = Theme.of(context);
    final modeInfo = TransportService.getTransportModeInfo(selectedMode);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                modeInfo['icon'],
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Text(
                '已選擇：${modeInfo['name']}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            modeInfo['description'],
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }


}

/// 交通方式選擇對話框
class TransportModeDialog extends StatefulWidget {
  final TransportMode initialMode;
  final String? fromActivityName;
  final String? toActivityName;

  const TransportModeDialog({
    super.key,
    required this.initialMode,
    this.fromActivityName,
    this.toActivityName,
  });

  @override
  State<TransportModeDialog> createState() => _TransportModeDialogState();
}

class _TransportModeDialogState extends State<TransportModeDialog> {
  late TransportMode selectedMode;

  @override
  void initState() {
    super.initState();
    selectedMode = widget.initialMode;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.8,
          maxWidth: 400,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 標題區域
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.directions,
                        color: theme.colorScheme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '選擇交通方式',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.fromActivityName != null && widget.toActivityName != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      '從 ${widget.fromActivityName} 到 ${widget.toActivityName}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            
            // 內容區域
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: TransportModeSelector(
                  selectedMode: selectedMode,
                  onModeChanged: (mode) {
                    setState(() {
                      selectedMode = mode;
                    });
                  },
                ),
              ),
            ),
            
            // 按鈕區域
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('取消'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(selectedMode),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('確認'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}