/// TripMuse 地圖組件
/// 
/// 基於 MapBox Maps Flutter SDK 的專用地圖組件
/// 支援行程路線顯示、景點標記、互動功能、位置追蹤和導航等

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // 已包含在 material.dart 中
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart' as geo;
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../providers/trip_provider.dart';
import '../providers/location_provider.dart';
import '../services/location_service.dart';
import '../services/navigation_helper.dart';
import '../utils/coordinate_validator.dart';

/// 地圖狀態 Provider
final mapStateProvider = StateNotifierProvider<MapStateNotifier, MapState>((ref) {
  return MapStateNotifier();
});

/// 地圖狀態
class MapState {
  final bool isLoading;
  final String? error;
  final Trip? selectedTrip;
  final Activity? selectedActivity;
  final bool showRoute;
  final bool showAllTrips;
  final double zoom;
  final Point? center;

  const MapState({
    this.isLoading = false,
    this.error,
    this.selectedTrip,
    this.selectedActivity,
    this.showRoute = true,
    this.showAllTrips = false,
    this.zoom = 12.0,
    this.center,
  });

  MapState copyWith({
    bool? isLoading,
    String? error,
    Trip? selectedTrip,
    Activity? selectedActivity,
    bool? showRoute,
    bool? showAllTrips,
    double? zoom,
    Point? center,
  }) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedTrip: selectedTrip ?? this.selectedTrip,
      selectedActivity: selectedActivity ?? this.selectedActivity,
      showRoute: showRoute ?? this.showRoute,
      showAllTrips: showAllTrips ?? this.showAllTrips,
      zoom: zoom ?? this.zoom,
      center: center ?? this.center,
    );
  }
}

/// 活動資訊類別
class _ActivityInfo {
  final Activity activity;
  final DayPlan dayPlan;
  final int dayIndex;
  final int activityIndex;

  _ActivityInfo({
    required this.activity,
    required this.dayPlan,
    required this.dayIndex,
    required this.activityIndex,
  });
}

/// 地圖狀態管理器
class MapStateNotifier extends StateNotifier<MapState> {
  MapStateNotifier() : super(const MapState());

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void selectTrip(Trip? trip) {
    state = state.copyWith(selectedTrip: trip, selectedActivity: null);
  }

  void selectActivity(Activity? activity) {
    state = state.copyWith(selectedActivity: activity);
  }

  void toggleRoute() {
    state = state.copyWith(showRoute: !state.showRoute);
  }

  void toggleAllTrips() {
    state = state.copyWith(showAllTrips: !state.showAllTrips);
  }

  void updateCamera(double zoom, Point center) {
    state = state.copyWith(zoom: zoom, center: center);
  }
}

/// TripMuse 地圖組件
class TripMapWidget extends ConsumerStatefulWidget {
  final Trip? initialTrip;
  final Activity? initialActivity;
  final bool showControls;
  final double height;
  final Function(Activity)? onActivityTap;
  final Function(Trip)? onTripSelect;
  final DateTime? selectedDate; // 新增：選中的日期

  const TripMapWidget({
    super.key,
    this.initialTrip,
    this.initialActivity,
    this.showControls = true,
    this.height = double.infinity,
    this.onActivityTap,
    this.onTripSelect,
    this.selectedDate, // 新增參數
  });

  @override
  ConsumerState<TripMapWidget> createState() => _TripMapWidgetState();
}

