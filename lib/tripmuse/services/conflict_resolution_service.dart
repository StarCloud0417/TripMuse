/// TripMuse 同步衝突檢測和解決服務
/// 
/// 處理本地和雲端資料的同步衝突，提供多種解決策略

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'storage/storage_service.dart';
import 'edit_history_service.dart';

/// 衝突類型
enum ConflictType {
  tripModified,      // 行程被修改
  activityModified,  // 活動被修改
  dayPlanModified,   // 日程計畫被修改
  tripDeleted,       // 行程被刪除
  activityDeleted,   // 活動被刪除
}

/// 衝突解決策略
enum ConflictResolutionStrategy {
  useLocal,          // 使用本地版本
  useRemote,         // 使用遠端版本
  merge,             // 合併版本
  askUser,           // 詢問使用者
  createCopy,        // 建立副本
}

/// 同步衝突
class SyncConflict {
  final String id;
  final String tripId;
  final ConflictType type;
  final DateTime detectedAt;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> remoteData;
  final DateTime localModifiedAt;
  final DateTime remoteModifiedAt;
  final String? activityId;
  final int? dayIndex;
  final bool isResolved;
  final ConflictResolutionStrategy? resolvedWith;
  final DateTime? resolvedAt;
  
  const SyncConflict({
    required this.id,
    required this.tripId,
    required this.type,
    required this.detectedAt,
    required this.localData,
    required this.remoteData,
    required this.localModifiedAt,
    required this.remoteModifiedAt,
    this.activityId,
    this.dayIndex,
    this.isResolved = false,
    this.resolvedWith,
    this.resolvedAt,
  });
  
  factory SyncConflict.fromJson(Map<String, dynamic> json) {
    return SyncConflict(
      id: json['id'] as String,
      tripId: json['tripId'] as String,
      type: ConflictType.values[json['type'] as int],
      detectedAt: DateTime.parse(json['detectedAt'] as String),
      localData: Map<String, dynamic>.from(json['localData'] as Map),
      remoteData: Map<String, dynamic>.from(json['remoteData'] as Map),
      localModifiedAt: DateTime.parse(json['localModifiedAt'] as String),
      remoteModifiedAt: DateTime.parse(json['remoteModifiedAt'] as String),
      activityId: json['activityId'] as String?,
      dayIndex: json['dayIndex'] as int?,
      isResolved: json['isResolved'] as bool? ?? false,
      resolvedWith: json['resolvedWith'] != null 
          ? ConflictResolutionStrategy.values[json['resolvedWith'] as int]
          : null,
      resolvedAt: json['resolvedAt'] != null 
          ? DateTime.parse(json['resolvedAt'] as String)
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'type': type.index,
      'detectedAt': detectedAt.toIso8601String(),
      'localData': localData,
      'remoteData': remoteData,
      'localModifiedAt': localModifiedAt.toIso8601String(),
      'remoteModifiedAt': remoteModifiedAt.toIso8601String(),
      'activityId': activityId,
      'dayIndex': dayIndex,
      'isResolved': isResolved,
      'resolvedWith': resolvedWith?.index,
      'resolvedAt': resolvedAt?.toIso8601String(),
    };
  }
  
  SyncConflict copyWith({
    String? id,
    String? tripId,
    ConflictType? type,
    DateTime? detectedAt,
    Map<String, dynamic>? localData,
    Map<String, dynamic>? remoteData,
    DateTime? localModifiedAt,
    DateTime? remoteModifiedAt,
    String? activityId,
    int? dayIndex,
    bool? isResolved,
    ConflictResolutionStrategy? resolvedWith,
    DateTime? resolvedAt,
  }) {
    return SyncConflict(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      type: type ?? this.type,
      detectedAt: detectedAt ?? this.detectedAt,
      localData: localData ?? this.localData,
      remoteData: remoteData ?? this.remoteData,
      localModifiedAt: localModifiedAt ?? this.localModifiedAt,
      remoteModifiedAt: remoteModifiedAt ?? this.remoteModifiedAt,
      activityId: activityId ?? this.activityId,
      dayIndex: dayIndex ?? this.dayIndex,
      isResolved: isResolved ?? this.isResolved,
      resolvedWith: resolvedWith ?? this.resolvedWith,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }
  
  /// 取得衝突描述
  String get description {
    switch (type) {
      case ConflictType.tripModified:
        return '行程已在其他裝置上被修改';
      case ConflictType.activityModified:
        return '活動已在其他裝置上被修改';
      case ConflictType.dayPlanModified:
        return '日程計畫已在其他裝置上被修改';
      case ConflictType.tripDeleted:
        return '行程已在其他裝置上被刪除';
      case ConflictType.activityDeleted:
        return '活動已在其他裝置上被刪除';
    }
  }
  
  /// 是否為刪除衝突
  bool get isDeletionConflict => 
      type == ConflictType.tripDeleted || type == ConflictType.activityDeleted;
  
  /// 本地版本較新
  bool get isLocalNewer => localModifiedAt.isAfter(remoteModifiedAt);
  
  /// 遠端版本較新
  bool get isRemoteNewer => remoteModifiedAt.isAfter(localModifiedAt);
}

/// 衝突解決結果
class ConflictResolutionResult {
  final String conflictId;
  final ConflictResolutionStrategy strategy;
  final Map<String, dynamic> resolvedData;
  final bool requiresUserAction;
  final String? message;
  
