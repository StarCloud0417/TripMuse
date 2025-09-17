import 'package:flutter/material.dart';
import '../models/transport_info.dart';
import '../models/enums.dart';

/// 交通信息顯示組件
/// 
/// 顯示兩個活動之間的交通方式、通勤時間和相關圖標
class TransportInfoWidget extends StatelessWidget {
  final TransportInfo transportInfo;
  final bool isCompact;

  const TransportInfoWidget({
    super.key,
    required this.transportInfo,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (isCompact) {
      return _buildCompactView(theme);
    } else {
      return _buildFullView(theme);
    }
  }

  Widget _buildCompactView(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            transportInfo.modeIcon,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 6),
          Text(
            transportInfo.formattedDuration,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullView(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 交通方式圖標
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                transportInfo.modeIcon,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // 交通信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      transportInfo.modeName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        transportInfo.formattedDuration,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                if (transportInfo.distanceMeters != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    transportInfo.formattedDistance,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (transportInfo.estimatedCost != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '預估費用: ${transportInfo.estimatedCost}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // 箭頭圖標
          Icon(
            Icons.arrow_downward,
            color: theme.colorScheme.onSurfaceVariant,
            size: 16,
          ),
        ],
      ),
    );
  }
}

/// 交通信息分隔線組件
/// 
/// 在活動列表中顯示為分隔線形式的交通信息
class TransportDivider extends StatelessWidget {
  final TransportInfo transportInfo;
  final VoidCallback? onTap;

  const TransportDivider({
    super.key,
    required this.transportInfo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // 左側連接線
          Container(
            width: 2,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey.shade300,
                  Colors.grey.shade400,
                  Colors.grey.shade300,
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // 交通信息卡片
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 交通工具圖示
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _getTransportColor(transportInfo.mode).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getTransportIcon(transportInfo.mode),
                        size: 14,
                        color: _getTransportColor(transportInfo.mode),
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // 通勤時間
                    Text(
                      transportInfo.formattedDuration,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    
                    // 距離信息（如果有的話）
                    if (transportInfo.distanceMeters != null) ...[
                      const SizedBox(width: 6),
                      Text(
                        '• ${transportInfo.formattedDistance}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                    
                    const Spacer(),
                    
                    // 編輯指示器
                    if (onTap != null)
                      Icon(
                        Icons.keyboard_arrow_right,
                        size: 16,
                        color: Colors.grey.shade500,
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  /// 根據交通方式獲取對應的圖標
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

  /// 根據交通方式獲取對應的顏色
  Color _getTransportColor(TransportMode mode) {
    switch (mode) {
      case TransportMode.walking:
        return Colors.green;
      case TransportMode.cycling:
        return Colors.blue;
      case TransportMode.driving:
        return Colors.orange;
      case TransportMode.transit:
        return Colors.purple;
      case TransportMode.taxi:
        return Colors.amber;
      case TransportMode.metro:
        return Colors.indigo;
    }
  }
}