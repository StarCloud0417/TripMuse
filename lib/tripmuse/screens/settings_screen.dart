/// TripMuse 設定頁面
///
/// 提供應用設定和偏好設定管理

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';

/// 設定頁面
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
        padding: const EdgeInsets.all(16),
        children: [
          // 應用設定區塊
          _buildSectionHeader('應用設定'),
          _buildSettingItem(
            icon: Icons.palette,
            title: '主題設定',
            subtitle: '淺色/深色主題',
            onTap: () {
              // TODO: 實現主題切換
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('主題設定功能開發中...')),
              );
            },
          ),
          _buildSettingItem(
            icon: Icons.language,
            title: '語言設定',
            subtitle: '選擇應用語言',
            onTap: () {
              // TODO: 實現語言切換
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('語言設定功能開發中...')),
              );
            },
          ),

          const SizedBox(height: 24),

          // 通知設定區塊
          _buildSectionHeader('通知設定'),
          _buildSettingItem(
            icon: Icons.notifications,
            title: '推播通知',
            subtitle: '接收行程提醒',
            trailing: Switch(
              value: true, // TODO: 從狀態管理獲取
              onChanged: (value) {
                // TODO: 實現通知設定
              },
            ),
          ),

          const SizedBox(height: 24),

          // 資料管理區塊
          _buildSectionHeader('資料管理'),
          _buildSettingItem(
            icon: Icons.backup,
            title: '資料備份',
            subtitle: '備份您的行程資料',
            onTap: () {
              // TODO: 實現資料備份
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('資料備份功能開發中...')),
              );
            },
          ),
          _buildSettingItem(
            icon: Icons.restore,
            title: '資料還原',
            subtitle: '從備份還原資料',
            onTap: () {
              // TODO: 實現資料還原
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('資料還原功能開發中...')),
              );
            },
          ),

          const SizedBox(height: 24),

          // 關於區塊
          _buildSectionHeader('關於'),
          _buildSettingItem(
            icon: Icons.info,
            title: '版本資訊',
            subtitle: 'TripMuse v0.2.1',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'TripMuse',
                applicationVersion: '0.2.1',
                applicationLegalese: '© 2025 TripMuse Team',
              );
            },
          ),
          _buildSettingItem(
            icon: Icons.help,
            title: '幫助與支援',
            subtitle: '常見問題與聯絡我們',
            onTap: () {
              // TODO: 實現幫助頁面
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('幫助頁面開發中...')),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 建立區塊標題
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: TripMuseTheme.primaryColor,
        ),
      ),
    );
  }

  /// 建立設定項目
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: TripMuseTheme.primaryColor),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
