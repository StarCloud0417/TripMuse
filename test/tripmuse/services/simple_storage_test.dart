import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_example/tripmuse/models/models.dart';
import 'package:mapbox_maps_example/tripmuse/services/services.dart';

void main() {
  group('TripMuse 儲存系統基礎測試', () {
    group('資料模型序列化測試', () {
      test('Trip 模型應該能夠正確序列化和反序列化', () {
        final trip = ExampleData.taipeiTripExample;
        
        // 序列化為 JSON
        final json = trip.toJson();
        
        // 從 JSON 反序列化
        final deserializedTrip = Trip.fromJson(json);
        
        // 驗證資料完整性
        expect(deserializedTrip.id, equals(trip.id));
        expect(deserializedTrip.title, equals(trip.title));
        expect(deserializedTrip.destination.name, equals(trip.destination.name));
        expect(deserializedTrip.days.length, equals(trip.days.length));
        expect(deserializedTrip.status, equals(trip.status));
      });
      
      test('Activity 模型應該能夠正確序列化和反序列化', () {
        final activity = ExampleData.taipeiDay1Activities.first;
        
        final json = activity.toJson();
        final deserializedActivity = Activity.fromJson(json);
        
        expect(deserializedActivity.id, equals(activity.id));
        expect(deserializedActivity.name, equals(activity.name));
        expect(deserializedActivity.category, equals(activity.category));
        expect(deserializedActivity.priority, equals(activity.priority));
        expect(deserializedActivity.lat, equals(activity.lat));
        expect(deserializedActivity.lng, equals(activity.lng));
      });
      
      test('UserPreferenceAnalysis 模型應該能夠正確序列化和反序列化', () {
        final analysis = ExampleData.foodLoverAnalysis;
        
        final json = analysis.toJson();
        final deserializedAnalysis = UserPreferenceAnalysis.fromJson(json);
        
        expect(deserializedAnalysis.primaryFocus, equals(analysis.primaryFocus));
        expect(deserializedAnalysis.travelPace, equals(analysis.travelPace));
        expect(deserializedAnalysis.interests, equals(analysis.interests));
        expect(deserializedAnalysis.mood, equals(analysis.mood));
      });
    });
    
    group('儲存服務介面測試', () {
      test('StorageKeys 常數應該正確定義', () {
        expect(StorageKeys.userId, equals('user_id'));
        expect(StorageKeys.jwtToken, equals('jwt_token'));
        expect(StorageKeys.appLanguage, equals('app_language'));
        expect(StorageKeys.isFirstLaunch, equals('is_first_launch'));
      });
      
      test('SyncAction 列舉應該包含所有必要動作', () {
        expect(SyncAction.values.length, equals(3));
        expect(SyncAction.values, contains(SyncAction.create));
        expect(SyncAction.values, contains(SyncAction.update));
        expect(SyncAction.values, contains(SyncAction.delete));
      });
      
      test('SyncStatus 列舉應該包含所有狀態', () {
        expect(SyncStatus.values.length, equals(4));
        expect(SyncStatus.values, contains(SyncStatus.pending));
        expect(SyncStatus.values, contains(SyncStatus.syncing));
        expect(SyncStatus.values, contains(SyncStatus.completed));
        expect(SyncStatus.values, contains(SyncStatus.failed));
      });
    });
    
    group('SyncItem 模型測試', () {
      test('SyncItem 應該能夠正確建立和序列化', () {
        final syncItem = SyncItem(
          id: 'sync-1',
          itemId: 'trip-1',
          action: SyncAction.create,
          status: SyncStatus.pending,
          createdAt: DateTime(2025, 1, 9, 10, 0),
          retryCount: 0,
        );
        
        // 序列化
        final json = syncItem.toJson();
        
        // 反序列化
        final deserializedItem = SyncItem.fromJson(json);
        
        expect(deserializedItem.id, equals(syncItem.id));
        expect(deserializedItem.itemId, equals(syncItem.itemId));
        expect(deserializedItem.action, equals(syncItem.action));
        expect(deserializedItem.status, equals(syncItem.status));
        expect(deserializedItem.retryCount, equals(syncItem.retryCount));
      });
      
      test('SyncItem copyWith 應該正確更新欄位', () {
        final originalItem = SyncItem(
          id: 'sync-1',
          itemId: 'trip-1',
          action: SyncAction.create,
          status: SyncStatus.pending,
          createdAt: DateTime.now(),
        );
        
        final updatedItem = originalItem.copyWith(
          status: SyncStatus.completed,
          retryCount: 1,
        );
        
        expect(updatedItem.id, equals(originalItem.id));
        expect(updatedItem.status, equals(SyncStatus.completed));
        expect(updatedItem.retryCount, equals(1));
        expect(updatedItem.action, equals(originalItem.action));
      });
    });
    
    group('User 模型測試', () {
      test('User.guest() 應該建立正確的訪客使用者', () {
        final guestUser = User.guest();
        
        expect(guestUser.isGuest, isTrue);
        expect(guestUser.email, equals('guest@tripmuse.local'));
        expect(guestUser.name, equals('訪客使用者'));
        expect(guestUser.id, startsWith('guest_'));
      });
      
      test('User 應該能夠正確序列化和反序列化', () {
        final user = User(
          id: 'user-123',
          googleId: 'google-456',
          email: 'test@example.com',
          name: 'Test User',
          avatarUrl: 'https://example.com/avatar.jpg',
          createdAt: DateTime(2025, 1, 9),
          updatedAt: DateTime(2025, 1, 9),
          isGuest: false,
        );
        
        final json = user.toJson();
        final deserializedUser = User.fromJson(json);
        
        expect(deserializedUser.id, equals(user.id));
        expect(deserializedUser.googleId, equals(user.googleId));
        expect(deserializedUser.email, equals(user.email));
        expect(deserializedUser.name, equals(user.name));
        expect(deserializedUser.isGuest, equals(user.isGuest));
      });
      
      test('User copyWith 應該正確更新欄位', () {
        final originalUser = User.guest();
        
        final updatedUser = originalUser.copyWith(
          name: '更新的使用者',
          email: 'updated@example.com',
        );
        
        expect(updatedUser.id, equals(originalUser.id));
        expect(updatedUser.name, equals('更新的使用者'));
        expect(updatedUser.email, equals('updated@example.com'));
        expect(updatedUser.isGuest, equals(originalUser.isGuest));
      });
    });
    
    group('UserPreferences 模型測試', () {
      test('UserPreferences.defaultPreferences() 應該提供合理的預設值', () {
        final defaultPrefs = UserPreferences.defaultPreferences();
        
        expect(defaultPrefs.language, equals('zh-TW'));
        expect(defaultPrefs.theme, equals('system'));
        expect(defaultPrefs.enableNotifications, isTrue);
        expect(defaultPrefs.enableLocationTracking, isTrue);
        expect(defaultPrefs.enableOfflineMode, isTrue);
        expect(defaultPrefs.defaultCurrency, equals('TWD'));
        expect(defaultPrefs.defaultMapStyle, equals('streets'));
      });
      
      test('UserPreferences 應該能夠正確序列化和反序列化', () {
        final prefs = UserPreferences.defaultPreferences();
        
        final json = prefs.toJson();
        final deserializedPrefs = UserPreferences.fromJson(json);
        
        expect(deserializedPrefs.language, equals(prefs.language));
        expect(deserializedPrefs.theme, equals(prefs.theme));
        expect(deserializedPrefs.enableNotifications, equals(prefs.enableNotifications));
        expect(deserializedPrefs.defaultCurrency, equals(prefs.defaultCurrency));
      });
      
      test('UserPreferences copyWith 應該正確更新欄位', () {
        final originalPrefs = UserPreferences.defaultPreferences();
        
        final updatedPrefs = originalPrefs.copyWith(
          language: 'en-US',
          theme: 'dark',
          enableNotifications: false,
        );
        
        expect(updatedPrefs.language, equals('en-US'));
        expect(updatedPrefs.theme, equals('dark'));
        expect(updatedPrefs.enableNotifications, isFalse);
        expect(updatedPrefs.enableLocationTracking, equals(originalPrefs.enableLocationTracking));
      });
    });
    
    group('TripStatistics 模型測試', () {
      test('TripStatistics 應該正確計算統計資料', () {
        final stats = TripStatistics(
          totalTrips: 10,
          draftTrips: 3,
          activeTrips: 4,
          completedTrips: 3,
          favoriteTrips: 5,
          totalActivities: 50,
          totalDays: 30,
        );
        
        expect(stats.completionRate, equals(0.3));
        expect(stats.averageDaysPerTrip, equals(3.0));
        expect(stats.averageActivitiesPerTrip, equals(5.0));
      });
      
      test('TripStatistics 應該處理零除法情況', () {
        final emptyStats = TripStatistics(
          totalTrips: 0,
          draftTrips: 0,
          activeTrips: 0,
          completedTrips: 0,
          favoriteTrips: 0,
          totalActivities: 0,
          totalDays: 0,
        );
        
        expect(emptyStats.completionRate, equals(0.0));
        expect(emptyStats.averageDaysPerTrip, equals(0.0));
        expect(emptyStats.averageActivitiesPerTrip, equals(0.0));
      });
    });
    
    group('StorageStatistics 模型測試', () {
      test('StorageStatistics 應該正確格式化同步時間', () {
        final now = DateTime.now();
        
        // 剛剛同步
        final recentStats = StorageStatistics(
          totalTrips: 5,
          totalActivities: 20,
          pendingSyncItems: 0,
          totalStorageKeys: 10,
          isOnline: true,
          lastSyncTime: now.subtract(Duration(seconds: 30)),
        );
        expect(recentStats.formattedLastSyncTime, equals('剛剛同步'));
        
        // 幾分鐘前同步
        final minutesAgoStats = StorageStatistics(
          totalTrips: 5,
          totalActivities: 20,
          pendingSyncItems: 0,
          totalStorageKeys: 10,
          isOnline: true,
          lastSyncTime: now.subtract(Duration(minutes: 5)),
        );
        expect(minutesAgoStats.formattedLastSyncTime, equals('5 分鐘前同步'));
        
        // 從未同步
        final neverSyncedStats = StorageStatistics(
          totalTrips: 5,
          totalActivities: 20,
          pendingSyncItems: 0,
          totalStorageKeys: 10,
          isOnline: true,
          lastSyncTime: null,
        );
        expect(neverSyncedStats.formattedLastSyncTime, equals('從未同步'));
      });
      
      test('StorageStatistics 應該正確判斷是否需要同步', () {
        final needsSyncStats = StorageStatistics(
          totalTrips: 5,
          totalActivities: 20,
          pendingSyncItems: 3,
          totalStorageKeys: 10,
          isOnline: true,
        );
        expect(needsSyncStats.needsSync, isTrue);
        
        final noSyncNeededStats = StorageStatistics(
          totalTrips: 5,
          totalActivities: 20,
          pendingSyncItems: 0,
          totalStorageKeys: 10,
          isOnline: true,
        );
        expect(noSyncNeededStats.needsSync, isFalse);
      });
      
      test('StorageStatistics 應該生成正確的狀態摘要', () {
        final onlineStats = StorageStatistics(
          totalTrips: 5,
          totalActivities: 20,
          pendingSyncItems: 2,
          totalStorageKeys: 10,
          isOnline: true,
        );
        expect(onlineStats.statusSummary, equals('5 個行程，20 個活動，2 項待同步'));
        
        final offlineStats = StorageStatistics(
          totalTrips: 3,
          totalActivities: 15,
          pendingSyncItems: 0,
          totalStorageKeys: 8,
          isOnline: false,
        );
        expect(offlineStats.statusSummary, equals('3 個行程，15 個活動（離線模式）'));
      });
    });
    
    group('例外處理測試', () {
      test('TripRepositoryException 應該正確顯示錯誤訊息', () {
        const exception = TripRepositoryException('測試錯誤');
        expect(exception.toString(), equals('TripRepositoryException: 測試錯誤'));
      });
      
      test('UserRepositoryException 應該正確顯示錯誤訊息', () {
        const exception = UserRepositoryException('使用者錯誤');
        expect(exception.toString(), equals('UserRepositoryException: 使用者錯誤'));
      });
      
      test('SyncException 應該正確顯示錯誤訊息', () {
        const exception = SyncException('同步錯誤');
        expect(exception.toString(), equals('SyncException: 同步錯誤'));
      });
      
      test('StorageManagerException 應該正確顯示錯誤訊息', () {
        const exception = StorageManagerException('儲存管理錯誤');
        expect(exception.toString(), equals('StorageManagerException: 儲存管理錯誤'));
      });
    });
  });
}