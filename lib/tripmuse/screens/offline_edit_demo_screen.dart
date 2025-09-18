/// TripMuse 離線編輯功能展示頁面
/// 
/// 展示離線編輯和同步機制的各項功能

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/providers.dart';

class OfflineEditDemoScreen extends ConsumerStatefulWidget {
  const OfflineEditDemoScreen({super.key});

  @override
  ConsumerState<OfflineEditDemoScreen> createState() => _OfflineEditDemoScreenState();
}

class _OfflineEditDemoScreenState extends ConsumerState<OfflineEditDemoScreen> {
  final String _demoTripId = 'demo_trip_offline_edit';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('離線編輯功能展示'),
        backgroundColor: TripMuseTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildNetworkStatusSection(),
            const SizedBox(height: 24),
            _buildEditHistorySection(),
            const SizedBox(height: 24),
            _buildOfflineQueueSection(),
            const SizedBox(height: 24),
            _buildConflictResolutionSection(),
            const SizedBox(height: 24),
            _buildAutoSaveSection(),
            const SizedBox(height: 24),
            _buildDemoActionsSection(),
          ],
        ),
      ),
    );
  }
  
  /// 建立標題區域
  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.offline_bolt,
                  color: TripMuseTheme.primaryColor,
                  size: 32,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    '離線編輯和同步機制',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '這個頁面展示了 TripMuse 的離線編輯功能，包括：\n'
              '• 網路狀態監控\n'
              '• 編輯歷史和復原/重做\n'
              '• 離線編輯佇列管理\n'
              '• 同步衝突檢測和解決\n'
              '• 自動儲存機制',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 建立網路狀態區域
  Widget _buildNetworkStatusSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.wifi, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  '網路狀態監控',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Consumer(
              builder: (context, ref, child) {
                final networkStatus = ref.watch(networkStatusProvider);
                
                return networkStatus.when(
                  data: (networkInfo) => _buildNetworkStatusCard(networkInfo),
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text('錯誤: $error'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  /// 建立網路狀態卡片
  Widget _buildNetworkStatusCard(NetworkInfo networkInfo) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: networkInfo.isConnected ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: networkInfo.isConnected ? Colors.green : Colors.red,
        ),
      ),
      child: Row(
        children: [
          Icon(
            networkInfo.isConnected ? Icons.wifi : Icons.wifi_off,
            color: networkInfo.isConnected ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  networkInfo.isConnected ? '已連線' : '離線',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: networkInfo.isConnected ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                ),
                Text(
                  '連線類型: ${_getConnectionTypeText(networkInfo.connectionType)}',
                  style: const TextStyle(fontSize: 12),
                ),
                if (networkInfo.isMetered)
                  const Text(
                    '計量網路',
                    style: TextStyle(fontSize: 12, color: Colors.orange),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// 建立編輯歷史區域
  Widget _buildEditHistorySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.history, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  '編輯歷史',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Consumer(
              builder: (context, ref, child) {
                final historyState = ref.watch(editHistoryProvider(_demoTripId));
                
                return Column(
                  children: [
                    _buildHistoryStatsRow(historyState),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: historyState.canUndo ? () => _performUndo() : null,
                            icon: const Icon(Icons.undo),
                            label: const Text('復原'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: historyState.canRedo ? () => _performRedo() : null,
                            icon: const Icon(Icons.redo),
                            label: const Text('重做'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _showHistoryDialog(),
                            icon: const Icon(Icons.list),
                            label: const Text('歷史'),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  /// 建立歷史統計行
  Widget _buildHistoryStatsRow(EditHistoryState historyState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('可復原', historyState.undoStack.length.toString(), Colors.blue),
        _buildStatItem('可重做', historyState.redoStack.length.toString(), Colors.green),
        _buildStatItem('記錄狀態', historyState.isRecording ? '開啟' : '暫停', 
                      historyState.isRecording ? Colors.green : Colors.orange),
      ],
    );
  }
  
  /// 建立統計項目
  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
  
  /// 建立離線佇列區域
  Widget _buildOfflineQueueSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.queue, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  '離線編輯佇列',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Consumer(
              builder: (context, ref, child) {
                final queueState = ref.watch(offlineEditQueueProvider);
                
                return Column(
                  children: [
                    _buildQueueStatsRow(queueState),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: queueState.hasFailedOperations 
                                ? () => _retryFailedOperations() 
                                : null,
                            icon: const Icon(Icons.refresh),
                            label: const Text('重試失敗'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _clearAllQueues(),
                            icon: const Icon(Icons.clear_all),
                            label: const Text('清除佇列'),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  /// 建立佇列統計行
  Widget _buildQueueStatsRow(OfflineEditQueueState queueState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('待處理', queueState.pendingOperations.length.toString(), Colors.blue),
        _buildStatItem('處理中', queueState.processingOperations.length.toString(), Colors.orange),
        _buildStatItem('失敗', queueState.failedOperations.length.toString(), Colors.red),
      ],
    );
  }
  
  /// 建立衝突解決區域
  Widget _buildConflictResolutionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.warning, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  '同步衝突解決',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Consumer(
              builder: (context, ref, child) {
                final conflicts = ref.watch(conflictResolutionProvider);
                final unresolvedCount = conflicts.where((c) => !c.isResolved).length;
                
                return Column(
                  children: [
                    _buildConflictStatsRow(conflicts.length, unresolvedCount),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: unresolvedCount > 0 
                                ? () => _showConflictResolutionDialog() 
                                : null,
                            icon: const Icon(Icons.build),
                            label: const Text('解決衝突'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _clearResolvedConflicts(),
                            icon: const Icon(Icons.clear),
                            label: const Text('清除已解決'),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  /// 建立衝突統計行
  Widget _buildConflictStatsRow(int totalConflicts, int unresolvedCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('總衝突', totalConflicts.toString(), Colors.grey),
        _buildStatItem('未解決', unresolvedCount.toString(), Colors.red),
        _buildStatItem('已解決', (totalConflicts - unresolvedCount).toString(), Colors.green),
      ],
    );
  }
  
  /// 建立自動儲存區域
  Widget _buildAutoSaveSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.save, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  '自動儲存',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Consumer(
              builder: (context, ref, child) {
                final autoSaveState = ref.watch(autoSaveProvider);
                
                return Column(
                  children: [
                    _buildAutoSaveStatsRow(autoSaveState),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: autoSaveState.isEnabled 
                                ? null 
                                : () => _enableAutoSave(),
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('啟用'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: !autoSaveState.isEnabled 
                                ? null 
                                : () => _disableAutoSave(),
                            icon: const Icon(Icons.pause),
                            label: const Text('停用'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _saveImmediately(),
                            icon: const Icon(Icons.save_alt),
                            label: const Text('立即儲存'),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  /// 建立自動儲存統計行
  Widget _buildAutoSaveStatsRow(AutoSaveState autoSaveState) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('狀態', autoSaveState.isEnabled ? '啟用' : '停用', 
                          autoSaveState.isEnabled ? Colors.green : Colors.red),
            _buildStatItem('儲存中', autoSaveState.isSaving ? '是' : '否', 
                          autoSaveState.isSaving ? Colors.orange : Colors.grey),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          autoSaveState.formattedLastSaveTime,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        if (autoSaveState.lastError != null)
          Text(
            '錯誤: ${autoSaveState.lastError}',
            style: const TextStyle(fontSize: 12, color: Colors.red),
          ),
      ],
    );
  }
  
  /// 建立示範動作區域
  Widget _buildDemoActionsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.play_circle, color: Colors.indigo),
                SizedBox(width: 8),
                Text(
                  '示範動作',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '以下按鈕可以模擬各種編輯操作，用於測試離線編輯功能：',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _simulateEditAction(),
                  icon: const Icon(Icons.edit),
                  label: const Text('模擬編輯'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _simulateAddActivity(),
                  icon: const Icon(Icons.add),
                  label: const Text('新增活動'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _simulateDeleteActivity(),
                  icon: const Icon(Icons.delete),
                  label: const Text('刪除活動'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _simulateConflict(),
                  icon: const Icon(Icons.warning),
                  label: const Text('模擬衝突'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// 取得連線類型文字
  String _getConnectionTypeText(ConnectionType type) {
    switch (type) {
      case ConnectionType.wifi:
        return 'WiFi';
      case ConnectionType.mobile:
        return '行動網路';
      case ConnectionType.ethernet:
        return '乙太網路';
      case ConnectionType.none:
        return '無連線';
    }
  }
  
  /// 執行復原
  void _performUndo() {
    ref.read(editHistoryProvider(_demoTripId).notifier).undo();
    _showSnackBar('已復原', Colors.blue);
  }
  
  /// 執行重做
  void _performRedo() {
    ref.read(editHistoryProvider(_demoTripId).notifier).redo();
    _showSnackBar('已重做', Colors.green);
  }
  
  /// 顯示歷史對話框
  void _showHistoryDialog() {
    // 這裡可以顯示編輯歷史對話框
    _showSnackBar('編輯歷史對話框（待實作）', Colors.purple);
  }
  
  /// 重試失敗的操作
  void _retryFailedOperations() {
    ref.read(offlineEditQueueProvider.notifier).retryFailedOperations();
    _showSnackBar('正在重試失敗的操作', Colors.orange);
  }
  
  /// 清除所有佇列
  void _clearAllQueues() {
    ref.read(offlineEditQueueProvider.notifier).clearAllQueues();
    _showSnackBar('已清除所有佇列', Colors.red);
  }
  
  /// 顯示衝突解決對話框
  void _showConflictResolutionDialog() {
    // 這裡可以顯示衝突解決對話框
    _showSnackBar('衝突解決對話框（待實作）', Colors.red);
  }
  
  /// 清除已解決的衝突
  void _clearResolvedConflicts() {
    ref.read(conflictResolutionProvider.notifier).clearResolvedConflicts();
    _showSnackBar('已清除已解決的衝突', Colors.green);
  }
  
  /// 啟用自動儲存
  void _enableAutoSave() {
    ref.read(autoSaveProvider.notifier).enable();
    _showSnackBar('已啟用自動儲存', Colors.green);
  }
  
  /// 停用自動儲存
  void _disableAutoSave() {
    ref.read(autoSaveProvider.notifier).disable();
    _showSnackBar('已停用自動儲存', Colors.red);
  }
  
  /// 立即儲存
  void _saveImmediately() {
    ref.read(autoSaveProvider.notifier).saveImmediately();
    _showSnackBar('正在立即儲存', Colors.blue);
  }
  
  /// 模擬編輯動作
  void _simulateEditAction() {
    // 模擬一個編輯動作
    ref.read(editHistoryProvider(_demoTripId).notifier).recordAction(
      type: EditActionType.updateTrip,
      beforeState: {'title': '原始標題'},
      afterState: {'title': '修改後的標題'},
      description: '修改行程標題',
    );
    _showSnackBar('已模擬編輯動作', Colors.blue);
  }
  
  /// 模擬新增活動
  void _simulateAddActivity() {
    ref.read(editHistoryProvider(_demoTripId).notifier).recordAction(
      type: EditActionType.addActivity,
      beforeState: {},
      afterState: {'name': '新活動', 'id': 'activity_${DateTime.now().millisecondsSinceEpoch}'},
      description: '新增活動: 新活動',
    );
    _showSnackBar('已模擬新增活動', Colors.green);
  }
  
  /// 模擬刪除活動
  void _simulateDeleteActivity() {
    ref.read(editHistoryProvider(_demoTripId).notifier).recordAction(
      type: EditActionType.deleteActivity,
      beforeState: {'name': '要刪除的活動', 'id': 'activity_to_delete'},
      afterState: {},
      description: '刪除活動: 要刪除的活動',
    );
    _showSnackBar('已模擬刪除活動', Colors.red);
  }
  
  /// 模擬衝突
  void _simulateConflict() {
    // 這裡可以模擬一個同步衝突
    _showSnackBar('衝突模擬功能（待實作）', Colors.orange);
  }
  
  /// 顯示 SnackBar
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}