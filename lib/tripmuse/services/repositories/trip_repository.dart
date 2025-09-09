/// 行程資料存取層
/// 
/// 實作 Repository 模式，提供行程資料的 CRUD 操作和同步功能

import '../../models/models.dart';
import '../storage/storage_service.dart';
import '../sync/sync_service.dart';

/// 行程 Repository 介面
abstract class TripRepository {
  /// 取得所有行程
  Future<List<Trip>> getAllTrips();
  
  /// 根據 ID 取得行程
  Future<Trip?> getTripById(String id);
  
  /// 儲存行程
  Future<void> saveTrip(Trip trip);
  
  /// 刪除行程
  Future<void> deleteTrip(String id);
  
  /// 搜尋行程
  Future<List<Trip>> searchTrips(String query);
  
  /// 根據狀態篩選行程
  Future<List<Trip>> getTripsByStatus(TripStatus status);
  
  /// 取得收藏的行程
  Future<List<Trip>> getFavoriteTrips();
  
  /// 同步行程到雲端
  Future<void> syncTrips();
  
  /// 檢查是否有未同步的變更
  Future<bool> hasPendingChanges();
}

/// 行程 Repository 實作
class TripRepositoryImpl implements TripRepository {
  final HiveStorageService _localStorage;
  final SyncService _syncService;
  
  TripRepositoryImpl({
    required HiveStorageService localStorage,
    required SyncService syncService,
  }) : _localStorage = localStorage,
       _syncService = syncService;
  
  @override
  Future<List<Trip>> getAllTrips() async {
    try {
      final trips = await _localStorage.getAllTrips();
      
      // 按建立時間排序（最新的在前）
      trips.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return trips;
    } catch (e) {
      throw TripRepositoryException('取得行程列表失敗: $e');
    }
  }
  
  @override
  Future<Trip?> getTripById(String id) async {
    try {
      return await _localStorage.getTrip(id);
    } catch (e) {
      throw TripRepositoryException('取得行程失敗: $e');
    }
  }
  
  @override
  Future<void> saveTrip(Trip trip) async {
    try {
      // 更新時間戳記
      final updatedTrip = trip.copyWith(
        updatedAt: DateTime.now(),
      );
      
      // 儲存到本地
      await _localStorage.saveTrip(updatedTrip);
      
      // 標記為需要同步
      await _syncService.markForSync(updatedTrip.id, SyncAction.update);
      
      // 嘗試立即同步（如果有網路連線）
      if (await _syncService.isOnline()) {
        await _syncService.syncTrip(updatedTrip.id);
      }
    } catch (e) {
      throw TripRepositoryException('儲存行程失敗: $e');
    }
  }
  
  @override
  Future<void> deleteTrip(String id) async {
    try {
      // 從本地刪除
      await _localStorage.deleteTrip(id);
      
      // 標記為需要同步刪除
      await _syncService.markForSync(id, SyncAction.delete);
      
      // 嘗試立即同步（如果有網路連線）
      if (await _syncService.isOnline()) {
        await _syncService.syncTrip(id);
      }
    } catch (e) {
      throw TripRepositoryException('刪除行程失敗: $e');
    }
  }
  
  @override
  Future<List<Trip>> searchTrips(String query) async {
    try {
      final allTrips = await getAllTrips();
      
      if (query.isEmpty) return allTrips;
      
      final lowercaseQuery = query.toLowerCase();
      
      return allTrips.where((trip) {
        return trip.title.toLowerCase().contains(lowercaseQuery) ||
               trip.destination.name.toLowerCase().contains(lowercaseQuery) ||
               trip.destination.city.toLowerCase().contains(lowercaseQuery) ||
               trip.destination.country.toLowerCase().contains(lowercaseQuery) ||
               (trip.notes?.toLowerCase().contains(lowercaseQuery) ?? false);
      }).toList();
    } catch (e) {
      throw TripRepositoryException('搜尋行程失敗: $e');
    }
  }
  
