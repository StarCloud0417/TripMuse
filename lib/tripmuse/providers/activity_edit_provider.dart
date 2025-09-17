/// TripMuse 活動編輯狀態管理
///
/// 提供活動編輯相關的狀態管理和操作

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/activity_edit_service.dart';
import '../services/storage_manager.dart';

import '../services/route_optimization_service.dart';
import 'trip_provider.dart';

/// 活動編輯狀態
class ActivityEditState {
  final bool isEditing;
  final Activity? editingActivity;
  final String? error;
  final bool isLoading;

  const ActivityEditState({
    this.isEditing = false,
    this.editingActivity,
    this.error,
    this.isLoading = false,
  });

  ActivityEditState copyWith({
    bool? isEditing,
    Activity? editingActivity,
    String? error,
    bool? isLoading,
  }) {
    return ActivityEditState(
      isEditing: isEditing ?? this.isEditing,
      editingActivity: editingActivity ?? this.editingActivity,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// 活動編輯 Notifier
class ActivityEditNotifier extends StateNotifier<ActivityEditState> {
  ActivityEditNotifier(this._ref) : super(const ActivityEditState());
  
  final Ref _ref;

  /// 開始編輯活動
  void startEditing(Activity activity) {
    state = state.copyWith(
      isEditing: true,
      editingActivity: activity,
      error: null,
    );
  }

  /// 取消編輯
  void cancelEditing() {
    state = const ActivityEditState();
  }

  /// 更新活動時間
  Future<bool> updateActivityTime(
    String tripId,
    int dayIndex,
    Activity activity,
    String newTimeFrom,
    String newTimeTo,
  ) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // 驗證時間格式
      if (!ActivityEditService.validateTimeRange(newTimeFrom, newTimeTo)) {
        state = state.copyWith(
          isLoading: false,
          error: '時間格式無效或結束時間早於開始時間',
        );
        return false;
      }

      // 獲取行程資料
      final storageManager = StorageManager.instance;
      final tripRepository = storageManager.tripRepository;
      final trip = await tripRepository.getTripById(tripId);

      if (trip == null) {
        state = state.copyWith(
          isLoading: false,
          error: '找不到行程資料',
        );
        return false;
      }

      // 檢查時間衝突
      final dayPlan = trip.days[dayIndex];
      final hasConflict = ActivityEditService.checkTimeConflict(
        activity,
        newTimeFrom,
        newTimeTo,
        dayPlan.activities,
      );

      if (hasConflict) {
        state = state.copyWith(
          isLoading: false,
          error: '時間與其他活動衝突',
        );
        return false;
      }

      // 更新活動時間
      final updatedActivity = ActivityEditService.updateActivityTime(
        activity,
        newTimeFrom,
        newTimeTo,
      );

      // 更新日程
      final updatedActivities = dayPlan.activities.map((a) {
        if (a.id == activity.id) {
          return updatedActivity;
        }
        return a;
      }).toList();

      final updatedDayPlan = dayPlan.copyWith(activities: updatedActivities);
      final updatedDays = List<DayPlan>.from(trip.days);
      updatedDays[dayIndex] = updatedDayPlan;

      final updatedTrip = trip.copyWith(
        days: updatedDays,
        updatedAt: DateTime.now(),
      );

      // 儲存更新
      await tripRepository.saveTrip(updatedTrip);

      state = state.copyWith(
        isLoading: false,
        editingActivity: updatedActivity,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '更新活動時間失敗: ${e.toString()}',
      );
      return false;
    }
  }

  /// 刪除活動
  Future<bool> deleteActivity(
    String tripId,
    int dayIndex,
    Activity activity,
  ) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // 獲取行程資料
      final storageManager = StorageManager.instance;
      final tripRepository = storageManager.tripRepository;
      final trip = await tripRepository.getTripById(tripId);

      if (trip == null) {
        state = state.copyWith(
          isLoading: false,
          error: '找不到行程資料',
        );
        return false;
      }

      // 從日程中移除活動
      final dayPlan = trip.days[dayIndex];
      final updatedDayPlan = ActivityEditService.removeActivityFromDay(dayPlan, activity.id);

      final updatedDays = List<DayPlan>.from(trip.days);
      updatedDays[dayIndex] = updatedDayPlan;

      final updatedTrip = trip.copyWith(
        days: updatedDays,
        updatedAt: DateTime.now(),
      );

      // 儲存更新
      await tripRepository.saveTrip(updatedTrip);

      state = const ActivityEditState();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '刪除活動失敗: ${e.toString()}',
      );
      return false;
    }
  }

  /// 移動活動到其他日期
  Future<bool> moveActivityToDay(
    String tripId,
    int fromDayIndex,
    int toDayIndex,
    Activity activity,
  ) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      if (fromDayIndex == toDayIndex) {
        state = state.copyWith(isLoading: false);
        return true; // 沒有實際移動
      }

      // 獲取行程資料
      final storageManager = StorageManager.instance;
      final tripRepository = storageManager.tripRepository;
      final trip = await tripRepository.getTripById(tripId);

      if (trip == null) {
        state = state.copyWith(
          isLoading: false,
          error: '找不到行程資料',
        );
        return false;
      }

      if (toDayIndex < 0 || toDayIndex >= trip.days.length) {
        state = state.copyWith(
          isLoading: false,
          error: '目標日期無效',
        );
        return false;
      }

      // 從原日期移除活動
      final fromDayPlan = trip.days[fromDayIndex];
      final updatedFromDayPlan = ActivityEditService.removeActivityFromDay(fromDayPlan, activity.id);

      // 添加到目標日期
      final toDayPlan = trip.days[toDayIndex];
      final updatedToDayPlan = ActivityEditService.addActivityToDay(toDayPlan, activity);

      // 更新行程
      final updatedDays = List<DayPlan>.from(trip.days);
      updatedDays[fromDayIndex] = updatedFromDayPlan;
      updatedDays[toDayIndex] = updatedToDayPlan;

      final updatedTrip = trip.copyWith(
        days: updatedDays,
        updatedAt: DateTime.now(),
      );

      // 儲存更新
      await tripRepository.saveTrip(updatedTrip);

      state = const ActivityEditState();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '移動活動失敗: ${e.toString()}',
      );
      return false;
    }
  }

  /// 替換活動
  Future<bool> replaceActivity(
    String tripId,
    int dayIndex,
    Activity oldActivity,
    Activity newActivity,
  ) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // 獲取行程資料
      final storageManager = StorageManager.instance;
      final tripRepository = storageManager.tripRepository;
      final trip = await tripRepository.getTripById(tripId);

      if (trip == null) {
        state = state.copyWith(
          isLoading: false,
          error: '找不到行程資料',
        );
        return false;
      }

      // 替換活動
      final dayPlan = trip.days[dayIndex];
      final updatedDayPlan = ActivityEditService.replaceActivity(
        dayPlan,
        oldActivity.id,
        newActivity,
      );

      final updatedDays = List<DayPlan>.from(trip.days);
      updatedDays[dayIndex] = updatedDayPlan;

      final updatedTrip = trip.copyWith(
        days: updatedDays,
        updatedAt: DateTime.now(),
      );

      // 儲存更新
      await tripRepository.saveTrip(updatedTrip);

      state = state.copyWith(
        isLoading: false,
        editingActivity: newActivity,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '替換活動失敗: ${e.toString()}',
      );
      return false;
    }
  }

  /// 自動調整活動時間
  Future<bool> autoAdjustActivityTimes(
    String tripId,
    int dayIndex,
  ) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // 獲取行程資料
      final storageManager = StorageManager.instance;
      final tripRepository = storageManager.tripRepository;
      final trip = await tripRepository.getTripById(tripId);

      if (trip == null) {
        state = state.copyWith(
          isLoading: false,
          error: '找不到行程資料',
        );
        return false;
      }

      // 自動調整時間
      final dayPlan = trip.days[dayIndex];
      final adjustedActivities = ActivityEditService.autoAdjustActivityTimes(dayPlan.activities);

      final updatedDayPlan = dayPlan.copyWith(activities: adjustedActivities);
      final updatedDays = List<DayPlan>.from(trip.days);
      updatedDays[dayIndex] = updatedDayPlan;

      final updatedTrip = trip.copyWith(
        days: updatedDays,
        updatedAt: DateTime.now(),
      );

      // 儲存更新
      await tripRepository.saveTrip(updatedTrip);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '自動調整時間失敗: ${e.toString()}',
      );
      return false;
    }
  }

  /// 向上移動活動
  Future<bool> moveActivityUp(
    String tripId,
    int dayIndex,
    Activity activity,
  ) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // 獲取行程資料
      final storageManager = StorageManager.instance;
      final tripRepository = storageManager.tripRepository;
      final trip = await tripRepository.getTripById(tripId);

      if (trip == null) {
        state = state.copyWith(
          isLoading: false,
          error: '找不到行程資料',
        );
        return false;
      }

      final dayPlan = trip.days[dayIndex];
      final currentIndex = dayPlan.activities.indexWhere((a) => a.id == activity.id);
      
      if (currentIndex <= 0) {
        state = state.copyWith(isLoading: false);
        return false; // 已經在最上面或找不到活動
      }

      // 交換活動位置
      final updatedActivities = List<Activity>.from(dayPlan.activities);
      final temp = updatedActivities[currentIndex];
      updatedActivities[currentIndex] = updatedActivities[currentIndex - 1];
      updatedActivities[currentIndex - 1] = temp;

      final updatedDayPlan = dayPlan.copyWith(activities: updatedActivities);
      final updatedDays = List<DayPlan>.from(trip.days);
      updatedDays[dayIndex] = updatedDayPlan;

      final updatedTrip = trip.copyWith(
        days: updatedDays,
        updatedAt: DateTime.now(),
      );

      // 儲存更新
      await tripRepository.saveTrip(updatedTrip);

      // 刷新相關的 provider
      _ref.invalidate(tripProvider(tripId));
      _ref.invalidate(userTripsProvider);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '移動活動失敗: ${e.toString()}',
      );
      return false;
    }
  }

  /// 向下移動活動
  Future<bool> moveActivityDown(
    String tripId,
    int dayIndex,
    Activity activity,
  ) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // 獲取行程資料
      final storageManager = StorageManager.instance;
      final tripRepository = storageManager.tripRepository;
      final trip = await tripRepository.getTripById(tripId);

      if (trip == null) {
        state = state.copyWith(
          isLoading: false,
          error: '找不到行程資料',
        );
        return false;
      }

      final dayPlan = trip.days[dayIndex];
      final currentIndex = dayPlan.activities.indexWhere((a) => a.id == activity.id);
      
      if (currentIndex < 0 || currentIndex >= dayPlan.activities.length - 1) {
        state = state.copyWith(isLoading: false);
        return false; // 已經在最下面或找不到活動
      }

      // 交換活動位置
      final updatedActivities = List<Activity>.from(dayPlan.activities);
      final temp = updatedActivities[currentIndex];
      updatedActivities[currentIndex] = updatedActivities[currentIndex + 1];
      updatedActivities[currentIndex + 1] = temp;

      final updatedDayPlan = dayPlan.copyWith(activities: updatedActivities);
      final updatedDays = List<DayPlan>.from(trip.days);
      updatedDays[dayIndex] = updatedDayPlan;

      final updatedTrip = trip.copyWith(
        days: updatedDays,
        updatedAt: DateTime.now(),
      );

      // 儲存更新
      await tripRepository.saveTrip(updatedTrip);

      // 刷新相關的 provider
      _ref.invalidate(tripProvider(tripId));
      _ref.invalidate(userTripsProvider);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '移動活動失敗: ${e.toString()}',
      );
      return false;
    }
  }

  /// 跨日期移動活動
  Future<bool> moveActivityBetweenDays(
    String tripId,
    int fromDayIndex,
    int toDayIndex,
    Activity activity,
  ) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // 獲取行程資料
      final storageManager = StorageManager.instance;
      final tripRepository = storageManager.tripRepository;
      final trip = await tripRepository.getTripById(tripId);

      if (trip == null) {
        state = state.copyWith(
          isLoading: false,
          error: '找不到行程資料',
        );
        return false;
      }

      // 使用服務層進行跨日期移動
      final updatedTrip = ActivityEditServiceExtended.moveActivityBetweenDays(
        trip,
        fromDayIndex,
        toDayIndex,
        activity,
      );

      // 儲存更新並觸發自動儲存
      await tripRepository.saveTrip(updatedTrip);
      _triggerAutoSave(updatedTrip);

      // 刷新相關的 provider
      _ref.invalidate(tripProvider(tripId));
      _ref.invalidate(userTripsProvider);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '跨日期移動活動失敗: ${e.toString()}',
      );
      return false;
    }
  }

  /// 批量刪除活動
  Future<bool> batchDeleteActivities(
    String tripId,
    List<ActivityReference> activityRefs,
  ) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // 獲取行程資料
      final storageManager = StorageManager.instance;
      final tripRepository = storageManager.tripRepository;
      final trip = await tripRepository.getTripById(tripId);

      if (trip == null) {
        state = state.copyWith(
          isLoading: false,
          error: '找不到行程資料',
        );
        return false;
      }

      // 使用服務層進行批量刪除
      final updatedTrip = ActivityEditServiceExtended.batchDeleteActivities(trip, activityRefs);

      // 儲存更新並觸發自動儲存
      await tripRepository.saveTrip(updatedTrip);
      _triggerAutoSave(updatedTrip);

      // 刷新相關的 provider
      _ref.invalidate(tripProvider(tripId));
      _ref.invalidate(userTripsProvider);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '批量刪除活動失敗: ${e.toString()}',
      );
      return false;
    }
  }

  /// 最佳化行程路線
  Future<bool> optimizeTripRoute(
    String tripId, {
    TransportMode transportMode = TransportMode.walking,
    bool preserveTimeConstraints = true,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // 獲取行程資料
      final storageManager = StorageManager.instance;
      final tripRepository = storageManager.tripRepository;
      final trip = await tripRepository.getTripById(tripId);

      if (trip == null) {
        state = state.copyWith(
          isLoading: false,
          error: '找不到行程資料',
        );
        return false;
      }

      // 使用服務層進行路線最佳化
      final optimizedTrip = ActivityEditServiceExtended.optimizeTripRoute(
        trip,
        transportMode: transportMode,
        preserveTimeConstraints: preserveTimeConstraints,
      );

      // 儲存更新並觸發自動儲存
      await tripRepository.saveTrip(optimizedTrip);
      _triggerAutoSave(optimizedTrip);

      // 刷新相關的 provider
      _ref.invalidate(tripProvider(tripId));
      _ref.invalidate(userTripsProvider);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '路線最佳化失敗: ${e.toString()}',
      );
      return false;
    }
  }

  /// 自動調整行程時間
  Future<bool> autoAdjustTripTiming(
    String tripId,
    TransportMode transportMode,
  ) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // 獲取行程資料
      final storageManager = StorageManager.instance;
      final tripRepository = storageManager.tripRepository;
      final trip = await tripRepository.getTripById(tripId);

      if (trip == null) {
        state = state.copyWith(
          isLoading: false,
          error: '找不到行程資料',
        );
        return false;
      }

      // 使用服務層進行時間調整
      final adjustedTrip = ActivityEditServiceExtended.autoAdjustTripTiming(trip, transportMode);

      // 儲存更新並觸發自動儲存
      await tripRepository.saveTrip(adjustedTrip);
      _triggerAutoSave(adjustedTrip);

      // 刷新相關的 provider
      _ref.invalidate(tripProvider(tripId));
      _ref.invalidate(userTripsProvider);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '自動調整時間失敗: ${e.toString()}',
      );
      return false;
    }
  }

  /// 觸發自動儲存
  void _triggerAutoSave(Trip trip) {
    // 暫時禁用自動儲存以避免狀態管理問題
    // TODO: 修復自動儲存的狀態管理問題後重新啟用
    /*
    try {
      final autoSaveNotifier = _ref.read(autoSaveProvider.notifier);
      autoSaveNotifier.markTripForSave(trip);
    } catch (e) {
      print('觸發自動儲存失敗: $e');
    }
    */
    print('自動儲存已暫時禁用');
  }

  /// 清除錯誤訊息
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// 活動編輯 Provider
final activityEditProvider = StateNotifierProvider<ActivityEditNotifier, ActivityEditState>((ref) {
  return ActivityEditNotifier(ref);
});

