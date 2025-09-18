/// TripMuse 我的行程頁面
/// 
/// 顯示用戶所有行程，提供搜尋、篩選和管理功能

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/trip_provider.dart';
import '../widgets/enhanced_trip_card.dart';

class MyTripsScreen extends ConsumerStatefulWidget {
  const MyTripsScreen({super.key});

  @override
  ConsumerState<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends ConsumerState<MyTripsScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedFilter = '全部';

  final List<String> _filterOptions = ['全部', '即將到來', '進行中', '已完成', '收藏'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

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
              
              // 搜尋欄
              _buildSearchBar(),
              
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
                      // 篩選器和統計
                      _buildFilterSection(),
                      
                      // 分頁標籤
                      _buildTabBar(),
                      
                      // 內容區域
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildTripsGrid(),
                            _buildTripsList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // 浮動新增按鈕
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// 建立頂部標題區域
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // 返回按鈕和標題
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  '我的行程',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              GestureDetector(
                onTap: _showSortOptions,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.sort,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 統計信息
          _buildStatistics(),
        ],
      ),
    );
  }

  /// 建立統計信息
  Widget _buildStatistics() {
    final tripsAsync = ref.watch(userTripsProvider);
    
    return tripsAsync.when(
      data: (trips) {
        final totalTrips = trips.length;
        final upcomingTrips = trips.where((trip) {
          if (trip.days.isEmpty) return false;
          return trip.days.first.date.isAfter(DateTime.now());
        }).length;
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem('總行程', totalTrips.toString()),
            _buildStatItem('即將到來', upcomingTrips.toString()),
            _buildStatItem('收藏', '0'), // TODO: 實現收藏功能
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  /// 建立統計項目
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  /// 建立搜尋欄
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: '搜尋行程、目的地...',
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey.shade400,
              size: 24,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? GestureDetector(
                    onTap: _clearSearch,
                    child: Icon(
                      Icons.clear,
                      color: Colors.grey.shade400,
                      size: 24,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
      ),
    );
  }

  /// 建立篩選區域
  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '篩選',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filterOptions.length,
              itemBuilder: (context, index) {
                final filter = _filterOptions[index];
                final isSelected = _selectedFilter == filter;
                
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF4ECDC4) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF4ECDC4) : Colors.grey.shade300,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ] : null,
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 建立分頁標籤
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(25), // 更圓的背景
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF4ECDC4), // 主題綠色
              Color(0xFF44A08D), // 主題深綠色
            ],
          ),
          borderRadius: BorderRadius.circular(25), // 橢圓形膠囊狀
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab, // 指示器覆蓋整個標籤
        dividerColor: Colors.transparent, // 移除分隔線
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade600,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
        ),
        tabs: const [
          Tab(text: '網格檢視'),
          Tab(text: '列表檢視'),
        ],
      ),
    );
  }

  /// 建立行程網格檢視
  Widget _buildTripsGrid() {
    final tripsAsync = ref.watch(userTripsProvider);
    
    return tripsAsync.when(
      data: (trips) {
        final filteredTrips = _filterTrips(trips);
        
        if (filteredTrips.isEmpty) {
          return _buildEmptyState();
        }
        
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: filteredTrips.length,
            itemBuilder: (context, index) {
              return EnhancedTripCard(
                trip: filteredTrips[index],
                cardType: TripCardType.featured,
                onTap: () => _navigateToTripDetail(filteredTrips[index]),
                onEdit: () => _navigateToTripDetail(filteredTrips[index]),
                onDuplicate: () => _duplicateTrip(filteredTrips[index]),
                onDelete: () => _showDeleteConfirmation(filteredTrips[index]),
              );
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
        ),
      ),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  /// 建立行程列表檢視
  Widget _buildTripsList() {
    final tripsAsync = ref.watch(userTripsProvider);
    
    return tripsAsync.when(
      data: (trips) {
        final filteredTrips = _filterTrips(trips);
        
        if (filteredTrips.isEmpty) {
          return _buildEmptyState();
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(24.0),
          itemCount: filteredTrips.length,
          itemBuilder: (context, index) {
            return EnhancedTripCard(
              trip: filteredTrips[index],
              cardType: TripCardType.standard,
              onTap: () => _navigateToTripDetail(filteredTrips[index]),
              onEdit: () => _navigateToTripDetail(filteredTrips[index]),
              onDuplicate: () => _duplicateTrip(filteredTrips[index]),
              onDelete: () => _showDeleteConfirmation(filteredTrips[index]),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
        ),
      ),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }





  /// 建立空狀態
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4ECDC4).withValues(alpha: 0.1),
                    const Color(0xFF44A08D).withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                _searchQuery.isNotEmpty ? Icons.search_off : Icons.explore_off,
                size: 64,
                color: const Color(0xFF4ECDC4),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _searchQuery.isNotEmpty ? '找不到相關行程' : '還沒有任何行程',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isNotEmpty ? '試試其他關鍵字或調整篩選條件' : '開始規劃您的第一個旅程吧！',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchQuery.isEmpty) ...[
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF4ECDC4),
                      Color(0xFF44A08D),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _createNewTrip,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: const Text(
                    '建立新行程',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 建立錯誤狀態
  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '載入失敗',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4ECDC4),
                    Color(0xFF44A08D),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  ref.invalidate(userTripsProvider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                label: const Text(
                  '重試',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 建立浮動新增按鈕
  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4ECDC4),
            Color(0xFF44A08D),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _createNewTrip,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  // 輔助方法

  /// 篩選行程
  List<Trip> _filterTrips(List<Trip> trips) {
    var filteredTrips = trips;

    // 搜尋篩選 - 增強搜尋功能
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filteredTrips = filteredTrips.where((trip) {
        return trip.title.toLowerCase().contains(query) ||
               trip.destination.city.toLowerCase().contains(query) ||
               trip.destination.country.toLowerCase().contains(query) ||
               trip.destination.name.toLowerCase().contains(query) ||
               trip.days.any((day) => 
                   day.activities.any((activity) => 
                       activity.name.toLowerCase().contains(query) ||
                       activity.description.toLowerCase().contains(query)));
      }).toList();
    }

    // 狀態篩選
    final now = DateTime.now();
    switch (_selectedFilter) {
      case '即將到來':
        filteredTrips = filteredTrips.where((trip) {
          if (trip.days.isEmpty) return false;
          return trip.days.first.date.isAfter(now);
        }).toList();
        break;
      case '進行中':
        filteredTrips = filteredTrips.where((trip) {
          if (trip.days.isEmpty) return false;
          final startDate = trip.days.first.date;
          final endDate = trip.days.last.date;
          return now.isAfter(startDate.subtract(const Duration(days: 1))) && 
                 now.isBefore(endDate.add(const Duration(days: 1)));
        }).toList();
        break;
      case '已完成':
        filteredTrips = filteredTrips.where((trip) {
          if (trip.days.isEmpty) return false;
          return trip.days.last.date.isBefore(now);
        }).toList();
        break;
      case '收藏':
        final favoriteIds = ref.watch(favoriteTripProvider);
        filteredTrips = filteredTrips.where((trip) => favoriteIds.contains(trip.id)).toList();
        break;
      case '全部':
      default:
        // 不需要額外篩選
        break;
    }

    return filteredTrips;
  }



  // 事件處理方法

  /// 清除搜尋
  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }





  /// 切換收藏狀態
  void _toggleFavorite(String tripId) {
    ref.read(favoriteTripProvider.notifier).toggleFavorite(tripId);
    
    // 顯示提示訊息
    final isFavorite = ref.read(favoriteTripProvider).contains(tripId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isFavorite ? '已加入收藏' : '已取消收藏'),
        backgroundColor: const Color(0xFF4ECDC4),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// 導航到行程詳情
  void _navigateToTripDetail(Trip trip) {
    Navigator.pushNamed(
      context,
      '/trip-detail',
      arguments: trip,
    );
  }

  /// 建立新行程
  void _createNewTrip() {
    Navigator.pushNamed(context, '/create-trip');
  }

  /// 複製行程
  void _duplicateTrip(Trip trip) async {
    try {
      final tripNotifier = ref.read(tripNotifierProvider.notifier);
      await tripNotifier.duplicateTrip(trip);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('行程複製成功'),
            backgroundColor: Color(0xFF4ECDC4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('複製失敗：$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 顯示刪除確認對話框
  void _showDeleteConfirmation(Trip trip) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('確認刪除'),
          content: Text('確定要刪除「${trip.title}」嗎？此操作無法復原。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteTrip(trip);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('刪除'),
            ),
          ],
        );
      },
    );
  }

  /// 刪除行程
  void _deleteTrip(Trip trip) async {
    try {
      final tripNotifier = ref.read(tripNotifierProvider.notifier);
      await tripNotifier.deleteTrip(trip.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('行程已刪除'),
            backgroundColor: Color(0xFF4ECDC4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('刪除失敗：$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 顯示排序選項
  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '排序方式',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildSortOption('建立時間（新到舊）', Icons.access_time),
              _buildSortOption('建立時間（舊到新）', Icons.history),
              _buildSortOption('行程名稱（A-Z）', Icons.sort_by_alpha),
              _buildSortOption('目的地', Icons.location_on),
              _buildSortOption('天數', Icons.calendar_today),
            ],
          ),
        );
      },
    );
  }

  /// 建立排序選項
  Widget _buildSortOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4ECDC4)),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        // TODO: 實現排序功能
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('排序方式：$title'),
            backgroundColor: const Color(0xFF4ECDC4),
          ),
        );
      },
    );
  }

  /// 處理行程操作
  void _handleTripAction(String action, Trip trip) {
    switch (action) {
      case 'edit':
        Navigator.pushNamed(
          context,
          '/trip-detail',
          arguments: trip,
        );
        break;
      case 'duplicate':
        _duplicateTrip(trip);
        break;
      case 'delete':
        _showDeleteConfirmation(trip);
        break;
    }
  }
}