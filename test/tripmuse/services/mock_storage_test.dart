import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_example/tripmuse/models/models.dart';
import 'package:mapbox_maps_example/tripmuse/services/services.dart';

/// 模擬儲存服務用於測試
class MockHiveStorageService implements StorageService {
  final Map<String, dynamic> _storage = {};
  final Map<String, Trip> _trips = {};
  final Map<String, dynamic> _cache = {};
  
  @override
  Future<void> initialize() async {
    // 模擬初始化
  }
  
  @override
  Future<void> dispose() async {
    _storage.clear();
    _trips.clear();
    _cache.clear();
  }
  
  @override
  Future<void> store<T>(String key, T value) async {
    _storage[key] = value;
  }
  
  @override
  Future<T?> retrieve<T>(String key) async {
    return _storage[key] as T?;
  }
  
  @override
  Future<void> delete(String key) async {
    _storage.remove(key);
    _trips.remove(key);
  }
  
  @override
  Future<void> clear() async {
    _storage.clear();
    _trips.clear();
    _cache.clear();
  }
  
  @override
  Future<bool> exists(String key) async {
    return _storage.containsKey(key) || _trips.containsKey(key);
  }
  
  @override
  Future<List<String>> getAllKeys() async {
    return [..._storage.keys, ..._trips.keys];
  }
  
  @override
  Future<List<Trip>> getAllTrips() async {
    return _trips.values.toList();
  }
  
  @override
  Future<void> saveTrip(Trip trip) async {
    _trips[trip.id] = trip;
  }
  
  @override
  Future<Trip?> getTrip(String tripId) async {
    return _trips[tripId];
  }
  
  @override
  Future<void> deleteTrip(String tripId) async {
    _trips.remove(tripId);
  }
  
  Future<void> storeCache(String key, dynamic value, {Duration? ttl}) async {
    _cache[key] = {
      'value': value,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'ttl': ttl?.inMilliseconds,
    };
  }
  
  Future<T?> getCache<T>(String key) async {
    final cacheData = _cache[key];
    if (cacheData == null) return null;
    
    final timestamp = cacheData['timestamp'] as int?;
    final ttl = cacheData['ttl'] as int?;
    
    if (timestamp != null && ttl != null) {
      final expireTime = timestamp + ttl;
      if (DateTime.now().millisecondsSinceEpoch > expireTime) {
        _cache.remove(key);
        return null;
      }
    }
    
    return cacheData['value'] as T?;
  }
  
  Future<void> cleanExpiredCache() async {
    final keys = _cache.keys.toList();
    final now = DateTime.now().millisecondsSinceEpoch;
    
    for (final key in keys) {
      final cacheData = _cache[key];
      if (cacheData != null) {
        final timestamp = cacheData['timestamp'] as int?;
        final ttl = cacheData['ttl'] as int?;
        
        if (timestamp != null && ttl != null) {
          final expireTime = timestamp + ttl;
          if (now > expireTime) {
            _cache.remove(key);
          }
        }
      }
    }
  }
}

/// 模擬安全儲存服務
class MockSecureStorageService implements SecureStorageService {
  final Map<String, String> _secureStorage = {};
  
  @override
  Future<void> storeSecure(String key, String value) async {
    _secureStorage[key] = value;
  }
  
  @override
  Future<String?> retrieveSecure(String key) async {
    return _secureStorage[key];
  }
  
  @override
  Future<void> deleteSecure(String key) async {
    _secureStorage.remove(key);
  }
  
  @override
  Future<void> clearSecure() async {
    _secureStorage.clear();
  }
  
  @override
  Future<bool> existsSecure(String key) async {
    return _secureStorage.containsKey(key);
  }
}

/// 模擬同步服務
class MockSyncService implements SyncService {
  final List<SyncItem> _syncQueue = [];
  bool _isOnline = true;
  
  @override
  Future<bool> isOnline() async => _isOnline;
  
  void setOnlineStatus(bool isOnline) {
    _isOnline = isOnline;
  }
  
