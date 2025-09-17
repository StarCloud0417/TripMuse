/// TripMuse 活動卡片組件
///
/// 顯示行程中單一活動的卡片組件

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import 'activity_detail_bottom_sheet.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.activity,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final Activity activity;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _showActivityDetails(context),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: TripMuseSpacing.md,
          vertical: TripMuseSpacing.sm,
        ),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TripMuseRadius.md),
        ),
        child: Padding(
          padding: const EdgeInsets.all(TripMuseSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 活動標題和類別
              Row(
                children: [
                  // 類別圖標
                  Container(
                    padding: const EdgeInsets.all(TripMuseSpacing.xs),
                    decoration: BoxDecoration(
                      color: _getCategoryColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TripMuseRadius.sm),
                    ),
                    child: Icon(
                      _getCategoryIcon(),
                      size: 20,
                      color: _getCategoryColor(),
                    ),
                  ),
                  const SizedBox(width: TripMuseSpacing.sm),
                  // 活動名稱
                  Expanded(
                    child: Text(
                      activity.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // 優先級標籤
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TripMuseSpacing.xs,
                      vertical: TripMuseSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(),
                      borderRadius: BorderRadius.circular(TripMuseRadius.sm),
                    ),
                    child: Text(
                      activity.priority.displayName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TripMuseSpacing.sm),

              // 時間資訊
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: TripMuseTheme.textSecondary,
                  ),
                  const SizedBox(width: TripMuseSpacing.xs),
                  Text(
                    '${activity.timeFrom} - ${activity.timeTo}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: TripMuseTheme.textSecondary,
                    ),
                  ),
                  if (activity.estimatedCost != null) ...[
                    const SizedBox(width: TripMuseSpacing.md),
                    Icon(
                      Icons.attach_money,
                      size: 16,
                      color: TripMuseTheme.textSecondary,
                    ),
                    const SizedBox(width: TripMuseSpacing.xs),
                    Text(
                      activity.estimatedCost!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: TripMuseTheme.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: TripMuseSpacing.sm),

              // 活動描述
              Text(
                activity.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: TripMuseTheme.textPrimary,
                  height: 1.4,
                ),
              ),

              // 提示資訊
              if (activity.tips != null && activity.tips!.isNotEmpty) ...[
                const SizedBox(height: TripMuseSpacing.sm),
                Container(
                  padding: const EdgeInsets.all(TripMuseSpacing.sm),
                  decoration: BoxDecoration(
                    color: TripMuseTheme.infoColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TripMuseRadius.sm),
                    border: Border.all(
                      color: TripMuseTheme.infoColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 16,
                        color: TripMuseTheme.infoColor,
                      ),
                      const SizedBox(width: TripMuseSpacing.xs),
                      Expanded(
                        child: Text(
                          activity.tips!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: TripMuseTheme.textPrimary,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    switch (activity.category) {
      case ActivityCategory.food:
        return Colors.orange;
      case ActivityCategory.sightseeing:
        return Colors.blue;
      case ActivityCategory.culture:
        return Colors.purple;
      case ActivityCategory.nature:
        return Colors.green;
      case ActivityCategory.shopping:
        return Colors.pink;
      case ActivityCategory.outdoor:
        return Colors.teal;
      case ActivityCategory.transportation:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon() {
    switch (activity.category) {
      case ActivityCategory.food:
        return Icons.restaurant;
      case ActivityCategory.sightseeing:
        return Icons.camera_alt;
      case ActivityCategory.culture:
        return Icons.museum;
      case ActivityCategory.nature:
        return Icons.park;
      case ActivityCategory.shopping:
        return Icons.shopping_bag;
      case ActivityCategory.outdoor:
        return Icons.directions_run;
      case ActivityCategory.transportation:
        return Icons.directions_bus;
    }
  }

  Color _getPriorityColor() {
    switch (activity.priority) {
      case ActivityPriority.high:
        return Colors.red;
      case ActivityPriority.medium:
        return Colors.orange;
      case ActivityPriority.low:
        return Colors.green;
    }
  }

  void _showActivityDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ActivityDetailBottomSheet(
        activity: activity,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }
}