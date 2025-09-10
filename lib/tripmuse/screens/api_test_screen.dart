import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/trip_service.dart';
import '../services/api_client.dart';

class ApiTestScreen extends ConsumerStatefulWidget {
  const ApiTestScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends ConsumerState<ApiTestScreen> {
  final _destinationController = TextEditingController(text: '台北');
  final _daysController = TextEditingController(text: '3');
  final _descriptionController = TextEditingController(
    text: '想要體驗台北的美食和文化，希望能夠品嚐當地特色料理，參觀著名景點，感受城市的活力。',
  );
  final _searchController = TextEditingController();

  bool _isHealthy = false;
  String? _healthError;
  List<Place> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _checkApiHealth();
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _daysController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // 檢查 API 健康狀態
  Future<void> _checkApiHealth() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final health = await apiClient.checkHealth();
      setState(() {
        _isHealthy = health.status == 'healthy';
        _healthError = null;
      });
    } catch (e) {
      setState(() {
        _isHealthy = false;
        _healthError = e.toString();
      });
    }
  }

  // 生成行程
  Future<void> _generateTrip() async {
    final destination = _destinationController.text.trim();
    final daysText = _daysController.text.trim();
    final description = _descriptionController.text.trim();

    if (destination.isEmpty || daysText.isEmpty || description.isEmpty) {
      _showSnackBar('請填寫所有必要欄位', isError: true);
      return;
    }

    final days = int.tryParse(daysText);
    if (days == null || days < 1 || days > 30) {
      _showSnackBar('天數必須是 1-30 之間的數字', isError: true);
      return;
    }

    final request = TripRequest(
      destination: destination,
      days: days,
      description: description,
      preferences: const TripPreferences(
        budget: 'medium',
        pace: 'medium',
        interests: ['美食', '文化'],
        companions: 2,
      ),
    );

    final notifier = ref.read(tripGenerationProvider.notifier);
    await notifier.generateTrip(request);
  }

  // 搜尋地點
  Future<void> _searchPlaces() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      _showSnackBar('請輸入搜尋關鍵字', isError: true);
      return;
    }

    try {
      final tripService = ref.read(tripServiceProvider);
      final results = await tripService.searchPlaces(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      _showSnackBar('搜尋失敗: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tripGenerationState = ref.watch(tripGenerationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TripMuse API 測試'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // API 健康狀態
            _buildHealthCard(),
            const SizedBox(height: 16),

            // 行程生成測試
            _buildTripGenerationCard(tripGenerationState),
            const SizedBox(height: 16),

            // 地點搜尋測試
            _buildPlaceSearchCard(),
            const SizedBox(height: 16),

            // 地圖配置測試
            _buildMapConfigCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _isHealthy ? Icons.check_circle : Icons.error,
                  color: _isHealthy ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'API 健康狀態',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _isHealthy ? '✅ API 服務正常運作' : '❌ API 服務異常',
              style: TextStyle(
                color: _isHealthy ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_healthError != null) ...[
              const SizedBox(height: 8),
              Text(
                '錯誤: $_healthError',
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _checkApiHealth,
              child: const Text('重新檢查'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripGenerationCard(TripGenerationResult state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎯 行程生成測試',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            
            // 輸入欄位
            TextField(
              controller: _destinationController,
              decoration: const InputDecoration(
                labelText: '目的地',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            
            TextField(
              controller: _daysController,
              decoration: const InputDecoration(
                labelText: '天數',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '旅行描述',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // 生成按鈕和狀態
            if (state.state == TripGenerationState.loading) ...[
              const LinearProgressIndicator(),
              const SizedBox(height: 8),
              Text('生成中... ${((state.progress ?? 0) * 100).toInt()}%'),
            ] else ...[
              ElevatedButton(
                onPressed: _isHealthy ? _generateTrip : null,
                child: const Text('生成行程'),
              ),
            ],

            // 結果顯示
            if (state.state == TripGenerationState.success && state.trip != null) ...[
              const SizedBox(height: 16),
              _buildTripResult(state.trip!),
            ],

            if (state.state == TripGenerationState.error) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '錯誤: ${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTripResult(Trip trip) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✅ 行程生成成功!',
            style: TextStyle(
              color: Colors.green.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text('標題: ${trip.title}'),
          Text('目的地: ${trip.destination.name}'),
          Text('天數: ${trip.days.length} 天'),
          Text('總活動數: ${trip.days.fold(0, (sum, day) => sum + day.activities.length)}'),
          const SizedBox(height: 8),
          
          // 顯示第一天的活動
          if (trip.days.isNotEmpty) ...[
            Text(
              '第一天活動預覽:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...trip.days.first.activities.take(2).map((activity) => 
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text('• ${activity.name} (${activity.timeFrom}-${activity.timeTo})'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlaceSearchCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🔍 地點搜尋測試',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: '搜尋地點',
                      border: OutlineInputBorder(),
                      hintText: '例如: 台北101',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isHealthy ? _searchPlaces : null,
                  child: const Text('搜尋'),
                ),
              ],
            ),
            
            if (_searchResults.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                '搜尋結果 (${_searchResults.length} 個):',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._searchResults.take(3).map((place) => 
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(place.address),
                      Text('座標: ${place.location.lat}, ${place.location.lng}'),
                      if (place.rating != null) Text('評分: ${place.rating}'),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMapConfigCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🗺️ 地圖配置測試',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            
            Consumer(
              builder: (context, ref, child) {
                final mapConfigAsync = ref.watch(mapConfigProvider);
                
                return mapConfigAsync.when(
                  data: (config) => Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '✅ 地圖配置載入成功',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('樣式: ${config.style}'),
                        Text('縮放範圍: ${config.minZoom} - ${config.maxZoom}'),
                        Text('預設中心: ${config.defaultCenter}'),
                        Text('預設縮放: ${config.defaultZoom}'),
                        Text('Token: ${config.accessToken.substring(0, 20)}...'),
                      ],
                    ),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '❌ 載入失敗: $error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}