import '../../exceptions/app_exceptions.dart';
import '../../models/trip.dart';
import '../../services/local_storage_service.dart';
import '../../services/logger_service.dart';
import '../../services/offline_sync_service.dart';
import '../trip_repository.dart';

/// Hive implementation of TripRepository
class HiveTripRepository implements TripRepository {
  final LocalStorageService _localStorage;
  final LoggerService _logger;
  OfflineSyncService? _syncService;
  
  // Keys for metadata
  static const String _unsyncedTripsKey = 'unsynced_trips';
  static const String _offlineEditedTripsKey = 'offline_edited_trips';
  
  HiveTripRepository(this._localStorage, this._logger);
  
  /// Set the sync service (called after initialization to avoid circular dependency)
  void setSyncService(OfflineSyncService syncService) {
    _syncService = syncService;
  }
  
  @override
  Future<List<Trip>> getAll() async {
    try {
      final trips = _localStorage.tripsBox.values
          .cast<Trip>()
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      
      _logger.debug('Retrieved ${trips.length} trips from local storage');
      return trips;
    } catch (e) {
      _logger.error('Failed to get all trips', e);
      throw StorageException('取得行程列表失敗');
    }
  }
  
  @override
  Future<Trip?> getById(String id) async {
    try {
      final trip = _localStorage.tripsBox.get(id) as Trip?;
      if (trip != null) {
        _logger.debug('Retrieved trip: $id');
      }
      return trip;
    } catch (e) {
      _logger.error('Failed to get trip by id: $id', e);
      return null;
    }
  }
  
  @override
  Future<void> save(Trip trip) async {
    try {
      await _localStorage.tripsBox.put(trip.id, trip);
      _logger.debug('Saved trip: ${trip.id}');
      
      // Queue for sync if user is not guest
      if (trip.userId != null && !trip.userId!.startsWith('guest_')) {
        await _queueForSync(trip);
      }
    } catch (e) {
      _logger.error('Failed to save trip: ${trip.id}', e);
      throw StorageException('儲存行程失敗');
    }
  }
  
  @override
  Future<void> delete(String id) async {
    try {
      final trip = await getById(id);
      if (trip == null) return;
      
      await _localStorage.tripsBox.delete(id);
      _logger.debug('Deleted trip: $id');
      
      // Queue deletion for sync if user is not guest
      if (trip.userId != null && !trip.userId!.startsWith('guest_')) {
        await _queueDeletionForSync(id);
      }
    } catch (e) {
      _logger.error('Failed to delete trip: $id', e);
      throw StorageException('刪除行程失敗');
    }
  }
  
  @override
  Future<bool> exists(String id) async {
    try {
      return _localStorage.tripsBox.containsKey(id);
    } catch (e) {
      _logger.error('Failed to check trip existence: $id', e);
      return false;
    }
  }
  
  @override
  Future<void> clear() async {
    try {
      await _localStorage.tripsBox.clear();
      _logger.info('Cleared all trips from local storage');
    } catch (e) {
      _logger.error('Failed to clear trips', e);
      throw StorageException('清除行程失敗');
    }
  }
  
  @override
  Future<List<Trip>> getTripsByUserId(String userId) async {
    try {
      final trips = _localStorage.tripsBox.values
          .cast<Trip>()
          .where((trip) => trip.userId == userId)
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      
      _logger.debug('Retrieved ${trips.length} trips for user: $userId');
      return trips;
    } catch (e) {
      _logger.error('Failed to get trips by user id: $userId', e);
      throw StorageException('取得使用者行程失敗');
    }
  }
  
  @override
  Future<List<Trip>> getRecentTrips({int limit = 10}) async {
    try {
      final trips = _localStorage.tripsBox.values
          .cast<Trip>()
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      
      final recentTrips = trips.take(limit).toList();
      _logger.debug('Retrieved ${recentTrips.length} recent trips');
      return recentTrips;
    } catch (e) {
      _logger.error('Failed to get recent trips', e);
      throw StorageException('取得最近行程失敗');
    }
  }
  
  @override
  Future<List<Trip>> searchTrips(String query) async {
    try {
      final lowercaseQuery = query.toLowerCase();
      final trips = _localStorage.tripsBox.values
          .cast<Trip>()
          .where((trip) =>
              trip.title.toLowerCase().contains(lowercaseQuery) ||
              trip.destination.name.toLowerCase().contains(lowercaseQuery) ||
              trip.destination.city.toLowerCase().contains(lowercaseQuery) ||
              trip.destination.country.toLowerCase().contains(lowercaseQuery))
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      
      _logger.debug('Found ${trips.length} trips matching query: $query');
      return trips;
    } catch (e) {
      _logger.error('Failed to search trips with query: $query', e);
      throw StorageException('搜尋行程失敗');
    }
  }
  
