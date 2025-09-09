/// TripMuse 地圖畫面
/// 
/// 顯示行程地圖視圖和路線規劃

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          // 地圖區域（暫時用容器代替）
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE3F2FD),
                  Color(0xFFBBDEFB),
                ],
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 80,
                    color: TripMuseTheme.primaryColor,
                  ),
                  SizedBox(height: TripMuseSpacing.md),
                  Text(
                    '地圖視圖',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: TripMuseTheme.primaryColor,
                    ),
                  ),
                  SizedBox(height: TripMuseSpacing.sm),
                  Text(
                    '即將整合 MapBox 地圖功能',
                    style: TextStyle(
                      fontSize: 16,
                      color: TripMuseTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 頂部控制欄
          Positioned(
            top: MediaQuery.of(context).padding.top + TripMuseSpacing.md,
            left: TripMuseSpacing.md,
            right: TripMuseSpacing.md,
            child: Row(
              children: [
                // 搜尋框
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TripMuseSpacing.md,
                      vertical: TripMuseSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(TripMuseRadius.lg),
                      boxShadow: TripMuseShadows.small,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: TripMuseTheme.textSecondary,
                        ),
                        const SizedBox(width: TripMuseSpacing.sm),
                        Expanded(
                          child: Text(
                            '搜尋地點或行程...',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: TripMuseTheme.textHint,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: TripMuseSpacing.sm),
                
                // 圖層按鈕
                Container(
                  padding: const EdgeInsets.all(TripMuseSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(TripMuseRadius.md),
                    boxShadow: TripMuseShadows.small,
                  ),
                  child: const Icon(
                    Icons.layers,
                    color: TripMuseTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // 右側控制按鈕
          Positioned(
            right: TripMuseSpacing.md,
            bottom: 120, // 避免與底部導航欄重疊
            child: Column(
              children: [
                // 我的位置按鈕
                Container(
                  margin: const EdgeInsets.only(bottom: TripMuseSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(TripMuseRadius.md),
                    boxShadow: TripMuseShadows.small,
                  ),
                  child: IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('定位功能開發中...')),
                      );
                    },
                    icon: const Icon(
                      Icons.my_location,
                      color: TripMuseTheme.primaryColor,
                    ),
                  ),
                ),
                
                // 縮放控制
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(TripMuseRadius.md),
                    boxShadow: TripMuseShadows.small,
                  ),
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          // TODO: 放大地圖
                        },
                        icon: const Icon(
                          Icons.add,
                          color: TripMuseTheme.primaryColor,
                        ),
                      ),
                      Container(
                        height: 1,
                        width: 24,
                        color: TripMuseTheme.dividerColor,
                      ),
                      IconButton(
                        onPressed: () {
                          // TODO: 縮小地圖
                        },
                        icon: const Icon(
                          Icons.remove,
                          color: TripMuseTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 底部行程資訊卡片
          Positioned(
            left: TripMuseSpacing.md,
            right: TripMuseSpacing.md,
            bottom: 100, // 避免與底部導航欄重疊
            child: Container(
              padding: const EdgeInsets.all(TripMuseSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(TripMuseRadius.lg),
                boxShadow: TripMuseShadows.medium,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(TripMuseSpacing.sm),
                        decoration: BoxDecoration(
                          color: TripMuseTheme.primaryColor.withValues(alpha: 25),
                          borderRadius: BorderRadius.circular(TripMuseRadius.sm),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: TripMuseTheme.primaryColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: TripMuseSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '台北101',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              '10:00 - 12:00',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: TripMuseTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // TODO: 顯示詳細資訊
                        },
                        icon: const Icon(
                          Icons.info_outline,
                          color: TripMuseTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: TripMuseSpacing.sm),
                  
                  // 進度指示器
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: 0.3,
                          backgroundColor: TripMuseTheme.backgroundColor,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            TripMuseTheme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: TripMuseSpacing.sm),
                      Text(
                        '第 1 天',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: TripMuseTheme.textSecondary,
                        ),
                      ),
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
}