import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class MapboxMapScreen extends StatefulWidget {
  const MapboxMapScreen({super.key});

  @override
  State<MapboxMapScreen> createState() => _MapboxMapScreenState();
}

class _MapboxMapScreenState extends State<MapboxMapScreen> {
  MapboxMap? mapboxMap;
  bool _isLoading = true;
  String? _errorMessage;
  bool _hasNetworkConnection = true;
  String _currentStyle = MapboxStyles.MAPBOX_STREETS;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    try {
      final connectivityResults = await Connectivity().checkConnectivity();
      setState(() {
        _hasNetworkConnection = !connectivityResults.contains(ConnectivityResult.none) &&
                               connectivityResults.isNotEmpty;
      });

      if (!_hasNetworkConnection) {
        setState(() {
          _errorMessage = '沒有網路連接\n請檢查網路設定後重試';
          _isLoading = false;
        });
        return;
      }

      // Start a timeout timer in case map creation takes too long
      _startMapLoadTimeout();
    } catch (e) {
      debugPrint('Connectivity check error: $e');
      setState(() {
        _hasNetworkConnection = false;
        _errorMessage = '網路檢查失敗: $e';
        _isLoading = false;
      });
    }
  }

  void _startMapLoadTimeout() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted && _isLoading && _errorMessage == null) {
        setState(() {
          _errorMessage = '地圖載入超時\n請檢查網路連接或稍後重試';
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapbox Map'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _hasNetworkConnection ? Icons.error : Icons.wifi_off,
              size: 64,
              color: _hasNetworkConnection ? Colors.red : Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              _hasNetworkConnection ? '地圖載入失敗' : '網路連接問題',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _retryMapLoad,
                  child: const Text('重試'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _testMapboxToken,
                  child: const Text('檢查 Token'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _showDebugInfo,
                  child: const Text('診斷資訊'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _forceMapReload,
                  child: const Text('強制重載'),
                ),
                if (!_hasNetworkConnection) ...[
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _checkConnectivity,
                    child: const Text('檢查網路'),
                  ),
                ],
              ],
            ),
          ],
        ),
      );
    }

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('載入地圖中...'),
            const SizedBox(height: 8),
            Text(
              _hasNetworkConnection ? '正在連接 Mapbox 服務' : '等待網路連接',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return MapWidget(
      key: ValueKey("mapWidget_$_currentStyle"),
      styleUri: _currentStyle,
      onMapCreated: _onMapCreated,
    );
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    debugPrint('Mapbox map created successfully');
    setState(() {
      this.mapboxMap = mapboxMap;
      _isLoading = false;
      _errorMessage = null;
    });

    try {
      // Set initial camera position (e.g., Taipei, Taiwan)
      mapboxMap.setCamera(CameraOptions(
        center: Point(
          coordinates: Position(121.5654, 25.0330), // Taipei coordinates [lng, lat]
        ),
        zoom: 10.0,
      ));

      // Add a marker
      mapboxMap.annotations.createPointAnnotationManager().then((pointAnnotationManager) {
        pointAnnotationManager.create(PointAnnotationOptions(
          geometry: Point(
            coordinates: Position(121.5654, 25.0330),
          ),
          textField: "Taipei",
          textSize: 14.0,
        ));
        debugPrint('Mapbox marker added successfully');
      }).catchError((error) {
        debugPrint('Error creating point annotation: $error');
        // Don't set error state for annotation errors, just log them
      });
    } catch (e) {
      debugPrint('Error initializing map: $e');
      setState(() {
        _errorMessage = '地圖初始化失敗: $e';
        _isLoading = false;
      });
    }
  }

  void _testMapboxToken() async {
    debugPrint('Testing Mapbox token...');
    setState(() {
      _isLoading = true;
      _errorMessage = '正在檢查 Mapbox token...';
    });

    try {
      // 測試基本的 HTTP 請求到 Mapbox API
      final response = await http.get(
        Uri.parse('https://api.mapbox.com/styles/v1/mapbox/streets-v11?access_token=YOUR_MAPBOX_ACCESS_TOKEN'),
      );

      if (response.statusCode == 200) {
        debugPrint('Mapbox token is valid');
        setState(() {
          _errorMessage = 'Mapbox token 有效 ✅\n如果地圖仍無法載入，請檢查網路連接';
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        debugPrint('Mapbox token is invalid or expired');
        setState(() {
          _errorMessage = 'Mapbox token 無效或過期 ❌\n請前往 https://account.mapbox.com/ 獲取新的 token';
          _isLoading = false;
        });
      } else {
        debugPrint('Mapbox API error: ${response.statusCode}');
        setState(() {
          _errorMessage = 'Mapbox API 錯誤: ${response.statusCode}\n請稍後重試';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Token test error: $e');
      setState(() {
        _errorMessage = 'Token 測試失敗: $e\n可能是網路問題或 token 問題';
        _isLoading = false;
      });
    }
  }

  void _retryMapLoad() {
    debugPrint('Retrying map load...');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    _checkConnectivity();
  }

  void _showDebugInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('地圖診斷資訊'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('網路連接: ${_hasNetworkConnection ? "✅" : "❌"}'),
              Text('載入狀態: ${_isLoading ? "載入中" : "完成"}'),
              Text('地圖物件: ${mapboxMap != null ? "✅ 已創建" : "❌ 未創建"}'),
              const SizedBox(height: 16),
              const Text('當前配置:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('樣式: $_currentStyle'),
              const Text('Token: 已設置 (隱藏)'),
              const SizedBox(height: 16),
              const Text('建議檢查:', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text('1. 網路連接是否正常'),
              const Text('2. Token 是否有效'),
              const Text('3. 防火牆是否阻擋'),
              const Text('4. 設備權限是否正確'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('關閉'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _testAlternativeStyle();
            },
            child: const Text('測試其他樣式'),
          ),
        ],
      ),
    );
  }

  void _forceMapReload() {
    debugPrint('Force reloading map...');
    setState(() {
      mapboxMap = null;
      _isLoading = true;
      _errorMessage = null;
      _currentStyle = MapboxStyles.MAPBOX_STREETS; // Reset to default style
    });
  }

  void _testAlternativeStyle() {
    setState(() {
      _currentStyle = MapboxStyles.SATELLITE;
      _isLoading = true;
      _errorMessage = null;
    });
    debugPrint('Testing alternative style: $_currentStyle');
  }
}
