/// TripMuse 行程狀態管理
/// 
/// 提供行程資料的狀態管理和操作

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/services.dart';
import '../models/models.dart';

// 注意：tripRepositoryProvider 已在 storage_manager.dart 中定義，這裡不需要重複定義

/// 使用者所有行程 Provider
final userTripsProvider = FutureProvider<List<Trip>>((ref) async {
  try {
    final tripRepository = ref.watch(tripRepositoryProvider);
    return await tripRepository.getAllTrips();
  } catch (e) {
    // 如果儲存管理器尚未初始化，返回空列表
    if (e is StorageManagerException && e.message.contains('尚未初始化')) {
      return [];
    }
    // 重新拋出其他錯誤
    rethrow;
  }
});

/// 特定行程 Provider
final tripProvider = FutureProvider.family<Trip?, String>((ref, tripId) async {
  final tripRepository = ref.watch(tripRepositoryProvider);
  return await tripRepository.getTripById(tripId);
});

/// 行程統計 Provider
final tripStatisticsProvider = FutureProvider<TripStatistics>((ref) async {
  final tripRepository = ref.watch(tripRepositoryProvider);
  return await tripRepository.getTripStatistics();
});

/// 最近行程 Provider（最多5個）
final recentTripsProvider = FutureProvider<List<Trip>>((ref) async {
  try {
    final allTrips = await ref.watch(userTripsProvider.future);

    // 按建立時間排序，取最新的5個
    final sortedTrips = List<Trip>.from(allTrips)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return sortedTrips.take(5).toList();
  } catch (e) {
    // 如果儲存管理器尚未初始化，返回空列表
    if (e is StorageManagerException && e.message.contains('尚未初始化')) {
      return [];
    }
    // 重新拋出其他錯誤
    rethrow;
  }
});

/// 即將到來的行程 Provider
final upcomingTripsProvider = FutureProvider<List<Trip>>((ref) async {
  final allTrips = await ref.watch(userTripsProvider.future);
  final now = DateTime.now();
  
  return allTrips.where((trip) {
    if (trip.days.isEmpty) return false;
    return trip.days.first.date.isAfter(now);
  }).toList()
    ..sort((a, b) => a.days.first.date.compareTo(b.days.first.date));
});

/// 行程操作 Notifier
class TripNotifier extends StateNotifier<AsyncValue<List<Trip>>> {
  TripNotifier(this._tripRepository) : super(const AsyncValue.loading()) {
    _loadTrips();
  }
  
  final TripRepositoryImpl _tripRepository;
  
  /// 載入所有行程
  Future<void> _loadTrips() async {
    try {
      final trips = await _tripRepository.getAllTrips();
      state = AsyncValue.data(trips);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// 重新載入行程
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadTrips();
  }
  
  /// 建立新行程
  Future<void> createTrip(Trip trip) async {
    try {
      await _tripRepository.saveTrip(trip);
      await _loadTrips(); // 重新載入列表
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// 更新行程
  Future<void> updateTrip(Trip trip) async {
    try {
      await _tripRepository.saveTrip(trip);
      await _loadTrips(); // 重新載入列表
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// 刪除行程
  Future<void> deleteTrip(String tripId) async {
    try {
      await _tripRepository.deleteTrip(tripId);
      await _loadTrips(); // 重新載入列表
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// 複製行程
  Future<void> duplicateTrip(Trip originalTrip) async {
    try {
      final now = DateTime.now();
      final duplicatedTrip = originalTrip.copyWith(
        id: 'trip_${now.millisecondsSinceEpoch}',
        title: '${originalTrip.title} (副本)',
        createdAt: now,
        updatedAt: now,
      );
      
      await _tripRepository.saveTrip(duplicatedTrip);
      await _loadTrips(); // 重新載入列表
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// 行程操作 Notifier Provider
final tripNotifierProvider = StateNotifierProvider<TripNotifier, AsyncValue<List<Trip>>>((ref) {
  final tripRepository = ref.watch(tripRepositoryProvider);
  return TripNotifier(tripRepository);
});

/// 搜尋行程 Provider
final searchTripsProvider = FutureProvider.family<List<Trip>, String>((ref, query) async {
  if (query.isEmpty) return [];
  
  final allTrips = await ref.watch(userTripsProvider.future);
  final lowerQuery = query.toLowerCase();
  
  return allTrips.where((trip) {
    return trip.title.toLowerCase().contains(lowerQuery) ||
           trip.destination.city.toLowerCase().contains(lowerQuery) ||
           trip.destination.country.toLowerCase().contains(lowerQuery) ||
           trip.days.any((day) => 
               day.activities.any((activity) => 
                   activity.name.toLowerCase().contains(lowerQuery)));
  }).toList();
});

/// 按目的地分組的行程 Provider
final tripsByDestinationProvider = FutureProvider<Map<String, List<Trip>>>((ref) async {
  final allTrips = await ref.watch(userTripsProvider.future);
  final Map<String, List<Trip>> groupedTrips = {};
  
  for (final trip in allTrips) {
    final destination = '${trip.destination.city}, ${trip.destination.country}';
    groupedTrips.putIfAbsent(destination, () => []).add(trip);
  }
  
  return groupedTrips;
});

/// 行程收藏狀態管理
class FavoriteTripNotifier extends StateNotifier<Set<String>> {
  FavoriteTripNotifier() : super(<String>{}) {
    _loadFavorites();
  }
  
  /// 載入收藏的行程 ID
  Future<void> _loadFavorites() async {
    try {
      final storageManager = StorageManager.instance;
      if (storageManager.isInitialized) {
        final favoriteIds = await storageManager.hiveStorage.retrieve<List<String>>('favorite_trips') ?? <String>[];
        state = Set<String>.from(favoriteIds);
      } else {
        state = <String>{};
      }
    } catch (e) {
      print('載入收藏列表失敗: $e');
      state = <String>{};
    }
  }
  
  /// 切換收藏狀態
  Future<void> toggleFavorite(String tripId) async {
    final newState = Set<String>.from(state);
    if (newState.contains(tripId)) {
      newState.remove(tripId);
    } else {
      newState.add(tripId);
    }
    state = newState;
    
    // 儲存到本地儲存
    try {
      final storageManager = StorageManager.instance;
      if (storageManager.isInitialized) {
        await storageManager.hiveStorage.store('favorite_trips', newState.toList());
      }
    } catch (e) {
      print('儲存收藏列表失敗: $e');
    }
  }
  
  /// 檢查是否為收藏
  bool isFavorite(String tripId) {
    return state.contains(tripId);
  }
}

/// 收藏行程 Provider
final favoriteTripProvider = StateNotifierProvider<FavoriteTripNotifier, Set<String>>((ref) {
  return FavoriteTripNotifier();
});

/// 收藏的行程列表 Provider
final favoriteTripsProvider = FutureProvider<List<Trip>>((ref) async {
  final allTrips = await ref.watch(userTripsProvider.future);
  final favoriteIds = ref.watch(favoriteTripProvider);
  
  return allTrips.where((trip) => favoriteIds.contains(trip.id)).toList();
});