class _TripMapWidgetState extends ConsumerState<TripMapWidget> 
    with TickerProviderStateMixin {
  MapboxMap? _mapboxMap;
  PointAnnotationManager? _pointAnnotationManager;
  PolylineAnnotationManager? _polylineAnnotationManager;
  
  // 標記圖標（保留供未來使用）
  // Uint8List? _activityIconData;
  
  // 標記與活動的對應關係
  final Map<String, _ActivityInfo> _markerToActivityMap = {};
  
  // 位置追蹤相關
  bool _isLocationTrackingEnabled = false;
  
  // 動畫控制器
  late AnimationController _markerAnimationController;
  late AnimationController _routeAnimationController;
  late AnimationController _cameraAnimationController;
  
  // 日期篩選（移至 MapScreen）
  // DateTime? _selectedDate;
  // bool _showDateFilter = false;
  
  // 地圖互動狀態
  bool _isAnimating = false;
  
  // 現代化每日行程顏色主題 - 美觀漸層色彩
  static const List<Color> dayColors = [
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

  @override
  void initState() {
    super.initState();
    _loadIcons();
    _initializeAnimations();
    
    // 設置初始狀態
    if (widget.initialTrip != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(mapStateProvider.notifier).selectTrip(widget.initialTrip);
      });
    }
    if (widget.initialActivity != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(mapStateProvider.notifier).selectActivity(widget.initialActivity);
      });
    }
  }

  @override
  void didUpdateWidget(TripMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // 當 widget 更新時，檢查是否需要更新地圖內容
    if (oldWidget.initialTrip != widget.initialTrip) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(mapStateProvider.notifier).selectTrip(widget.initialTrip);
        // 如果有新的行程，聚焦到第一個景點
        if (widget.initialTrip != null) {
          _focusOnFirstActivityOfTrip(widget.initialTrip!);
        }
      });
    }
    
    if (oldWidget.initialActivity != widget.initialActivity) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(mapStateProvider.notifier).selectActivity(widget.initialActivity);
      });
    }
  }

  /// 聚焦到行程的第一個景點
  Future<void> _focusOnFirstActivityOfTrip(Trip trip) async {
    if (_mapboxMap == null || trip.days.isEmpty) return;
    
    final firstDay = trip.days.first;
    if (firstDay.activities.isEmpty) return;
    
    final firstActivity = firstDay.activities.first;
    if (!CoordinateValidator.isValidCoordinate(firstActivity.lat, firstActivity.lng)) return;
    
    // 動畫地圖視圖到第一個景點
    await _mapboxMap!.setCamera(CameraOptions(
      center: Point(coordinates: Position(firstActivity.lng, firstActivity.lat)),
      zoom: 16.0, // 高縮放級別以聚焦到景點
      pitch: 0,
    ));
    
    print('🎯 已聚焦到新行程的第一個景點: ${firstActivity.name}');
  }
  void _initializeAnimations() {
    // 標記動畫控制器
    _markerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // 路線動畫控制器
    _routeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    // 相機動畫控制器
    _cameraAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _markerAnimationController.dispose();
    _routeAnimationController.dispose();
    _cameraAnimationController.dispose();
    _pointAnnotationManager = null;
    _polylineAnnotationManager = null;
    _mapboxMap = null;
    super.dispose();
  }

  /// 載入地圖標記圖標（保留供未來使用）
  Future<void> _loadIcons() async {
    // 目前使用 emoji 標記，圖標載入功能保留供未來使用
    print('✅ 地圖標記系統已準備就緒');
  }

  /// 平滑移動到指定位置 - 複製自 animation_example.dart
  Future<void> _animatedEaseTo(Position position, {double? zoom, double? bearing, double? pitch}) async {
    if (_mapboxMap == null || _isAnimating) return;
    
    setState(() => _isAnimating = true);
    
    try {
      await _mapboxMap!.easeTo(
        CameraOptions(
          center: Point(coordinates: position),
          zoom: zoom ?? 14.0,
          bearing: bearing ?? 0,
          pitch: pitch ?? 0,
        ),
        MapAnimationOptions(duration: 2000, startDelay: 0),
      );
    } finally {
      setState(() => _isAnimating = false);
    }
  }

  /// 飛行到指定位置 - 複製自 animation_example.dart
  Future<void> _animatedFlyTo(Position position, {double? zoom, double? bearing, double? pitch}) async {
    if (_mapboxMap == null || _isAnimating) return;
    
    setState(() => _isAnimating = true);
    
    try {
      await _mapboxMap!.flyTo(
        CameraOptions(
          center: Point(coordinates: position),
          zoom: zoom ?? 16.0,
          bearing: bearing ?? 0,
          pitch: pitch ?? 30,
        ),
        MapAnimationOptions(duration: 3000, startDelay: 0),
      );
    } finally {
      setState(() => _isAnimating = false);
    }
  }

  /// 動畫顯示活動標記
  Future<void> _animateMarkerAppearance(List<PointAnnotationOptions> annotations) async {
    if (annotations.isEmpty) {
      print('⚠️ 標記列表為空，跳過動畫');
      return;
    }
    
    print('🎬 開始標記動畫，共 ${annotations.length} 個標記');
    
    // 重置動畫
    _markerAnimationController.reset();
    
    // 分批顯示標記，創造波浪效果
    for (int i = 0; i < annotations.length; i += 2) {
      final batch = annotations.skip(i).take(2).toList();
      print('📍 創建標記批次 ${(i ~/ 2) + 1}，包含 ${batch.length} 個標記');
      
      try {
        await _pointAnnotationManager!.createMulti(batch);
        print('✅ 標記批次創建成功');
      } catch (e) {
        print('❌ 標記創建失敗: $e');
      }
      
      // 短暫延遲創造動畫效果
      await Future.delayed(const Duration(milliseconds: 150));
    }
    
    // 啟動縮放動畫
    _markerAnimationController.forward();
    print('🎬 標記動畫完成');
  }

  /// 動畫顯示路線
  Future<void> _animateRouteAppearance(List<PolylineAnnotationOptions> routes) async {
    if (routes.isEmpty) return;
    
    // 重置動畫
    _routeAnimationController.reset();
    
    // 逐條顯示路線
    for (final route in routes) {
      await _polylineAnnotationManager!.create(route);
      await Future.delayed(const Duration(milliseconds: 300));
    }
    
    // 啟動透明度動畫
    _routeAnimationController.forward();
  }

  /// 地圖創建回調
  void _onMapCreated(MapboxMap mapboxMap) async {
    print('🗺️ MapBox 地圖創建回調被調用');
    _mapboxMap = mapboxMap;
    
    try {
      // 設置初始相機位置
      Point initialCenter = Point(coordinates: Position(121.5654, 25.0330)); // 台北101
      double initialZoom = 12.0; // 預設縮放級別
      
      if (widget.initialTrip != null && widget.initialTrip!.days.isNotEmpty) {
        final firstDay = widget.initialTrip!.days.first;
        if (firstDay.activities.isNotEmpty) {
          final firstActivity = firstDay.activities.first;
          if (CoordinateValidator.isValidCoordinate(firstActivity.lat, firstActivity.lng)) {
            initialCenter = Point(coordinates: Position(firstActivity.lng, firstActivity.lat));
            initialZoom = 16.0; // 聚焦到景點時使用更高的縮放級別
            print('🎯 聚焦到第一個景點: ${firstActivity.name} (${firstActivity.lat}, ${firstActivity.lng})');
          }
        }
      }
      
      print('📍 設置地圖中心點: ${initialCenter.coordinates.lng}, ${initialCenter.coordinates.lat} (縮放: $initialZoom)');
      
      await mapboxMap.setCamera(CameraOptions(
        center: initialCenter,
        zoom: initialZoom,
        pitch: 0,
      ));

      print('📷 地圖相機設置完成');

      // 創建標記管理器
      _pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();
      _polylineAnnotationManager = await mapboxMap.annotations.createPolylineAnnotationManager();
      
      print('📌 標記管理器創建完成');
      
      // 設置標記點擊事件
      _pointAnnotationManager?.tapEvents(onTap: _onAnnotationTap);
      
      // 啟用地圖手勢
      await mapboxMap.gestures.updateSettings(GesturesSettings(
        scrollEnabled: true,
        pinchToZoomEnabled: true,
        rotateEnabled: true,
        doubleTapToZoomInEnabled: true,
        doubleTouchToZoomOutEnabled: true,
        quickZoomEnabled: true,
      ));
      
      print('👆 地圖手勢已啟用');
      
      // 啟用位置組件
      await _enableLocationComponent();
      
      // 初始化地圖內容
      _updateMapContent();
      
      print('✅ 地圖初始化完成');
    } catch (e) {
      print('❌ 地圖初始化失敗: $e');
      ref.read(mapStateProvider.notifier).setError('地圖初始化失敗: $e');
    }
  }

  /// 啟用位置組件
  Future<void> _enableLocationComponent() async {
    try {
      // 檢查位置權限
      final permissionStatus = await ref.read(locationServiceProvider).checkAndRequestPermission();
      
      if (permissionStatus == LocationServiceStatus.granted) {
        // 啟用 MapBox 內建位置組件
        await _mapboxMap?.location.updateSettings(LocationComponentSettings(
          enabled: true,
          puckBearingEnabled: true,
          pulsingEnabled: true,
          showAccuracyRing: true,
          pulsingColor: TripMuseTheme.primaryColor.toARGB32(),
          accuracyRingColor: TripMuseTheme.primaryColor.withValues(alpha: 0.2).toARGB32(),
          accuracyRingBorderColor: TripMuseTheme.primaryColor.toARGB32(),
        ));
        
        print('✅ 位置組件已啟用');
      } else {
        print('❌ 位置權限未授予，無法啟用位置組件');
      }
    } catch (e) {
      print('❌ 啟用位置組件失敗: $e');
    }
  }

  /// 標記點擊事件處理
  void _onAnnotationTap(PointAnnotation annotation) {
    print('📍 標記被點擊');
    
    // 通過座標來找到對應的活動
    final clickedPoint = annotation.geometry;
    final clickedPosition = clickedPoint.coordinates;
    final markerKey = '${clickedPosition.lng}_${clickedPosition.lat}';
    
    // 從對應關係中找到活動
    final activityInfo = _markerToActivityMap[markerKey];
    
    if (activityInfo != null) {
      ref.read(mapStateProvider.notifier).selectActivity(activityInfo.activity);
      
      // 只調用一個回調，避免重複彈窗
      if (widget.onActivityTap != null) {
        widget.onActivityTap?.call(activityInfo.activity);
      } else {
        _showActivityInfoWindow(activityInfo.activity, activityInfo.dayPlan);
      }
      
      print('🎯 找到活動: ${activityInfo.activity.name}');
    } else {
      print('❌ 未找到對應的活動');
    }
  }

  /// 顯示活動資訊窗口
  void _showActivityInfoWindow(Activity activity, DayPlan dayPlan) {
    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildActivityInfoWindow(activity, dayPlan),
    );
  }

  /// 更新地圖內容
  void _updateMapContent() {
    final mapState = ref.read(mapStateProvider);
    
    if (mapState.selectedTrip != null) {
      _showTripOnMap(mapState.selectedTrip!);
    } else if (mapState.showAllTrips) {
      _showAllTripsOnMap();
    } else {
      // 清除地圖內容
      _clearMapContent();
    }
  }

  /// 在地圖上顯示行程
  void _showTripOnMap(Trip trip) async {
    if (_pointAnnotationManager == null) {
      print('❌ 標記管理器未初始化');
      return;
    }
    
    print('🗺️ 開始在地圖上顯示行程: ${trip.title}');
    print('📊 行程包含 ${trip.days.length} 天');
    
    // 清除現有標記和路線
    await _clearMapContent();
    
    final allCoordinates = <Position>[];
    final allAnnotations = <PointAnnotationOptions>[];
    final allRoutes = <PolylineAnnotationOptions>[];
    
    // 根據日期篩選決定顯示哪些天
    final daysToShow = _getFilteredDays(trip);
    print('📅 要顯示的天數: ${daysToShow.length}');
    
    // 為每一天創建不同顏色的標記和路線
    for (int dayIndex = 0; dayIndex < daysToShow.length; dayIndex++) {
      final dayPlan = daysToShow[dayIndex];
      final originalDayIndex = trip.days.indexOf(dayPlan);
      final dayColor = _getDayColor(originalDayIndex);
      
      print('📍 處理第${originalDayIndex + 1}天，包含 ${dayPlan.activities.length} 個活動');
      
      final dayAnnotations = await _prepareDayAnnotations(dayPlan, dayColor, originalDayIndex);
      allAnnotations.addAll(dayAnnotations);
      
      // 收集所有座標用於調整視角
      for (final activity in dayPlan.activities) {
        if (CoordinateValidator.isValidCoordinate(activity.lat, activity.lng)) {
          allCoordinates.add(Position(activity.lng, activity.lat));
        }
      }
      
      // 準備路線
      if (ref.read(mapStateProvider).showRoute) {
        final dayRoutes = await _prepareDayRoutes(dayPlan, dayColor, originalDayIndex);
        allRoutes.addAll(dayRoutes);
      }
    }
    
    // 動畫顯示標記
    print('📌 準備顯示 ${allAnnotations.length} 個標記');
    if (allAnnotations.isNotEmpty) {
      await _animateMarkerAppearance(allAnnotations);
    } else {
      print('⚠️ 沒有標記需要顯示');
    }
    
    // 動畫顯示路線
    if (allRoutes.isNotEmpty) {
      await _animateRouteAppearance(allRoutes);
    }
    
    // 顯示跨天連接路線
    if (ref.read(mapStateProvider).showRoute && daysToShow.length > 1) {
      await _showInterDayRoutes(trip);
    }
    
    // 動畫調整相機視角以包含所有標記
    if (allCoordinates.isNotEmpty) {
      await _animatedFitCameraToBounds(allCoordinates);
    }
    
    print('✅ 行程顯示完成，共 ${daysToShow.length} 天');
  }

  /// 根據日期篩選獲取要顯示的天數
  List<DayPlan> _getFilteredDays(Trip trip) {
    if (widget.selectedDate == null) {
      return trip.days; // 顯示所有天數
    }
    
    // 計算選中日期對應的天數索引
    final tripStartDate = trip.startDate ?? DateTime.now();
    final daysDifference = widget.selectedDate!.difference(tripStartDate).inDays;
    
    if (daysDifference >= 0 && daysDifference < trip.days.length) {
      return [trip.days[daysDifference]]; // 只顯示選中的那一天
    }
    
    return []; // 選中日期不在行程範圍內
  }

  /// 準備單日標記（不立即創建）
  Future<List<PointAnnotationOptions>> _prepareDayAnnotations(
    DayPlan dayPlan, 
    Color dayColor, 
    int dayIndex
  ) async {
    final annotations = <PointAnnotationOptions>[];
    
    // 為每個活動創建標記
    for (int activityIndex = 0; activityIndex < dayPlan.activities.length; activityIndex++) {
      final activity = dayPlan.activities[activityIndex];
      
      if (CoordinateValidator.isValidCoordinate(activity.lat, activity.lng)) {
        final position = Position(activity.lng, activity.lat);
        
        // 判斷是否為選中的活動（高亮顯示）
        final isSelected = ref.read(mapStateProvider).selectedActivity?.id == activity.id;
        
        // 創建高亮標記 - 選中時使用特殊樣式
        final annotationOptions = PointAnnotationOptions(
          geometry: Point(coordinates: position),
          textField: isSelected ? '🎯' : '📍', // 選中時使用目標圖標
          textSize: isSelected ? 56.0 : 40.0, // 選中時更大
          textColor: isSelected 
              ? const Color(0xFFFF6B35).toARGB32() // 選中時使用橙紅色高亮
              : dayColor.toARGB32(),
          textOffset: [0.0, 0.0],
          textHaloColor: Colors.white.toARGB32(),
          textHaloWidth: isSelected ? 3.0 : 2.0, // 選中時更粗的光暈
          symbolSortKey: isSelected ? 100.0 : (10.0 + dayIndex), // 選中的標記顯示在最上層
          iconSize: 0.0,
        );
        
        // 添加活動順序數字 - 選中時樣式增強
        final numberAnnotation = PointAnnotationOptions(
          geometry: Point(coordinates: position),
          textField: '${activityIndex + 1}',
          textSize: isSelected ? 18.0 : 14.0, // 選中時更大的數字
          textColor: Colors.white.toARGB32(),
          textOffset: [0.0, isSelected ? -2.0 : -1.5], // 選中時調整偏移
          textHaloColor: isSelected 
              ? const Color(0xFFFF6B35).toARGB32() // 選中時使用高亮色
              : dayColor.toARGB32(),
          textHaloWidth: isSelected ? 2.0 : 1.5, // 選中時更粗的光暈
          symbolSortKey: isSelected ? 101.0 : (11.0 + dayIndex),
        );
        
        // 如果是選中的活動，添加脈衝動畫效果的外圈
        if (isSelected) {
          final pulseAnnotation = PointAnnotationOptions(
            geometry: Point(coordinates: position),
            textField: '⭕', // 使用圓圈作為脈衝效果
            textSize: 72.0, // 更大的外圈
            textColor: const Color(0xFFFF6B35).withValues(alpha: 0.3).toARGB32(), // 半透明橙色
            textOffset: [0.0, 0.0],
            symbolSortKey: 99.0, // 顯示在主標記下方
          );
          annotations.add(pulseAnnotation);
        }
        
        // 創建標記的唯一鍵
        final markerKey = '${position.lng}_${position.lat}';
        
        // 存儲標記與活動的對應關係
        _markerToActivityMap[markerKey] = _ActivityInfo(
          activity: activity,
          dayPlan: dayPlan,
          dayIndex: dayIndex,
          activityIndex: activityIndex,
        );
        
        annotations.add(annotationOptions);
        annotations.add(numberAnnotation);
      }
    }
    
    return annotations;
  }

  /// 準備單日路線（不立即創建）
  Future<List<PolylineAnnotationOptions>> _prepareDayRoutes(
    DayPlan dayPlan, 
    Color dayColor, 
    int dayIndex
  ) async {
    final routes = <PolylineAnnotationOptions>[];
    final routeCoordinates = <Position>[];
    
    // 收集路線座標
    for (final activity in dayPlan.activities) {
      if (CoordinateValidator.isValidCoordinate(activity.lat, activity.lng)) {
        routeCoordinates.add(Position(activity.lng, activity.lat));
      }
    }
    
    if (routeCoordinates.length > 1) {
      // 路線陰影
      routes.add(PolylineAnnotationOptions(
        geometry: LineString(coordinates: routeCoordinates),
        lineColor: Colors.black.withValues(alpha: 0.3).toARGB32(),
        lineWidth: 12.0,
        lineOpacity: 0.4,
      ));
      
      // 主路線
      routes.add(PolylineAnnotationOptions(
        geometry: LineString(coordinates: routeCoordinates),
        lineColor: dayColor.toARGB32(),
        lineWidth: 8.0,
        lineOpacity: 0.9,
      ));
      
      // 高光路線
      final highlightColor = _lightenColor(dayColor, 0.3);
      routes.add(PolylineAnnotationOptions(
        geometry: LineString(coordinates: routeCoordinates),
        lineColor: highlightColor.toARGB32(),
        lineWidth: 4.0,
        lineOpacity: 0.7,
      ));
    }
    
    return routes;
  }

  /// 動畫調整相機視角以包含所有座標點
  Future<void> _animatedFitCameraToBounds(List<Position> coordinates) async {
    if (_mapboxMap == null || coordinates.isEmpty) return;
    
    // 計算邊界
    double minLat = coordinates.first.lat.toDouble();
    double maxLat = coordinates.first.lat.toDouble();
    double minLng = coordinates.first.lng.toDouble();
    double maxLng = coordinates.first.lng.toDouble();
    
    for (final coord in coordinates) {
      minLat = minLat < coord.lat ? minLat : coord.lat.toDouble();
      maxLat = maxLat > coord.lat ? maxLat : coord.lat.toDouble();
      minLng = minLng < coord.lng ? minLng : coord.lng.toDouble();
      maxLng = maxLng > coord.lng ? maxLng : coord.lng.toDouble();
    }
    
    // 添加邊距
    const double padding = 0.01;
    minLat -= padding;
    maxLat += padding;
    minLng -= padding;
    maxLng += padding;
    
    // 計算中心點和縮放級別
    final centerLat = (minLat + maxLat) / 2;
    final centerLng = (minLng + maxLng) / 2;
    final zoom = _calculateZoomLevel(maxLat - minLat, maxLng - minLng);
    
    // 使用動畫移動相機
    await _animatedEaseTo(
      Position(centerLng, centerLat),
      zoom: zoom,
    );
  }

  /// 顯示所有行程
  void _showAllTripsOnMap() async {
    final tripsAsync = ref.read(userTripsProvider);
    
    tripsAsync.when(
      data: (trips) async {
        if (_pointAnnotationManager == null) return;
        
        await _pointAnnotationManager!.deleteAll();
        await _polylineAnnotationManager!.deleteAll();
        
        final annotations = <PointAnnotationOptions>[];
        
        for (final trip in trips) {
          for (final dayPlan in trip.days) {
            for (final activity in dayPlan.activities) {
              if (CoordinateValidator.isValidCoordinate(activity.lat, activity.lng)) {
                final annotationOptions = PointAnnotationOptions(
                  geometry: Point(coordinates: Position(activity.lng, activity.lat)),
                  textField: '📍 ${activity.name}',
                  textOffset: [0.0, -2.0],
                  textColor: Colors.black.toARGB32(),
                  textSize: 12.0,
                  textHaloColor: Colors.white.toARGB32(),
                  textHaloWidth: 2.0,
                  iconSize: 0.0, // 隱藏圖標，因為我們使用 emoji
                  symbolSortKey: 5,
                );
                
                annotations.add(annotationOptions);
              }
            }
          }
        }
        
        if (annotations.isNotEmpty) {
          await _pointAnnotationManager!.createMulti(annotations);
        }
      },
      loading: () => print('載入行程中...'),
      error: (error, stack) => print('載入行程失敗: $error'),
    );
  }

  /// 顏色變亮工具函數
  Color _lightenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
  
  /// 顯示連接不同天數的路線
  Future<void> _showInterDayRoutes(Trip trip) async {
    if (_polylineAnnotationManager == null || trip.days.length < 2) return;
    
    for (int i = 0; i < trip.days.length - 1; i++) {
      final currentDay = trip.days[i];
      final nextDay = trip.days[i + 1];
      
      if (currentDay.activities.isNotEmpty && nextDay.activities.isNotEmpty) {
        final lastActivityToday = currentDay.activities.last;
        final firstActivityTomorrow = nextDay.activities.first;
        
        if (CoordinateValidator.isValidCoordinate(lastActivityToday.lat, lastActivityToday.lng) &&
            CoordinateValidator.isValidCoordinate(firstActivityTomorrow.lat, firstActivityTomorrow.lng)) {
          
          final coordinates = [
            Position(lastActivityToday.lng, lastActivityToday.lat),
            Position(firstActivityTomorrow.lng, firstActivityTomorrow.lat),
          ];
          
          // 使用下一天的顏色作為跨天路線顏色
          final nextDayColor = _getDayColor(i + 1);
          
          // 創建美觀的跨天連接路線
          final interDayOptions = PolylineAnnotationOptions(
            geometry: LineString(coordinates: coordinates),
            lineColor: nextDayColor.withValues(alpha: 0.7).toARGB32(),
            lineWidth: 6.0,
            lineOpacity: 0.8,
          );
          
          await _polylineAnnotationManager!.create(interDayOptions);
          
          print('🔗 創建第${i + 1}天到第${i + 2}天的連接路線，使用第${i + 2}天顏色: ${nextDayColor.toString()}');
        }
      }
    }
  }
  
  /// 清除地圖內容
  Future<void> _clearMapContent() async {
    await _pointAnnotationManager?.deleteAll();
    await _polylineAnnotationManager?.deleteAll();
    _markerToActivityMap.clear(); // 清除標記對應關係
  }
  
  /// 取得每日顏色
  Color _getDayColor(int dayIndex) {
    return dayColors[dayIndex % dayColors.length];
  }

  // 日期篩選控制項已移至 MapScreen

  // 日期選擇晶片已移至 MapScreen

  /// 建立地圖控制按鈕
  Widget _buildControlButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    bool isActive = false,
    Color? activeColor,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: isActive 
            ? (activeColor ?? TripMuseTheme.primaryColor)
            : Colors.white,
        borderRadius: BorderRadius.circular(TripMuseSpacing.sm),
        elevation: 2,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(TripMuseSpacing.sm),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(TripMuseSpacing.sm),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isActive ? Colors.white : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }

  /// 建立活動資訊窗口
  Widget _buildActivityInfoWindow(Activity activity, DayPlan dayPlan) {
    return Container(
      margin: const EdgeInsets.all(TripMuseSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TripMuseSpacing.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 標題欄
          Container(
            padding: const EdgeInsets.all(TripMuseSpacing.md),
            decoration: BoxDecoration(
              color: TripMuseTheme.primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(TripMuseSpacing.lg),
                topRight: Radius.circular(TripMuseSpacing.lg),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.place,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: TripMuseSpacing.sm),
                Expanded(
                  child: Text(
                    activity.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          
          // 內容
          Padding(
            padding: const EdgeInsets.all(TripMuseSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 活動描述
                if (activity.description.isNotEmpty) ...[
                  Text(
                    activity.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: TripMuseSpacing.md),
                ],
                
                // 活動詳情
                _buildInfoRow(
                  icon: Icons.schedule,
                  label: '時間',
                  value: '${activity.timeFrom} - ${activity.timeTo}',
                ),
                
                if (activity.address?.isNotEmpty == true)
                  _buildInfoRow(
                    icon: Icons.location_on,
                    label: '地址',
                    value: activity.address!,
                  ),
                
                if (activity.estimatedCost != null && double.tryParse(activity.estimatedCost!) != null && double.parse(activity.estimatedCost!) > 0)
                  _buildInfoRow(
                    icon: Icons.attach_money,
                    label: '預估費用',
                    value: 'NT\$${double.parse(activity.estimatedCost!).toStringAsFixed(0)}',
                  ),
                
                const SizedBox(height: TripMuseSpacing.md),
                
                // 操作按鈕
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _navigateToActivity(activity);
                        },
                        icon: const Icon(Icons.navigation, size: 18),
                        label: const Text('導航'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TripMuseTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: TripMuseSpacing.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _focusOnActivity(activity);
                        },
                        icon: const Icon(Icons.center_focus_strong, size: 18),
                        label: const Text('聚焦'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 建立資訊行
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TripMuseSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: TripMuseSpacing.sm),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  /// 導航到活動
  Future<void> _navigateToActivity(Activity activity) async {
    try {
      final navigationHelper = ref.read(navigationHelperProvider);
      await navigationHelper.navigateToActivity(activity);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('導航失敗: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 聚焦到活動
  Future<void> _focusOnActivity(Activity activity) async {
    if (CoordinateValidator.isValidCoordinate(activity.lat, activity.lng)) {
      await _animatedFlyTo(
        Position(activity.lng, activity.lat),
        zoom: 17.0,
        pitch: 45.0,
        bearing: 0.0,
      );
    }
  }

  /// 計算適當的縮放級別
  double _calculateZoomLevel(double latSpan, double lngSpan) {
    final maxSpan = latSpan > lngSpan ? latSpan : lngSpan;
    
    if (maxSpan > 10) return 4.0;
    if (maxSpan > 5) return 6.0;
    if (maxSpan > 2) return 8.0;
    if (maxSpan > 1) return 10.0;
    if (maxSpan > 0.5) return 12.0;
    if (maxSpan > 0.1) return 14.0;
    if (maxSpan > 0.05) return 15.0;
    return 16.0;
  }

  /// 切換位置追蹤
  Future<void> _toggleLocationTracking() async {
    setState(() {
      _isLocationTrackingEnabled = !_isLocationTrackingEnabled;
    });
    
    if (_isLocationTrackingEnabled) {
      // 移動到用戶當前位置
      try {
        final locationService = ref.read(locationServiceProvider);
        final position = await locationService.getCurrentPosition();
        
        if (position != null) {
          await _animatedFlyTo(
            Position(position.longitude, position.latitude),
            zoom: 16.0,
            pitch: 30.0,
          );
        }
      } catch (e) {
        print('❌ 獲取位置失敗: $e');
        setState(() {
          _isLocationTrackingEnabled = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapStateProvider);
    
    // 監聽地圖狀態變化並更新地圖內容
    ref.listen<MapState>(mapStateProvider, (previous, next) {
      print('🔄 地圖狀態變化: selectedTrip=${next.selectedTrip?.title}, showRoute=${next.showRoute}');
      
      if (previous?.selectedTrip != next.selectedTrip ||
          previous?.showRoute != next.showRoute ||
          previous?.showAllTrips != next.showAllTrips) {
        print('📍 需要更新地圖內容');
        // 延遲執行以確保地圖已初始化
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_mapboxMap != null) {
            _updateMapContent();
          } else {
            print('⚠️ 地圖尚未初始化，延遲更新');
          }
        });
      }
      
      // 監聽選中活動變化，自動飛行到該活動
      if (previous?.selectedActivity != next.selectedActivity && 
          next.selectedActivity != null) {
        final activity = next.selectedActivity!;
        print('🎯 選中活動變化: ${activity.name}');
        if (CoordinateValidator.isValidCoordinate(activity.lat, activity.lng)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _animatedFlyTo(
              Position(activity.lng, activity.lat),
              zoom: 16.0,
              pitch: 45.0,
              bearing: 0.0,
            );
          });
        }
      }
    });
    
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TripMuseSpacing.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(TripMuseSpacing.md),
        child: Stack(
          children: [
            // 地圖主體
            MapWidget(
              key: const ValueKey("tripMapWidget"),
              onMapCreated: _onMapCreated,
            ),
            
            // 載入指示器
            if (mapState.isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(TripMuseTheme.primaryColor),
                  ),
                ),
              ),
            
            // 錯誤訊息
            if (mapState.error != null)
              Container(
                color: Colors.black.withValues(alpha: 0.7),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 48,
                      ),
                      const SizedBox(height: TripMuseSpacing.md),
                      Text(
                        mapState.error!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            
            // 控制面板
            if (widget.showControls) ...[
              // 右下角 - 地圖控制按鈕
              Positioned(
                bottom: 100, // 避免與底部導航欄重疊
                right: TripMuseSpacing.md,
                child: Column(
                  children: [
                    // 位置追蹤按鈕
                    _buildControlButton(
                      icon: _isLocationTrackingEnabled ? Icons.my_location : Icons.location_searching,
                      tooltip: _isLocationTrackingEnabled ? '停止位置追蹤' : '開始位置追蹤',
                      onPressed: _toggleLocationTracking,
                      isActive: _isLocationTrackingEnabled,
                    ),
                    
                    const SizedBox(height: TripMuseSpacing.sm),
                    
                    // 路線顯示切換
                    _buildControlButton(
                      icon: mapState.showRoute ? Icons.route : Icons.route_outlined,
                      tooltip: mapState.showRoute ? '隱藏路線' : '顯示路線',
                      onPressed: () {
                        ref.read(mapStateProvider.notifier).toggleRoute();
                        _updateMapContent();
                      },
                      isActive: mapState.showRoute,
                    ),
                    
                    const SizedBox(height: TripMuseSpacing.sm),
                    
                    // 重置到第一個景點按鈕
                    _buildControlButton(
                      icon: Icons.refresh,
                      tooltip: '重置到第一個景點',
                      onPressed: () {
                        if (mapState.selectedTrip != null) {
                          _focusOnFirstActivityOfTrip(mapState.selectedTrip!);
                        } else if (widget.initialTrip != null) {
                          _focusOnFirstActivityOfTrip(widget.initialTrip!);
                        }
                      },
                    ),
                    
                    const SizedBox(height: TripMuseSpacing.sm),
                    
                    // 重新聚焦按鈕
                    _buildControlButton(
                      icon: Icons.center_focus_strong,
                      tooltip: '重新聚焦',
                      onPressed: () {
                        if (mapState.selectedTrip != null) {
                          final allCoordinates = <Position>[];
                          for (final dayPlan in mapState.selectedTrip!.days) {
                            for (final activity in dayPlan.activities) {
                              if (CoordinateValidator.isValidCoordinate(activity.lat, activity.lng)) {
                                allCoordinates.add(Position(activity.lng, activity.lat));
                              }
                            }
                          }
                          if (allCoordinates.isNotEmpty) {
                            _animatedFitCameraToBounds(allCoordinates);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
            
            // 動畫進行中指示器
            if (_isAnimating)
              Positioned(
                bottom: TripMuseSpacing.md,
                left: TripMuseSpacing.md,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TripMuseSpacing.md,
                    vertical: TripMuseSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(TripMuseSpacing.lg),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(width: TripMuseSpacing.sm),
                      Text(
                        '地圖動畫中...',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}