  @override
  Future<void> markForSync(String itemId, SyncAction action) async {
    final syncItem = SyncItem(
      id: '${itemId}_${DateTime.now().millisecondsSinceEpoch}',
      itemId: itemId,
      action: action,
      status: SyncStatus.pending,
      createdAt: DateTime.now(),
    );
    
    _syncQueue.removeWhere((item) => item.itemId == itemId);
    _syncQueue.add(syncItem);
  }
  
  @override
  Future<void> syncTrip(String tripId) async {
    if (!_isOnline) {
      throw SyncException('無網路連線');
    }
    
    final index = _syncQueue.indexWhere((item) => item.itemId == tripId);
    if (index >= 0) {
      _syncQueue.removeAt(index);
    }
  }
  
  @override
  Future<void> syncAllTrips() async {
    if (!_isOnline) {
      throw SyncException('無網路連線');
    }
    
    _syncQueue.clear();
  }
  
  @override
  Future<bool> hasPendingChanges() async {
    return _syncQueue.isNotEmpty;
  }
  
  @override
  Future<List<SyncItem>> getSyncQueue() async {
    return List.from(_syncQueue);
  }
  
  @override
  Future<void> clearSyncQueue() async {
    _syncQueue.clear();
  }
  
  @override
  void startAutoSync() {
    // 模擬實作
  }
  
  @override
  void stopAutoSync() {
    // 模擬實作
  }
}

