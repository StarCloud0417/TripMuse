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
import '../widgets/trip_edit_toolbar.dart';
import '../widgets/enhanced_trip_edit_toolbar.dart';
import '../widgets/edit_history_widget.dart';

import '../widgets/activity_detail_bottom_sheet.dart';

import '../providers/providers.dart';

import '../services/storage_manager.dart';

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
  void initState() {
    super.initState();
    // 暫時禁用自動儲存服務初始化
    // TODO: 修復自動儲存的狀態管理問題後重新啟用
    /*
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(autoSaveProvider.notifier).setCurrentTrip(widget.trip.id);
    });
    */
  }

  @override
  Widget build(BuildContext context) {
    // 監聽行程資料的變化，確保排序更新後 UI 能即時刷新
    final tripAsyncValue = ref.watch(tripProvider(widget.trip.id));
    
    return tripAsyncValue.when(
      data: (trip) {
        // 如果找不到行程，使用原始行程資料
        final currentTrip = trip ?? widget.trip;
        
        return Scaffold(
          body: Column(
            children: [
              // 離線編輯狀態指示器（暫時禁用）
              // const OfflineEditStatusWidget(),
              
              // 主要內容
              Expanded(
                child: _isTimelineView 
                  ? _buildTimelineView(context, currentTrip)
                  : _buildMapView(context, currentTrip),
              ),
              
              // 增強版編輯工具欄
              EnhancedTripEditToolbar(
                tripId: currentTrip.id,
                onSave: () {
                  // 刷新行程資料
                  ref.invalidate(tripProvider(currentTrip.id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('行程已儲存'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                onCancel: () {
                  // 刷新行程資料以恢復原始狀態
                  ref.invalidate(tripProvider(currentTrip.id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('已取消編輯'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
              ),
            ],
          ),
          floatingActionButton: Stack(
            children: [
              // 編輯歷史浮動按鈕
              FloatingUndoRedoButtons(
                tripId: currentTrip.id,
                onUndo: () {
                  // 刷新行程資料
                  ref.invalidate(tripProvider(currentTrip.id));
                },
                onRedo: () {
                  // 刷新行程資料
                  ref.invalidate(tripProvider(currentTrip.id));
                },
              ),
              // 原有的編輯按鈕
              Positioned(
                bottom: 0,
                right: 0,
                child: FloatingEditButton(
                  tripId: currentTrip.id,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('已進入編輯模式'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4ECDC4),
                Color(0xFF44A08D),
                Color(0xFFFF9A8B),
                Color(0xFFFEAD96),
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      ),
      error: (error, stackTrace) {
        // 發生錯誤時使用原始行程資料
        return _buildErrorFallback(context, widget.trip);
      },
    );
  }

  Widget _buildErrorFallback(BuildContext context, Trip trip) {
    return Scaffold(
      body: Column(
        children: [
          // 主要內容
          Expanded(
            child: _isTimelineView 
              ? _buildTimelineView(context, trip)
              : _buildMapView(context, trip),
          ),
          
          // 編輯工具欄移到底部
          TripEditToolbar(
            tripId: trip.id,
            onSave: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('行程已儲存'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            onCancel: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('已取消編輯'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingEditButton(
        tripId: trip.id,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('已進入編輯模式'),
              backgroundColor: Colors.blue,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimelineView(BuildContext context, Trip trip) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4ECDC4), // 青綠色
            Color(0xFF44A08D), // 深綠色
            Color(0xFFFF9A8B), // 珊瑚色
            Color(0xFFFEAD96), // 桃色
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Column(
        children: [
          _buildAppBar(context, trip),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: TimelineWidget(
                trip: trip,
                onSwitchToMap: () {
                  setState(() {
                    _isTimelineView = false;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView(BuildContext context, Trip trip) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4ECDC4), // 青綠色
            Color(0xFF44A08D), // 深綠色
            Color(0xFFFF9A8B), // 珊瑚色
            Color(0xFFFEAD96), // 桃色
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Column(
        children: [
          _buildAppBar(context, trip),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // 視圖切換器
                  Container(
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
                                    color: Colors.grey.shade600,
                                    size: 20,
                                  ),
                                  const SizedBox(width: TripMuseSpacing.xs),
                                  Text(
                                    '時間軸',
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
                                  Icons.map,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '地圖',
                                  style: TextStyle(
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
                    child: _buildTripMapContent(context, trip),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripMapContent(BuildContext context, Trip trip) {
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
                      '${trip.totalActivities}',
                    ),
                    const SizedBox(width: TripMuseSpacing.sm),
                    _buildMapStatChip(
                      context,
                      Icons.calendar_today,
                      '${trip.days.length}天',
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
                initialTrip: trip,
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
      builder: (context) => ActivityDetailBottomSheet(
        activity: activity,
        onEdit: () {
          // 這裡可以添加編輯功能
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('編輯「${activity.name}」功能開發中...'),
              backgroundColor: Colors.blue,
            ),
          );
        },
        onDelete: () {
          // 這裡可以添加刪除功能
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('刪除「${activity.name}」功能開發中...'),
              backgroundColor: Colors.red,
            ),
          );
        },
      ),
    );
  }



  Widget _buildAppBar(BuildContext context, Trip trip) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4ECDC4), // 青綠色
            Color(0xFF44A08D), // 深綠色
            Color(0xFFFF9A8B), // 珊瑚色
            Color(0xFFFEAD96), // 桃色
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // 返回按鈕和標題
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      trip.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    children: [
                      // 測試編輯模式按鈕
                      Consumer(
                        builder: (context, ref, child) {
                          final isEditMode = ref.watch(isEditingTripProvider(trip.id));
                          return GestureDetector(
                            onTap: () {
                              print('Test button tapped. Current edit mode: $isEditMode');
                              ref.read(tripEditModeProvider.notifier).toggleEditMode(trip.id);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isEditMode ? Colors.red.withValues(alpha: 0.2) : Colors.blue.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isEditMode ? Icons.edit_off : Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      // 離線編輯狀態指示器（暫時禁用）
                      // const CompactOfflineStatusWidget(),
                      const SizedBox(width: 8),
                      AppBarEditButton(tripId: trip.id),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // 行程信息
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTripInfoChip(
                    Icons.location_on,
                    trip.destination.city,
                  ),
                  const SizedBox(width: 12),
                  _buildTripInfoChip(
                    Icons.calendar_today,
                    '${trip.days.length}天',
                  ),
                  const SizedBox(width: 12),
                  _buildTripInfoChip(
                    Icons.event,
                    '${trip.totalActivities}個活動',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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

  void _editTrip(BuildContext context) {
    // TODO: 實作編輯功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('編輯功能即將推出')),
    );
  }

  void _deleteTrip(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('刪除行程'),
        content: Text('確定要刪除「${widget.trip.title}」嗎？此操作無法復原。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // 關閉確認對話框

              try {
                // 刪除行程（同時刪除本地和雲端）
                await ref.read(tripRepositoryProvider).deleteTrip(widget.trip.id);

                // 強制重新載入行程列表
                ref.invalidate(userTripsProvider);

                // 顯示成功訊息
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('已刪除行程: ${widget.trip.title}')),
                  );

                  // 導航回上一頁
                  Navigator.of(context).pop();
                }
              } catch (e) {
                // 顯示錯誤訊息
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('刪除行程失敗: $e'),
                      backgroundColor: TripMuseTheme.errorColor,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: TripMuseTheme.errorColor),
            child: const Text('刪除'),
          ),
        ],
      ),
    );
  }
}
