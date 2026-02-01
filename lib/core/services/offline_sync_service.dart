import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../exceptions/app_exceptions.dart';
import '../models/trip.dart';
import '../models/user.dart';
import '../repositories/trip_repository.dart';
import '../repositories/user_repository.dart';
import 'api_client.dart';
import 'cache_manager.dart';
import 'connectivity_service.dart';
import 'logger_service.dart';

/// Service for managing offline data synchronization
class OfflineSyncService {
  final ApiClient _apiClient;
  final CacheManager _cacheManager;
  final ConnectivityService _connectivityService;
  final LoggerService _logger;
  final TripRepository _tripRepository;
  final UserRepository _userRepository;
  
  // Sync queue keys
  static const String _syncQueueKey = 'sync_queue';
  static const String _lastSyncKey = 'last_sync_timestamp';
  
  // Sync status
  bool _isSyncing = false;
  StreamController<SyncStatus>? _syncStatusController;
  
  OfflineSyncService(
    this._apiClient,
    this._cacheManager,
    this._connectivityService,
    this._logger,
    this._tripRepository,
    this._userRepository,
  );
  
  /// Stream of sync status updates
  Stream<SyncStatus> get syncStatusStream {
    _syncStatusController ??= StreamController<SyncStatus>.broadcast();
    return _syncStatusController!.stream;
  }
  
  /// Initialize offline sync service
  Future<void> initialize() async {
    try {
      // Listen to connectivity changes
      _connectivityService.connectivityStream.listen((connectivityResult) {
        final isConnected = connectivityResult != ConnectivityResult.none;
        if (isConnected && !_isSyncing) {
          _performAutoSync();
        }
      });
      
      _logger.info('Offline sync service initialized');
    } catch (e) {
      _logger.error('Failed to initialize offline sync service', e);
      throw SyncException('離線同步服務初始化失敗');
    }
  }
  
  /// Add operation to sync queue
  Future<void> queueOperation(SyncOperation operation) async {
    try {
      final queue = await _getSyncQueue();
      queue.add(operation);
      await _saveSyncQueue(queue);
      
      _logger.debug('Added operation to sync queue: ${operation.type}');
      
      // Try to sync immediately if connected
      if (await _connectivityService.isOnline) {
        unawaited(_performSync());
      }
    } catch (e) {
      _logger.error('Failed to queue sync operation', e);
      throw SyncException('同步操作加入佇列失敗');
    }
  }
  
  /// Perform manual sync
  Future<SyncResult> performSync() async {
    if (_isSyncing) {
      _logger.warning('Sync already in progress');
      return SyncResult.inProgress();
    }
    
    return await _performSync();
  }
  
  /// Get last sync timestamp
  Future<DateTime?> getLastSyncTime() async {
    try {
      final timestamp = await _cacheManager.get<int>(_lastSyncKey);
      return timestamp != null 
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
    } catch (e) {
      _logger.error('Failed to get last sync time', e);
      return null;
    }
  }
  
  /// Check if data needs sync
  Future<bool> needsSync() async {
    try {
      final queue = await _getSyncQueue();
      return queue.isNotEmpty;
    } catch (e) {
      _logger.error('Failed to check sync needs', e);
      return false;
    }
  }
  
  /// Get pending sync operations count
  Future<int> getPendingSyncCount() async {
    try {
      final queue = await _getSyncQueue();
      return queue.length;
    } catch (e) {
      _logger.error('Failed to get pending sync count', e);
      return 0;
    }
  }
  
  /// Clear sync queue (use with caution)
  Future<void> clearSyncQueue() async {
    try {
      await _cacheManager.remove(_syncQueueKey);
      _logger.info('Sync queue cleared');
    } catch (e) {
      _logger.error('Failed to clear sync queue', e);
      throw SyncException('清除同步佇列失敗');
    }
  }
  