  @override
  Future<List<Trip>> getTripsByStatus(TripStatus status) async {
    try {
      final allTrips = await getAllTrips();
      return allTrips.where((trip) => trip.status == status).toList();
    } catch (e) {
      throw TripRepositoryException('根據狀態取得行程失敗: $e');
    }
  }
  
  @override
  Future<List<Trip>> getFavoriteTrips() async {
    try {
      final allTrips = await getAllTrips();
      return allTrips.where((trip) => trip.isFavorite).toList();
    } catch (e) {
      throw TripRepositoryException('取得收藏行程失敗: $e');
    }
  }
  
  @override
  Future<void> syncTrips() async {
    try {
      await _syncService.syncAllTrips();
    } catch (e) {
      throw TripRepositoryException('同步行程失敗: $e');
    }
  }
  
  @override
  Future<bool> hasPendingChanges() async {
    try {
      return await _syncService.hasPendingChanges();
    } catch (e) {
      return false;
    }
  }
  
  /// 取得行程統計資訊
  Future<TripStatistics> getTripStatistics() async {
    try {
      final allTrips = await getAllTrips();
      
      return TripStatistics(
        totalTrips: allTrips.length,
        draftTrips: allTrips.where((t) => t.status == TripStatus.draft).length,
        activeTrips: allTrips.where((t) => t.status == TripStatus.active).length,
        completedTrips: allTrips.where((t) => t.status == TripStatus.completed).length,
        favoriteTrips: allTrips.where((t) => t.isFavorite).length,
        totalActivities: allTrips.fold(0, (sum, trip) => sum + trip.totalActivities),
        totalDays: allTrips.fold(0, (sum, trip) => sum + trip.totalDays),
      );
    } catch (e) {
      throw TripRepositoryException('取得行程統計失敗: $e');
    }
  }
  
  /// 匯出行程資料
  Future<Map<String, dynamic>> exportTrips() async {
    try {
      final allTrips = await getAllTrips();
      
      return {
        'version': '1.0',
        'exportDate': DateTime.now().toIso8601String(),
        'trips': allTrips.map((trip) => trip.toJson()).toList(),
      };
    } catch (e) {
      throw TripRepositoryException('匯出行程資料失敗: $e');
    }
  }
  
  /// 匯入行程資料
  Future<void> importTrips(Map<String, dynamic> data) async {
    try {
      final tripsData = data['trips'] as List<dynamic>?;
      if (tripsData == null) {
        throw TripRepositoryException('無效的匯入資料格式');
      }
      
      for (final tripData in tripsData) {
        final trip = Trip.fromJson(tripData as Map<String, dynamic>);
        await saveTrip(trip);
      }
    } catch (e) {
      throw TripRepositoryException('匯入行程資料失敗: $e');
    }
  }
}

/// 行程統計資訊
class TripStatistics {
  final int totalTrips;
  final int draftTrips;
  final int activeTrips;
  final int completedTrips;
  final int favoriteTrips;
  final int totalActivities;
  final int totalDays;
  
  const TripStatistics({
    required this.totalTrips,
    required this.draftTrips,
    required this.activeTrips,
    required this.completedTrips,
    required this.favoriteTrips,
    required this.totalActivities,
    required this.totalDays,
  });
  
  /// 取得完成率
  double get completionRate {
    if (totalTrips == 0) return 0.0;
    return completedTrips / totalTrips;
  }
  
  /// 取得平均每趟行程的天數
  double get averageDaysPerTrip {
    if (totalTrips == 0) return 0.0;
    return totalDays / totalTrips;
  }
  
  /// 取得平均每趟行程的活動數
  double get averageActivitiesPerTrip {
    if (totalTrips == 0) return 0.0;
    return totalActivities / totalTrips;
  }
}

/// 行程 Repository 例外
class TripRepositoryException implements Exception {
  final String message;
  
  const TripRepositoryException(this.message);
  
  @override
  String toString() => 'TripRepositoryException: $message';
}