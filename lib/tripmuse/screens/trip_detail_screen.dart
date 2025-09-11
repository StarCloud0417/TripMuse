/// TripMuse 行程詳情頁面
///
/// 顯示完整的行程資訊，包括每日計畫和活動詳情

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/activity_card.dart';

class TripDetailScreen extends ConsumerWidget {
  final Trip trip;

  const TripDetailScreen({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(TripMuseSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTripOverview(context),
                  const SizedBox(height: TripMuseSpacing.xl),
                  _buildDayPlans(context),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _shareTrip(context),
        backgroundColor: TripMuseTheme.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.share),
        label: const Text('分享行程'),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          trip.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                TripMuseTheme.primaryColor,
                TripMuseTheme.primaryColor.withValues(alpha: 0.7),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.map,
              size: 80,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: () => _editTrip(context),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.white),
          onPressed: () => _deleteTrip(context),
        ),
      ],
    );
  }

  Widget _buildTripOverview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 行程基本資訊
        Text(
          '行程概覽',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: TripMuseTheme.textPrimary,
          ),
        ),
        const SizedBox(height: TripMuseSpacing.md),

        // 目的地資訊
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TripMuseRadius.md),
          ),
          child: Padding(
            padding: const EdgeInsets.all(TripMuseSpacing.md),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: TripMuseTheme.primaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: TripMuseSpacing.sm),
                    Expanded(
                      child: Text(
                        trip.destination.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TripMuseSpacing.sm),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: TripMuseTheme.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: TripMuseSpacing.sm),
                    Text(
                      '${trip.days.length} 天行程',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: TripMuseTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // 偏好分析（如果有的話）
        if (trip.preferenceAnalysis != null) ...[
          const SizedBox(height: TripMuseSpacing.lg),
          Text(
            '旅行偏好',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: TripMuseTheme.textPrimary,
            ),
          ),
          const SizedBox(height: TripMuseSpacing.sm),
          Wrap(
            spacing: TripMuseSpacing.sm,
            runSpacing: TripMuseSpacing.sm,
            children: [
              _buildPreferenceChip(context, '預算', trip.preferenceAnalysis!.budgetRange.displayName),
              _buildPreferenceChip(context, '節奏', trip.preferenceAnalysis!.travelPace.displayName),
              if (trip.preferenceAnalysis!.interests.isNotEmpty)
                ...trip.preferenceAnalysis!.interests.map(
                  (interest) => _buildPreferenceChip(context, '興趣', interest),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDayPlans(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '每日行程',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: TripMuseTheme.textPrimary,
          ),
        ),
        const SizedBox(height: TripMuseSpacing.md),

        ...trip.days.asMap().entries.map((entry) {
          final dayIndex = entry.key;
          final dayPlan = entry.value;
          return _buildDayPlanCard(context, dayIndex + 1, dayPlan);
        }),
      ],
    );
  }

  Widget _buildDayPlanCard(BuildContext context, int dayNumber, DayPlan dayPlan) {
    return Card(
      margin: const EdgeInsets.only(bottom: TripMuseSpacing.md),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TripMuseRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(TripMuseSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 日期標題
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TripMuseSpacing.sm,
                    vertical: TripMuseSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: TripMuseTheme.primaryColor,
                    borderRadius: BorderRadius.circular(TripMuseRadius.sm),
                  ),
                  child: Text(
                    '第 $dayNumber 天',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: TripMuseSpacing.sm),
                if (dayPlan.theme.isNotEmpty)
                  Expanded(
                    child: Text(
                      dayPlan.theme,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: TripMuseTheme.textPrimary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TripMuseSpacing.md),

            // 活動列表
            if (dayPlan.activities.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(TripMuseSpacing.lg),
                  child: Text(
                    '此日暫無活動',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: TripMuseTheme.textSecondary,
                    ),
                  ),
                ),
              )
            else
              Column(
                children: dayPlan.activities.asMap().entries.map((entry) {
                  final index = entry.key;
                  final activity = entry.value;
                  return Column(
                    children: [
                      ActivityCard(activity: activity),
                      if (index < dayPlan.activities.length - 1)
                        const SizedBox(height: TripMuseSpacing.md),
                    ],
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceChip(BuildContext context, String label, String value) {
    return Chip(
      label: Text(
        '$label: $value',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: TripMuseTheme.primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: TripMuseTheme.primaryColor.withValues(alpha: 0.1),
      side: BorderSide(
        color: TripMuseTheme.primaryColor.withValues(alpha: 0.3),
      ),
    );
  }

  void _shareTrip(BuildContext context) {
    // TODO: 實作分享功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('分享功能即將推出')),
    );
  }

  void _editTrip(BuildContext context) {
    // TODO: 實作編輯功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('編輯功能即將推出')),
    );
  }

  void _deleteTrip(BuildContext context) {
    // TODO: 實作刪除功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('刪除功能即將推出')),
    );
  }
}