  Future<SyncResult> _performSync() async {
    if (!await _connectivityService.isOnline) {
      _logger.warning('Cannot sync: no internet connection');
      return SyncResult.noConnection();
    }
    
    _isSyncing = true;
    _emitSyncStatus(SyncStatus.syncing());
    
    try {
      final queue = await _getSyncQueue();
      final results = <SyncOperationResult>[];
      
      _logger.info('Starting sync with ${queue.length} operations');
      
      for (final operation in queue) {
        try {
          final result = await _executeOperation(operation);
          results.add(result);
          
          if (result.success) {
            // Remove successful operation from queue
            queue.remove(operation);
          }
        } catch (e) {
          _logger.error('Failed to execute sync operation: ${operation.type}', e);
          results.add(SyncOperationResult(
            operation: operation,
            success: false,
            error: e.toString(),
          ));
        }
      }
      
      // Save updated queue
      await _saveSyncQueue(queue);
      
      // Update last sync time
      await _cacheManager.set(_lastSyncKey, DateTime.now().millisecondsSinceEpoch);
      
      final successCount = results.where((r) => r.success).length;
      final failureCount = results.length - successCount;
      
      _logger.info('Sync completed: $successCount success, $failureCount failures');
      
      final syncResult = SyncResult.completed(
        successCount: successCount,
        failureCount: failureCount,
        results: results,
      );
      
      _emitSyncStatus(SyncStatus.completed(syncResult));
      return syncResult;
      
    } catch (e) {
      _logger.error('Sync failed with error', e);
      final syncResult = SyncResult.failed(e.toString());
      _emitSyncStatus(SyncStatus.failed(e.toString()));
      return syncResult;
    } finally {
      _isSyncing = false;
    }
  }
  
  Future<void> _performAutoSync() async {
    try {
      await _performSync();
    } catch (e) {
      _logger.error('Auto sync failed', e);
    }
  }
  
  Future<SyncOperationResult> _executeOperation(SyncOperation operation) async {
    switch (operation.type) {
      case SyncOperationType.createTrip:
        return await _syncCreateTrip(operation);
      case SyncOperationType.updateTrip:
        return await _syncUpdateTrip(operation);
      case SyncOperationType.deleteTrip:
        return await _syncDeleteTrip(operation);
      case SyncOperationType.updateUser:
        return await _syncUpdateUser(operation);
    }
  }
  
  Future<SyncOperationResult> _syncCreateTrip(SyncOperation operation) async {
    try {
      final trip = Trip.fromJson(operation.data);
      final response = await _apiClient.post('/api/v1/trips', data: trip.toJson());
      
      // Update local trip with server ID
      final serverTrip = Trip.fromJson(response.data);
      await _tripRepository.save(serverTrip);
      
      return SyncOperationResult(operation: operation, success: true);
    } catch (e) {
      return SyncOperationResult(
        operation: operation,
        success: false,
        error: e.toString(),
      );
    }
  }
  
  Future<SyncOperationResult> _syncUpdateTrip(SyncOperation operation) async {
    try {
      final trip = Trip.fromJson(operation.data);
      await _apiClient.put('/api/v1/trips/${trip.id}', data: trip.toJson());
      
      return SyncOperationResult(operation: operation, success: true);
    } catch (e) {
      return SyncOperationResult(
        operation: operation,
        success: false,
        error: e.toString(),
      );
    }
  }
  
  Future<SyncOperationResult> _syncDeleteTrip(SyncOperation operation) async {
    try {
      final tripId = operation.data['id'] as String;
      await _apiClient.delete('/api/v1/trips/$tripId');
      
      return SyncOperationResult(operation: operation, success: true);
    } catch (e) {
      return SyncOperationResult(
        operation: operation,
        success: false,
        error: e.toString(),
      );
    }
  }
  
