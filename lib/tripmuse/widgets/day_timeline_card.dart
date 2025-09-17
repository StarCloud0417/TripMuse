/// TripMuse 每日時間軸卡片組件
///
/// 顯示單日行程的時間軸卡片，包含日期資訊和活動列表

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../providers/activity_edit_provider.dart';
import '../providers/trip_edit_mode_provider.dart';
import 'draggable_activity_card.dart';

class DayTimelineCard extends ConsumerWidget {
  final DayPlan dayPlan;
  final int dayNumber;
  final bool isLastDay;
  final String? tripId;

  const DayTimelineCard({
    super.key,
    required this.dayPlan,
    required this.dayNumber,
    this.isLastDay = false,
    this.tripId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // 日期標題區域
        _buildDayHeader(context),
        
        // 活動列表
        _buildActivitiesList(context, ref),
        
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
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF4ECDC4),
                  Color(0xFF44A08D),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$dayNumber',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade200,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 日期和星期
                  Row(
                    children: [
                      Text(
                        dayPlan.formattedDate,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: TripMuseSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ECDC4).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          dayPlan.weekday,
                          style: const TextStyle(
                            color: Color(0xFF4ECDC4),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // 主題
                  if (dayPlan.theme.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      dayPlan.theme,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  
                  // 統計資訊
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStatChip(
                        context,
                        Icons.event,
                        '${dayPlan.activityCount} 個活動',
                      ),
                      if (dayPlan.startTime != null && dayPlan.endTime != null) ...[
                        const SizedBox(width: 8),
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

  Widget _buildActivitiesList(BuildContext context, WidgetRef ref) {
    if (dayPlan.activities.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(left: 56), // 對齊時間軸圓點右側
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.event_busy,
              color: Colors.grey.shade400,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              '此日暫無活動安排',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(left: 56), // 對齊時間軸圓點右側
      child: Column(
        children: _buildActivityCards(context, ref),
      ),
    );
  }

  Widget _buildTimelineConnector() {
    return Container(
      margin: const EdgeInsets.only(left: 20), // 對齊時間軸圓點中心
      width: 3,
      height: 30,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4ECDC4),
            Color(0xFF44A08D),
          ],
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildStatChip(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActivityCards(BuildContext context, WidgetRef ref) {
    return dayPlan.activities.asMap().entries.map((entry) {
      final index = entry.key;
      final activity = entry.value;
      final isLastActivity = index == dayPlan.activities.length - 1;
      final isFirstActivity = index == 0;
      
      return DraggableActivityCard(
        activity: activity,
        isLastActivity: isLastActivity,
        isFirstActivity: isFirstActivity,
        tripId: tripId,
        onTimeChanged: (activity, newTimeFrom, newTimeTo) {
          _handleTimeChanged(ref, activity, newTimeFrom, newTimeTo, context);
        },
        onDelete: (activity) {
          _handleDeleteActivity(ref, activity, context);
        },
        onMoveToDay: (activity, targetDay) {
          _handleMoveToDay(ref, activity, targetDay, context);
        },
        onReplace: (activity) {
          _handleReplaceActivity(ref, activity, context);
        },
        onEdit: (activity) {
          _handleEditActivity(ref, activity, context);
        },
        onMoveUp: (activity) {
          _handleMoveActivityUp(ref, activity, context);
        },
        onMoveDown: (activity) {
          _handleMoveActivityDown(ref, activity, context);
        },
        onMapSync: () {
          _handleMapSync(context);
        },
        onEnterEditMode: () {
          _handleEnterEditMode(ref, context);
        },
      );
    }).toList();
  }

  void _handleTimeChanged(WidgetRef ref, Activity activity, String newTimeFrom, String newTimeTo, BuildContext context) {
    if (tripId == null) return;
    
    final activityEditNotifier = ref.read(activityEditProvider.notifier);
    activityEditNotifier.updateActivityTime(
      tripId!,
      dayNumber - 1, // dayNumber 從 1 開始，但索引從 0 開始
      activity,
      newTimeFrom,
      newTimeTo,
    ).then((success) {
      if (!success) {
        final error = ref.read(activityEditErrorProvider);
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  void _handleDeleteActivity(WidgetRef ref, Activity activity, BuildContext context) {
    if (tripId == null) return;
    
    final activityEditNotifier = ref.read(activityEditProvider.notifier);
    activityEditNotifier.deleteActivity(
      tripId!,
      dayNumber - 1,
      activity,
    ).then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已刪除「${activity.name}」'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final error = ref.read(activityEditErrorProvider);
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  void _handleMoveToDay(WidgetRef ref, Activity activity, int targetDay, BuildContext context) {
    if (tripId == null) return;
    
    final activityEditNotifier = ref.read(activityEditProvider.notifier);
    activityEditNotifier.moveActivityToDay(
      tripId!,
      dayNumber - 1,
      targetDay - 1, // 轉換為索引
      activity,
    ).then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已將「${activity.name}」移動到第 $targetDay 天'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final error = ref.read(activityEditErrorProvider);
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  void _handleReplaceActivity(WidgetRef ref, Activity activity, BuildContext context) {
    // 這裡可以實作活動替換邏輯
    // 暫時顯示一個提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('活動替換功能開發中...'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _handleEditActivity(WidgetRef ref, Activity activity, BuildContext context) {
    // 開始編輯活動
    ref.read(activityEditProvider.notifier).startEditing(activity);
    
    // 這裡可以導航到活動編輯頁面
    // 暫時顯示一個提示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('編輯「${activity.name}」'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _handleMapSync(BuildContext context) {
    // 同步到地圖視圖
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已同步到地圖視圖'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleMoveActivityUp(WidgetRef ref, Activity activity, BuildContext context) {
    if (tripId == null) return;
    
    final activityEditNotifier = ref.read(activityEditProvider.notifier);
    activityEditNotifier.moveActivityUp(
      tripId!,
      dayNumber - 1,
      activity,
    ).then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已將「${activity.name}」向上移動'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        final error = ref.read(activityEditErrorProvider);
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  void _handleMoveActivityDown(WidgetRef ref, Activity activity, BuildContext context) {
    if (tripId == null) return;
    
    final activityEditNotifier = ref.read(activityEditProvider.notifier);
    activityEditNotifier.moveActivityDown(
      tripId!,
      dayNumber - 1,
      activity,
    ).then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已將「${activity.name}」向下移動'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        final error = ref.read(activityEditErrorProvider);
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  void _handleEnterEditMode(WidgetRef ref, BuildContext context) {
    if (tripId == null) return;
    
    // 進入編輯模式
    ref.read(tripEditModeProvider.notifier).enterEditMode(tripId!);
    
    // 顯示提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已進入編輯模式，現在可以拖拉活動調整順序'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }
}