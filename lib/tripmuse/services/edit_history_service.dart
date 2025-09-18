/// TripMuse 編輯歷史服務
/// 
/// 提供編輯歷史記錄、復原(Undo)和重做(Redo)功能

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'storage/storage_service.dart';

/// 編輯動作類型
enum EditActionType {
  createTrip,
  updateTrip,
  deleteTrip,
  addActivity,
  updateActivity,
  deleteActivity,
  moveActivity,
  reorderActivities,
  updateDayPlan,
}

/// 編輯動作
class EditAction {
  final String id;
  final String tripId;
  final EditActionType type;
  final DateTime timestamp;
  final Map<String, dynamic> beforeState;
  final Map<String, dynamic> afterState;
  final String description;
  
  const EditAction({
    required this.id,
    required this.tripId,
    required this.type,
    required this.timestamp,
    required this.beforeState,
    required this.afterState,
    required this.description,
  });
  
  factory EditAction.fromJson(Map<String, dynamic> json) {
    return EditAction(
      id: json['id'] as String,
      tripId: json['tripId'] as String,
      type: EditActionType.values[json['type'] as int],
      timestamp: DateTime.parse(json['timestamp'] as String),
      beforeState: Map<String, dynamic>.from(json['beforeState'] as Map),
      afterState: Map<String, dynamic>.from(json['afterState'] as Map),
      description: json['description'] as String,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'type': type.index,
      'timestamp': timestamp.toIso8601String(),
      'beforeState': beforeState,
      'afterState': afterState,
      'description': description,
    };
  }
}

/// 編輯歷史狀態
class EditHistoryState {
  final List<EditAction> undoStack;
  final List<EditAction> redoStack;
  final int maxHistorySize;
  final bool isRecording;
  
  const EditHistoryState({
    this.undoStack = const [],
    this.redoStack = const [],
    this.maxHistorySize = 50,
    this.isRecording = true,
  });
  
  EditHistoryState copyWith({
    List<EditAction>? undoStack,
    List<EditAction>? redoStack,
    int? maxHistorySize,
    bool? isRecording,
  }) {
    return EditHistoryState(
      undoStack: undoStack ?? this.undoStack,
      redoStack: redoStack ?? this.redoStack,
      maxHistorySize: maxHistorySize ?? this.maxHistorySize,
      isRecording: isRecording ?? this.isRecording,
    );
  }
  
  bool get canUndo => undoStack.isNotEmpty;
  bool get canRedo => redoStack.isNotEmpty;
  
  String? get nextUndoDescription => 
      undoStack.isNotEmpty ? undoStack.last.description : null;
  
  String? get nextRedoDescription => 
      redoStack.isNotEmpty ? redoStack.last.description : null;
}

/// 編輯歷史服務
class EditHistoryService {
  static const String _historyKey = 'edit_history';
  static const int _defaultMaxHistorySize = 50;
  
  final HiveStorageService _storageService;
  final Map<String, EditHistoryState> _tripHistories = {};
  
  EditHistoryService({required HiveStorageService storageService})
      : _storageService = storageService;
  
  /// 初始化服務
  Future<void> initialize() async {
    await _loadHistories();
  }
  
  /// 記錄編輯動作
  Future<void> recordAction({
    required String tripId,
    required EditActionType type,
    required Map<String, dynamic> beforeState,
    required Map<String, dynamic> afterState,
    required String description,
  }) async {
    final history = _getOrCreateHistory(tripId);
    
    if (!history.isRecording) return;
    
    final action = EditAction(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      tripId: tripId,
      type: type,
      timestamp: DateTime.now(),
      beforeState: beforeState,
      afterState: afterState,
      description: description,
    );
    
    // 添加到 undo 堆疊
    final newUndoStack = List<EditAction>.from(history.undoStack)..add(action);
    
    // 限制歷史大小
    if (newUndoStack.length > history.maxHistorySize) {
      newUndoStack.removeAt(0);
    }
    
    // 清空 redo 堆疊（新動作會使 redo 無效）
    final newHistory = history.copyWith(
      undoStack: newUndoStack,
      redoStack: [],
    );
    
    _tripHistories[tripId] = newHistory;
    await _saveHistory(tripId, newHistory);
  }
  
  /// 復原動作
  Future<Map<String, dynamic>?> undo(String tripId) async {
    final history = _getOrCreateHistory(tripId);
    
    if (!history.canUndo) return null;
    
    final actionToUndo = history.undoStack.last;
    
    // 移動到 redo 堆疊
    final newUndoStack = List<EditAction>.from(history.undoStack)..removeLast();
    final newRedoStack = List<EditAction>.from(history.redoStack)..add(actionToUndo);
    
    final newHistory = history.copyWith(
      undoStack: newUndoStack,
      redoStack: newRedoStack,
    );
    
    _tripHistories[tripId] = newHistory;
    await _saveHistory(tripId, newHistory);
    
    return actionToUndo.beforeState;
  }
  
  /// 重做動作
  Future<Map<String, dynamic>?> redo(String tripId) async {
    final history = _getOrCreateHistory(tripId);
    
    if (!history.canRedo) return null;
    
    final actionToRedo = history.redoStack.last;
    
    // 移動到 undo 堆疊
    final newRedoStack = List<EditAction>.from(history.redoStack)..removeLast();
    final newUndoStack = List<EditAction>.from(history.undoStack)..add(actionToRedo);
    
    final newHistory = history.copyWith(
      undoStack: newUndoStack,
      redoStack: newRedoStack,
    );
    
    _tripHistories[tripId] = newHistory;
    await _saveHistory(tripId, newHistory);
    
    return actionToRedo.afterState;
  }
  
