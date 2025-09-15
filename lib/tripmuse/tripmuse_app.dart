/// TripMuse 主應用入口
/// 
/// 提供底部導航欄和頁面路由管理

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/home_screen_new.dart';
import 'screens/map_screen.dart';
import 'screens/settings_screen_new.dart';
import 'screens/trip_detail_screen.dart';
import 'screens/create_trip_screen.dart';
import 'screens/my_trips_screen.dart';
import 'services/services.dart';
import 'models/models.dart';

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
  
  /// 檢查儲存系統狀態
  Future<void> _initializeStorageSystem() async {
    try {
      final storageManager = StorageManager.instance;
      if (storageManager.isInitialized) {
        print('✅ TripMuse 儲存系統已經初始化');
      } else {
        print('⚠️ TripMuse 儲存系統尚未初始化，嘗試初始化...');
        
        try {
          await storageManager.initialize();
          print('✅ TripMuse 儲存系統初始化成功');
        } catch (initError) {
          print('❌ TripMuse 儲存系統初始化失敗，嘗試清除數據: $initError');
          
          // 清除 Hive 數據
          await _clearHiveData();
          
          // 重新初始化
          await storageManager.initialize();
          print('✅ TripMuse 儲存系統重新初始化成功');
        }
      }
    } catch (e) {
      print('❌ TripMuse 儲存系統檢查失敗: $e');
      // 顯示錯誤提示但不阻止應用運行
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('儲存系統檢查失敗，部分功能可能無法使用'),
            backgroundColor: TripMuseTheme.errorColor,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: '重試',
              textColor: Colors.white,
              onPressed: () {
                _initializeStorageSystem();
              },
            ),
          ),
        );
      }
    }
  }

  /// 清除 Hive 數據
  Future<void> _clearHiveData() async {
    try {
      // 刪除所有 Hive box
      await Hive.deleteBoxFromDisk('trips');
      await Hive.deleteBoxFromDisk('settings');
      await Hive.deleteBoxFromDisk('cache');
      print('Hive 數據已清除');
    } catch (e) {
      print('清除 Hive 數據失敗: $e');
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
        routes: {
          '/trip-detail': (context) {
            final trip = ModalRoute.of(context)!.settings.arguments as Trip;
            return TripDetailScreen(trip: trip);
          },
          '/api-test': (context) => const HomeScreen(), // API 測試頁面
          '/trip-generation': (context) => const CreateTripScreen(), // 行程生成頁面
          '/create-trip': (context) => const CreateTripScreen(), // 建立新行程頁面
          '/trips': (context) => const MyTripsScreen(), // 所有行程頁面
          '/my-trips': (context) => const MyTripsScreen(), // 我的行程頁面
          '/map': (context) => const MapScreen(), // 地圖頁面
          '/settings': (context) => const SettingsScreenNew(), // 設定頁面
        },
        home: Scaffold(
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(), // 禁用滑動，防止與地圖手勢衝突
            onPageChanged: (index) {
              ref.read(currentPageIndexProvider.notifier).state = index;
            },
            children: [
              const HomeScreenNew(),
              const MapScreen(),
              const SettingsScreenNew(),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: BottomNavigationBar(
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
                backgroundColor: Colors.transparent,
                selectedItemColor: const Color(0xFF4ECDC4),
                unselectedItemColor: Colors.grey.shade500,
                elevation: 0,
                selectedLabelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined, size: 24),
                    activeIcon: Icon(Icons.home, size: 24),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.map_outlined, size: 24),
                    activeIcon: Icon(Icons.map, size: 24),
                    label: 'Map',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings_outlined, size: 24),
                    activeIcon: Icon(Icons.settings, size: 24),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}