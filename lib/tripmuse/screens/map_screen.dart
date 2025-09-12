/// TripMuse 地圖畫面
/// 
/// 顯示行程地圖視圖和路線規劃

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../widgets/trip_map_widget.dart';
import '../providers/trip_provider.dart';
import '../models/models.dart';
import '../services/navigation_helper.dart';
import '../services/places_service.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  Trip? _selectedTrip;
  Activity? _selectedActivity;
  bool _showTripSelector = false;
  bool _hasInitialized = false;
  
  // 日期篩選相關
  DateTime? _selectedDate;
  bool _showDateFilter = false;

  @override
  Widget build(BuildContext context) {
    final tripsAsync = ref.watch(userTripsProvider);
    
    // 自動選擇第一個行程
    tripsAsync.whenData((trips) {
      if (!_hasInitialized && trips.isNotEmpty && _selectedTrip == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _selectedTrip = trips.first;
              _hasInitialized = true;
            });
            ref.read(mapStateProvider.notifier).selectTrip(trips.first);
          }
        });
      }
    });
    
    return Scaffold(
      body: Stack(
        children: [
          // 地圖組件
          TripMapWidget(
            key: ValueKey('${_selectedTrip?.id ?? 'no-trip'}-${_selectedDate?.millisecondsSinceEpoch ?? 'all'}'), // 包含日期的 key
            initialTrip: _selectedTrip,
            initialActivity: _selectedActivity,
            selectedDate: _selectedDate, // 傳入選中的日期
            showControls: true,
            onActivityTap: (activity) {
              setState(() {
                _selectedActivity = activity;
              });
              _showActivityDetails(activity);
            },
            onTripSelect: (trip) {
              setState(() {
                _selectedTrip = trip;
                _selectedActivity = null;
              });
            },
          ),
          
          // 頂部控制欄
          Positioned(
            top: MediaQuery.of(context).padding.top + TripMuseSpacing.md,
            left: TripMuseSpacing.md,
            right: TripMuseSpacing.md,
            child: Row(
              children: [
                // 行程選擇按鈕
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TripMuseSpacing.md,
                    vertical: TripMuseSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(TripMuseRadius.lg),
                    boxShadow: TripMuseShadows.small,
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _showTripSelector = !_showTripSelector;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.luggage,
                          color: TripMuseTheme.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: TripMuseSpacing.sm),
                        Text(
                          _selectedTrip?.title ?? '選擇行程',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: _selectedTrip != null 
                                ? TripMuseTheme.primaryColor 
                                : TripMuseTheme.textHint,
                            fontWeight: _selectedTrip != null 
                                ? FontWeight.w500 
                                : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(width: TripMuseSpacing.sm),
                        Icon(
                          _showTripSelector ? Icons.expand_less : Icons.expand_more,
                          color: TripMuseTheme.textSecondary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // 日期篩選按鈕
                if (_selectedTrip != null)
                  Container(
                    margin: const EdgeInsets.only(right: TripMuseSpacing.sm),
                    padding: const EdgeInsets.all(TripMuseSpacing.sm),
                    decoration: BoxDecoration(
                      color: _showDateFilter ? TripMuseTheme.primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(TripMuseRadius.md),
                      boxShadow: TripMuseShadows.small,
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _showDateFilter = !_showDateFilter;
                        });
                      },
                      child: Icon(
                        Icons.date_range,
                        color: _showDateFilter ? Colors.white : TripMuseTheme.primaryColor,
                      ),
                    ),
                  ),
                
                // 搜尋按鈕
                Container(
                  padding: const EdgeInsets.all(TripMuseSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(TripMuseRadius.md),
                    boxShadow: TripMuseShadows.small,
                  ),
                  child: InkWell(
                    onTap: () {
                      _showSearchDialog();
                    },
                    child: const Icon(
                      Icons.search,
                      color: TripMuseTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 行程選擇下拉選單
          if (_showTripSelector)
            Positioned(
              top: MediaQuery.of(context).padding.top + TripMuseSpacing.xl + 40,
              left: TripMuseSpacing.md,
              right: TripMuseSpacing.md,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 300),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(TripMuseRadius.lg),
                  boxShadow: TripMuseShadows.medium,
                ),
                child: tripsAsync.when(
                  data: (trips) {
                    if (trips.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(TripMuseSpacing.lg),
                        child: Text(
                          '尚無行程\n請先建立行程',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: TripMuseTheme.textSecondary),
                        ),
                      );
                    }
                    
                    return ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: TripMuseSpacing.sm),
                      itemCount: trips.length + 1, // +1 for "清除選擇" option
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // 清除選擇選項
                          return ListTile(
                            leading: const Icon(Icons.clear, color: TripMuseTheme.textSecondary),
                            title: const Text('清除選擇'),
                            onTap: () {
                              setState(() {
                                _selectedTrip = null;
                                _selectedActivity = null;
                                _showTripSelector = false;
                              });
                              // 清除地圖狀態
                              ref.read(mapStateProvider.notifier).selectTrip(null);
                              print('🗺️ 清除行程選擇');
                            },
                          );
                        }
                        
                        final trip = trips[index - 1];
                        final isSelected = _selectedTrip?.id == trip.id;
                        
                        return ListTile(
                          leading: Icon(
                            Icons.luggage,
                            color: isSelected ? TripMuseTheme.primaryColor : TripMuseTheme.textSecondary,
                          ),
                          title: Text(
                            trip.title,
                            style: TextStyle(
                              color: isSelected ? TripMuseTheme.primaryColor : null,
                              fontWeight: isSelected ? FontWeight.w500 : null,
                            ),
                          ),
                          subtitle: Text(
                            '${trip.destination.name} • ${trip.totalDays} 天',
                            style: TextStyle(
                              color: isSelected 
                                  ? TripMuseTheme.primaryColor.withAlpha((0.7 * 255).round()) 
                                  : TripMuseTheme.textSecondary,
                            ),
                          ),
                          trailing: isSelected 
                              ? const Icon(Icons.check, color: TripMuseTheme.primaryColor)
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedTrip = trip;
                              _selectedActivity = null;
                              _showTripSelector = false;
                            });
                            // 更新地圖狀態
                            ref.read(mapStateProvider.notifier).selectTrip(trip);
                            print('🗺️ 選擇行程: ${trip.title}');
                          },
                        );
                      },
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.all(TripMuseSpacing.lg),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, stack) => Padding(
                    padding: const EdgeInsets.all(TripMuseSpacing.lg),
                    child: Text(
                      '載入行程失敗: $error',
                      style: const TextStyle(color: TripMuseTheme.errorColor),
                    ),
                  ),
                ),
              ),
            ),
          
          // 日期篩選面板（調整位置，不遮擋地圖）
          if (_showDateFilter && _selectedTrip != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 80, // 往上移動，緊貼在頂部控制欄下方
              left: TripMuseSpacing.md,
              right: TripMuseSpacing.md,
              child: Container(
                padding: const EdgeInsets.all(TripMuseSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(TripMuseRadius.lg),
                  boxShadow: TripMuseShadows.medium,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 標題
                    Row(
                      children: [
                        const Icon(
                          Icons.date_range,
                          size: 20,
                          color: TripMuseTheme.primaryColor,
                        ),
                        const SizedBox(width: TripMuseSpacing.sm),
                        Text(
                          '日期篩選',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: TripMuseTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _showDateFilter = false;
                            });
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 20,
                            color: TripMuseTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: TripMuseSpacing.md),
                    
                    // 日期選項
                    Wrap(
                      spacing: TripMuseSpacing.sm,
                      runSpacing: TripMuseSpacing.sm,
                      children: [
                        // 全部顯示選項
                        _buildDateChip(
                          label: '全部',
                          isSelected: _selectedDate == null,
                          onTap: () {
                            setState(() {
                              _selectedDate = null;
                            });
                            
                            // 顯示全部行程，自動調整地圖視角
                            _flyToTripOverview();
                          },
                        ),
                        
                        // 各天選項
                        ...List.generate(_selectedTrip!.days.length, (index) {
                          final dayDate = (_selectedTrip!.startDate ?? DateTime.now()).add(Duration(days: index));
                          final isSelected = _selectedDate != null && 
                              _selectedDate!.year == dayDate.year &&
                              _selectedDate!.month == dayDate.month &&
                              _selectedDate!.day == dayDate.day;
                          
                          return _buildDateChip(
                            label: '第${index + 1}天',
                            subtitle: '${dayDate.month}/${dayDate.day}',
                            color: _getDayColor(index),
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                _selectedDate = dayDate;
                              });
                              
                              // 自動切換地圖視角到該天第一個景點
                              _flyToFirstActivityOfDay(index);
                            },
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          
          // 底部活動資訊卡片
          if (_selectedActivity != null)
            Positioned(
              left: TripMuseSpacing.md,
              right: TripMuseSpacing.md,
              bottom: 100, // 避免與底部導航欄重疊
              child: Container(
                padding: const EdgeInsets.all(TripMuseSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(TripMuseRadius.lg),
                  boxShadow: TripMuseShadows.medium,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(TripMuseSpacing.sm),
                          decoration: BoxDecoration(
                            color: TripMuseTheme.primaryColor.withAlpha((0.1 * 255).round()),
                            borderRadius: BorderRadius.circular(TripMuseRadius.sm),
                          ),
                          child: Icon(
                            _getActivityIcon(_selectedActivity!.category),
                            color: TripMuseTheme.primaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: TripMuseSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedActivity!.name,
                                style: Theme.of(context).textTheme.titleSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                _selectedActivity!.timeRange,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: TripMuseTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedActivity = null;
                            });
                          },
                          icon: const Icon(
                            Icons.close,
                            color: TripMuseTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    
                    if (_selectedActivity!.description.isNotEmpty) ...[
                      const SizedBox(height: TripMuseSpacing.sm),
                      Text(
                        _selectedActivity!.description,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    
                    if (_selectedActivity!.estimatedCost != null) ...[
                      const SizedBox(height: TripMuseSpacing.sm),
                      Row(
                        children: [
                          const Icon(
                            Icons.attach_money,
                            size: 16,
                            color: TripMuseTheme.textSecondary,
                          ),
                          Text(
                            _selectedActivity!.estimatedCost!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: TripMuseTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 顯示活動詳細資訊
  void _showActivityDetails(Activity activity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(TripMuseRadius.xl)),
        ),
        child: Column(
          children: [
            // 拖拽指示器
            Container(
              margin: const EdgeInsets.symmetric(vertical: TripMuseSpacing.sm),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TripMuseTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // 活動資訊
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(TripMuseSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 標題和類別
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(TripMuseSpacing.sm),
                          decoration: BoxDecoration(
                            color: TripMuseTheme.primaryColor.withAlpha((0.1 * 255).round()),
                            borderRadius: BorderRadius.circular(TripMuseRadius.sm),
                          ),
                          child: Icon(
                            _getActivityIcon(activity.category),
                            color: TripMuseTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: TripMuseSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity.name,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                activity.timeRange,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: TripMuseTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: TripMuseSpacing.lg),
                    
                    // 描述
                    if (activity.description.isNotEmpty) ...[
                      Text(
                        '活動描述',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: TripMuseSpacing.sm),
                      Text(
                        activity.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: TripMuseSpacing.lg),
                    ],
                    
                    // 詳細資訊
                    if (activity.address != null || 
                        activity.estimatedCost != null || 
                        activity.tips != null) ...[
                      Text(
                        '詳細資訊',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: TripMuseSpacing.sm),
                      
                      if (activity.address != null)
                        _buildInfoRow(Icons.location_on, '地址', activity.address!),
                      
                      if (activity.estimatedCost != null)
                        _buildInfoRow(Icons.attach_money, '預估費用', activity.estimatedCost!),
                      
                      if (activity.tips != null)
                        _buildInfoRow(Icons.lightbulb_outline, '小貼士', activity.tips!),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 建立資訊行
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TripMuseSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: TripMuseTheme.textSecondary,
          ),
          const SizedBox(width: TripMuseSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: TripMuseTheme.textSecondary,
                  ),
                ),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 顯示搜尋對話框
  void _showSearchDialog() {
    final TextEditingController searchController = TextEditingController();
    List<Place> searchResults = [];
    bool isSearching = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.search, color: TripMuseTheme.primaryColor),
              const SizedBox(width: TripMuseSpacing.sm),
              const Text('搜尋地點'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 搜尋輸入框
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: '輸入地點名稱...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              setState(() {
                                searchResults = [];
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TripMuseRadius.md),
                    ),
                  ),
                  onChanged: (value) async {
                    if (value.trim().isEmpty) {
                      setState(() {
                        searchResults = [];
                        isSearching = false;
                      });
                      return;
                    }

                    setState(() {
                      isSearching = true;
                    });

                    try {
                      // 使用 PlacesService 搜尋地點
                      final placesService = ref.read(placesServiceProvider);
                      final results = await placesService.searchPlaces(
                        value.trim(),
                        maxResults: 10,
                      );

                      setState(() {
                        searchResults = results;
                        isSearching = false;
                      });
                    } catch (e) {
                      setState(() {
                        searchResults = [];
                        isSearching = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('搜尋失敗: $e'),
                          backgroundColor: TripMuseTheme.errorColor,
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: TripMuseSpacing.md),

                // 搜尋結果
                if (isSearching)
                  const Padding(
                    padding: EdgeInsets.all(TripMuseSpacing.md),
                    child: CircularProgressIndicator(),
                  )
                else if (searchResults.isNotEmpty)
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final place = searchResults[index];
                        return ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: TripMuseTheme.primaryColor.withAlpha((0.1 * 255).round()),
                              borderRadius: BorderRadius.circular(TripMuseRadius.sm),
                            ),
                            child: const Icon(
                              Icons.place,
                              color: TripMuseTheme.primaryColor,
                            ),
                          ),
                          title: Text(
                            place.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            place.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: TripMuseTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          onTap: () {
                            // 關閉搜尋對話框
                            Navigator.of(dialogContext).pop();

                            // 在地圖上顯示選定的地點
                            _showPlaceOnMap(place);
                          },
                        );
                      },
                    ),
                  )
                else if (searchController.text.isNotEmpty && !isSearching)
                  const Padding(
                    padding: EdgeInsets.all(TripMuseSpacing.lg),
                    child: Text(
                      '未找到相關地點',
                      style: TextStyle(color: TripMuseTheme.textSecondary),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('取消'),
            ),
          ],
        ),
      ),
    );
  }

  /// 根據活動類別取得圖標
  IconData _getActivityIcon(ActivityCategory category) {
    switch (category) {
      case ActivityCategory.sightseeing:
        return Icons.camera_alt;
      case ActivityCategory.food:
        return Icons.restaurant;
      case ActivityCategory.shopping:
        return Icons.shopping_bag;
      case ActivityCategory.culture:
        return Icons.museum;
      case ActivityCategory.nature:
        return Icons.nature;
      case ActivityCategory.outdoor:
        return Icons.hiking;
      case ActivityCategory.transportation:
        return Icons.directions;
    }
  }

  /// 建立日期選擇晶片
  Widget _buildDateChip({
    required String label,
    String? subtitle,
    Color? color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: TripMuseSpacing.md,
          vertical: TripMuseSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? (color ?? TripMuseTheme.primaryColor)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(TripMuseRadius.md),
          border: Border.all(
            color: isSelected 
                ? (color ?? TripMuseTheme.primaryColor)
                : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isSelected ? Colors.white70 : Colors.grey.shade500,
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 取得每日顏色
  Color _getDayColor(int dayIndex) {
    // 現代化每日行程顏色主題 - 美觀漸層色彩
    const dayColors = [
      Color(0xFF667EEA), // 漸層藍紫 - 第1天
      Color(0xFF06D6A0), // 薄荷綠 - 第2天  
      Color(0xFFFFB347), // 暖橙色 - 第3天
      Color(0xFF9B59B6), // 優雅紫 - 第4天
      Color(0xFFE74C3C), // 珊瑚紅 - 第5天
      Color(0xFF1ABC9C), // 土耳其藍 - 第6天
      Color(0xFFF39C12), // 金橙色 - 第7天
      Color(0xFF8E44AD), // 深紫色 - 第8天
      Color(0xFF34495E), // 深藍灰 - 第9天
      Color(0xFFE91E63), // 玫瑰粉 - 第10天
    ];
    return dayColors[dayIndex % dayColors.length];
  }

  /// 飛行到指定天數的第一個景點
  void _flyToFirstActivityOfDay(int dayIndex) {
    if (_selectedTrip == null || dayIndex >= _selectedTrip!.days.length) {
      return;
    }

    final dayPlan = _selectedTrip!.days[dayIndex];
    if (dayPlan.activities.isEmpty) {
      print('⚠️ 第${dayIndex + 1}天沒有活動');
      return;
    }

    final firstActivity = dayPlan.activities.first;
    if (firstActivity.lat == 0.0 && firstActivity.lng == 0.0) {
      print('⚠️ 第${dayIndex + 1}天第一個活動座標無效');
      return;
    }

    // 通知地圖組件執行飛行動畫
    ref.read(mapStateProvider.notifier).selectActivity(firstActivity);
    
    print('🎯 飛行到第${dayIndex + 1}天第一個景點: ${firstActivity.name}');
    print('📍 座標: ${firstActivity.lat}, ${firstActivity.lng}');
  }

  /// 在地圖上顯示選定的地點
  void _showPlaceOnMap(Place place) {
    // 創建一個臨時的活動物件來在地圖上顯示
    final tempActivity = Activity(
      id: 'search_${place.id}',
      name: place.name,
      description: place.address,
      category: ActivityCategory.sightseeing, // 預設為景點
      priority: ActivityPriority.medium, // 預設中等優先級
      lat: place.location.lat,
      lng: place.location.lng,
      address: place.address,
      estimatedCost: null,
      tips: null,
    );

    // 更新地圖狀態以顯示這個地點
    ref.read(mapStateProvider.notifier).selectActivity(tempActivity);

    // 顯示一個snackbar提示用戶
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已在地圖上標記: ${place.name}'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: '導航',
          onPressed: () async {
            try {
              final navigationHelper = ref.read(navigationHelperProvider);
              await navigationHelper.navigateToActivity(tempActivity);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('無法啟動導航: $e'),
                  backgroundColor: TripMuseTheme.errorColor,
                ),
              );
            }
          },
        ),
      ),
    );
  }
  /// ������{�`������
  void _flyToTripOverview() {
    if (_selectedTrip == null) {
      return;
    }

    // �M���襤�����ʡA���a����ܾ�Ӧ�{
    ref.read(mapStateProvider.notifier).selectActivity(null);
    
    print(' �������{�`������');
  }
}
