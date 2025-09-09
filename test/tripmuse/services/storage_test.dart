import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_example/tripmuse/models/models.dart';
import 'package:mapbox_maps_example/tripmuse/services/services.dart';

void main() {
  group('TripMuse 儲存系統測試', () {
    late StorageManager storageManager;
    
    setUpAll(() async {
      storageManager = StorageManager.instance;
      await storageManager.initialize();
    });
    
    tearDownAll(() async {
      await storageManager.dispose();
    });
    
    setUp(() async {
      // 每個測試前清除資料
      await storageManager.clearAllData();
    });
    
    group('HiveStorageService 測試', () {
      test('應該能夠儲存和讀取行程', () async {
        final hiveStorage = storageManager.hiveStorage;
        final trip = ExampleData.taipeiTripExample;
        
        // 儲存行程
        await hiveStorage.saveTrip(trip);
        
        // 讀取行程
        final retrievedTrip = await hiveStorage.getTrip(trip.id);
        
        expect(retrievedTrip, isNotNull);
        expect(retrievedTrip!.id, equals(trip.id));
        expect(retrievedTrip.title, equals(trip.title));
        expect(retrievedTrip.destination.name, equals(trip.destination.name));
      });
      
      test('應該能夠取得所有行程', () async {
        final hiveStorage = storageManager.hiveStorage;
        final trip1 = ExampleData.taipeiTripExample;
        final trip2 = trip1.copyWith(
          id: 'trip-2',
          title: '台北美食2日遊',
        );
        
        // 儲存多個行程
        await hiveStorage.saveTrip(trip1);
        await hiveStorage.saveTrip(trip2);
        
        // 取得所有行程
        final allTrips = await hiveStorage.getAllTrips();
        
        expect(allTrips.length, equals(2));
        expect(allTrips.any((t) => t.id == trip1.id), isTrue);
        expect(allTrips.any((t) => t.id == trip2.id), isTrue);
      });
      
      test('應該能夠刪除行程', () async {
        final hiveStorage = storageManager.hiveStorage;
        final trip = ExampleData.taipeiTripExample;
        
        // 儲存行程
        await hiveStorage.saveTrip(trip);
        expect(await hiveStorage.getTrip(trip.id), isNotNull);
        
        // 刪除行程
        await hiveStorage.deleteTrip(trip.id);
        expect(await hiveStorage.getTrip(trip.id), isNull);
      });
      
      test('應該能夠儲存和讀取快取資料', () async {
        final hiveStorage = storageManager.hiveStorage;
        const cacheKey = 'test_cache';
        const cacheValue = {'data': 'test_value'};
        
        // 儲存快取
        await hiveStorage.storeCache(cacheKey, cacheValue, ttl: Duration(minutes: 5));
        
        // 讀取快取
        final retrievedValue = await hiveStorage.getCache<Map<String, dynamic>>(cacheKey);
        
        expect(retrievedValue, isNotNull);
        expect(retrievedValue!['data'], equals('test_value'));
      });
      
      test('過期的快取應該被自動清除', () async {
        final hiveStorage = storageManager.hiveStorage;
        const cacheKey = 'expired_cache';
        const cacheValue = 'expired_value';
        
        // 儲存短期快取
        await hiveStorage.storeCache(cacheKey, cacheValue, ttl: Duration(milliseconds: 1));
        
        // 等待過期
        await Future.delayed(Duration(milliseconds: 10));
        
        // 讀取快取應該返回 null
        final retrievedValue = await hiveStorage.getCache<String>(cacheKey);
        expect(retrievedValue, isNull);
      });
    });
    
    group('TripRepository 測試', () {
      test('應該能夠儲存和取得行程', () async {
        final tripRepository = storageManager.tripRepository;
        final trip = ExampleData.taipeiTripExample;
        
        // 儲存行程
        await tripRepository.saveTrip(trip);
        
        // 取得行程
        final retrievedTrip = await tripRepository.getTripById(trip.id);
        
        expect(retrievedTrip, isNotNull);
        expect(retrievedTrip!.id, equals(trip.id));
      });
      
      test('應該能夠搜尋行程', () async {
        final tripRepository = storageManager.tripRepository;
        final trip1 = ExampleData.taipeiTripExample;
        final trip2 = trip1.copyWith(
          id: 'trip-2',
          title: '東京美食之旅',
          destination: ExampleData.tokyoDestination,
        );
        
        await tripRepository.saveTrip(trip1);
        await tripRepository.saveTrip(trip2);
        
        // 搜尋台北相關行程
        final taipeiTrips = await tripRepository.searchTrips('台北');
        expect(taipeiTrips.length, equals(1));
        expect(taipeiTrips.first.id, equals(trip1.id));
        
        // 搜尋美食相關行程
        final foodTrips = await tripRepository.searchTrips('美食');
        expect(foodTrips.length, equals(2));
      });
      
      test('應該能夠根據狀態篩選行程', () async {
        final tripRepository = storageManager.tripRepository;
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
        
        // 取得草稿行程
        final draftTrips = await tripRepository.getTripsByStatus(TripStatus.draft);
        expect(draftTrips.length, equals(1));
        expect(draftTrips.first.id, equals(draftTrip.id));
        
        // 取得進行中行程
        final activeTrips = await tripRepository.getTripsByStatus(TripStatus.active);
        expect(activeTrips.length, equals(1));
        expect(activeTrips.first.id, equals(activeTrip.id));
      });
      
      test('應該能夠取得收藏行程', () async {
        final tripRepository = storageManager.tripRepository;
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
        
        // 取得收藏行程
        final favoriteTrips = await tripRepository.getFavoriteTrips();
        expect(favoriteTrips.length, equals(1));
        expect(favoriteTrips.first.id, equals(favoriteTrip.id));
      });
      
      test('應該能夠取得行程統計', () async {
        final tripRepository = storageManager.tripRepository;
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
        
        // 取得統計
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
        final userRepository = storageManager.userRepository;
        
        // 建立訪客使用者
        final guestUser = await userRepository.continueAsGuest();
        
        expect(guestUser.isGuest, isTrue);
        expect(guestUser.email, equals('guest@tripmuse.local'));
        expect(guestUser.name, equals('訪客使用者'));
        
        // 檢查是否已登入
        final isSignedIn = await userRepository.isSignedIn();
        expect(isSignedIn, isTrue);
        
        // 檢查是否為訪客模式
        final isGuestMode = await userRepository.isGuestMode();
        expect(isGuestMode, isTrue);
      });
      
      test('應該能夠儲存和取得使用者偏好', () async {
        final userRepository = storageManager.userRepository;
        
        // 建立自訂偏好
        final customPrefs = UserPreferences.defaultPreferences().copyWith(
          language: 'en-US',
          theme: 'dark',
          enableNotifications: false,
        );
        
        // 儲存偏好
        await userRepository.saveUserPreferences(customPrefs);
        
        // 取得偏好
        final retrievedPrefs = await userRepository.getUserPreferences();
        
        expect(retrievedPrefs.language, equals('en-US'));
        expect(retrievedPrefs.theme, equals('dark'));
        expect(retrievedPrefs.enableNotifications, isFalse);
      });
      
      test('應該能夠登出並清除資料', () async {
        final userRepository = storageManager.userRepository;
        
        // 建立使用者
        await userRepository.continueAsGuest();
        expect(await userRepository.isSignedIn(), isTrue);
        
        // 登出
        await userRepository.signOut();
        expect(await userRepository.isSignedIn(), isFalse);
        expect(await userRepository.getCurrentUser(), isNull);
      });
    });
    
    group('SyncService 測試', () {
      test('應該能夠標記項目需要同步', () async {
        final syncService = storageManager.syncService;
        const tripId = 'test-trip-id';
        
        // 標記需要同步
        await syncService.markForSync(tripId, SyncAction.create);
        
        // 檢查是否有待同步項目
        final hasPending = await syncService.hasPendingChanges();
        expect(hasPending, isTrue);
        
        // 取得同步佇列
        final syncQueue = await syncService.getSyncQueue();
        expect(syncQueue.length, equals(1));
        expect(syncQueue.first.itemId, equals(tripId));
        expect(syncQueue.first.action, equals(SyncAction.create));
      });
      
      test('應該能夠清除同步佇列', () async {
        final syncService = storageManager.syncService;
        
        // 添加同步項目
        await syncService.markForSync('trip-1', SyncAction.create);
        await syncService.markForSync('trip-2', SyncAction.update);
        
        expect(await syncService.hasPendingChanges(), isTrue);
        
        // 清除佇列
        await syncService.clearSyncQueue();
        
        expect(await syncService.hasPendingChanges(), isFalse);
        final syncQueue = await syncService.getSyncQueue();
        expect(syncQueue.isEmpty, isTrue);
      });
    });
    
    group('StorageManager 整合測試', () {
      test('應該能夠取得儲存統計', () async {
        final tripRepository = storageManager.tripRepository;
        final trip = ExampleData.taipeiTripExample;
        
        // 儲存行程
        await tripRepository.saveTrip(trip);
        
        // 取得統計
        final stats = await storageManager.getStorageStatistics();
        
        expect(stats.totalTrips, equals(1));
        expect(stats.totalActivities, greaterThan(0));
        expect(stats.totalStorageKeys, greaterThan(0));
      });
      
      test('應該能夠清除所有資料', () async {
        final tripRepository = storageManager.tripRepository;
        final userRepository = storageManager.userRepository;
        
        // 建立一些資料
        await tripRepository.saveTrip(ExampleData.taipeiTripExample);
        await userRepository.continueAsGuest();
        
        // 確認資料存在
        final trips = await tripRepository.getAllTrips();
        expect(trips.isNotEmpty, isTrue);
        
        // 清除所有資料
        await storageManager.clearAllData();
        
        // 確認資料已清除
        final tripsAfterClear = await tripRepository.getAllTrips();
        expect(tripsAfterClear.isEmpty, isTrue);
        
        final userAfterClear = await userRepository.getCurrentUser();
        expect(userAfterClear, isNull);
      });
    });
  });
}