  const ConflictResolutionResult({
    required this.conflictId,
    required this.strategy,
    required this.resolvedData,
    this.requiresUserAction = false,
    this.message,
  });
}

/// 衝突解決服務
class ConflictResolutionService {
  static const String _conflictsKey = 'sync_conflicts';
  
  final HiveStorageService _storageService;
  final StreamController<List<SyncConflict>> _conflictsController = 
      StreamController<List<SyncConflict>>.broadcast();
  
  List<SyncConflict> _conflicts = [];
  
  ConflictResolutionService({
    required HiveStorageService storageService,
  }) : _storageService = storageService {
    _loadConflicts();
  }
  
  /// 當前衝突列表
  List<SyncConflict> get conflicts => List.unmodifiable(_conflicts);
  
  /// 衝突串流
  Stream<List<SyncConflict>> get conflictsStream => _conflictsController.stream;
  
  /// 是否有未解決的衝突
  bool get hasUnresolvedConflicts => _conflicts.any((c) => !c.isResolved);
  
  /// 未解決的衝突數量
  int get unresolvedConflictCount => _conflicts.where((c) => !c.isResolved).length;
  
  /// 檢測衝突
  Future<SyncConflict?> detectConflict({
    required String tripId,
    required Map<String, dynamic> localData,
    required Map<String, dynamic> remoteData,
    required DateTime localModifiedAt,
    required DateTime remoteModifiedAt,
    String? activityId,
    int? dayIndex,
  }) async {
    // 如果修改時間相同，沒有衝突
    if (localModifiedAt.isAtSameMomentAs(remoteModifiedAt)) {
      return null;
    }
    
    // 檢查資料是否不同
    if (_areDataEqual(localData, remoteData)) {
      return null;
    }
    
    // 確定衝突類型
    ConflictType conflictType;
    if (activityId != null) {
      if (remoteData.isEmpty) {
        conflictType = ConflictType.activityDeleted;
      } else {
        conflictType = ConflictType.activityModified;
      }
    } else if (dayIndex != null) {
      conflictType = ConflictType.dayPlanModified;
    } else {
      if (remoteData.isEmpty) {
        conflictType = ConflictType.tripDeleted;
      } else {
        conflictType = ConflictType.tripModified;
      }
    }
    
    final conflict = SyncConflict(
      id: '${DateTime.now().millisecondsSinceEpoch}_${tripId}',
      tripId: tripId,
      type: conflictType,
      detectedAt: DateTime.now(),
      localData: localData,
      remoteData: remoteData,
      localModifiedAt: localModifiedAt,
      remoteModifiedAt: remoteModifiedAt,
      activityId: activityId,
      dayIndex: dayIndex,
    );
    
    await _addConflict(conflict);
    return conflict;
  }
  
  /// 自動解決衝突
  Future<ConflictResolutionResult?> autoResolveConflict(
    String conflictId,
    ConflictResolutionStrategy strategy,
  ) async {
    final conflict = _conflicts.firstWhere(
      (c) => c.id == conflictId,
      orElse: () => throw ArgumentError('找不到衝突: $conflictId'),
    );
    
    if (conflict.isResolved) {
      throw StateError('衝突已經被解決');
    }
    
    Map<String, dynamic> resolvedData;
    String? message;
    
    switch (strategy) {
      case ConflictResolutionStrategy.useLocal:
        resolvedData = conflict.localData;
        message = '使用本地版本';
        break;
        
      case ConflictResolutionStrategy.useRemote:
        resolvedData = conflict.remoteData;
        message = '使用遠端版本';
        break;
        
      case ConflictResolutionStrategy.merge:
        resolvedData = await _mergeData(conflict);
        message = '合併版本';
        break;
        
      case ConflictResolutionStrategy.createCopy:
        resolvedData = await _createCopyData(conflict);
        message = '建立副本';
        break;
        
      case ConflictResolutionStrategy.askUser:
        return ConflictResolutionResult(
          conflictId: conflictId,
          strategy: strategy,
          resolvedData: {},
          requiresUserAction: true,
          message: '需要使用者選擇',
        );
    }
    
    // 標記衝突為已解決
    await _markConflictResolved(conflictId, strategy);
    
    return ConflictResolutionResult(
      conflictId: conflictId,
      strategy: strategy,
      resolvedData: resolvedData,
      message: message,
    );
  }
  