  @override
  Future<void> syncTrips() async {
    try {
      if (_syncService == null) {
        _logger.warning('Sync service not available');
        return;
      }
      await _syncService!.performSync();
      _logger.info('Trip sync completed');
    } catch (e) {
      _logger.error('Failed to sync trips', e);
      throw SyncException('行程同步失敗');
    }
  }
  
  @override
  Future<List<Trip>> getUnsyncedTrips() async {
    try {
      final unsyncedIds = (_localStorage.tripsBox.get(_unsyncedTripsKey, defaultValue: <String>[]) as List).cast<String>();
      final unsyncedTrips = <Trip>[];
      
      for (final id in unsyncedIds) {
        final trip = await getById(id);
        if (trip != null) {
          unsyncedTrips.add(trip);
        }
      }
      
      _logger.debug('Retrieved ${unsyncedTrips.length} unsynced trips');
      return unsyncedTrips;
    } catch (e) {
      _logger.error('Failed to get unsynced trips', e);
      return [];
    }
  }
  
  @override
  Future<void> markAsSynced(String tripId) async {
    try {
      final unsyncedIds = (_localStorage.tripsBox.get(_unsyncedTripsKey, defaultValue: <String>[]) as List).cast<String>();
      unsyncedIds.remove(tripId);
      await _localStorage.tripsBox.put(_unsyncedTripsKey, unsyncedIds);
      
      final offlineEditedIds = (_localStorage.tripsBox.get(_offlineEditedTripsKey, defaultValue: <String>[]) as List).cast<String>();
      offlineEditedIds.remove(tripId);
      await _localStorage.tripsBox.put(_offlineEditedTripsKey, offlineEditedIds);
      
      _logger.debug('Marked trip as synced: $tripId');
    } catch (e) {
      _logger.error('Failed to mark trip as synced: $tripId', e);
    }
  }
  
  @override
  Future<List<Trip>> getOfflineEditedTrips() async {
    try {
      final offlineEditedIds = (_localStorage.tripsBox.get(_offlineEditedTripsKey, defaultValue: <String>[]) as List).cast<String>();
      final offlineEditedTrips = <Trip>[];
      
      for (final id in offlineEditedIds) {
        final trip = await getById(id);
        if (trip != null) {
          offlineEditedTrips.add(trip);
        }
      }
      
      _logger.debug('Retrieved ${offlineEditedTrips.length} offline edited trips');
      return offlineEditedTrips;
    } catch (e) {
      _logger.error('Failed to get offline edited trips', e);
      return [];
    }
  }
  
  Future<void> _queueForSync(Trip trip) async {
    try {
      // Add to unsynced list
      final unsyncedIds = (_localStorage.tripsBox.get(_unsyncedTripsKey, defaultValue: <String>[]) as List).cast<String>();
      if (!unsyncedIds.contains(trip.id)) {
        unsyncedIds.add(trip.id);
        await _localStorage.tripsBox.put(_unsyncedTripsKey, unsyncedIds);
      }
      
      // Queue sync operation
      final operation = SyncOperation(
        id: 'trip_${trip.id}_${DateTime.now().millisecondsSinceEpoch}',
        type: SyncOperationType.updateTrip,
        data: trip.toJson(),
        createdAt: DateTime.now(),
      );
      
      if (_syncService != null) {
        await _syncService!.queueOperation(operation);
        _logger.debug('Queued trip for sync: ${trip.id}');
      }
    } catch (e) {
      _logger.error('Failed to queue trip for sync: ${trip.id}', e);
    }
  }
  
  Future<void> _queueDeletionForSync(String tripId) async {
    try {
      final operation = SyncOperation(
        id: 'delete_trip_${tripId}_${DateTime.now().millisecondsSinceEpoch}',
        type: SyncOperationType.deleteTrip,
        data: {'id': tripId},
        createdAt: DateTime.now(),
      );
      
      if (_syncService != null) {
        await _syncService!.queueOperation(operation);
        _logger.debug('Queued trip deletion for sync: $tripId');
      }
    } catch (e) {
      _logger.error('Failed to queue trip deletion for sync: $tripId', e);
    }
  }
}