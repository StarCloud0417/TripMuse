/// TripMuse 行程詳情頁面
///
/// 顯示完整的行程資訊，包括每日計畫和活動詳情，支援時間軸和地圖視圖切換

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/activity_card.dart';
import '../widgets/timeline_widget.dart';
import '../widgets/trip_map_widget.dart';

class TripDetailScreen extends ConsumerStatefulWidget {
  final Trip trip;

  const TripDetailScreen({
    super.key,
    required this.trip,
  });

  @override
  ConsumerState<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends ConsumerState<TripDetailScreen> {
  bool _isTimelineView = true; // 預設顯示時間軸視圖

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isTimelineView 
        ? _buildTimelineView(context)
        : _buildMapView(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _shareTrip(context),
        backgroundColor: TripMuseTheme.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.share),
        label: const Text('分享行程'),
      ),
    );
  }

  Widget _buildTimelineView(BuildContext context) {
    return Column(
      children: [
        _buildAppBar(context),
        Expanded(
          child: TimelineWidget(
            trip: widget.trip,
            onSwitchToMap: () {
              setState(() {
                _isTimelineView = false;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMapView(BuildContext context) {
    return Column(
      children: [
        _buildAppBar(context),
        // 視圖切換器
        Container(
          margin: const EdgeInsets.all(TripMuseSpacing.md),
          decoration: BoxDecoration(
            color: TripMuseTheme.surfaceColor,
            borderRadius: BorderRadius.circular(TripMuseRadius.lg),
            boxShadow: TripMuseShadows.small,
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isTimelineView = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TripMuseSpacing.md,
                      vertical: TripMuseSpacing.sm,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timeline,
                          color: TripMuseTheme.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: TripMuseSpacing.xs),
                        Text(
                          '時間軸',
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
                        Icons.map,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: TripMuseSpacing.xs),
                      Text(
                        '地圖',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // 地圖內容
        Expanded(
          child: _buildTripMapContent(context),
        ),
      ],
    );
  }

  Widget _buildTripMapContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TripMuseSpacing.md),
      decoration: BoxDecoration(
        color: TripMuseTheme.surfaceColor,
        borderRadius: BorderRadius.circular(TripMuseRadius.lg),
        boxShadow: TripMuseShadows.small,
      ),
      child: Column(
        children: [
          // 地圖標題
          Container(
            padding: const EdgeInsets.all(TripMuseSpacing.md),
            decoration: BoxDecoration(
              color: TripMuseTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(TripMuseRadius.lg),
                topRight: Radius.circular(TripMuseRadius.lg),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.map,
                  color: TripMuseTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: TripMuseSpacing.sm),
                Text(
                  '行程地圖',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: TripMuseTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                // 地圖統計資訊
                Row(
                  children: [
                    _buildMapStatChip(
                      context,
                      Icons.location_on,
                      '${widget.trip.totalActivities}',
                    ),
                    const SizedBox(width: TripMuseSpacing.sm),
                    _buildMapStatChip(
                      context,
                      Icons.calendar_today,
                      '${widget.trip.days.length}天',
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 真正的地圖組件
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(TripMuseRadius.lg),
                bottomRight: Radius.circular(TripMuseRadius.lg),
              ),
              child: TripMapWidget(
                initialTrip: widget.trip,
                showControls: false, // 在詳情頁面中不顯示控制項
                onActivityTap: (activity) {
                  _showActivityDetails(context, activity);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapStatChip(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TripMuseSpacing.sm,
        vertical: TripMuseSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: TripMuseTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TripMuseRadius.sm),
        border: Border.all(
          color: TripMuseTheme.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: TripMuseTheme.primaryColor,
          ),
          const SizedBox(width: TripMuseSpacing.xs),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: TripMuseTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showActivityDetails(BuildContext context, Activity activity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(TripMuseRadius.xl)),
        ),
        child: Column(
          children: [
            // 拖拽指示器
            Container(
              margin: const EdgeInsets.symmetric(vertical: TripMuseSpacing.sm),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TripMuseTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // 活動資訊
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(TripMuseSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 標題和類別
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(TripMuseSpacing.sm),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(activity.category).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(TripMuseRadius.sm),
                          ),
                          child: Icon(
                            _getCategoryIcon(activity.category),
                            color: _getCategoryColor(activity.category),
                          ),
                        ),
                        const SizedBox(width: TripMuseSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity.name,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                activity.timeRange,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: TripMuseTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: TripMuseSpacing.lg),
                    
                    // 描述
                    if (activity.description.isNotEmpty) ...[
                      Text(
                        '活動描述',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: TripMuseSpacing.sm),
                      Text(
                        activity.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: TripMuseSpacing.lg),
                    ],
                    
                    // 詳細資訊
                    if (activity.address != null || 
                        activity.estimatedCost != null || 
                        activity.tips != null) ...[
                      Text(
                        '詳細資訊',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: TripMuseSpacing.sm),
                      
                      if (activity.address != null)
                        _buildInfoRow(Icons.location_on, '地址', activity.address!),
                      
                      if (activity.estimatedCost != null)
                        _buildInfoRow(Icons.attach_money, '預估費用', activity.estimatedCost!),
                      
                      if (activity.tips != null)
                        _buildInfoRow(Icons.lightbulb_outline, '小貼士', activity.tips!),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TripMuseSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: TripMuseTheme.textSecondary,
          ),
          const SizedBox(width: TripMuseSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: TripMuseTheme.textSecondary,
                  ),
                ),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(ActivityCategory category) {
    switch (category) {
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

  IconData _getCategoryIcon(ActivityCategory category) {
    switch (category) {
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

  Widget _buildAppBar(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            TripMuseTheme.primaryColor,
            TripMuseTheme.primaryColor.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: TripMuseSpacing.md),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: Text(
                  widget.trip.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      _editTrip(context);
                      break;
                    case 'delete':
                      _deleteTrip(context);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('編輯行程'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete),
                        SizedBox(width: 8),
                        Text('刪除行程'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildViewSwitcher(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TripMuseTheme.surfaceColor,
        borderRadius: BorderRadius.circular(TripMuseRadius.lg),
        boxShadow: TripMuseShadows.small,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isTimelineView = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TripMuseSpacing.md,
                  vertical: TripMuseSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: _isTimelineView ? TripMuseTheme.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(TripMuseRadius.lg),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timeline,
                      color: _isTimelineView ? Colors.white : TripMuseTheme.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: TripMuseSpacing.xs),
                    Text(
                      '時間軸',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: _isTimelineView ? Colors.white : TripMuseTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isTimelineView = false;
                });
              },
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
                      color: !_isTimelineView ? TripMuseTheme.primaryColor : TripMuseTheme.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: TripMuseSpacing.xs),
                    Text(
                      '地圖',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: !_isTimelineView ? TripMuseTheme.primaryColor : TripMuseTheme.textSecondary,
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

  // ignore: unused_element
  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.trip.title,
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

  // ignore: unused_element
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
                        widget.trip.destination.name,
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
                      '${widget.trip.days.length} 天行程',
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
        if (widget.trip.preferenceAnalysis != null) ...[
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
              _buildPreferenceChip(context, '預算', widget.trip.preferenceAnalysis!.budgetRange.displayName),
              _buildPreferenceChip(context, '節奏', widget.trip.preferenceAnalysis!.travelPace.displayName),
              if (widget.trip.preferenceAnalysis!.interests.isNotEmpty)
                ...widget.trip.preferenceAnalysis!.interests.map(
                  (interest) => _buildPreferenceChip(context, '興趣', interest),
                ),
            ],
          ),
        ],
      ],
    );
  }

  // ignore: unused_element
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

        ...widget.trip.days.asMap().entries.map((entry) {
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
