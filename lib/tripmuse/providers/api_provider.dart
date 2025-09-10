/// TripMuse API 服務 Provider
/// 
/// 提供 API 相關服務的 Riverpod Provider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/services.dart';

/// API 客戶端 Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

/// 行程 API 服務 Provider
final tripApiServiceProvider = Provider<TripApiServiceImpl>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TripApiServiceImpl(apiClient);
});

/// 網路服務已在 network_service.dart 中定義
/// 這裡重新匯出以保持一致性
final networkServiceProviderAlias = networkServiceProvider;
final networkStatusProviderAlias = networkStatusProvider;
final isConnectedProviderAlias = isConnectedProvider;