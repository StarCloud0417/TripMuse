/// TripMuse 時間軸視圖組件
///
/// 提供時間軸形式的行程展示，包含每日行程卡片和活動卡片

import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'day_timeline_card.dart';

class TimelineWidget extends StatelessWidget {
  final Trip trip;
  final VoidCallback? onSwitchToMap;

  const TimelineWidget({
    super.key,
    required this.trip,
    this.onSwitchToMap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 視圖切換按鈕
        _buildViewSwitcher(context),
        
        // 時間軸內容
        Expanded(
          child: _buildTimelineContent(context),
        ),
      ],
    );
  }

  Widget _buildViewSwitcher(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(TripMuseSpacing.md),
      decoration: BoxDecoration(
        color: TripMuseTheme.surfaceColor,
        borderRadius: BorderRadius.circular(TripMuseRadius.lg),
        boxShadow: TripMuseShadows.small,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TripMuseSpacing.md,
                vertical: TripMuseSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: TripMuseTheme.primaryColor,
                borderRadius: BorderRadius.circular(TripMuseRadius.lg),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.timeline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: TripMuseSpacing.xs),
                  Text(
                    '時間軸',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onSwitchToMap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TripMuseSpacing.md,
                  vertical: TripMuseSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map,
                      color: TripMuseTheme.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: TripMuseSpacing.xs),
                    Text(
                      '地圖',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: TripMuseTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineContent(BuildContext context) {
    if (trip.days.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: TripMuseSpacing.md),
      itemCount: trip.days.length,
      itemBuilder: (context, index) {
        final dayPlan = trip.days[index];
        final isLastDay = index == trip.days.length - 1;
        
        return DayTimelineCard(
          dayPlan: dayPlan,
          dayNumber: index + 1,
          isLastDay: isLastDay,
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TripMuseSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timeline,
              size: 80,
              color: TripMuseTheme.textHint,
            ),
            const SizedBox(height: TripMuseSpacing.lg),
            Text(
              '暫無行程安排',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: TripMuseTheme.textSecondary,
              ),
            ),
            const SizedBox(height: TripMuseSpacing.sm),
            Text(
              '開始規劃您的精彩旅程吧！',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TripMuseTheme.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}