  /// 手動解決衝突
  Future<void> manualResolveConflict(
    String conflictId,
    ConflictResolutionStrategy strategy,
    Map<String, dynamic> resolvedData,
  ) async {
    await _markConflictResolved(conflictId, strategy);
  }
  
  /// 取得建議的解決策略
  ConflictResolutionStrategy getSuggestedStrategy(SyncConflict conflict) {
    // 刪除衝突的處理
    if (conflict.isDeletionConflict) {
      if (conflict.isLocalNewer) {
        return ConflictResolutionStrategy.useLocal;
      } else {
        return ConflictResolutionStrategy.useRemote;
      }
    }
    
    // 根據修改時間建議策略
    if (conflict.isLocalNewer) {
      return ConflictResolutionStrategy.useLocal;
    } else if (conflict.isRemoteNewer) {
      return ConflictResolutionStrategy.useRemote;
    } else {
      // 時間相同，嘗試合併
      return ConflictResolutionStrategy.merge;
    }
  }
  
  /// 清除已解決的衝突
  Future<void> clearResolvedConflicts() async {
    _conflicts.removeWhere((c) => c.isResolved);
    await _saveConflicts();
    _conflictsController.add(_conflicts);
  }
  
  /// 清除所有衝突
  Future<void> clearAllConflicts() async {
    _conflicts.clear();
    await _saveConflicts();
    _conflictsController.add(_conflicts);
  }
  
  /// 合併資料
  Future<Map<String, dynamic>> _mergeData(SyncConflict conflict) async {
    final localData = Map<String, dynamic>.from(conflict.localData);
    final remoteData = Map<String, dynamic>.from(conflict.remoteData);
    
    // 簡單的合併策略：本地優先，但保留遠端的新欄位
    final mergedData = Map<String, dynamic>.from(remoteData);
    
    for (final entry in localData.entries) {
      final key = entry.key;
      final localValue = entry.value;
      
      if (!remoteData.containsKey(key)) {
        // 本地有但遠端沒有的欄位，保留本地版本
        mergedData[key] = localValue;
      } else {
        final remoteValue = remoteData[key];
        
        // 特殊欄位的合併邏輯
        if (key == 'title' || key == 'description') {
          // 標題和描述使用較新的版本
          if (conflict.isLocalNewer) {
            mergedData[key] = localValue;
          }
        } else if (key == 'activities' && localValue is List && remoteValue is List) {
          // 活動列表的合併
          mergedData[key] = _mergeActivityLists(localValue, remoteValue);
        } else if (key == 'updatedAt') {
          // 更新時間使用較新的
          mergedData[key] = conflict.isLocalNewer 
              ? conflict.localModifiedAt.toIso8601String()
              : conflict.remoteModifiedAt.toIso8601String();
        } else {
          // 其他欄位使用本地版本
          mergedData[key] = localValue;
        }
      }
    }
    
    return mergedData;
  }
  
  /// 合併活動列表
  List<dynamic> _mergeActivityLists(List<dynamic> localActivities, List<dynamic> remoteActivities) {
    final mergedActivities = <Map<String, dynamic>>[];
    final processedIds = <String>{};
    
    // 處理本地活動
    for (final activity in localActivities) {
      if (activity is Map<String, dynamic>) {
        final id = activity['id'] as String?;
        if (id != null) {
          mergedActivities.add(activity);
          processedIds.add(id);
        }
      }
    }
    
    // 處理遠端活動（只添加本地沒有的）
    for (final activity in remoteActivities) {
      if (activity is Map<String, dynamic>) {
        final id = activity['id'] as String?;
        if (id != null && !processedIds.contains(id)) {
          mergedActivities.add(activity);
        }
      }
    }
    
    return mergedActivities;
  }
  
  /// 建立副本資料
  Future<Map<String, dynamic>> _createCopyData(SyncConflict conflict) async {
    final localData = Map<String, dynamic>.from(conflict.localData);
    
    // 修改標題以表示這是副本
    if (localData.containsKey('title')) {
      final originalTitle = localData['title'] as String;
      localData['title'] = '$originalTitle (副本)';
    }
    
    // 生成新的 ID
    localData['id'] = '${DateTime.now().millisecondsSinceEpoch}_copy';
    localData['createdAt'] = DateTime.now().toIso8601String();
    localData['updatedAt'] = DateTime.now().toIso8601String();
    
    return localData;
  }
  
