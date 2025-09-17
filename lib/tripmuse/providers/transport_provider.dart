import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/transport_service.dart';
import '../services/storage_manager.dart';

/// 交通信息狀態管理
class TransportNotifier extends StateNotifier<AsyncValue<void>> {
  TransportNotifier() : super(const AsyncValue.data(null));

  /// 添加新的交通信息
  Future<bool> addTransportInfo({
    required String tripId,
    required int dayIndex,
    required int activityIndex,
    required TransportMode mode,
  }) async {
    try {
      state = const AsyncValue.loading();
      
      // 從存儲中獲取行程
      final storageManager = StorageManager.instance;
      final trip = await storageManager.tripRepository.getTripById(tripId);
      if (trip == null) {
        state = AsyncValue.error('找不到行程', StackTrace.current);
        return false;
      }
      
      // 檢查索引是否有效
      if (dayIndex >= trip.days.length) {
        state = AsyncValue.error('無效的日期索引', StackTrace.current);
        return false;
      }
      
      final dayPlan = trip.days[dayIndex];
      if (activityIndex >= dayPlan.activities.length - 1) {
        state = AsyncValue.error('無效的活動索引', StackTrace.current);
        return false;
      }
      
      // 計算新的交通信息
      final fromActivity = dayPlan.activities[activityIndex];
      final toActivity = dayPlan.activities[activityIndex + 1];
      
      final newTransportInfo = TransportService.calculateTransport(
        fromActivity: fromActivity,
        toActivity: toActivity,
        mode: mode,
      );
      
      // 更新交通信息
      final updatedTransports = List<TransportInfo>.from(dayPlan.transports);
      
      // 確保 transports 列表有足夠的長度
      while (updatedTransports.length <= activityIndex) {
        updatedTransports.add(TransportInfo(
          mode: TransportMode.walking,
          durationMinutes: 10,
        ));
      }
      
      updatedTransports[activityIndex] = newTransportInfo;
      
      // 更新 DayPlan
      final updatedDayPlan = dayPlan.copyWith(transports: updatedTransports);
      
      // 更新 Trip
      final updatedDays = List<DayPlan>.from(trip.days);
      updatedDays[dayIndex] = updatedDayPlan;
      
      final updatedTrip = trip.copyWith(
        days: updatedDays,
        updatedAt: DateTime.now(),
      );
      
      // 保存到存儲
      await storageManager.tripRepository.saveTrip(updatedTrip);
      
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  /// 更新活動之間的交通方式
  Future<bool> updateTransportMode({
    required String tripId,
    required int dayIndex,
    required int activityIndex,
    required TransportMode newMode,
  }) async {
    try {
      state = const AsyncValue.loading();
      
      // 從存儲中獲取行程
      final storageManager = StorageManager.instance;
      final trip = await storageManager.tripRepository.getTripById(tripId);
      if (trip == null) {
        state = AsyncValue.error('找不到行程', StackTrace.current);
        return false;
      }
      
      // 檢查索引是否有效
      if (dayIndex >= trip.days.length) {
        state = AsyncValue.error('無效的日期索引', StackTrace.current);
        return false;
      }
      
      final dayPlan = trip.days[dayIndex];
      if (activityIndex >= dayPlan.activities.length - 1) {
        state = AsyncValue.error('無效的活動索引', StackTrace.current);
        return false;
      }
      
      // 計算新的交通信息
      final fromActivity = dayPlan.activities[activityIndex];
      final toActivity = dayPlan.activities[activityIndex + 1];
      
      final newTransportInfo = TransportService.calculateTransport(
        fromActivity: fromActivity,
        toActivity: toActivity,
        mode: newMode,
      );
      
      // 更新交通信息
      final updatedTransports = List<TransportInfo>.from(dayPlan.transports);
      
      // 確保 transports 列表有足夠的長度
      while (updatedTransports.length <= activityIndex) {
        updatedTransports.add(TransportInfo(
          mode: TransportMode.walking,
          durationMinutes: 10,
        ));
      }
      
      updatedTransports[activityIndex] = newTransportInfo;
      
      // 更新 DayPlan
      final updatedDayPlan = dayPlan.copyWith(transports: updatedTransports);
      
      // 更新 Trip
      final updatedDays = List<DayPlan>.from(trip.days);
      updatedDays[dayIndex] = updatedDayPlan;
      
      final updatedTrip = trip.copyWith(
        days: updatedDays,
        updatedAt: DateTime.now(),
      );
      
      // 保存到存儲
      await storageManager.tripRepository.saveTrip(updatedTrip);
      
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  /// 為整個行程生成交通信息
  Future<bool> generateTransportForTrip({
    required String tripId,
    required TransportMode defaultMode,
  }) async {
    try {
      state = const AsyncValue.loading();
      
      // 從存儲中獲取行程
      final storageManager = StorageManager.instance;
      final trip = await storageManager.tripRepository.getTripById(tripId);
      if (trip == null) {
        state = AsyncValue.error('找不到行程', StackTrace.current);
        return false;
      }
      
      // 生成交通信息
      final updatedTrip = TransportService.generateTransportForTrip(trip, defaultMode);
      
      // 保存到存儲
      await storageManager.tripRepository.saveTrip(updatedTrip);
      
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  /// 清除所有交通信息
  Future<bool> clearAllTransports(String tripId) async {
    try {
      state = const AsyncValue.loading();
      
      // 從存儲中獲取行程
      final storageManager = StorageManager.instance;
      final trip = await storageManager.tripRepository.getTripById(tripId);
      if (trip == null) {
        state = AsyncValue.error('找不到行程', StackTrace.current);
        return false;
      }
      
      // 清除所有交通信息
      final updatedDays = trip.days.map((dayPlan) {
        return dayPlan.copyWith(transports: []);
      }).toList();
      
      final updatedTrip = trip.copyWith(
        days: updatedDays,
        updatedAt: DateTime.now(),
      );
      
      // 保存到存儲
      await storageManager.tripRepository.saveTrip(updatedTrip);
      
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  /// 批量更新所有交通方式
  Future<bool> updateAllTransportModes({
    required String tripId,
    required TransportMode newMode,
  }) async {
    try {
      state = const AsyncValue.loading();
      
      // 從存儲中獲取行程
      final storageManager = StorageManager.instance;
      final trip = await storageManager.tripRepository.getTripById(tripId);
      if (trip == null) {
        state = AsyncValue.error('找不到行程', StackTrace.current);
        return false;
      }
      
      // 更新所有日程中的交通方式
      final updatedDays = trip.days.map((dayPlan) {
        if (dayPlan.activities.length <= 1) {
          return dayPlan; // 如果只有一個或沒有活動，不需要交通信息
        }
        
        final transports = <TransportInfo>[];
        
        for (int i = 0; i < dayPlan.activities.length - 1; i++) {
          final fromActivity = dayPlan.activities[i];
          final toActivity = dayPlan.activities[i + 1];
          
          final transport = TransportService.calculateTransport(
            fromActivity: fromActivity,
            toActivity: toActivity,
            mode: newMode,
          );
          
          transports.add(transport);
        }
        
        return dayPlan.copyWith(transports: transports);
      }).toList();
      
      final updatedTrip = trip.copyWith(
        days: updatedDays,
        updatedAt: DateTime.now(),
      );
      
      // 保存到存儲
      await storageManager.tripRepository.saveTrip(updatedTrip);
      
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  /// 自動推薦交通方式
  Future<bool> autoRecommendTransports(String tripId) async {
    try {
      state = const AsyncValue.loading();
      
      // 從存儲中獲取行程
      final storageManager = StorageManager.instance;
      final trip = await storageManager.tripRepository.getTripById(tripId);
      if (trip == null) {
        state = AsyncValue.error('找不到行程', StackTrace.current);
        return false;
      }
      
      // 為每個活動間推薦交通方式
      final updatedDays = trip.days.map((dayPlan) {
        if (dayPlan.activities.length <= 1) {
          return dayPlan;
        }
        
        final transports = <TransportInfo>[];
        
        for (int i = 0; i < dayPlan.activities.length - 1; i++) {
          final fromActivity = dayPlan.activities[i];
          final toActivity = dayPlan.activities[i + 1];
          
          // 計算距離 - 使用 calculateTransport 來獲取距離
          final tempTransport = TransportService.calculateTransport(
            fromActivity: fromActivity,
            toActivity: toActivity,
            mode: TransportMode.walking, // 臨時使用步行模式來計算距離
          );
          final distance = tempTransport.distanceMeters?.toDouble() ?? 0.0;
          
          // 推薦交通方式
          final recommendedMode = TransportService.recommendTransportMode(
            fromActivity: fromActivity,
            toActivity: toActivity,
            distanceMeters: distance,
          );
          
          // 計算交通信息
          final transport = TransportService.calculateTransport(
            fromActivity: fromActivity,
            toActivity: toActivity,
            mode: recommendedMode,
          );
          
          transports.add(transport);
        }
        
        return dayPlan.copyWith(transports: transports);
      }).toList();
      
      final updatedTrip = trip.copyWith(
        days: updatedDays,
        updatedAt: DateTime.now(),
      );
      
      // 保存到存儲
      await storageManager.tripRepository.saveTrip(updatedTrip);
      
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }
}

/// 交通信息 Provider
final transportProvider = StateNotifierProvider<TransportNotifier, AsyncValue<void>>((ref) {
  return TransportNotifier();
});

/// 錯誤信息 Provider
final transportErrorProvider = Provider<String?>((ref) {
  final transportState = ref.watch(transportProvider);
  return transportState.maybeWhen(
    error: (error, _) => error.toString(),
    orElse: () => null,
  );
});

/// 加載狀態 Provider
final transportLoadingProvider = Provider<bool>((ref) {
  final transportState = ref.watch(transportProvider);
  return transportState.maybeWhen(
    loading: () => true,
    orElse: () => false,
  );
});