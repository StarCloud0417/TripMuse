import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/trip_generation_service.dart';

/// 行程生成測試頁面
/// 
/// 用於測試新的兩階段行程生成服務
class TripGenerationTestScreen extends ConsumerStatefulWidget {
  const TripGenerationTestScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TripGenerationTestScreen> createState() => _TripGenerationTestScreenState();
}

class _TripGenerationTestScreenState extends ConsumerState<TripGenerationTestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController(text: '台北');
  final _daysController = TextEditingController(text: '3');
  final _descriptionController = TextEditingController(
    text: '想要體驗台北的美食文化，希望能品嚐到道地的小吃和傳統料理，也想參觀一些歷史文化景點。'
  );
  
  String _selectedBudget = 'medium';
  String _selectedPace = 'medium';
  int _companions = 2;
  final List<String> _selectedInterests = [];

  @override
  void dispose() {
    _destinationController.dispose();
    _daysController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(tripGenerationProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('行程生成測試'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(tripGenerationProgressProvider.notifier).reset();
            },
            tooltip: '重置',
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              ref.read(tripGenerationProgressProvider.notifier).clearCache();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('快取已清除')),
              );
            },
            tooltip: '清除快取',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 進度顯示
              if (progress.isLoading || progress.isCompleted || progress.hasError)
                _buildProgressCard(progress),
              
              const SizedBox(height: 16),
              
              // 基本資訊
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '基本資訊',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // 目的地
                      TextFormField(
                        controller: _destinationController,
                        decoration: const InputDecoration(
                          labelText: '目的地',
                          hintText: '例如：台北、台中、高雄',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '請輸入目的地';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // 天數
                      TextFormField(
                        controller: _daysController,
                        decoration: const InputDecoration(
                          labelText: '天數',
                          hintText: '1-30',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '請輸入天數';
                          }
                          final days = int.tryParse(value);
                          if (days == null || days < 1 || days > 30) {
                            return '天數必須在 1-30 之間';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 旅行偏好
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '旅行偏好',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // 預算
                      DropdownButtonFormField<String>(
                        initialValue: _selectedBudget,
                        decoration: const InputDecoration(
                          labelText: '預算範圍',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'low', child: Text('經濟 - 省錢為主')),
                          DropdownMenuItem(value: 'medium', child: Text('中等 - 平衡體驗')),
                          DropdownMenuItem(value: 'high', child: Text('豪華 - 品質優先')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedBudget = value!;
                          });
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // 旅行節奏
                      DropdownButtonFormField<String>(
                        initialValue: _selectedPace,
                        decoration: const InputDecoration(
                          labelText: '旅行節奏',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'slow', child: Text('放鬆 - 悠閒慢遊')),
                          DropdownMenuItem(value: 'medium', child: Text('適中 - 平衡安排')),
                          DropdownMenuItem(value: 'fast', child: Text('緊湊 - 豐富行程')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedPace = value!;
                          });
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // 旅伴人數
                      Row(
                        children: [
                          const Text('旅伴人數：'),
                          Expanded(
                            child: Slider(
                              value: _companions.toDouble(),
                              min: 1,
                              max: 10,
                              divisions: 9,
                              label: '$_companions 人',
                              onChanged: (value) {
                                setState(() {
                                  _companions = value.round();
                                });
                              },
                            ),
                          ),
                          Text('$_companions 人'),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // 興趣選擇
                      const Text('興趣領域：'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          '美食', '文化', '歷史', '自然', '購物', '夜生活', '藝術', '運動'
                        ].map((interest) {
                          return FilterChip(
                            label: Text(interest),
                            selected: _selectedInterests.contains(interest),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedInterests.add(interest);
                                } else {
                                  _selectedInterests.remove(interest);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 旅行描述
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '旅行描述',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: '描述您的旅行期望',
                          hintText: '例如：想要體驗當地美食文化，參觀歷史景點...',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '請描述您的旅行期望';
                          }
                          if (value.trim().length < 10) {
                            return '描述至少需要 10 個字元';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // 生成按鈕
              ElevatedButton(
                onPressed: progress.isLoading ? null : _generateTrip,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: progress.isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('生成中...'),
                        ],
                      )
                    : const Text(
                        '🤖 智能生成行程',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              
              const SizedBox(height: 16),
              
              // 快取測試按鈕
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: progress.isLoading ? null : () => _generateTrip(useCache: true),
                      child: const Text('使用快取生成'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: progress.isLoading ? null : () => _generateTrip(useCache: false),
                      child: const Text('強制重新生成'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard(TripGenerationProgress progress) {
    return Card(
      color: progress.hasError ? Colors.red.shade50 : Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (progress.isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else if (progress.hasError)
                  Icon(Icons.error, color: Colors.red.shade600)
                else if (progress.isCompleted)
                  Icon(Icons.check_circle, color: Colors.green.shade600),
                
                const SizedBox(width: 12),
                
                Expanded(
                  child: Text(
                    progress.hasError 
                        ? '生成失敗' 
                        : progress.isCompleted 
                            ? '生成完成' 
                            : progress.phase.displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: progress.hasError 
                          ? Colors.red.shade600 
                          : progress.isCompleted 
                              ? Colors.green.shade600 
                              : Colors.blue.shade600,
                    ),
                  ),
                ),
              ],
            ),
            
            if (progress.message != null) ...[
              const SizedBox(height: 8),
              Text(
                progress.message!,
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
            ],
            
            if (progress.isLoading) ...[
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress.progress,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
              ),
              const SizedBox(height: 4),
              Text(
                '${(progress.progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
            
            if (progress.hasError) ...[
              const SizedBox(height: 8),
              Text(
                progress.error!,
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontSize: 12,
                ),
              ),
            ],
            
            if (progress.isCompleted && progress.trip != null) ...[
              const SizedBox(height: 12),
              _buildTripSummary(progress.trip!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTripSummary(Trip trip) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trip.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(trip.summary),
          const SizedBox(height: 8),
          
          if (trip.hasPreferenceAnalysis) ...[
            Text(
              '偏好分析：${trip.preferenceAnalysis!.preferenceSummary}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
          ],
          
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '生成時間：${trip.formattedCreatedAt}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const Spacer(),
              if (trip.generatedBy != null)
                Text(
                  trip.generatedBy!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _generateTrip({bool useCache = true}) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final request = TripRequest(
      destination: _destinationController.text.trim(),
      days: int.parse(_daysController.text.trim()),
      description: _descriptionController.text.trim(),
      preferences: TripPreferences(
        budget: _selectedBudget,
        pace: _selectedPace,
        interests: _selectedInterests,
        companions: _companions,
      ),
    );

    ref.read(tripGenerationProgressProvider.notifier).generateTrip(
      request,
      useCache: useCache,
    );
  }
}