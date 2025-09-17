/// TripMuse 行程編輯模式狀態管理
///
/// 管理行程詳細頁面的編輯模式狀態

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 編輯模式狀態
class TripEditModeState {
  final bool isEditMode;
  final String? editingTripId;

  const TripEditModeState({
    this.isEditMode = false,
    this.editingTripId,
  });

  TripEditModeState copyWith({
    bool? isEditMode,
    String? editingTripId,
  }) {
    return TripEditModeState(
      isEditMode: isEditMode ?? this.isEditMode,
      editingTripId: editingTripId ?? this.editingTripId,
    );
  }
}

/// 編輯模式 Notifier
class TripEditModeNotifier extends StateNotifier<TripEditModeState> {
  TripEditModeNotifier() : super(const TripEditModeState());

  /// 進入編輯模式
  void enterEditMode(String tripId) {
    state = TripEditModeState(
      isEditMode: true,
      editingTripId: tripId,
    );
  }

  /// 退出編輯模式
  void exitEditMode() {
    state = const TripEditModeState();
  }

  /// 切換編輯模式
  void toggleEditMode(String tripId) {
    if (state.isEditMode && state.editingTripId == tripId) {
      exitEditMode();
    } else {
      enterEditMode(tripId);
    }
  }

  /// 檢查是否為指定行程的編輯模式
  bool isEditingTrip(String tripId) {
    return state.isEditMode && state.editingTripId == tripId;
  }
}

/// 編輯模式 Provider
final tripEditModeProvider = StateNotifierProvider<TripEditModeNotifier, TripEditModeState>((ref) {
  return TripEditModeNotifier();
});

/// 當前是否為編輯模式 Provider
final isEditModeProvider = Provider<bool>((ref) {
  return ref.watch(tripEditModeProvider).isEditMode;
});

/// 當前編輯的行程 ID Provider
final editingTripIdProvider = Provider<String?>((ref) {
  return ref.watch(tripEditModeProvider).editingTripId;
});

/// 檢查特定行程是否在編輯模式 Provider
final isEditingTripProvider = Provider.family<bool, String>((ref, tripId) {
  final editModeState = ref.watch(tripEditModeProvider);
  return editModeState.isEditMode && editModeState.editingTripId == tripId;
});