/// 除錯版進度對話框
/// 
/// 用於測試和比較兩種不同的實作方式

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/services.dart';

class DebugProgressDialog extends ConsumerStatefulWidget {
  final TripRequest request;
  final VoidCallback? onCancel;
  final Function(Trip)? onSuccess;
  final Function(String)? onError;

  const DebugProgressDialog({
    super.key,
    required this.request,
    this.onCancel,
    this.onSuccess,
    this.onError,
  });

  @override
  ConsumerState<DebugProgressDialog> createState() => _DebugProgressDialogState();
}

class _DebugProgressDialogState extends ConsumerState<DebugProgressDialog> {
  String _debugInfo = '';
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 標題 - 固定在頂部
            const Text(
              '🔍 除錯資訊',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // 可滾動的內容區域
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 請求資訊
                    _buildSection('請求資訊', [
                      '目的地: ${widget.request.destination}',
                      '天數: ${widget.request.days}',
                      '描述: ${_truncateText(widget.request.description, 50)}',
                      '預算: ${widget.request.preferences?.budget ?? "null"}',
                      '節奏: ${widget.request.preferences?.pace ?? "null"}',
                      '人數: ${widget.request.preferences?.companions ?? "null"}',
                    ]),
                    
                    const SizedBox(height: 16),
                    
                    // Provider 狀態
                    _buildSection('Provider 狀態', [
                      'ApiClient: ${_checkProvider(() => ref.read(apiClientProvider))}',
                      'TripGenerationService: ${_checkProvider(() => ref.read(tripGenerationServiceProvider))}',
                      'TripService: ${_checkProvider(() => ref.read(tripServiceProvider))}',
                    ]),
                    
                    const SizedBox(height: 16),
                    
                    // 除錯資訊
                    if (_debugInfo.isNotEmpty) ...[
                      _buildScrollableSection('除錯日誌', _debugInfo),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
            
            // 按鈕區域 - 固定在底部
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isGenerating ? null : _testTripService,
                        child: Text(_isGenerating ? '測試中...' : '測試 TripService'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isGenerating ? null : _testDirectGeneration,
                        child: Text(_isGenerating ? '測試中...' : '測試直接生成'),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('關閉'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                item,
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildScrollableSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: 150, // 固定高度
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: SingleChildScrollView(
            child: Text(
              content,
              style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
            ),
          ),
        ),
      ],
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  String _checkProvider(Function() providerGetter) {
    try {
      final provider = providerGetter();
      return provider != null ? '✅ OK' : '❌ NULL';
    } catch (e) {
      return '❌ ERROR: ${e.toString().substring(0, 30)}...';
    }
  }

  Future<void> _testTripService() async {
    setState(() {
      _isGenerating = true;
      _debugInfo = '開始測試 TripService...\n';
    });

    try {
      // 測試 TripService
      final tripService = ref.read(tripServiceProvider);
      _addDebugInfo('✅ TripService 取得成功');
      
      _addDebugInfo('📤 開始呼叫 generateTrip...');
      
      final trip = await tripService.generateTrip(
        widget.request,
        onProgress: (progress) {
          _addDebugInfo('📊 進度更新: ${progress.phase.displayName} (${(progress.progress * 100).toInt()}%)');
        },
        useCache: true,
      );
      
      _addDebugInfo('✅ 生成成功: ${trip.title}');
      widget.onSuccess?.call(trip);
      
    } catch (e, stackTrace) {
      _addDebugInfo('❌ TripService 錯誤: $e');
      _addDebugInfo('Stack trace: ${stackTrace.toString().substring(0, 200)}...');
      widget.onError?.call(e.toString());
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  Future<void> _testDirectGeneration() async {
    setState(() {
      _isGenerating = true;
      _debugInfo = '開始測試直接生成...\n';
    });

    try {
      // 直接使用 TripGenerationService
      final generationService = ref.read(tripGenerationServiceProvider);
      _addDebugInfo('✅ TripGenerationService 取得成功');
      
      _addDebugInfo('📤 開始呼叫 generateTrip...');
      
      final trip = await generationService.generateTrip(
        widget.request,
        onProgress: (progress) {
          _addDebugInfo('📊 進度更新: ${progress.phase.displayName} (${(progress.progress * 100).toInt()}%)');
        },
        useCache: true,
      );
      
      _addDebugInfo('✅ 生成成功: ${trip.title}');
      widget.onSuccess?.call(trip);
      
    } catch (e, stackTrace) {
      _addDebugInfo('❌ 直接生成錯誤: $e');
      _addDebugInfo('Stack trace: ${stackTrace.toString().substring(0, 200)}...');
      widget.onError?.call(e.toString());
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  void _addDebugInfo(String info) {
    setState(() {
      _debugInfo += '${DateTime.now().toString().substring(11, 19)}: $info\n';
    });
  }
}