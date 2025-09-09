/// TripMuse 使用者個人資料頁面
/// 
/// 顯示使用者資訊和提供登入/登出功能

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/user_provider.dart';
import '../models/models.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userAuthNotifierProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('個人資料'),
        backgroundColor: TripMuseTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: userAsync.when(
        data: (user) => _buildProfileContent(context, ref, user),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: TripMuseTheme.errorColor,
              ),
              const SizedBox(height: TripMuseSpacing.md),
              Text(
                '載入使用者資料時發生錯誤',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: TripMuseSpacing.sm),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: TripMuseTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TripMuseSpacing.lg),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(userAuthNotifierProvider);
                },
                child: const Text('重試'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildProfileContent(BuildContext context, WidgetRef ref, User? user) {
    if (user == null) {
      return _buildSignInPrompt(context, ref);
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TripMuseSpacing.md),
      child: Column(
        children: [
          // 使用者資訊卡片
          Card(
            child: Padding(
              padding: const EdgeInsets.all(TripMuseSpacing.lg),
              child: Column(
                children: [
                  // 頭像
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: TripMuseTheme.primaryColor.withValues(alpha: 25.5),
                    backgroundImage: user.avatarUrl != null 
                        ? NetworkImage(user.avatarUrl!) 
                        : null,
                    child: user.avatarUrl == null
                        ? Icon(
                            user.isGuest ? Icons.person_outline : Icons.person,
                            size: 50,
                            color: TripMuseTheme.primaryColor,
                          )
                        : null,
                  ),
                  
                  const SizedBox(height: TripMuseSpacing.md),
                  
                  // 使用者名稱
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: TripMuseSpacing.sm),
                  
                  // 電子郵件
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: TripMuseTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: TripMuseSpacing.sm),
                  
                  // 使用者類型標籤
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TripMuseSpacing.md,
                      vertical: TripMuseSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: user.isGuest 
                          ? TripMuseTheme.warningColor.withValues(alpha: 25.5)
                          : TripMuseTheme.successColor.withValues(alpha: 25.5),
                      borderRadius: BorderRadius.circular(TripMuseRadius.lg),
                    ),
                    child: Text(
                      user.isGuest ? '訪客模式' : '已登入',
                      style: TextStyle(
                        color: user.isGuest 
                            ? TripMuseTheme.warningColor
                            : TripMuseTheme.successColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  if (user.isGuest) ...[
                    const SizedBox(height: TripMuseSpacing.lg),
                    
                    // 訪客模式提示
                    Container(
                      padding: const EdgeInsets.all(TripMuseSpacing.md),
                      decoration: BoxDecoration(
                        color: TripMuseTheme.infoColor.withValues(alpha: 25.5),
                        borderRadius: BorderRadius.circular(TripMuseRadius.md),
                        border: Border.all(
                          color: TripMuseTheme.infoColor.withValues(alpha: 76.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: TripMuseTheme.infoColor,
                          ),
                          const SizedBox(height: TripMuseSpacing.sm),
                          Text(
                            '您目前使用訪客模式',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: TripMuseTheme.infoColor,
                            ),
                          ),
                          const SizedBox(height: TripMuseSpacing.sm),
                          Text(
                            '登入 Google 帳號以同步您的行程資料到雲端，並在多個裝置間存取。',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: TripMuseSpacing.lg),
                    
                    // Google 登入按鈕
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _signInWithGoogle(context, ref),
                        icon: const Icon(Icons.login),
                        label: const Text('使用 Google 帳號登入'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TripMuseTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          const SizedBox(height: TripMuseSpacing.lg),
          
          // 帳號資訊
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.calendar_today, color: TripMuseTheme.primaryColor),
                  title: const Text('註冊時間'),
                  subtitle: Text(_formatDate(user.createdAt)),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.update, color: TripMuseTheme.primaryColor),
                  title: const Text('最後更新'),
                  subtitle: Text(_formatDate(user.updatedAt)),
                ),
                if (user.googleId != null) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.account_circle, color: TripMuseTheme.primaryColor),
                    title: const Text('Google 帳號'),
                    subtitle: const Text('已連結'),
                    trailing: const Icon(Icons.check_circle, color: TripMuseTheme.successColor),
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: TripMuseSpacing.lg),
          
          // 帳號操作
          Card(
            child: Column(
              children: [
                if (!user.isGuest)
                  ListTile(
                    leading: const Icon(Icons.edit, color: TripMuseTheme.primaryColor),
                    title: const Text('編輯個人資料'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _editProfile(context, ref, user),
                  ),
                ListTile(
                  leading: const Icon(Icons.logout, color: TripMuseTheme.errorColor),
                  title: Text(
                    user.isGuest ? '結束訪客模式' : '登出',
                    style: const TextStyle(color: TripMuseTheme.errorColor),
                  ),
                  onTap: () => _signOut(context, ref),
                ),
                if (!user.isGuest) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.delete_forever, color: TripMuseTheme.errorColor),
                    title: const Text(
                      '刪除帳號',
                      style: TextStyle(color: TripMuseTheme.errorColor),
                    ),
                    onTap: () => _deleteAccount(context, ref),
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: TripMuseSpacing.xxl),
        ],
      ),
    );
  }
  
  Widget _buildSignInPrompt(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TripMuseSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_outline,
              size: 80,
              color: TripMuseTheme.textSecondary,
            ),
            
            const SizedBox(height: TripMuseSpacing.lg),
            
            Text(
              '歡迎使用 TripMuse',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: TripMuseSpacing.md),
            
            Text(
              '選擇您的使用方式開始規劃完美的旅程',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: TripMuseTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: TripMuseSpacing.xxl),
            
            // Google 登入按鈕
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _signInWithGoogle(context, ref),
                icon: const Icon(Icons.login),
                label: const Text('使用 Google 帳號登入'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TripMuseTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: TripMuseSpacing.md),
                ),
              ),
            ),
            
            const SizedBox(height: TripMuseSpacing.md),
            
            // 訪客模式按鈕
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _continueAsGuest(context, ref),
                icon: const Icon(Icons.person_outline),
                label: const Text('以訪客模式繼續'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: TripMuseSpacing.md),
                ),
              ),
            ),
            
            const SizedBox(height: TripMuseSpacing.lg),
            
            // 說明文字
            Text(
              '訪客模式下，您的資料僅儲存在本機裝置上。\\n登入後可將資料同步到雲端。',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: TripMuseTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
  
  Future<void> _signInWithGoogle(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(userAuthNotifierProvider.notifier).signInWithGoogle();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google 登入成功！'),
            backgroundColor: TripMuseTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('登入失敗：$e'),
            backgroundColor: TripMuseTheme.errorColor,
          ),
        );
      }
    }
  }
  
  Future<void> _continueAsGuest(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(userAuthNotifierProvider.notifier).continueAsGuest();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('已進入訪客模式'),
            backgroundColor: TripMuseTheme.infoColor,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('進入訪客模式失敗：$e'),
            backgroundColor: TripMuseTheme.errorColor,
          ),
        );
      }
    }
  }
  
  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('確認登出'),
        content: const Text('您確定要登出嗎？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: TripMuseTheme.errorColor),
            child: const Text('登出'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      try {
        await ref.read(userAuthNotifierProvider.notifier).signOut();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('已成功登出'),
              backgroundColor: TripMuseTheme.infoColor,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('登出失敗：$e'),
              backgroundColor: TripMuseTheme.errorColor,
            ),
          );
        }
      }
    }
  }
  
  void _editProfile(BuildContext context, WidgetRef ref, User user) {
    // 編輯個人資料功能 - 目前顯示提示訊息
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('編輯個人資料功能開發中...')),
    );
  }
  
  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('刪除帳號'),
        content: const Text('此操作將永久刪除您的帳號和所有資料，且無法復原。您確定要繼續嗎？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: TripMuseTheme.errorColor),
            child: const Text('確定刪除'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      try {
        await ref.read(userAuthNotifierProvider.notifier).deleteUser();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('帳號已刪除'),
              backgroundColor: TripMuseTheme.errorColor,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('刪除帳號失敗：$e'),
              backgroundColor: TripMuseTheme.errorColor,
            ),
          );
        }
      }
    }
  }
}