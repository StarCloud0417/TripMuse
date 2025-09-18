/// TripMuse 新版首頁
/// 
/// 實現現代化的旅遊規劃應用程式首頁設計
/// 包含漸層背景、搜尋功能、快速開始和最近旅程展示

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/trip_provider.dart';
import '../widgets/enhanced_trip_card.dart';

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
    final tripsAsync = ref.watch(userTripsProvider);
    
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
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Journeys',
                style: TextStyle(
                  fontSize: 24,
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
          const SizedBox(height: 16),
          Expanded(
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
                  ],
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

    // 使用自定義佈局來匹配設計圖
    return _buildCustomTripLayout(recentTrips);
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
            EnhancedTripCard(
              trip: trips[0],
              cardType: TripCardType.featured,
              onTap: () => _navigateToTripDetail(trips[0]),
            ),
          
          // 第二行：兩個精簡卡片
          if (trips.length > 1)
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: EnhancedTripCard(
                      trip: trips[1],
                      cardType: TripCardType.compact,
                      onTap: () => _navigateToTripDetail(trips[1]),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: EnhancedTripCard(
                      trip: trips.length > 2 ? trips[2] : trips[1],
                      cardType: TripCardType.compact,
                      onTap: () => _navigateToTripDetail(trips.length > 2 ? trips[2] : trips[1]),
                    ),
                  ),
                ),
              ],
            ),
        ],
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


}