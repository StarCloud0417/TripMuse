/// TripMuse 每日時間軸卡片組件
///
/// 顯示單日行程的時間軸卡片，包含日期資訊和活動列表

import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'timeline_activity_card.dart';

class DayTimelineCard extends StatelessWidget {
  final DayPlan dayPlan;
  final int dayNumber;
  final bool isLastDay;

  const DayTimelineCard({
    super.key,
    required this.dayPlan,
    required this.dayNumber,
    this.isLastDay = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 日期標題區域
        _buildDayHeader(context),
        
        // 活動列表
        _buildActivitiesList(context),
        
        // 時間軸連接線（除了最後一天）
        if (!isLastDay) _buildTimelineConnector(),
      ],
    );
  }

  Widget _buildDayHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TripMuseSpacing.md),
      child: Row(
        children: [
          // 時間軸圓點
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TripMuseTheme.primaryColor,
              shape: BoxShape.circle,
              boxShadow: TripMuseShadows.small,
            ),
            child: Center(
              child: Text(
                '$dayNumber',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: TripMuseSpacing.md),
          
          // 日期資訊卡片
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(TripMuseSpacing.md),
              decoration: BoxDecoration(
                color: TripMuseTheme.surfaceColor,
                borderRadius: BorderRadius.circular(TripMuseRadius.lg),
                border: Border.all(
                  color: TripMuseTheme.primaryColor.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: TripMuseShadows.small,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 日期和星期
                  Row(
                    children: [
                      Text(
                        dayPlan.formattedDate,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: TripMuseTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: TripMuseSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TripMuseSpacing.sm,
                          vertical: TripMuseSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: TripMuseTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(TripMuseRadius.sm),
                        ),
                        child: Text(
                          dayPlan.weekday,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: TripMuseTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // 主題
                  if (dayPlan.theme.isNotEmpty) ...[
                    const SizedBox(height: TripMuseSpacing.xs),
                    Text(
                      dayPlan.theme,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: TripMuseTheme.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  
                  // 統計資訊
                  const SizedBox(height: TripMuseSpacing.sm),
                  Row(
                    children: [
                      _buildStatChip(
                        context,
                        Icons.event,
                        '${dayPlan.activityCount} 個活動',
                      ),
                      if (dayPlan.startTime != null && dayPlan.endTime != null) ...[
                        const SizedBox(width: TripMuseSpacing.sm),
                        _buildStatChip(
                          context,
                          Icons.access_time,
                          '${dayPlan.startTime} - ${dayPlan.endTime}',
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesList(BuildContext context) {
    if (dayPlan.activities.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(left: 56), // 對齊時間軸圓點右側
        padding: const EdgeInsets.all(TripMuseSpacing.lg),
        decoration: BoxDecoration(
          color: TripMuseTheme.backgroundColor,
          borderRadius: BorderRadius.circular(TripMuseRadius.md),
          border: Border.all(
            color: TripMuseTheme.dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.event_busy,
              color: TripMuseTheme.textHint,
              size: 20,
            ),
            const SizedBox(width: TripMuseSpacing.sm),
            Text(
              '此日暫無活動安排',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TripMuseTheme.textHint,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(left: 56), // 對齊時間軸圓點右側
      child: Column(
        children: dayPlan.activities.asMap().entries.map((entry) {
          final index = entry.key;
          final activity = entry.value;
          final isLastActivity = index == dayPlan.activities.length - 1;
          
          return TimelineActivityCard(
            activity: activity,
            isLastActivity: isLastActivity,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimelineConnector() {
    return Container(
      margin: const EdgeInsets.only(left: 20), // 對齊時間軸圓點中心
      width: 2,
      height: 30,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            TripMuseTheme.primaryColor,
            TripMuseTheme.primaryColor.withValues(alpha: 0.3),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TripMuseSpacing.sm,
        vertical: TripMuseSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: TripMuseTheme.backgroundColor,
        borderRadius: BorderRadius.circular(TripMuseRadius.sm),
        border: Border.all(
          color: TripMuseTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: TripMuseTheme.textSecondary,
          ),
          const SizedBox(width: TripMuseSpacing.xs),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: TripMuseTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}