  /// 取得編輯歷史狀態
  EditHistoryState getHistoryState(String tripId) {
    return _getOrCreateHistory(tripId);
  }
  
  /// 清除歷史記錄
  Future<void> clearHistory(String tripId) async {
    _tripHistories[tripId] = const EditHistoryState();
    await _saveHistory(tripId, const EditHistoryState());
  }
  
  /// 暫停記錄
  void pauseRecording(String tripId) {
    final history = _getOrCreateHistory(tripId);
    _tripHistories[tripId] = history.copyWith(isRecording: false);
  }
  
  /// 恢復記錄
  void resumeRecording(String tripId) {
    final history = _getOrCreateHistory(tripId);
    _tripHistories[tripId] = history.copyWith(isRecording: true);
  }
  
  /// 取得或建立歷史記錄
  EditHistoryState _getOrCreateHistory(String tripId) {
    return _tripHistories[tripId] ?? const EditHistoryState();
  }
  
  /// 載入歷史記錄
  Future<void> _loadHistories() async {
    try {
      final historiesData = await _storageService.retrieve<Map<String, dynamic>>(_historyKey);
      if (historiesData == null) return;
      
      for (final entry in historiesData.entries) {
        final tripId = entry.key;
        final historyData = entry.value as Map<String, dynamic>;
        
        final undoStack = (historyData['undoStack'] as List<dynamic>? ?? [])
            .map((item) => EditAction.fromJson(item as Map<String, dynamic>))
            .toList();
        
        final redoStack = (historyData['redoStack'] as List<dynamic>? ?? [])
            .map((item) => EditAction.fromJson(item as Map<String, dynamic>))
            .toList();
        
        _tripHistories[tripId] = EditHistoryState(
          undoStack: undoStack,
          redoStack: redoStack,
          maxHistorySize: historyData['maxHistorySize'] as int? ?? _defaultMaxHistorySize,
          isRecording: historyData['isRecording'] as bool? ?? true,
        );
      }
    } catch (e) {
      print('載入編輯歷史失敗: $e');
    }
  }
  
  /// 儲存單一歷史記錄
  Future<void> _saveHistory(String tripId, EditHistoryState history) async {
    try {
      final historiesData = await _storageService.retrieve<Map<String, dynamic>>(_historyKey) ?? {};
      
      historiesData[tripId] = {
        'undoStack': history.undoStack.map((action) => action.toJson()).toList(),
        'redoStack': history.redoStack.map((action) => action.toJson()).toList(),
        'maxHistorySize': history.maxHistorySize,
        'isRecording': history.isRecording,
      };
      
      await _storageService.store(_historyKey, historiesData);
    } catch (e) {
      print('儲存編輯歷史失敗: $e');
    }
  }
}

/// 編輯歷史 Notifier
class EditHistoryNotifier extends StateNotifier<EditHistoryState> {
  EditHistoryNotifier({
    required this.tripId,
    required this.editHistoryService,
  }) : super(const EditHistoryState()) {
    _loadHistory();
  }
  
  final String tripId;
  final EditHistoryService editHistoryService;
  
  /// 載入歷史記錄
  void _loadHistory() {
    state = editHistoryService.getHistoryState(tripId);
  }
  
  /// 記錄編輯動作
  Future<void> recordAction({
    required EditActionType type,
    required Map<String, dynamic> beforeState,
    required Map<String, dynamic> afterState,
    required String description,
  }) async {
    await editHistoryService.recordAction(
      tripId: tripId,
      type: type,
      beforeState: beforeState,
      afterState: afterState,
      description: description,
    );
    _loadHistory();
  }
  
  /// 復原
  Future<Map<String, dynamic>?> undo() async {
    final result = await editHistoryService.undo(tripId);
    _loadHistory();
    return result;
  }
  
  /// 重做
  Future<Map<String, dynamic>?> redo() async {
    final result = await editHistoryService.redo(tripId);
    _loadHistory();
    return result;
  }
  
  /// 清除歷史
  Future<void> clearHistory() async {
    await editHistoryService.clearHistory(tripId);
    _loadHistory();
  }
  
  /// 暫停記錄
  void pauseRecording() {
    editHistoryService.pauseRecording(tripId);
    _loadHistory();
  }
  
  /// 恢復記錄
  void resumeRecording() {
    editHistoryService.resumeRecording(tripId);
    _loadHistory();
  }
}

/// 編輯歷史服務 Provider
final editHistoryServiceProvider = Provider<EditHistoryService>((ref) {
  final storageService = ref.watch(offlineStorageServiceProvider);
  return EditHistoryService(storageService: storageService);
});

/// 編輯歷史 Provider
final editHistoryProvider = StateNotifierProvider.family<EditHistoryNotifier, EditHistoryState, String>((ref, tripId) {
  final service = ref.watch(editHistoryServiceProvider);
  return EditHistoryNotifier(tripId: tripId, editHistoryService: service);
});

/// 儲存服務 Provider（重新命名以避免衝突）
final offlineStorageServiceProvider = Provider<HiveStorageService>((ref) {
  final service = HiveStorageService();
  // 注意：這裡不能直接調用 initialize()，因為 Provider 必須同步返回
  // 初始化應該在應用啟動時完成
  return service;
});