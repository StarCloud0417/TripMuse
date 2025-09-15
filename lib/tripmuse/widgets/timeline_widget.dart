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
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
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
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4ECDC4),
                    Color(0xFF44A08D),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timeline,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '時間軸',
                    style: TextStyle(
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
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '地圖',
                      style: TextStyle(
                        color: Colors.grey.shade600,
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
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4ECDC4).withValues(alpha: 0.1),
                    const Color(0xFF44A08D).withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.timeline,
                size: 64,
                color: Color(0xFF4ECDC4),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '暫無行程安排',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '開始規劃您的精彩旅程吧！',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}