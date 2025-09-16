/// TripMuse 活動編輯狀態管理
///
/// 提供活動編輯相關的狀態管理和操作

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/activity_edit_service.dart';
import '../services/storage_manager.dart';

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
  ActivityEditNotifier() : super(const ActivityEditState());

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

  /// 清除錯誤訊息
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// 活動編輯 Provider
final activityEditProvider = StateNotifierProvider<ActivityEditNotifier, ActivityEditState>((ref) {
  return ActivityEditNotifier();
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