  Future<SyncOperationResult> _syncUpdateUser(SyncOperation operation) async {
    try {
      final user = User.fromJson(operation.data);
      await _apiClient.put('/api/v1/users/${user.id}', data: user.toJson());
      
      // Update local user repository
      await _userRepository.save(user);
      
      return SyncOperationResult(operation: operation, success: true);
    } catch (e) {
      return SyncOperationResult(
        operation: operation,
        success: false,
        error: e.toString(),
      );
    }
  }
  
  Future<List<SyncOperation>> _getSyncQueue() async {
    try {
      final queueData = await _cacheManager.get<List<dynamic>>(_syncQueueKey);
      if (queueData == null) return [];
      
      return queueData
          .map((data) => SyncOperation.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logger.error('Failed to get sync queue', e);
      return [];
    }
  }
  
  Future<void> _saveSyncQueue(List<SyncOperation> queue) async {
    try {
      final queueData = queue.map((op) => op.toJson()).toList();
      await _cacheManager.set(_syncQueueKey, queueData);
    } catch (e) {
      _logger.error('Failed to save sync queue', e);
      throw SyncException('同步佇列儲存失敗');
    }
  }
  
  void _emitSyncStatus(SyncStatus status) {
    _syncStatusController?.add(status);
  }
  
  void dispose() {
    _syncStatusController?.close();
    _syncStatusController = null;
  }
}

/// Sync operation model
class SyncOperation {
  final String id;
  final SyncOperationType type;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final int retryCount;
  
  const SyncOperation({
    required this.id,
    required this.type,
    required this.data,
    required this.createdAt,
    this.retryCount = 0,
  });
  
  factory SyncOperation.fromJson(Map<String, dynamic> json) {
    return SyncOperation(
      id: json['id'] as String,
      type: SyncOperationType.values.byName(json['type'] as String),
      data: json['data'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      retryCount: json['retryCount'] as int? ?? 0,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
    };
  }
  
  SyncOperation copyWith({
    String? id,
    SyncOperationType? type,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    int? retryCount,
  }) {
    return SyncOperation(
      id: id ?? this.id,
      type: type ?? this.type,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}

enum SyncOperationType {
  createTrip,
  updateTrip,
  deleteTrip,
  updateUser,
}

/// Sync status model
class SyncStatus {
  final SyncState state;
  final String? message;
  final SyncResult? result;
  
  const SyncStatus({
    required this.state,
    this.message,
    this.result,
  });
  
  factory SyncStatus.idle() => const SyncStatus(state: SyncState.idle);
  factory SyncStatus.syncing() => const SyncStatus(state: SyncState.syncing);
  factory SyncStatus.completed(SyncResult result) => SyncStatus(
    state: SyncState.completed,
    result: result,
  );
  factory SyncStatus.failed(String message) => SyncStatus(
    state: SyncState.failed,
    message: message,
  );
}

enum SyncState { idle, syncing, completed, failed }

/// Sync result model
class SyncResult {
  final bool success;
  final int successCount;
  final int failureCount;
  final String? error;
  final List<SyncOperationResult> results;
  
  const SyncResult({
    required this.success,
    this.successCount = 0,
    this.failureCount = 0,
    this.error,
    this.results = const [],
  });
  
  factory SyncResult.completed({
    required int successCount,
    required int failureCount,
    required List<SyncOperationResult> results,
  }) {
    return SyncResult(
      success: failureCount == 0,
      successCount: successCount,
      failureCount: failureCount,
      results: results,
    );
  }
  
  factory SyncResult.failed(String error) => SyncResult(
    success: false,
    error: error,
  );
  
  factory SyncResult.inProgress() => const SyncResult(success: false);
  factory SyncResult.noConnection() => const SyncResult(
    success: false,
    error: 'No internet connection',
  );
}

/// Sync operation result model
class SyncOperationResult {
  final SyncOperation operation;
  final bool success;
  final String? error;
  
  const SyncOperationResult({
    required this.operation,
    required this.success,
    this.error,
  });
}