/// 當前編輯的活動 Provider
final currentEditingActivityProvider = Provider<Activity?>((ref) {
  return ref.watch(activityEditProvider).editingActivity;
});

/// 編輯狀態 Provider
final isEditingActivityProvider = Provider<bool>((ref) {
  return ref.watch(activityEditProvider).isEditing;
});

/// 編輯錯誤 Provider
final activityEditErrorProvider = Provider<String?>((ref) {
  return ref.watch(activityEditProvider).error;
});

/// 編輯載入狀態 Provider
final activityEditLoadingProvider = Provider<bool>((ref) {
  return ref.watch(activityEditProvider).isLoading;
});

/// 路線最佳化 Provider
final routeOptimizationProvider = FutureProvider.family<OptimizationResult, RouteOptimizationParams>((ref, params) async {
  return RouteOptimizationService.optimizeDayActivities(
    params.activities,
    transportMode: params.transportMode,
    preserveTimeConstraints: params.preserveTimeConstraints,
  );
});

/// 行程詳細統計 Provider
final tripDetailStatisticsProvider = FutureProvider.family<TripStatisticsInfo, TripStatisticsParams>((ref, params) async {
  return ActivityEditServiceExtended.calculateTripStatistics(params.trip, params.transportMode);
});

/// 時間驗證 Provider
final tripTimingValidationProvider = FutureProvider.family<TripValidationResult, TripValidationParams>((ref, params) async {
  return ActivityEditServiceExtended.validateTripTiming(params.trip, params.transportMode);
});

/// 路線最佳化參數
class RouteOptimizationParams {
  final List<Activity> activities;
  final TransportMode transportMode;
  final bool preserveTimeConstraints;

  const RouteOptimizationParams({
    required this.activities,
    required this.transportMode,
    required this.preserveTimeConstraints,
  });
}

/// 行程統計參數
class TripStatisticsParams {
  final Trip trip;
  final TransportMode transportMode;

  const TripStatisticsParams({
    required this.trip,
    required this.transportMode,
  });
}

/// 行程驗證參數
class TripValidationParams {
  final Trip trip;
  final TransportMode transportMode;

  const TripValidationParams({
    required this.trip,
    required this.transportMode,
  });
}