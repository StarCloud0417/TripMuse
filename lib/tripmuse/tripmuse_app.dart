/// TripMuse 主應用入口
/// 
/// 提供底部導航欄和頁面路由管理

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/settings_screen.dart';
import 'services/services.dart';

/// 當前頁面索引 Provider
final currentPageIndexProvider = StateProvider<int>((ref) => 0);

/// TripMuse 主應用
class TripMuseApp extends ConsumerStatefulWidget {
  const TripMuseApp({super.key});

  @override
  ConsumerState<TripMuseApp> createState() => _TripMuseAppState();
}

class _TripMuseAppState extends ConsumerState<TripMuseApp> {
  late PageController _pageController;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    // 初始化儲存系統
    _initializeStorageSystem();
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  /// 初始化儲存系統
  Future<void> _initializeStorageSystem() async {
    try {
      final storageManager = StorageManager.instance;
      if (!storageManager.isInitialized) {
        await storageManager.initialize();
        print('TripMuse 儲存系統初始化成功');

        // 初始化完成後重新整理相關的 providers
        if (mounted) {
          // 延遲一下確保 context 已經準備好
          Future.delayed(const Duration(milliseconds: 100), () {
            // 這裡可以通過 ProviderScope 的 ref 來重新整理 providers
            // 但由於我們在 initState 中，無法直接訪問 ref
            // 改為發送一個通知或者使用其他機制
          });
        }
      }
    } catch (e) {
      print('TripMuse 儲存系統初始化失敗: $e');
      // 顯示錯誤提示但不阻止應用運行
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('儲存系統初始化失敗: $e'),
            backgroundColor: TripMuseTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentPageIndexProvider);
    
    return ProviderScope(
      child: MaterialApp(
        title: 'TripMuse',
        theme: TripMuseTheme.lightTheme,
        darkTheme: TripMuseTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              ref.read(currentPageIndexProvider.notifier).state = index;
            },
            children: const [
              HomeScreen(),
              MapScreen(),
              SettingsScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              ref.read(currentPageIndexProvider.notifier).state = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: TripMuseTheme.surfaceColor,
            selectedItemColor: TripMuseTheme.primaryColor,
            unselectedItemColor: TripMuseTheme.textSecondary,
            elevation: 8,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: '首頁',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                activeIcon: Icon(Icons.map),
                label: '地圖',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: '設定',
              ),
            ],
          ),
        ),
      ),
    );
  }
}