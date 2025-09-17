/// TripMuse 自動儲存服務
///
/// 提供行程自動儲存機制，確保編輯內容不會遺失

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'storage_manager.dart';

class AutoSaveService {
  static const Duration _autoSaveInterval = Duration(seconds: 30);
  static const Duration _debounceDelay = Duration(seconds: 3);
  
  Timer? _autoSaveTimer;
  Timer? _debounceTimer;
  String? _currentTripId;
  Trip? _pendingTrip;
  bool _isEnabled = true;
  
  final List<Function(String tripId, bool success)> _saveCallbacks = [];
  
  /// 啟用自動儲存
  void enable() {
    _isEnabled = true;
    _startAutoSaveTimer();
  }
  
  /// 停用自動儲存
  void disable() {
    _isEnabled = false;
    _stopTimers();
  }
  
  /// 設定當前編輯的行程
  void setCurrentTrip(String tripId) {
    _currentTripId = tripId;
    if (_isEnabled) {
      _startAutoSaveTimer();
    }
  }
  
  /// 標記行程需要儲存
  void markTripForSave(Trip trip) {
    if (!_isEnabled) return;
    
    _pendingTrip = trip;
    _currentTripId = trip.id;
    
    // 重置防抖計時器
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDelay, () {
      _saveImmediately();
    });
  }
  
  /// 立即儲存
  Future<bool> saveImmediately() async {
    return await _saveImmediately();
  }
  
  /// 添加儲存回調
  void addSaveCallback(Function(String tripId, bool success) callback) {
    _saveCallbacks.add(callback);
  }
  
  /// 移除儲存回調
  void removeSaveCallback(Function(String tripId, bool success) callback) {
    _saveCallbacks.remove(callback);
  }
  
  /// 清理資源
  void dispose() {
    _stopTimers();
    _saveCallbacks.clear();
  }
  
  /// 開始自動儲存計時器
  void _startAutoSaveTimer() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer.periodic(_autoSaveInterval, (timer) {
      if (_pendingTrip != null) {
        _saveImmediately();
      }
    });
  }
  
  /// 停止所有計時器
  void _stopTimers() {
    _autoSaveTimer?.cancel();
    _debounceTimer?.cancel();
    _autoSaveTimer = null;
    _debounceTimer = null;
  }
  
  /// 執行實際儲存
  Future<bool> _saveImmediately() async {
    if (_pendingTrip == null || _currentTripId == null) return false;
    
    try {
      final storageManager = StorageManager.instance;
      if (!storageManager.isInitialized) {
        await storageManager.initialize();
      }
      
      final tripRepository = storageManager.tripRepository;
      
      // 更新最後修改時間
      final tripToSave = _pendingTrip!.copyWith(
        updatedAt: DateTime.now(),
      );
      
      await tripRepository.saveTrip(tripToSave);
      
      // 清除待儲存狀態
      _pendingTrip = null;
      
      // 通知回調
      for (final callback in _saveCallbacks) {
        callback(_currentTripId!, true);
      }
      
      print('✅ 自動儲存成功: ${tripToSave.title}');
      return true;
    } catch (e) {
      print('❌ 自動儲存失敗: $e');
      
      // 通知回調
      for (final callback in _saveCallbacks) {
        callback(_currentTripId!, false);
      }
      
      return false;
    }
  }
}

/// 自動儲存狀態
class AutoSaveState {
  final bool isEnabled;
  final bool isSaving;
  final DateTime? lastSaveTime;
  final String? lastError;
  final String? currentTripId;
  
  const AutoSaveState({
    this.isEnabled = true,
    this.isSaving = false,
    this.lastSaveTime,
    this.lastError,
    this.currentTripId,
  });
  
  AutoSaveState copyWith({
    bool? isEnabled,
    bool? isSaving,
    DateTime? lastSaveTime,
    String? lastError,
    String? currentTripId,
  }) {
    return AutoSaveState(
      isEnabled: isEnabled ?? this.isEnabled,
      isSaving: isSaving ?? this.isSaving,
      lastSaveTime: lastSaveTime ?? this.lastSaveTime,
      lastError: lastError,
      currentTripId: currentTripId ?? this.currentTripId,
    );
  }
  
  /// 取得格式化的最後儲存時間
  String get formattedLastSaveTime {
    if (lastSaveTime == null) return '從未儲存';
    
    final now = DateTime.now();
    final difference = now.difference(lastSaveTime!);
    
    if (difference.inSeconds < 60) {
      return '剛剛儲存';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} 分鐘前儲存';
    } else {
      return '${difference.inHours} 小時前儲存';
    }
  }
}

/// 自動儲存 Notifier
class AutoSaveNotifier extends StateNotifier<AutoSaveState> {
  AutoSaveNotifier() : super(const AutoSaveState()) {
    _autoSaveService = AutoSaveService();
    _autoSaveService.addSaveCallback(_onSaveComplete);
  }
  
  late final AutoSaveService _autoSaveService;
  
  /// 啟用自動儲存
  void enable() {
    _autoSaveService.enable();
    state = state.copyWith(isEnabled: true);
  }
  
  /// 停用自動儲存
  void disable() {
    _autoSaveService.disable();
    state = state.copyWith(isEnabled: false);
  }
  
  /// 設定當前編輯的行程
  void setCurrentTrip(String tripId) {
    _autoSaveService.setCurrentTrip(tripId);
    state = state.copyWith(currentTripId: tripId);
  }
  
  /// 標記行程需要儲存
  void markTripForSave(Trip trip) {
    if (!state.isEnabled) return;
    
    _autoSaveService.markTripForSave(trip);
    state = state.copyWith(isSaving: true, lastError: null);
  }
  
  /// 立即儲存
  Future<bool> saveImmediately() async {
    if (!state.isEnabled) return false;
    
    state = state.copyWith(isSaving: true, lastError: null);
    return await _autoSaveService.saveImmediately();
  }
  
  /// 儲存完成回調
  void _onSaveComplete(String tripId, bool success) {
    if (success) {
      state = state.copyWith(
        isSaving: false,
        lastSaveTime: DateTime.now(),
        lastError: null,
      );
    } else {
      state = state.copyWith(
        isSaving: false,
        lastError: '儲存失敗',
      );
    }
  }
  
  @override
  void dispose() {
    _autoSaveService.dispose();
    super.dispose();
  }
}

/// 自動儲存 Provider
final autoSaveProvider = StateNotifierProvider<AutoSaveNotifier, AutoSaveState>((ref) {
  return AutoSaveNotifier();
});

/// 自動儲存服務 Provider
final autoSaveServiceProvider = Provider<AutoSaveService>((ref) {
  // 創建一個獨立的 AutoSaveService 實例
  return AutoSaveService();
});