  /// 比較兩個資料是否相等
  bool _areDataEqual(Map<String, dynamic> data1, Map<String, dynamic> data2) {
    // 簡單的深度比較
    if (data1.length != data2.length) return false;
    
    for (final entry in data1.entries) {
      final key = entry.key;
      final value1 = entry.value;
      
      if (!data2.containsKey(key)) return false;
      
      final value2 = data2[key];
      
      // 忽略時間戳欄位的比較
      if (key == 'updatedAt' || key == 'createdAt') continue;
      
      if (value1 != value2) return false;
    }
    
    return true;
  }
  
  /// 新增衝突
  Future<void> _addConflict(SyncConflict conflict) async {
    _conflicts.add(conflict);
    await _saveConflicts();
    _conflictsController.add(_conflicts);
  }
  
  /// 標記衝突為已解決
  Future<void> _markConflictResolved(
    String conflictId,
    ConflictResolutionStrategy strategy,
  ) async {
    final index = _conflicts.indexWhere((c) => c.id == conflictId);
    if (index >= 0) {
      _conflicts[index] = _conflicts[index].copyWith(
        isResolved: true,
        resolvedWith: strategy,
        resolvedAt: DateTime.now(),
      );
      
      await _saveConflicts();
      _conflictsController.add(_conflicts);
    }
  }
  
  /// 載入衝突
  Future<void> _loadConflicts() async {
    try {
      final conflictsData = await _storageService.retrieve<List<dynamic>>(_conflictsKey);
      if (conflictsData == null) return;
      
      _conflicts = conflictsData
          .map((item) => SyncConflict.fromJson(item as Map<String, dynamic>))
          .toList();
      
      _conflictsController.add(_conflicts);
    } catch (e) {
      print('載入同步衝突失敗: $e');
    }
  }
  
  /// 儲存衝突
  Future<void> _saveConflicts() async {
    try {
      final conflictsData = _conflicts.map((c) => c.toJson()).toList();
      await _storageService.store(_conflictsKey, conflictsData);
    } catch (e) {
      print('儲存同步衝突失敗: $e');
    }
  }
  
  /// 釋放資源
  void dispose() {
    _conflictsController.close();
  }
}

/// 衝突解決 Notifier
class ConflictResolutionNotifier extends StateNotifier<List<SyncConflict>> {
  ConflictResolutionNotifier({
    required this.conflictResolutionService,
  }) : super([]) {
    _initialize();
  }
  
  final ConflictResolutionService conflictResolutionService;
  StreamSubscription<List<SyncConflict>>? _conflictsSubscription;
  
  void _initialize() {
    _conflictsSubscription = conflictResolutionService.conflictsStream.listen((conflicts) {
      state = conflicts;
    });
    
    // 設定初始狀態
    state = conflictResolutionService.conflicts;
  }
  
  /// 自動解決衝突
  Future<ConflictResolutionResult?> autoResolveConflict(
    String conflictId,
    ConflictResolutionStrategy strategy,
  ) async {
    return await conflictResolutionService.autoResolveConflict(conflictId, strategy);
  }
  
  /// 手動解決衝突
  Future<void> manualResolveConflict(
    String conflictId,
    ConflictResolutionStrategy strategy,
    Map<String, dynamic> resolvedData,
  ) async {
    await conflictResolutionService.manualResolveConflict(conflictId, strategy, resolvedData);
  }
  
  /// 取得建議策略
  ConflictResolutionStrategy getSuggestedStrategy(SyncConflict conflict) {
    return conflictResolutionService.getSuggestedStrategy(conflict);
  }
  
  /// 清除已解決的衝突
  Future<void> clearResolvedConflicts() async {
    await conflictResolutionService.clearResolvedConflicts();
  }
  
  /// 清除所有衝突
  Future<void> clearAllConflicts() async {
    await conflictResolutionService.clearAllConflicts();
  }
  
  @override
  void dispose() {
    _conflictsSubscription?.cancel();
    conflictResolutionService.dispose();
    super.dispose();
  }
}

/// 衝突解決服務 Provider
final conflictResolutionServiceProvider = Provider<ConflictResolutionService>((ref) {
  final storageService = ref.watch(offlineStorageServiceProvider);
  final service = ConflictResolutionService(storageService: storageService);
  ref.onDispose(() => service.dispose());
  return service;
});

/// 衝突解決 Provider
final conflictResolutionProvider = StateNotifierProvider<ConflictResolutionNotifier, List<SyncConflict>>((ref) {
  final service = ref.watch(conflictResolutionServiceProvider);
  return ConflictResolutionNotifier(conflictResolutionService: service);
});

/// 未解決衝突數量 Provider
final unresolvedConflictCountProvider = Provider<int>((ref) {
  final conflicts = ref.watch(conflictResolutionProvider);
  return conflicts.where((c) => !c.isResolved).length;
});