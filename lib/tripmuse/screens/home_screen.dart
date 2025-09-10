/// TripMuse 首頁畫面
/// 
/// 顯示行程概覽和快速操作

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';
import 'create_trip_screen.dart';
import 'trip_list_screen.dart';
import 'api_test_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 自訂 SliverAppBar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: TripMuseTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'TripMuse',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      TripMuseTheme.primaryColor,
                      TripMuseTheme.primaryVariant,
                    ],
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40), // 為 AppBar 留空間
                      Icon(
                        Icons.luggage,
                        size: 60,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'AI 智能旅行規劃',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // 快速操作區域
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(TripMuseSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '快速開始',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: TripMuseSpacing.md),
                  
                  // API 測試按鈕
                  Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ApiTestScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(TripMuseRadius.lg),
                      child: Padding(
                        padding: const EdgeInsets.all(TripMuseSpacing.lg),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(TripMuseSpacing.md),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 25),
                                borderRadius: BorderRadius.circular(TripMuseRadius.md),
                              ),
                              child: const Icon(
                                Icons.api,
                                color: Colors.green,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: TripMuseSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'API 測試',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '測試 GCP 後端 API 連線和功能',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: TripMuseTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: TripMuseTheme.textSecondary,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: TripMuseSpacing.md),
                  
                  // 建立新行程按鈕
                  Card(
                    child: InkWell(
                      onTap: () {
                        // 導航到建立行程頁面
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateTripScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(TripMuseRadius.lg),
                      child: Padding(
                        padding: const EdgeInsets.all(TripMuseSpacing.lg),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(TripMuseSpacing.md),
                              decoration: BoxDecoration(
                                color: TripMuseTheme.primaryColor.withValues(alpha: 25),
                                borderRadius: BorderRadius.circular(TripMuseRadius.md),
                              ),
                              child: const Icon(
                                Icons.add_location_alt,
                                color: TripMuseTheme.primaryColor,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: TripMuseSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '建立新行程',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '使用 AI 智能規劃您的完美旅程',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: TripMuseTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: TripMuseTheme.textSecondary,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 最近行程區域
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: TripMuseSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '最近行程',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TripListScreen(),
                            ),
                          );
                        },
                        child: const Text('查看全部'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // 行程列表
          Consumer(
            builder: (context, ref, child) {
              final recentTripsAsync = ref.watch(recentTripsProvider);

              return recentTripsAsync.when(
                data: (trips) {
                  if (trips.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(TripMuseSpacing.lg),
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: TripMuseTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(TripMuseRadius.lg),
                            border: Border.all(
                              color: TripMuseTheme.borderColor,
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.luggage,
                                  size: 48,
                                  color: TripMuseTheme.textSecondary,
                                ),
                                SizedBox(height: TripMuseSpacing.md),
                                Text(
                                  '還沒有任何行程',
                                  style: TextStyle(
                                    color: TripMuseTheme.textSecondary,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: TripMuseSpacing.sm),
                                Text(
                                  '點擊下方按鈕開始建立您的第一個行程',
                                  style: TextStyle(
                                    color: TripMuseTheme.textSecondary,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final trip = trips[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: TripMuseSpacing.md,
                            vertical: TripMuseSpacing.xs,
                          ),
                          child: TripCard(
                            trip: trip,
                            onTap: () => _openTrip(context, trip),
                            onEdit: () => _editTrip(context, trip),
                            onShare: () => _shareTrip(context, trip),
                            onDelete: () => _deleteTrip(context, ref, trip),
                          ),
                        );
                      },
                      childCount: trips.length,
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(TripMuseSpacing.lg),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                error: (error, stackTrace) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(TripMuseSpacing.lg),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: error.toString().contains('尚未初始化')
                            ? TripMuseTheme.primaryColor.withValues(alpha: 25.5)
                            : TripMuseTheme.errorColor.withValues(alpha: 25.5),
                        borderRadius: BorderRadius.circular(TripMuseRadius.lg),
                        border: Border.all(
                          color: error.toString().contains('尚未初始化')
                              ? TripMuseTheme.primaryColor.withValues(alpha: 76.5)
                              : TripMuseTheme.errorColor.withValues(alpha: 76.5),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              error.toString().contains('尚未初始化')
                                  ? Icons.hourglass_empty
                                  : Icons.error_outline,
                              size: 48,
                              color: error.toString().contains('尚未初始化')
                                  ? TripMuseTheme.primaryColor
                                  : TripMuseTheme.errorColor,
                            ),
                            const SizedBox(height: TripMuseSpacing.md),
                            Text(
                              error.toString().contains('尚未初始化')
                                  ? '系統初始化中...'
                                  : '載入行程時發生錯誤',
                              style: TextStyle(
                                color: error.toString().contains('尚未初始化')
                                    ? TripMuseTheme.primaryColor
                                    : TripMuseTheme.errorColor,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: TripMuseSpacing.sm),
                            Text(
                              error.toString().contains('尚未初始化')
                                  ? '請稍候，正在準備您的旅行資料'
                                  : '請檢查網路連線或稍後再試',
                              style: TextStyle(
                                color: error.toString().contains('尚未初始化')
                                    ? TripMuseTheme.primaryColor.withValues(alpha: 179.2)
                                    : TripMuseTheme.errorColor.withValues(alpha: 179.2),
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: TripMuseSpacing.md),
                            if (!error.toString().contains('尚未初始化'))
                              ElevatedButton(
                                onPressed: () {
                                  ref.invalidate(recentTripsProvider);
                                },
                                child: const Text('重試'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // 底部間距
          const SliverToBoxAdapter(
            child: SizedBox(height: TripMuseSpacing.xxl),
          ),
        ],
      ),
      
      // 浮動操作按鈕
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // 建立新行程功能 - 目前顯示提示訊息
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('建立新行程功能開發中...')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('新行程'),
      ),
    );
  }
  

  
  void _openTrip(BuildContext context, Trip trip) {
    // 開啟行程詳情 - 目前顯示提示訊息
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('開啟行程: ${trip.title}')),
    );
  }
  
  void _editTrip(BuildContext context, Trip trip) {
    // 編輯行程功能 - 目前顯示提示訊息
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('編輯行程: ${trip.title}')),
    );
  }
  
  void _shareTrip(BuildContext context, Trip trip) {
    // 分享行程功能 - 目前顯示提示訊息
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('分享行程: ${trip.title}')),
    );
  }
  
  void _deleteTrip(BuildContext context, WidgetRef ref, Trip trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('刪除行程'),
        content: Text('確定要刪除「${trip.title}」嗎？此操作無法復原。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(tripNotifierProvider.notifier).deleteTrip(trip.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('已刪除行程: ${trip.title}')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: TripMuseTheme.errorColor),
            child: const Text('刪除'),
          ),
        ],
      ),
    );
  }
}