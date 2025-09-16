/// TripMuse 新版首頁
/// 
/// 實現現代化的旅遊規劃應用程式首頁設計
/// 包含漸層背景、搜尋功能、快速開始和最近旅程展示

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/trip_provider.dart';
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
    // 優先使用真實的行程數據
    List<Trip> displayTrips = trips;
    
    // 如果沒有真實行程，創建示例數據以展示UI
    if (trips.isEmpty) {
      displayTrips = [
        Trip(
          id: 'sample-1',
          title: 'Kyoto Ancient History Tour',
          destination: const Destination(
            name: 'Kyoto',
            city: 'Kyoto',
            country: 'Japan',
            lat: 35.0116,
            lng: 135.7681,
          ),
          days: List.generate(10, (i) => DayPlan(
            dayIndex: i + 1,
            date: DateTime.now().add(Duration(days: i)),
            theme: 'Day ${i + 1}',
            activities: [],
          )),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Trip(
          id: 'sample-2',
          title: 'Alpine Escape',
          destination: const Destination(
            name: 'Alps',
            city: 'Alps',
            country: 'Switzerland',
            lat: 46.5197,
            lng: 8.2985,
          ),
          days: List.generate(5, (i) => DayPlan(
            dayIndex: i + 1,
            date: DateTime.now().add(Duration(days: i)),
            theme: 'Day ${i + 1}',
            activities: [],
          )),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Trip(
          id: 'sample-3',
          title: 'NYC Foodie Adventure',
          destination: const Destination(
            name: 'New York',
            city: 'New York',
            country: 'USA',
            lat: 40.7128,
            lng: -74.0060,
          ),
          days: List.generate(3, (i) => DayPlan(
            dayIndex: i + 1,
            date: DateTime.now().add(Duration(days: i)),
            theme: 'Day ${i + 1}',
            activities: [],
          )),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    }

    if (displayTrips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No journeys yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start planning your first adventure!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    // 使用自定義佈局來匹配設計圖
    return _buildCustomTripLayout(displayTrips);
  }

  /// 建立自定義旅程佈局（匹配設計圖）
  Widget _buildCustomTripLayout(List<Trip> trips) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 第一行：大卡片
          if (trips.isNotEmpty)
            Container(
              height: 200,
              margin: const EdgeInsets.only(bottom: 16),
              child: _buildTripCard(trips[0]),
            ),
          
          // 第二行：兩個小卡片
          if (trips.length > 1)
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 160,
                    margin: const EdgeInsets.only(right: 8),
                    child: _buildTripCard(trips[1]),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 160,
                    margin: const EdgeInsets.only(left: 8),
                    child: _buildTripCard(trips.length > 2 ? trips[2] : trips[1]),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  /// 建立旅程卡片
  Widget _buildTripCard(Trip trip) {
    // 使用實際的行程數據
    final String title = trip.title;
    final String subtitle = '${trip.destination.city} • ${trip.days.length}天';
    
    // 使用目的地圖片服務獲取高品質圖片
    final imageService = DestinationImageService();
    final String imageUrl = imageService.getDestinationThumbnail(
      trip.destination.city,
      trip.destination.country,
    );

    return GestureDetector(
      onTap: () => _navigateToTripDetail(trip),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // 背景圖片
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      // 如果圖片載入失敗，使用漸層背景
                    },
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                      stops: const [0.4, 1.0],
                    ),
                  ),
                ),
              ),
              
              // 內容
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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


}