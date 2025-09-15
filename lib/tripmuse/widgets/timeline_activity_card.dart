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
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _getCategoryColor().withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
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
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getCategoryColor().withValues(alpha: 0.1),
            _getCategoryColor().withValues(alpha: 0.05),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _getCategoryColor().withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.access_time,
              size: 14,
              color: _getCategoryColor(),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            activity.timeRange,
            style: TextStyle(
              color: _getCategoryColor(),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: _getPriorityColor(),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: _getPriorityColor().withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              activity.priority.displayName,
              style: const TextStyle(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 活動標題和類別
          Row(
            children: [
              // 類別圖標
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getCategoryColor().withValues(alpha: 0.2),
                      _getCategoryColor().withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: _getCategoryColor().withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  _getCategoryIcon(),
                  size: 18,
                  color: _getCategoryColor(),
                ),
              ),
              const SizedBox(width: 12),
              
              // 活動名稱
              Expanded(
                child: Text(
                  activity.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 活動描述
          Text(
            activity.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          
          // 額外資訊
          if (activity.estimatedCost != null || activity.address != null) ...[
            const SizedBox(height: 12),
            _buildExtraInfo(context),
          ],
          
          // 旅行小貼士
          if (activity.tips != null && activity.tips!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildTipsSection(context),
          ],
        ],
      ),
    );
  }

  Widget _buildExtraInfo(BuildContext context) {
    return Column(
      children: [
        // 費用資訊
        if (activity.estimatedCost != null)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.attach_money,
                    size: 14,
                    color: Colors.green.shade600,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  activity.estimatedCost!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        
        // 地址資訊
        if (activity.address != null)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.location_on,
                  size: 14,
                  color: Colors.blue.shade600,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  activity.address!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildTipsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade50,
            Colors.orange.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.shade200,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.lightbulb_outline,
              size: 14,
              color: Colors.amber.shade700,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              activity.tips!,
              style: TextStyle(
                fontSize: 13,
                color: Colors.amber.shade800,
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
      width: 3,
      height: 20,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _getCategoryColor().withValues(alpha: 0.6),
            _getCategoryColor().withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(2),
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