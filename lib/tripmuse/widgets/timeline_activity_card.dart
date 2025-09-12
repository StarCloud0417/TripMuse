/// TripMuse 時間軸活動卡片組件
///
/// 在時間軸視圖中顯示單一活動的卡片組件

import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class TimelineActivityCard extends StatelessWidget {
  final Activity activity;
  final bool isLastActivity;

  const TimelineActivityCard({
    super.key,
    required this.activity,
    this.isLastActivity = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 活動卡片
        Container(
          margin: const EdgeInsets.only(bottom: TripMuseSpacing.sm),
          decoration: BoxDecoration(
            color: TripMuseTheme.surfaceColor,
            borderRadius: BorderRadius.circular(TripMuseRadius.md),
            border: Border.all(
              color: _getCategoryColor().withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: TripMuseShadows.small,
          ),
          child: Column(
            children: [
              // 時間標籤
              _buildTimeLabel(context),
              
              // 活動內容
              _buildActivityContent(context),
            ],
          ),
        ),
        
        // 活動間連接線（除了最後一個活動）
        if (!isLastActivity) _buildActivityConnector(),
      ],
    );
  }

  Widget _buildTimeLabel(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: TripMuseSpacing.md,
        vertical: TripMuseSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: _getCategoryColor().withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(TripMuseRadius.md),
          topRight: Radius.circular(TripMuseRadius.md),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            size: 16,
            color: _getCategoryColor(),
          ),
          const SizedBox(width: TripMuseSpacing.xs),
          Text(
            activity.timeRange,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _getCategoryColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TripMuseSpacing.xs,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: _getPriorityColor(),
              borderRadius: BorderRadius.circular(TripMuseRadius.sm),
            ),
            child: Text(
              activity.priority.displayName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityContent(BuildContext context) {
    return Padding(
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
                  color: _getCategoryColor().withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(TripMuseRadius.sm),
                ),
                child: Icon(
                  _getCategoryIcon(),
                  size: 18,
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
                    color: TripMuseTheme.textPrimary,
                  ),
                ),
              ),
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
          
          // 額外資訊
          if (activity.estimatedCost != null || activity.address != null) ...[
            const SizedBox(height: TripMuseSpacing.sm),
            _buildExtraInfo(context),
          ],
          
          // 旅行小貼士
          if (activity.tips != null && activity.tips!.isNotEmpty) ...[
            const SizedBox(height: TripMuseSpacing.sm),
            _buildTipsSection(context),
          ],
        ],
      ),
    );
  }

  Widget _buildExtraInfo(BuildContext context) {
    return Row(
      children: [
        // 費用資訊
        if (activity.estimatedCost != null) ...[
          Icon(
            Icons.attach_money,
            size: 16,
            color: TripMuseTheme.textSecondary,
          ),
          const SizedBox(width: TripMuseSpacing.xs),
          Text(
            activity.estimatedCost!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: TripMuseTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        
        // 地址資訊
        if (activity.address != null) ...[
          if (activity.estimatedCost != null) 
            const SizedBox(width: TripMuseSpacing.md),
          Icon(
            Icons.location_on,
            size: 16,
            color: TripMuseTheme.textSecondary,
          ),
          const SizedBox(width: TripMuseSpacing.xs),
          Expanded(
            child: Text(
              activity.address!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: TripMuseTheme.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTipsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TripMuseSpacing.sm),
      decoration: BoxDecoration(
        color: TripMuseTheme.infoColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TripMuseRadius.sm),
        border: Border.all(
          color: TripMuseTheme.infoColor.withValues(alpha: 0.3),
          width: 1,
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
    );
  }

  Widget _buildActivityConnector() {
    return Container(
      width: 2,
      height: 20,
      margin: const EdgeInsets.only(bottom: TripMuseSpacing.sm),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _getCategoryColor().withValues(alpha: 0.5),
            _getCategoryColor().withValues(alpha: 0.2),
          ],
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
}