/// TripMuse 新版首頁
/// 
/// 實現現代化的旅遊規劃應用程式首頁設計
/// 包含漸層背景、搜尋功能、快速開始和最近旅程展示

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/trip_provider.dart';
import '../widgets/enhanced_trip_card.dart';
import '../services/destination_image_service.dart';

class HomeScreenNew extends ConsumerStatefulWidget {
  const HomeScreenNew({super.key});

  @override
  ConsumerState<HomeScreenNew> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends ConsumerState<HomeScreenNew> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripsAsync = ref.watch(tripNotifierProvider);
    
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
                      // Quick Start 區域
                      _buildQuickStart(),
                      
                      // Recent Journeys 區域
                      Expanded(
                        child: _buildRecentJourneys(tripsAsync),
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
          
          // 歡迎文字
          const Text(
            'Hello, Sarah! Where will your story begin?',
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
            hintText: 'Dream, Explore, Plan Your Next Journey...',
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey.shade400,
              size: 24,
            ),
            suffixIcon: Icon(
              Icons.mic,
              color: Colors.grey.shade400,
              size: 24,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
          onSubmitted: (value) {
            // 處理搜尋
            _handleSearch(value);
          },
        ),
      ),
    );
  }

  /// 建立 Quick Start 區域
  Widget _buildQuickStart() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Start',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickStartButton(
                  title: 'API Testing',
                  icon: Icons.cloud_upload,
                  color: const Color(0xFF4CAF50),
                  onTap: () => _navigateToApiTesting(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildQuickStartButton(
                  title: 'Itinerary Test',
                  icon: Icons.trending_up,
                  color: const Color(0xFF9C27B0),
                  onTap: () => _navigateToItineraryTest(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 建立快速開始按鈕
  Widget _buildQuickStartButton({
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

  /// 建立最近旅程區域
  Widget _buildRecentJourneys(AsyncValue<List<Trip>> tripsAsync) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Journeys',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () => _navigateToAllTrips(),
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4ECDC4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshPage,
              color: const Color(0xFF4ECDC4),
              child: tripsAsync.when(
                data: (trips) => _buildTripsList(trips),
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
                  ),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load trips',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refreshPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4ECDC4),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('重新載入'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 建立旅程列表
  Widget _buildTripsList(List<Trip> trips) {
    // 只顯示最近的行程（最多3個）
    final recentTrips = trips.take(3).toList();
    
    if (recentTrips.isEmpty) {
      return _buildEmptyTripsState();
    }

    // 使用自定義佈局來匹配設計圖，添加 key 強制重建
    return KeyedSubtree(
      key: ValueKey('trips_${recentTrips.length}_${recentTrips.map((t) => t.id).join('_')}'),
      child: _buildCustomTripLayout(recentTrips),
    );
  }

  /// 建立空行程狀態
  Widget _buildEmptyTripsState() {
    return Center(
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
            child: const Icon(
              Icons.explore_off,
              size: 64,
              color: Color(0xFF4ECDC4),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '還沒有任何行程',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '開始規劃您的第一個旅程吧！',
            style: TextStyle(
              fontSize: 16,
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
      ),
    );
  }

  /// 建立自定義旅程佈局（匹配設計圖）
  Widget _buildCustomTripLayout(List<Trip> trips) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 第一行：特色大卡片
          if (trips.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: EnhancedTripCard(
                trip: trips[0],
                cardType: TripCardType.featured,
                onTap: () => _navigateToTripDetail(trips[0]),
                onDelete: () => _deleteTrip(trips[0]),
              ),
            ),
          
          // 第二行：兩個精簡卡片 - 重新設計排版
          if (trips.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      child: _buildCompactTripCard(trips[1]),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 6),
                      child: _buildCompactTripCard(
                        trips.length > 2 ? trips[2] : trips[1],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// 建立精簡行程卡片（重新設計）
  Widget _buildCompactTripCard(Trip trip) {
    // 獲取目的地縮圖
    final imageService = DestinationImageService();
    final imageUrl = imageService.getDestinationThumbnail(
      trip.destination.city,
      trip.destination.country,
    );

    return GestureDetector(
      onTap: () => _navigateToTripDetail(trip),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 圖片區域
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.4),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // 狀態標籤
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getTripStatusIcon(trip),
                              size: 10,
                              color: _getTripStatusColor(trip),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              _getTripStatus(trip),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: _getTripStatusColor(trip),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // 操作按鈕
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildActionButton(
                            Icons.favorite_border,
                            () => _toggleFavorite(trip.id),
                          ),
                          const SizedBox(width: 8),
                          _buildActionButton(
                            Icons.delete_outline,
                            () => _deleteTrip(trip),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // 文字內容區域
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 標題
                  Text(
                    trip.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 目的地
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          trip.destination.city,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 天數和日期
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ECDC4).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${trip.days.length}天',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4ECDC4),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatTripDate(trip),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 建立操作按鈕
  Widget _buildActionButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 16,
          color: icon == Icons.delete_outline 
              ? Colors.red.shade600 
              : Colors.grey.shade700,
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

  // 事件處理方法
  void _handleSearch(String query) {
    if (query.trim().isEmpty) return;
    
    // TODO: 實現搜尋功能
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('搜尋: $query'),
        backgroundColor: const Color(0xFF4ECDC4),
      ),
    );
  }

  void _navigateToApiTesting() {
    Navigator.pushNamed(context, '/api-test');
  }

  void _navigateToItineraryTest() {
    Navigator.pushNamed(context, '/create-trip');
  }

  void _navigateToAllTrips() {
    Navigator.pushNamed(context, '/my-trips');
  }

  void _navigateToTripDetail(Trip trip) {
    Navigator.pushNamed(
      context,
      '/trip-detail',
      arguments: trip,
    );
  }



  void _createNewTrip() {
    Navigator.pushNamed(context, '/create-trip');
  }

  /// 刪除行程
  void _deleteTrip(Trip trip) async {
    try {
      // 顯示載入指示器
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Text('正在刪除「${trip.title}」...'),
            ],
          ),
          backgroundColor: const Color(0xFF4ECDC4),
          duration: const Duration(seconds: 2),
        ),
      );
      
      // 執行刪除操作
      await ref.read(tripNotifierProvider.notifier).deleteTrip(trip.id);
      
      // 強制刷新頁面
      await _refreshPage();
      
      // 顯示成功訊息
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text('已刪除「${trip.title}」'),
              ],
            ),
            backgroundColor: const Color(0xFF4CAF50),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      // 顯示錯誤訊息
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.error,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('刪除失敗: ${error.toString()}'),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: '重試',
              textColor: Colors.white,
              onPressed: () => _deleteTrip(trip),
            ),
          ),
        );
      }
    }
  }

  /// 強制刷新頁面
  Future<void> _refreshPage() async {
    // 強制刷新所有相關的 providers
    ref.invalidate(tripNotifierProvider);
    ref.invalidate(userTripsProvider);
    ref.invalidate(recentTripsProvider);
    
    // 等待刷新完成
    await Future.delayed(const Duration(milliseconds: 200));
    
    // 強制重建 widget
    if (mounted) {
      setState(() {});
    }
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

  /// 取得行程狀態
  String _getTripStatus(Trip trip) {
    final now = DateTime.now();
    if (trip.days.isEmpty) return '未設定';
    
    final startDate = trip.days.first.date;
    final endDate = trip.days.last.date;
    
    if (now.isBefore(startDate)) {
      return '即將開始';
    } else if (now.isAfter(endDate)) {
      return '已完成';
    } else {
      return '進行中';
    }
  }

  /// 取得行程狀態顏色
  Color _getTripStatusColor(Trip trip) {
    final now = DateTime.now();
    if (trip.days.isEmpty) return Colors.grey.shade600;
    
    final startDate = trip.days.first.date;
    final endDate = trip.days.last.date;
    
    if (now.isBefore(startDate)) {
      return const Color(0xFF2196F3);
    } else if (now.isAfter(endDate)) {
      return const Color(0xFF4CAF50); // 改為綠色，與 EnhancedTripCard 一致
    } else {
      return const Color(0xFFFF9800); // 橙色表示進行中
    }
  }

  /// 取得行程狀態圖標
  IconData _getTripStatusIcon(Trip trip) {
    final now = DateTime.now();
    if (trip.days.isEmpty) return Icons.help_outline;
    
    final startDate = trip.days.first.date;
    final endDate = trip.days.last.date;
    
    if (now.isBefore(startDate)) {
      return Icons.schedule;
    } else if (now.isAfter(endDate)) {
      return Icons.check_circle;
    } else {
      return Icons.play_circle;
    }
  }

  /// 格式化行程日期
  String _formatTripDate(Trip trip) {
    if (trip.days.isEmpty) return '未設定日期';
    
    final startDate = trip.days.first.date;
    final endDate = trip.days.last.date;
    
    if (trip.days.length == 1) {
      return '${startDate.month}/${startDate.day}';
    }
    
    if (startDate.year == endDate.year && startDate.month == endDate.month) {
      return '${startDate.month}/${startDate.day}-${endDate.day}';
    }
    
    return '${startDate.month}/${startDate.day}-${endDate.month}/${endDate.day}';
  }


}