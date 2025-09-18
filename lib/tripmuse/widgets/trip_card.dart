/// TripMuse 行程卡片組件
/// 
/// 顯示行程預覽資訊的卡片組件

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import 'pdf_export_button.dart';

class TripCard extends StatelessWidget {
  const TripCard({
    super.key,
    required this.trip,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onShare,
  });

  final Trip trip;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: TripMuseSpacing.md,
        vertical: TripMuseSpacing.sm,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TripMuseRadius.lg),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TripMuseRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(TripMuseSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 標題和操作按鈕
              Row(
                children: [
                  Expanded(
                    child: Text(
                      trip.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  // 操作選單
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit?.call();
                          break;
                        case 'share':
                          onShare?.call();
                          break;
                        case 'export_pdf':
                          PdfExportHelper.showExportDialog(context, trip);
                          break;
                        case 'delete':
                          onDelete?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('編輯'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            Icon(Icons.share, size: 20),
                            SizedBox(width: 8),
                            Text('分享'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'export_pdf',
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red[600],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.picture_as_pdf, size: 16, color: Colors.white),
                                SizedBox(width: 6),
                                Text(
                                  '匯出 PDF',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: TripMuseTheme.errorColor),
                            SizedBox(width: 8),
                            Text('刪除', style: TextStyle(color: TripMuseTheme.errorColor)),
                          ],
                        ),
                      ),
                    ],
                    child: const Icon(
                      Icons.more_vert,
                      color: TripMuseTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: TripMuseSpacing.sm),
              
              // 目的地資訊
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: TripMuseTheme.primaryColor,
                  ),
                  const SizedBox(width: TripMuseSpacing.xs),
                  Expanded(
                    child: Text(
                      '${trip.destination.city}, ${trip.destination.country}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: TripMuseTheme.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: TripMuseSpacing.sm),
              
              // 日期資訊
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: TripMuseTheme.primaryColor,
                  ),
                  const SizedBox(width: TripMuseSpacing.xs),
                  Text(
                    _formatDateRange(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: TripMuseTheme.textSecondary,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // 天數標籤
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TripMuseSpacing.sm,
                      vertical: TripMuseSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: TripMuseTheme.primaryColor.withValues(alpha: 25.5),
                      borderRadius: BorderRadius.circular(TripMuseRadius.sm),
                    ),
                    child: Text(
                      '${trip.days.length} 天',
                      style: const TextStyle(
                        color: TripMuseTheme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: TripMuseSpacing.md),
              
              // 行程狀態和統計
              Row(
                children: [
                  // 狀態標籤
                  _buildStatusChip(),
                  
                  const Spacer(),
                  
                  // 活動數量
                  Row(
                    children: [
                      const Icon(
                        Icons.event,
                        size: 14,
                        color: TripMuseTheme.textSecondary,
                      ),
                      const SizedBox(width: TripMuseSpacing.xs),
                      Text(
                        '${_getTotalActivities()} 個活動',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: TripMuseTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              // 如果有備註，顯示預覽
              if (trip.notes?.isNotEmpty == true) ...[
                const SizedBox(height: TripMuseSpacing.sm),
                Text(
                  trip.notes!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: TripMuseTheme.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatusChip() {
    final now = DateTime.now();
    final startDate = trip.days.isNotEmpty ? trip.days.first.date : DateTime.now();
    final endDate = trip.days.isNotEmpty ? trip.days.last.date : DateTime.now();
    
    String status;
    Color color;
    IconData icon;
    
    if (now.isBefore(startDate)) {
      status = '即將開始';
      color = TripMuseTheme.infoColor;
      icon = Icons.schedule;
    } else if (now.isAfter(endDate)) {
      status = '已完成';
      color = TripMuseTheme.textSecondary;
      icon = Icons.check_circle;
    } else {
      status = '進行中';
      color = TripMuseTheme.successColor;
      icon = Icons.play_circle;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TripMuseSpacing.sm,
        vertical: TripMuseSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 25.5),
        borderRadius: BorderRadius.circular(TripMuseRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: TripMuseSpacing.xs),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatDateRange() {
    if (trip.days.isEmpty) return '未設定日期';
    
    final startDate = trip.days.first.date;
    final endDate = trip.days.last.date;
    
    if (trip.days.length == 1) {
      return '${startDate.month}/${startDate.day}';
    }
    
    if (startDate.year == endDate.year && startDate.month == endDate.month) {
      return '${startDate.month}/${startDate.day} - ${endDate.day}';
    }
    
    return '${startDate.month}/${startDate.day} - ${endDate.month}/${endDate.day}';
  }
  
  int _getTotalActivities() {
    return trip.days.fold(0, (total, day) => total + day.activities.length);
  }
}