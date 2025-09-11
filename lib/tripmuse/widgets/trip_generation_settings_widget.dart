/// TripMuse 行程生成設定組件
/// 
/// 提供快取管理、重試設定和生成統計的介面

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/trip_generation_provider.dart';

/// 行程生成設定頁面
class TripGenerationSettingsScreen extends ConsumerWidget {
  const TripGenerationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('生成設定'),
        backgroundColor: TripMuseTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TripMuseSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCacheSection(ref),
            const SizedBox(height: TripMuseSpacing.xl),
            _buildStatsSection(ref),
            const SizedBox(height: TripMuseSpacing.xl),
            _buildAdvancedSettings(ref),
          ],
        ),
      ),
    );
  }

  Widget _buildCacheSection(WidgetRef ref) {
    final cacheManager = ref.read(tripGenerationCacheProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TripMuseSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.storage,
                  color: TripMuseTheme.primaryColor,
                ),
                const SizedBox(width: TripMuseSpacing.sm),
                const Text(
                  '快取管理',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: TripMuseTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TripMuseSpacing.md),
            
            // 快取統計
            _buildCacheStats(cacheManager),
            
            const SizedBox(height: TripMuseSpacing.lg),
            
            // 快取操作按鈕
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _clearCache(ref),
                    icon: const Icon(Icons.clear_all),
                    label: const Text('清除快取'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: TripMuseTheme.errorColor,
                      side: const BorderSide(color: TripMuseTheme.errorColor),
                    ),
                  ),
                ),
                const SizedBox(width: TripMuseSpacing.md),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _preloadCache(ref),
                    icon: const Icon(Icons.download),
                    label: const Text('預載快取'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TripMuseTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCacheStats(TripGenerationCacheManager cacheManager) {
    final stats = cacheManager.getCacheStats();
    final cacheSize = cacheManager.getCacheSizeInMB();
    
    return Container(
      padding: const EdgeInsets.all(TripMuseSpacing.md),
      decoration: BoxDecoration(
        color: TripMuseTheme.surfaceColor,
        borderRadius: BorderRadius.circular(TripMuseRadius.lg),
        border: Border.all(color: TripMuseTheme.borderColor),
      ),
      child: Column(
        children: [
          _buildStatRow('行程快取', '${stats['tripCacheSize']} 項'),
          const Divider(),
          _buildStatRow('偏好快取', '${stats['preferenceCacheSize']} 項'),
          const Divider(),
          _buildStatRow('快取大小', '${cacheSize.toStringAsFixed(1)} MB'),
          const Divider(),
          _buildStatRow('最大容量', '${stats['maxCacheSize']} 項'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: TripMuseTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: TripMuseTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TripMuseSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.analytics,
                  color: TripMuseTheme.primaryColor,
                ),
                const SizedBox(width: TripMuseSpacing.sm),
                const Text(
                  '生成統計',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: TripMuseTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TripMuseSpacing.md),
            
            // 統計資料
            Consumer(
              builder: (context, ref, child) {
                final statsAsync = ref.watch(tripGenerationStatsProvider);
                
                return statsAsync.when(
                  data: (stats) => _buildStatsContent(stats),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => Text(
                    '載入統計失敗: $error',
                    style: const TextStyle(color: TripMuseTheme.errorColor),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsContent(TripGenerationStats stats) {
    return Container(
      padding: const EdgeInsets.all(TripMuseSpacing.md),
      decoration: BoxDecoration(
        color: TripMuseTheme.surfaceColor,
        borderRadius: BorderRadius.circular(TripMuseRadius.lg),
        border: Border.all(color: TripMuseTheme.borderColor),
      ),
      child: Column(
        children: [
          _buildStatRow('總行程數', '${stats.totalTrips}'),
          const Divider(),
          _buildStatRow('AI 生成', '${stats.generatedTrips}'),
          const Divider(),
          _buildStatRow('快取命中率', '${(stats.cacheHitRate * 100).toInt()}%'),
          const Divider(),
          _buildStatRow('平均生成時間', '${stats.averageGenerationTime.inSeconds}秒'),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettings(WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TripMuseSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.settings,
                  color: TripMuseTheme.primaryColor,
                ),
                const SizedBox(width: TripMuseSpacing.sm),
                const Text(
                  '進階設定',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: TripMuseTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TripMuseSpacing.md),
            
            // 設定選項
            _buildSettingTile(
              title: '自動重試',
              subtitle: '生成失敗時自動重試',
              value: true, // TODO: 從設定中讀取
              onChanged: (value) {
                // TODO: 儲存設定
              },
            ),
            
            _buildSettingTile(
              title: '使用快取',
              subtitle: '優先使用快取的結果',
              value: true, // TODO: 從設定中讀取
              onChanged: (value) {
                // TODO: 儲存設定
              },
            ),
            
            _buildSettingTile(
              title: '詳細進度',
              subtitle: '顯示詳細的生成進度',
              value: true, // TODO: 從設定中讀取
              onChanged: (value) {
                // TODO: 儲存設定
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: TripMuseTheme.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: TripMuseTheme.textSecondary,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: TripMuseTheme.primaryColor,
      ),
    );
  }

  void _clearCache(WidgetRef ref) {
    showDialog(
      context: ref.context,
      builder: (context) => AlertDialog(
        title: const Text('清除快取'),
        content: const Text('確定要清除所有快取嗎？這將會移除已儲存的行程和偏好分析結果。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(tripGenerationCacheProvider).clearAllCache();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('快取已清除'),
                  backgroundColor: TripMuseTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TripMuseTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('確定'),
          ),
        ],
      ),
    );
  }

  void _preloadCache(WidgetRef ref) async {
    try {
      await ref.read(tripGenerationCacheProvider).preloadCommonDestinations();
      
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          const SnackBar(
            content: Text('快取預載完成'),
            backgroundColor: TripMuseTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(
            content: Text('快取預載失敗: $e'),
            backgroundColor: TripMuseTheme.errorColor,
          ),
        );
      }
    }
  }
}

/// 快速設定組件（用於其他頁面）
class TripGenerationQuickSettings extends ConsumerWidget {
  const TripGenerationQuickSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.all(TripMuseSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(TripMuseSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.tune,
                  color: TripMuseTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: TripMuseSpacing.sm),
                const Text(
                  '生成設定',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: TripMuseTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TripGenerationSettingsScreen(),
                      ),
                    );
                  },
                  child: const Text('更多'),
                ),
              ],
            ),
            const SizedBox(height: TripMuseSpacing.sm),
            
            // 快速操作
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => ref.read(tripGenerationCacheProvider).clearAllCache(),
                    icon: const Icon(Icons.clear_all, size: 16),
                    label: const Text('清除快取'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TripMuseSpacing.sm,
                        vertical: TripMuseSpacing.xs,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: TripMuseSpacing.sm),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await ref.read(tripGenerationCacheProvider).preloadCommonDestinations();
                    },
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('預載'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TripMuseTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: TripMuseSpacing.sm,
                        vertical: TripMuseSpacing.xs,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}