/// TripMuse 設定畫面
/// 
/// 使用者偏好設定和應用配置

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        backgroundColor: TripMuseTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // 使用者資訊區域
          Container(
            padding: const EdgeInsets.all(TripMuseSpacing.lg),
            decoration: const BoxDecoration(
              color: TripMuseTheme.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(TripMuseRadius.xl),
                bottomRight: Radius.circular(TripMuseRadius.xl),
              ),
            ),
            child: Column(
              children: [
                // 使用者頭像
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white.withValues(alpha: 51),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: TripMuseSpacing.md),
                
                // 使用者名稱
                const Text(
                  '訪客使用者',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: TripMuseSpacing.sm),
                
                // 登入按鈕
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('登入功能開發中...')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: const Text('登入 Google 帳號'),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: TripMuseSpacing.lg),
          
          // 一般設定
          _buildSectionTitle(context, '一般設定'),
          _buildSettingTile(
            context,
            icon: Icons.language,
            title: '語言',
            subtitle: '繁體中文',
            onTap: () {
              _showLanguageDialog(context);
            },
          ),
          _buildSettingTile(
            context,
            icon: Icons.palette,
            title: '主題',
            subtitle: '跟隨系統',
            onTap: () {
              _showThemeDialog(context);
            },
          ),
          _buildSettingTile(
            context,
            icon: Icons.currency_exchange,
            title: '預設貨幣',
            subtitle: 'TWD (新台幣)',
            onTap: () {
              _showCurrencyDialog(context);
            },
          ),
          
          const Divider(),
          
          // 地圖設定
          _buildSectionTitle(context, '地圖設定'),
          _buildSettingTile(
            context,
            icon: Icons.map,
            title: '地圖樣式',
            subtitle: '標準地圖',
            onTap: () {
              _showMapStyleDialog(context);
            },
          ),
          _buildSwitchTile(
            context,
            icon: Icons.my_location,
            title: '位置追蹤',
            subtitle: '允許應用追蹤您的位置',
            value: true,
            onChanged: (value) {
              // TODO: 更新位置追蹤設定
            },
          ),
          _buildSwitchTile(
            context,
            icon: Icons.offline_pin,
            title: '離線地圖',
            subtitle: '下載地圖以供離線使用',
            value: false,
            onChanged: (value) {
              // TODO: 更新離線地圖設定
            },
          ),
          
          const Divider(),
          
          // 通知設定
          _buildSectionTitle(context, '通知設定'),
          _buildSwitchTile(
            context,
            icon: Icons.notifications,
            title: '推播通知',
            subtitle: '接收行程提醒和更新',
            value: true,
            onChanged: (value) {
              // TODO: 更新通知設定
            },
          ),
          _buildSwitchTile(
            context,
            icon: Icons.schedule,
            title: '行程提醒',
            subtitle: '在活動開始前提醒您',
            value: true,
            onChanged: (value) {
              // TODO: 更新行程提醒設定
            },
          ),
          
          const Divider(),
          
          // 資料與隱私
          _buildSectionTitle(context, '資料與隱私'),
          _buildSettingTile(
            context,
            icon: Icons.cloud_sync,
            title: '資料同步',
            subtitle: '管理雲端同步設定',
            onTap: () {
              _showSyncDialog(context);
            },
          ),
          _buildSettingTile(
            context,
            icon: Icons.download,
            title: '匯出資料',
            subtitle: '下載您的行程資料',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('匯出功能開發中...')),
              );
            },
          ),
          _buildSettingTile(
            context,
            icon: Icons.delete_forever,
            title: '清除資料',
            subtitle: '刪除所有本地資料',
            onTap: () {
              _showClearDataDialog(context);
            },
          ),
          
          const Divider(),
          
          // 關於
          _buildSectionTitle(context, '關於'),
          _buildSettingTile(
            context,
            icon: Icons.info,
            title: '關於 TripMuse',
            subtitle: '版本 0.0.3',
            onTap: () {
              _showAboutDialog(context);
            },
          ),
          _buildSettingTile(
            context,
            icon: Icons.help,
            title: '說明與支援',
            subtitle: '使用指南和常見問題',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('說明功能開發中...')),
              );
            },
          ),
          _buildSettingTile(
            context,
            icon: Icons.privacy_tip,
            title: '隱私政策',
            subtitle: '了解我們如何保護您的隱私',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('隱私政策功能開發中...')),
              );
            },
          ),
          
          const SizedBox(height: TripMuseSpacing.xxl),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        TripMuseSpacing.md,
        TripMuseSpacing.lg,
        TripMuseSpacing.md,
        TripMuseSpacing.sm,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: TripMuseTheme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: TripMuseTheme.primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
  
  Widget _buildSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: TripMuseTheme.primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeThumbColor: TripMuseTheme.primaryColor,
    );
  }
  
  void _showLanguageDialog(BuildContext context) {
    String selectedValue = 'zh-TW';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('選擇語言'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('繁體中文'),
                value: 'zh-TW',
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() => selectedValue = value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('English'),
                value: 'en-US',
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() => selectedValue = value!);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showThemeDialog(BuildContext context) {
    String selectedValue = 'system';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('選擇主題'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('跟隨系統'),
                value: 'system',
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() => selectedValue = value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('亮色主題'),
                value: 'light',
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() => selectedValue = value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('暗色主題'),
                value: 'dark',
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() => selectedValue = value!);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showCurrencyDialog(BuildContext context) {
    String selectedValue = 'TWD';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('選擇預設貨幣'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('TWD (新台幣)'),
                value: 'TWD',
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() => selectedValue = value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('USD (美元)'),
                value: 'USD',
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() => selectedValue = value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('JPY (日圓)'),
                value: 'JPY',
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() => selectedValue = value!);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showMapStyleDialog(BuildContext context) {
    String selectedValue = 'standard';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('選擇地圖樣式'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('標準地圖'),
                value: 'standard',
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() => selectedValue = value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('衛星地圖'),
                value: 'satellite',
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() => selectedValue = value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('地形地圖'),
                value: 'terrain',
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() => selectedValue = value!);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showSyncDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('資料同步'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('同步狀態：已同步'),
            SizedBox(height: 8),
            Text('最後同步：剛剛'),
            SizedBox(height: 8),
            Text('待同步項目：0'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('立即同步'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('關閉'),
          ),
        ],
      ),
    );
  }
  
  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除資料'),
        content: const Text('此操作將刪除所有本地儲存的行程資料，且無法復原。您確定要繼續嗎？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('清除資料功能開發中...')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: TripMuseTheme.errorColor),
            child: const Text('確定清除'),
          ),
        ],
      ),
    );
  }
  
  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'TripMuse',
      applicationVersion: '0.0.3',
      applicationIcon: const Icon(
        Icons.luggage,
        size: 48,
        color: TripMuseTheme.primaryColor,
      ),
      children: const [
        Text('TripMuse 是一個基於 AI 的智能旅行規劃應用，幫助您輕鬆規劃完美的旅程。'),
        SizedBox(height: 16),
        Text('使用 Flutter 和 MapBox Maps SDK 開發，提供跨平台的優質體驗。'),
      ],
    );
  }
}