/// TripMuse 行程列表頁面
/// 
/// 顯示使用者的所有行程，支援搜尋和篩選

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/trip_card.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import 'create_trip_screen.dart';

class TripListScreen extends ConsumerStatefulWidget {
  const TripListScreen({super.key});

  @override
  ConsumerState<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends ConsumerState<TripListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  TripSortOption _sortOption = TripSortOption.newest;
  TripFilterOption _filterOption = TripFilterOption.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripsAsync = ref.watch(userTripsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的行程'),
        backgroundColor: TripMuseTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sort',
                child: Row(
                  children: [
                    Icon(Icons.sort),
                    SizedBox(width: 8),
                    Text('排序'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'filter',
                child: Row(
                  children: [
                    Icon(Icons.filter_list),
                    SizedBox(width: 8),
                    Text('篩選'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜尋欄
          if (_searchQuery.isNotEmpty) _buildSearchBar(),
          
          // 篩選和排序指示器
          if (_filterOption != TripFilterOption.all || _sortOption != TripSortOption.newest)
            _buildFilterIndicator(),
          
          // 行程列表
          Expanded(
            child: tripsAsync.when(
              data: (trips) => _buildTripList(trips),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => _buildErrorView(error),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewTrip,
        backgroundColor: TripMuseTheme.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('建立行程'),
      ),
    );
  }
  
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(TripMuseSpacing.md),
      color: TripMuseTheme.surfaceColor,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '搜尋行程...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TripMuseRadius.md),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }
  
  Widget _buildFilterIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TripMuseSpacing.md,
        vertical: TripMuseSpacing.sm,
      ),
      color: TripMuseTheme.primaryColor.withValues(alpha: 25.5),
      child: Row(
        children: [
          if (_filterOption != TripFilterOption.all) ...[
            Chip(
              label: Text(_getFilterLabel(_filterOption)),
              onDeleted: () {
                setState(() {
                  _filterOption = TripFilterOption.all;
                });
              },
              backgroundColor: TripMuseTheme.primaryColor.withValues(alpha: 51.0),
            ),
            const SizedBox(width: TripMuseSpacing.sm),
          ],
          if (_sortOption != TripSortOption.newest) ...[
            Chip(
              label: Text('排序: ${_getSortLabel(_sortOption)}'),
              onDeleted: () {
                setState(() {
                  _sortOption = TripSortOption.newest;
                });
              },
              backgroundColor: TripMuseTheme.secondaryColor.withValues(alpha: 51.0),
            ),
          ],
          const Spacer(),
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _filterOption = TripFilterOption.all;
                _sortOption = TripSortOption.newest;
                _searchController.clear();
              });
            },
            child: const Text('清除全部'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTripList(List<Trip> allTrips) {
    final filteredTrips = _filterAndSortTrips(allTrips);
    
    if (filteredTrips.isEmpty) {
      return _buildEmptyView();
    }
    
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: TripMuseSpacing.md,
        bottom: 80, // 為 FAB 留空間
      ),
      itemCount: filteredTrips.length,
      itemBuilder: (context, index) {
        final trip = filteredTrips[index];
        return TripCard(
          trip: trip,
          onTap: () => _openTrip(trip),
          onEdit: () => _editTrip(trip),
          onShare: () => _shareTrip(trip),
          onDelete: () => _deleteTrip(trip),
        );
      },
    );
  }
  
  Widget _buildEmptyView() {
    if (_searchQuery.isNotEmpty || _filterOption != TripFilterOption.all) {
      // 搜尋或篩選結果為空
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: TripMuseTheme.textSecondary,
            ),
            const SizedBox(height: TripMuseSpacing.md),
            Text(
              '找不到符合條件的行程',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: TripMuseTheme.textSecondary,
              ),
            ),
            const SizedBox(height: TripMuseSpacing.sm),
            Text(
              '試試調整搜尋條件或篩選設定',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TripMuseTheme.textSecondary,
              ),
            ),
            const SizedBox(height: TripMuseSpacing.lg),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _filterOption = TripFilterOption.all;
                  _sortOption = TripSortOption.newest;
                  _searchController.clear();
                });
              },
              child: const Text('清除篩選'),
            ),
          ],
        ),
      );
    } else {
      // 沒有任何行程
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.luggage,
              size: 80,
              color: TripMuseTheme.textSecondary,
            ),
            const SizedBox(height: TripMuseSpacing.lg),
            Text(
              '還沒有任何行程',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: TripMuseTheme.textSecondary,
              ),
            ),
            const SizedBox(height: TripMuseSpacing.md),
            Text(
              '點擊下方按鈕開始規劃您的第一趟旅程',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: TripMuseTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TripMuseSpacing.xl),
            ElevatedButton.icon(
              onPressed: _createNewTrip,
              icon: const Icon(Icons.add),
              label: const Text('建立第一個行程'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TripMuseTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: TripMuseSpacing.lg,
                  vertical: TripMuseSpacing.md,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
  
  Widget _buildErrorView(Object error) {
    return Center(
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
            '載入行程時發生錯誤',
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
              ref.invalidate(userTripsProvider);
            },
            child: const Text('重試'),
          ),
        ],
      ),
    );
  }
  
  List<Trip> _filterAndSortTrips(List<Trip> trips) {
    var filteredTrips = trips.where((trip) {
      // 搜尋篩選
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!trip.title.toLowerCase().contains(query) &&
            !trip.destination.city.toLowerCase().contains(query) &&
            !trip.destination.country.toLowerCase().contains(query)) {
          return false;
        }
      }
      
      // 狀態篩選
      switch (_filterOption) {
        case TripFilterOption.all:
          return true;
        case TripFilterOption.upcoming:
          return _isTripUpcoming(trip);
        case TripFilterOption.past:
          return _isTripPast(trip);
        case TripFilterOption.thisMonth:
          return _isTripThisMonth(trip);
      }
    }).toList();
    
    // 排序
    switch (_sortOption) {
      case TripSortOption.newest:
        filteredTrips.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case TripSortOption.oldest:
        filteredTrips.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case TripSortOption.alphabetical:
        filteredTrips.sort((a, b) => a.title.compareTo(b.title));
        break;
      case TripSortOption.byDate:
        filteredTrips.sort((a, b) {
          if (a.days.isEmpty && b.days.isEmpty) return 0;
          if (a.days.isEmpty) return 1;
          if (b.days.isEmpty) return -1;
          return a.days.first.date.compareTo(b.days.first.date);
        });
        break;
    }
    
    return filteredTrips;
  }
  
  bool _isTripUpcoming(Trip trip) {
    if (trip.days.isEmpty) return false;
    final now = DateTime.now();
    return trip.days.first.date.isAfter(now);
  }
  
  bool _isTripPast(Trip trip) {
    if (trip.days.isEmpty) return false;
    final now = DateTime.now();
    return trip.days.last.date.isBefore(now);
  }
  
  bool _isTripThisMonth(Trip trip) {
    if (trip.days.isEmpty) return false;
    final now = DateTime.now();
    return trip.days.any((day) => 
        day.date.year == now.year && day.date.month == now.month);
  }
  
  String _getFilterLabel(TripFilterOption option) {
    switch (option) {
      case TripFilterOption.all:
        return '全部';
      case TripFilterOption.upcoming:
        return '即將到來';
      case TripFilterOption.past:
        return '已完成';
      case TripFilterOption.thisMonth:
        return '本月';
    }
  }
  
  String _getSortLabel(TripSortOption option) {
    switch (option) {
      case TripSortOption.newest:
        return '最新建立';
      case TripSortOption.oldest:
        return '最早建立';
      case TripSortOption.alphabetical:
        return '名稱';
      case TripSortOption.byDate:
        return '日期';
    }
  }
  
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('搜尋行程'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: '輸入行程名稱或目的地...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (value) {
            setState(() {
              _searchQuery = value;
            });
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = _searchController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('搜尋'),
          ),
        ],
      ),
    );
  }
  
  void _handleMenuAction(String action) {
    switch (action) {
      case 'sort':
        _showSortDialog();
        break;
      case 'filter':
        _showFilterDialog();
        break;
    }
  }
  
  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('排序方式'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: TripSortOption.values.map((option) => ListTile(
              title: Text(_getSortLabel(option)),
              leading: Radio<TripSortOption>(
                value: option,
                groupValue: _sortOption, // ignore: deprecated_member_use
                onChanged: (value) { // ignore: deprecated_member_use
                  if (value != null) {
                    this.setState(() {
                      _sortOption = value;
                    });
                    Navigator.pop(context);
                  }
                },
              ),
              onTap: () {
                this.setState(() {
                  _sortOption = option;
                });
                Navigator.pop(context);
              },
            )).toList(),
          ),
        ),
      ),
    );
  }
  
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('篩選條件'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: TripFilterOption.values.map((option) => ListTile(
              title: Text(_getFilterLabel(option)),
              leading: Radio<TripFilterOption>(
                value: option,
                groupValue: _filterOption, // ignore: deprecated_member_use
                onChanged: (value) { // ignore: deprecated_member_use
                  if (value != null) {
                    this.setState(() {
                      _filterOption = value;
                    });
                    Navigator.pop(context);
                  }
                },
              ),
              onTap: () {
                this.setState(() {
                  _filterOption = option;
                });
                Navigator.pop(context);
              },
            )).toList(),
          ),
        ),
      ),
    );
  }
  
  void _createNewTrip() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateTripScreen(),
      ),
    );
  }
  
  void _openTrip(Trip trip) {
    // 開啟行程詳情頁面
    Navigator.pushNamed(
      context,
      '/trip-detail',
      arguments: trip,
    );
  }
  
  void _editTrip(Trip trip) {
    // 編輯行程功能 - 目前顯示提示訊息
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('編輯行程: ${trip.title}')),
    );
  }
  
  void _shareTrip(Trip trip) {
    // 分享行程功能 - 目前顯示提示訊息
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('分享行程: ${trip.title}')),
    );
  }
  
  void _deleteTrip(Trip trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('刪除行程'),
        content: Text('確定要刪除「${trip.title}」嗎？此操作無法復原。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              try {
                await ref.read(tripRepositoryProvider).deleteTrip(trip.id);
                
                // 強制重新載入行程列表
                ref.invalidate(userTripsProvider);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('已刪除行程: ${trip.title}')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('刪除行程失敗: $e'),
                    backgroundColor: TripMuseTheme.errorColor,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: TripMuseTheme.errorColor),
            child: const Text('刪除'),
          ),
        ],
      ),
    );
  }
}

// 排序選項
enum TripSortOption {
  newest,
  oldest,
  alphabetical,
  byDate,
}

// 篩選選項
enum TripFilterOption {
  all,
  upcoming,
  past,
  thisMonth,
}