/// 旅程進度指示器組件
/// 
/// 顯示當前旅程進度、當前活動和下一個目的地

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/location_provider.dart';
import '../services/navigation_helper.dart';
import '../theme/app_theme.dart';


/// 旅程進度指示器
class TripProgressIndicator extends ConsumerWidget {
  final Trip trip;
  final VoidCallback? onTap;

  const TripProgressIndicator({
    super.key,
    required this.trip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripProgress = ref.watch(tripProgressProvider(trip));
    final navigationHelper = ref.read(navigationHelperProvider);

    if (tripProgress == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(TripMuseSpacing.md),
        padding: const EdgeInsets.all(TripMuseSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(TripMuseRadius.lg),
          boxShadow: TripMuseShadows.medium,
          border: Border.all(
            color: TripMuseTheme.primaryColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 標題和整體進度
            Row(
              children: [
                Icon(
                  Icons.route,
                  color: TripMuseTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: TripMuseSpacing.sm),
                Expanded(
                  child: Text(
                    '第 ${tripProgress.currentDay} 天行程',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TripMuseTheme.textPrimary,
                    ),
                  ),
                ),
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
                    '${(tripProgress.overallProgress * 100).round()}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: TripMuseTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: TripMuseSpacing.md),
            
            // 整體進度條
            LinearProgressIndicator(
              value: tripProgress.overallProgress,
              backgroundColor: TripMuseTheme.backgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(TripMuseTheme.primaryColor),
              minHeight: 6,
            ),
            
            const SizedBox(height: TripMuseSpacing.lg),
            
            // 當前活動和下一個活動
            if (tripProgress.currentActivity != null) ...[
              _buildCurrentActivity(context, tripProgress.currentActivity!, navigationHelper),
              
              if (tripProgress.nextActivity != null) ...[
                const SizedBox(height: TripMuseSpacing.md),
                _buildNextActivity(context, tripProgress.nextActivity!, navigationHelper),
              ],
            ] else ...[
              _buildNoCurrentActivity(context),
            ],
            
            // 完成狀態
            if (tripProgress.isCompleted) ...[
              const SizedBox(height: TripMuseSpacing.md),
              _buildCompletedStatus(context),
            ],
          ],
        ),
      ),
    );
  }

  /// 建構當前活動顯示
  Widget _buildCurrentActivity(BuildContext context, Activity activity, NavigationHelper navigationHelper) {
    final distance = navigationHelper.getDistanceToActivity(activity);
    final isAtLocation = navigationHelper.isAtActivity(activity);
    
    return Container(
      padding: const EdgeInsets.all(TripMuseSpacing.md),
      decoration: BoxDecoration(
        color: isAtLocation 
            ? TripMuseTheme.successColor.withValues(alpha: 0.1)
            : TripMuseTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(TripMuseRadius.md),
        border: Border.all(
          color: isAtLocation 
              ? TripMuseTheme.successColor.withValues(alpha: 0.3)
              : TripMuseTheme.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // 狀態圖標
          Container(
            padding: const EdgeInsets.all(TripMuseSpacing.sm),
            decoration: BoxDecoration(
              color: isAtLocation 
                  ? TripMuseTheme.successColor
                  : TripMuseTheme.primaryColor,
              borderRadius: BorderRadius.circular(TripMuseRadius.sm),
            ),
            child: Icon(
              isAtLocation ? Icons.check_circle : Icons.location_on,
              color: Colors.white,
              size: 16,
            ),
          ),
          
          const SizedBox(width: TripMuseSpacing.md),
          
          // 活動資訊
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAtLocation ? '已到達' : '當前目的地',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isAtLocation 
                        ? TripMuseTheme.successColor
                        : TripMuseTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: TripMuseSpacing.xs),
                Text(
                  activity.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TripMuseTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (distance != null && !isAtLocation) ...[
                  const SizedBox(height: TripMuseSpacing.xs),
                  Text(
                    '距離 ${navigationHelper.formatDistance(distance)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: TripMuseTheme.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // 導航按鈕
          if (!isAtLocation)
            IconButton(
              onPressed: () => navigationHelper.navigateToActivity(activity),
              icon: const Icon(Icons.navigation),
              color: TripMuseTheme.primaryColor,
              tooltip: '開始導航',
            ),
        ],
      ),
    );
  }

  /// 建構下一個活動顯示
  Widget _buildNextActivity(BuildContext context, Activity activity, NavigationHelper navigationHelper) {
    return Container(
      padding: const EdgeInsets.all(TripMuseSpacing.md),
      decoration: BoxDecoration(
        color: TripMuseTheme.backgroundColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(TripMuseRadius.md),
        border: Border.all(
          color: TripMuseTheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // 下一個圖標
          Container(
            padding: const EdgeInsets.all(TripMuseSpacing.sm),
            decoration: BoxDecoration(
              color: TripMuseTheme.outline.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(TripMuseRadius.sm),
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: TripMuseTheme.textSecondary,
              size: 16,
            ),
          ),
          
          const SizedBox(width: TripMuseSpacing.md),
          
          // 活動資訊
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '下一個目的地',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: TripMuseTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: TripMuseSpacing.xs),
                Text(
                  activity.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TripMuseTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  activity.timeRange,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: TripMuseTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 建構無當前活動顯示
  Widget _buildNoCurrentActivity(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TripMuseSpacing.lg),
      decoration: BoxDecoration(
        color: TripMuseTheme.backgroundColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(TripMuseRadius.md),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: TripMuseTheme.textSecondary,
            size: 20,
          ),
          const SizedBox(width: TripMuseSpacing.md),
          Expanded(
            child: Text(
              '無法確定當前位置，請檢查定位權限',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TripMuseTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 建構完成狀態顯示
  Widget _buildCompletedStatus(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TripMuseSpacing.md),
      decoration: BoxDecoration(
        color: TripMuseTheme.successColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TripMuseRadius.md),
        border: Border.all(
          color: TripMuseTheme.successColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(TripMuseSpacing.sm),
            decoration: BoxDecoration(
              color: TripMuseTheme.successColor,
              borderRadius: BorderRadius.circular(TripMuseRadius.sm),
            ),
            child: const Icon(
              Icons.celebration,
              color: Colors.white,
              size: 16,
            ),
          ),
          
          const SizedBox(width: TripMuseSpacing.md),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🎉 行程完成！',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TripMuseTheme.successColor,
                  ),
                ),
                const SizedBox(height: TripMuseSpacing.xs),
                Text(
                  '恭喜您完成了這次精彩的旅程',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: TripMuseTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 簡化版旅程進度指示器（用於地圖上的浮動顯示）
class CompactTripProgressIndicator extends ConsumerWidget {
  final Trip trip;
  final VoidCallback? onTap;

  const CompactTripProgressIndicator({
    super.key,
    required this.trip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripProgress = ref.watch(tripProgressProvider(trip));
    final navigationHelper = ref.read(navigationHelperProvider);

    if (tripProgress?.currentActivity == null) {
      return const SizedBox.shrink();
    }

    final currentActivity = tripProgress!.currentActivity!;
    final distance = navigationHelper.getDistanceToActivity(currentActivity);
    final isAtLocation = navigationHelper.isAtActivity(currentActivity);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TripMuseSpacing.md,
          vertical: TripMuseSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(TripMuseRadius.xl),
          boxShadow: TripMuseShadows.medium,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 狀態圖標
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isAtLocation 
                    ? TripMuseTheme.successColor
                    : TripMuseTheme.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
            
            const SizedBox(width: TripMuseSpacing.sm),
            
            // 活動名稱
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 150),
              child: Text(
                currentActivity.name,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: TripMuseTheme.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // 距離或狀態
            if (distance != null && !isAtLocation) ...[
              const SizedBox(width: TripMuseSpacing.sm),
              Text(
                navigationHelper.formatDistance(distance),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: TripMuseTheme.textSecondary,
                ),
              ),
            ] else if (isAtLocation) ...[
              const SizedBox(width: TripMuseSpacing.sm),
              const Icon(
                Icons.check_circle,
                color: TripMuseTheme.successColor,
                size: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }
}