/// TripMuse 新版設定頁面
/// 
/// 實現現代化的設定介面設計，與HOME頁面保持一致的視覺風格
/// 包含漸層背景、設定選項和現代化UI元素

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreenNew extends ConsumerStatefulWidget {
  const SettingsScreenNew({super.key});

  @override
  ConsumerState<SettingsScreenNew> createState() => _SettingsScreenNewState();
}

class _SettingsScreenNewState extends ConsumerState<SettingsScreenNew> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _offlineModeEnabled = false;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          child: Column(
            children: [
              // 頂部標題區域
              _buildHeader(),
              
              // 主要內容區域
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
                      // 快速設定區域
                      _buildQuickSettings(),
                      
                      // 應用偏好設定區域
                      Expanded(
                        child: _buildAppPreferences(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 建立頂部標題區域（與HOME頁面完全一致）
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // TripMuse Logo 和標題
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.luggage,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'TripMuse',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 設定頁面副標題
          const Text(
            'Customize your travel experience',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 建立快速設定區域（與HOME頁面Quick Start風格一致）
  Widget _buildQuickSettings() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          // 第一行設定按鈕
          Row(
            children: [
              Expanded(
                child: _buildQuickSettingButton(
                  title: 'Language',
                  icon: Icons.language,
                  color: const Color(0xFF2196F3),
                  onTap: () => _showLanguageDialog(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildQuickSettingButton(
                  title: 'Theme',
                  icon: Icons.palette,
                  color: const Color(0xFFFF5722),
                  onTap: () => _showThemeDialog(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 第二行設定按鈕
          Row(
            children: [
              Expanded(
                child: _buildQuickSettingButton(
                  title: 'Currency',
                  icon: Icons.attach_money,
                  color: const Color(0xFF4CAF50),
                  onTap: () => _showCurrencyDialog(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildQuickSettingButton(
                  title: 'Map Style',
                  icon: Icons.map,
                  color: const Color(0xFF9C27B0),
                  onTap: () => _showMapStyleDialog(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 建立快速設定按鈕（與HOME頁面按鈕風格完全一致）
  Widget _buildQuickSettingButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 建立應用偏好設定區域（與HOME頁面Recent Journeys風格一致）
  Widget _buildAppPreferences() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'App Preferences',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildPreferenceCard(
                  title: 'Push Notifications',
                  subtitle: 'Receive updates about your trips and recommendations',
                  icon: Icons.notifications,
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
                _buildPreferenceCard(
                  title: 'Location Services',
                  subtitle: 'Allow location access for personalized suggestions',
                  icon: Icons.location_on,
                  value: _locationEnabled,
                  onChanged: (value) {
                    setState(() {
                      _locationEnabled = value;
                    });
                  },
                ),
                _buildPreferenceCard(
                  title: 'Offline Mode',
                  subtitle: 'Download maps and trip data for offline access',
                  icon: Icons.offline_pin,
                  value: _offlineModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      _offlineModeEnabled = value;
                    });
                  },
                ),
                _buildPreferenceCard(
                  title: 'Dark Mode',
                  subtitle: 'Switch to dark theme for comfortable night viewing',
                  icon: Icons.dark_mode,
                  value: _darkModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      _darkModeEnabled = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 建立偏好設定卡片（與HOME頁面旅程卡片風格一致）
  Widget _buildPreferenceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // 圖標容器
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4ECDC4).withValues(alpha: 0.2),
                    const Color(0xFF44A08D).withValues(alpha: 0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF4ECDC4),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // 文字內容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            // 開關
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: value 
                        ? const Color(0xFF4ECDC4).withValues(alpha: 0.3)
                        : Colors.grey.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF4ECDC4),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade300,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 對話框方法（保持現代化設計風格）
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Select Language',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogOption('English', '🇺🇸'),
            _buildDialogOption('中文', '🇹🇼'),
            _buildDialogOption('日本語', '🇯🇵'),
            _buildDialogOption('한국어', '🇰🇷'),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Select Theme',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogOption('Light', '☀️'),
            _buildDialogOption('Dark', '🌙'),
            _buildDialogOption('System', '⚙️'),
          ],
        ),
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Select Currency',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogOption('USD - US Dollar', '💵'),
            _buildDialogOption('EUR - Euro', '💶'),
            _buildDialogOption('JPY - Japanese Yen', '💴'),
            _buildDialogOption('TWD - Taiwan Dollar', '💰'),
          ],
        ),
      ),
    );
  }

  void _showMapStyleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Select Map Style',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogOption('Standard', '🗺️'),
            _buildDialogOption('Satellite', '🛰️'),
            _buildDialogOption('Terrain', '🏔️'),
            _buildDialogOption('Dark', '🌃'),
          ],
        ),
      ),
    );
  }

  /// 建立對話框選項
  Widget _buildDialogOption(String title, String emoji) {
    return ListTile(
      leading: Text(
        emoji,
        style: const TextStyle(fontSize: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected: $title'),
            backgroundColor: const Color(0xFF4ECDC4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}