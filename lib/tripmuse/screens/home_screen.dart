/// TripMuse 首頁畫面
/// 
/// 顯示行程列表和快速操作

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';

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
                  
                  // 建立新行程按鈕
                  Card(
                    child: InkWell(
                      onTap: () {
                        // TODO: 導航到建立行程頁面
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('建立新行程功能開發中...')),
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
                          // TODO: 查看所有行程
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildTripCard(context, index);
              },
              childCount: 3, // 暫時顯示 3 個範例行程
            ),
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
          // TODO: 建立新行程
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('建立新行程功能開發中...')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('新行程'),
      ),
    );
  }
  
  Widget _buildTripCard(BuildContext context, int index) {
    // 範例行程資料
    final trips = [
      {
        'title': '台北美食3日遊',
        'destination': '台北, 台灣',
        'days': 3,
        'status': '草稿',
        'image': '🏙️',
      },
      {
        'title': '東京櫻花季',
        'destination': '東京, 日本',
        'days': 5,
        'status': '進行中',
        'image': '🌸',
      },
      {
        'title': '巴黎浪漫之旅',
        'destination': '巴黎, 法國',
        'days': 7,
        'status': '已完成',
        'image': '🗼',
      },
    ];
    
    final trip = trips[index];
    
    return Card(
      child: InkWell(
        onTap: () {
          // TODO: 導航到行程詳情
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('查看 ${trip['title']} 詳情')),
          );
        },
        borderRadius: BorderRadius.circular(TripMuseRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(TripMuseSpacing.md),
          child: Row(
            children: [
              // 行程圖示
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: TripMuseTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(TripMuseRadius.md),
                ),
                child: Center(
                  child: Text(
                    trip['image'] as String,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              
              const SizedBox(width: TripMuseSpacing.md),
              
              // 行程資訊
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip['title'] as String,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trip['destination'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: TripMuseTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(trip['status'] as String).withValues(alpha: 25),
                            borderRadius: BorderRadius.circular(TripMuseRadius.sm),
                          ),
                          child: Text(
                            trip['status'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: _getStatusColor(trip['status'] as String),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${trip['days']} 天',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // 更多選項
              IconButton(
                onPressed: () {
                  // TODO: 顯示更多選項
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case '草稿':
        return TripMuseTheme.warningColor;
      case '進行中':
        return TripMuseTheme.infoColor;
      case '已完成':
        return TripMuseTheme.successColor;
      default:
        return TripMuseTheme.textSecondary;
    }
  }
}