void main() {
  group('TripMuse 儲存系統測試 (Mock)', () {
    late MockHiveStorageService mockStorage;
    late MockSecureStorageService mockSecureStorage;
    late MockSyncService mockSyncService;
    late TripRepositoryImpl tripRepository;
    late UserRepositoryImpl userRepository;
    
    setUp(() {
      mockStorage = MockHiveStorageService();
      mockSecureStorage = MockSecureStorageService();
      mockSyncService = MockSyncService();
      
      tripRepository = TripRepositoryImpl(
        localStorage: mockStorage as HiveStorageService,
        syncService: mockSyncService,
      );
      
      userRepository = UserRepositoryImpl(
        localStorage: mockStorage as HiveStorageService,
        secureStorage: mockSecureStorage as FlutterSecureStorageService,
      );
    });
    
    tearDown(() async {
      await mockStorage.dispose();
    });
    
    group('MockHiveStorageService 測試', () {
      test('應該能夠儲存和讀取行程', () async {
        final trip = ExampleData.taipeiTripExample;
        
        // 儲存行程
        await mockStorage.saveTrip(trip);
        
        // 讀取行程
        final retrievedTrip = await mockStorage.getTrip(trip.id);
        
        expect(retrievedTrip, isNotNull);
        expect(retrievedTrip!.id, equals(trip.id));
        expect(retrievedTrip.title, equals(trip.title));
      });
      
      test('應該能夠取得所有行程', () async {
        final trip1 = ExampleData.taipeiTripExample;
        final trip2 = trip1.copyWith(
          id: 'trip-2',
          title: '台北美食2日遊',
        );
        
        await mockStorage.saveTrip(trip1);
        await mockStorage.saveTrip(trip2);
        
        final allTrips = await mockStorage.getAllTrips();
        
        expect(allTrips.length, equals(2));
        expect(allTrips.any((t) => t.id == trip1.id), isTrue);
        expect(allTrips.any((t) => t.id == trip2.id), isTrue);
      });
      
      test('應該能夠刪除行程', () async {
        final trip = ExampleData.taipeiTripExample;
        
        await mockStorage.saveTrip(trip);
        expect(await mockStorage.getTrip(trip.id), isNotNull);
        
        await mockStorage.deleteTrip(trip.id);
        expect(await mockStorage.getTrip(trip.id), isNull);
      });
      
      test('應該能夠處理快取資料', () async {
        const cacheKey = 'test_cache';
        const cacheValue = {'data': 'test_value'};
        
        await mockStorage.storeCache(cacheKey, cacheValue, ttl: Duration(minutes: 5));
        
        final retrievedValue = await mockStorage.getCache<Map<String, dynamic>>(cacheKey);
        
        expect(retrievedValue, isNotNull);
        expect(retrievedValue!['data'], equals('test_value'));
      });
      
      test('過期的快取應該被清除', () async {
        const cacheKey = 'expired_cache';
        const cacheValue = 'expired_value';
        
        await mockStorage.storeCache(cacheKey, cacheValue, ttl: Duration(milliseconds: 1));
        
        await Future.delayed(Duration(milliseconds: 10));
        
        final retrievedValue = await mockStorage.getCache<String>(cacheKey);
        expect(retrievedValue, isNull);
      });
    });
    
    group('TripRepository 測試', () {
      test('應該能夠儲存和取得行程', () async {
        final trip = ExampleData.taipeiTripExample;
        
        await tripRepository.saveTrip(trip);
        
        final retrievedTrip = await tripRepository.getTripById(trip.id);
        
        expect(retrievedTrip, isNotNull);
        expect(retrievedTrip!.id, equals(trip.id));
      });
      
      test('應該能夠搜尋行程', () async {
        final trip1 = ExampleData.taipeiTripExample;
        final trip2 = trip1.copyWith(
          id: 'trip-2',
          title: '東京美食之旅',
          destination: ExampleData.tokyoDestination,
        );
        
        await tripRepository.saveTrip(trip1);
        await tripRepository.saveTrip(trip2);
        
        final taipeiTrips = await tripRepository.searchTrips('台北');
        expect(taipeiTrips.length, equals(1));
        expect(taipeiTrips.first.id, equals(trip1.id));
        
        final foodTrips = await tripRepository.searchTrips('美食');
        expect(foodTrips.length, equals(2));
      });
      
      test('應該能夠根據狀態篩選行程', () async {
        final draftTrip = ExampleData.taipeiTripExample.copyWith(
          id: 'draft-trip',
          status: TripStatus.draft,
        );
        final activeTrip = ExampleData.taipeiTripExample.copyWith(
          id: 'active-trip',
          status: TripStatus.active,
        );
        
        await tripRepository.saveTrip(draftTrip);
        await tripRepository.saveTrip(activeTrip);
        
        final draftTrips = await tripRepository.getTripsByStatus(TripStatus.draft);
        expect(draftTrips.length, equals(1));
        expect(draftTrips.first.id, equals(draftTrip.id));
        
        final activeTrips = await tripRepository.getTripsByStatus(TripStatus.active);
        expect(activeTrips.length, equals(1));
        expect(activeTrips.first.id, equals(activeTrip.id));
      });
      
      test('應該能夠取得收藏行程', () async {
        final favoriteTrip = ExampleData.taipeiTripExample.copyWith(
          id: 'favorite-trip',
          isFavorite: true,
        );
        final normalTrip = ExampleData.taipeiTripExample.copyWith(
          id: 'normal-trip',
          isFavorite: false,
        );
        
        await tripRepository.saveTrip(favoriteTrip);
        await tripRepository.saveTrip(normalTrip);
        
        final favoriteTrips = await tripRepository.getFavoriteTrips();
        expect(favoriteTrips.length, equals(1));
        expect(favoriteTrips.first.id, equals(favoriteTrip.id));
      });
      
      test('應該能夠取得行程統計', () async {
        final trip1 = ExampleData.taipeiTripExample.copyWith(
          id: 'trip-1',
          status: TripStatus.draft,
          isFavorite: true,
        );
        final trip2 = ExampleData.taipeiTripExample.copyWith(
          id: 'trip-2',
          status: TripStatus.active,
          isFavorite: false,
        );
        
        await tripRepository.saveTrip(trip1);
        await tripRepository.saveTrip(trip2);
        
        final stats = await tripRepository.getTripStatistics();
        
        expect(stats.totalTrips, equals(2));
        expect(stats.draftTrips, equals(1));
        expect(stats.activeTrips, equals(1));
        expect(stats.favoriteTrips, equals(1));
        expect(stats.totalActivities, greaterThan(0));
      });
    });
    
    group('UserRepository 測試', () {
      test('應該能夠建立訪客使用者', () async {
        final guestUser = await userRepository.continueAsGuest();
        
        expect(guestUser.isGuest, isTrue);
        expect(guestUser.email, equals('guest@tripmuse.local'));
        expect(guestUser.name, equals('訪客使用者'));
        
        final isSignedIn = await userRepository.isSignedIn();
        expect(isSignedIn, isTrue);
        
        final isGuestMode = await userRepository.isGuestMode();
        expect(isGuestMode, isTrue);
      });
      
      test('應該能夠儲存和取得使用者偏好', () async {
        final customPrefs = UserPreferences.defaultPreferences().copyWith(
          language: 'en-US',
          theme: 'dark',
          enableNotifications: false,
        );
        
        await userRepository.saveUserPreferences(customPrefs);
        
        final retrievedPrefs = await userRepository.getUserPreferences();
        
        expect(retrievedPrefs.language, equals('en-US'));
        expect(retrievedPrefs.theme, equals('dark'));
        expect(retrievedPrefs.enableNotifications, isFalse);
      });
      
      test('應該能夠登出並清除資料', () async {
        await userRepository.continueAsGuest();
        expect(await userRepository.isSignedIn(), isTrue);
        
        await userRepository.signOut();
        expect(await userRepository.isSignedIn(), isFalse);
        expect(await userRepository.getCurrentUser(), isNull);
      });
    });
    
    group('SyncService 測試', () {
      test('應該能夠標記項目需要同步', () async {
        const tripId = 'test-trip-id';
        
        await mockSyncService.markForSync(tripId, SyncAction.create);
        
        final hasPending = await mockSyncService.hasPendingChanges();
        expect(hasPending, isTrue);
        
        final syncQueue = await mockSyncService.getSyncQueue();
        expect(syncQueue.length, equals(1));
        expect(syncQueue.first.itemId, equals(tripId));
        expect(syncQueue.first.action, equals(SyncAction.create));
      });
      
      test('應該能夠處理離線狀態', () async {
        mockSyncService.setOnlineStatus(false);
        
        expect(await mockSyncService.isOnline(), isFalse);
        
        await mockSyncService.markForSync('trip-1', SyncAction.create);
        
        expect(() async => await mockSyncService.syncTrip('trip-1'), 
               throwsA(isA<SyncException>()));
      });
      
      test('應該能夠清除同步佇列', () async {
        await mockSyncService.markForSync('trip-1', SyncAction.create);
        await mockSyncService.markForSync('trip-2', SyncAction.update);
        
        expect(await mockSyncService.hasPendingChanges(), isTrue);
        
        await mockSyncService.clearSyncQueue();
        
        expect(await mockSyncService.hasPendingChanges(), isFalse);
        final syncQueue = await mockSyncService.getSyncQueue();
        expect(syncQueue.isEmpty, isTrue);
      });
    });
    
    group('整合測試', () {
      test('應該能夠完整的儲存和同步流程', () async {
        final trip = ExampleData.taipeiTripExample;
        
        // 儲存行程（應該自動標記為需要同步）
        await tripRepository.saveTrip(trip);
        
        // 檢查是否標記為需要同步
        final hasPending = await mockSyncService.hasPendingChanges();
        expect(hasPending, isTrue);
        
        // 模擬同步成功
        await mockSyncService.syncAllTrips();
        
        // 檢查同步佇列是否清空
        expect(await mockSyncService.hasPendingChanges(), isFalse);
        
        // 確認行程仍然存在
        final retrievedTrip = await tripRepository.getTripById(trip.id);
        expect(retrievedTrip, isNotNull);
      });
      
      test('應該能夠處理離線編輯和同步', () async {
        final trip = ExampleData.taipeiTripExample;
        
        // 離線狀態
        mockSyncService.setOnlineStatus(false);
        
        // 儲存行程（離線）
        await tripRepository.saveTrip(trip);
        
        // 檢查是否標記為需要同步
        expect(await mockSyncService.hasPendingChanges(), isTrue);
        
        // 嘗試同步應該失敗
        expect(() async => await tripRepository.syncTrips(), 
               throwsA(isA<TripRepositoryException>()));
        
        // 恢復網路連線
        mockSyncService.setOnlineStatus(true);
        
        // 同步應該成功
        await tripRepository.syncTrips();
        expect(await mockSyncService.hasPendingChanges(), isFalse);
      });
    });
  });
}