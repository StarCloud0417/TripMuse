import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

/// Mapbox Token 檢查工具
class MapboxTokenChecker {
  static const String testToken = "YOUR_MAPBOX_ACCESS_TOKEN";

  /// 檢查 token 格式是否正確
  static bool isValidTokenFormat(String token) {
    // Mapbox public token 應該以 "pk." 開頭
    if (!token.startsWith('pk.')) {
      return false;
    }

    // 檢查長度（Mapbox token 通常很長）
    if (token.length < 50) {
      return false;
    }

    return true;
  }

  /// 測試 token 是否有效
  static Future<TokenValidationResult> validateToken([String? token]) async {
    final testToken = token ?? MapboxTokenChecker.testToken;

    try {
      debugPrint('🔍 正在檢查 Mapbox token...');

      // 測試基本的 style API
      final styleResponse = await http.get(
        Uri.parse('https://api.mapbox.com/styles/v1/mapbox/streets-v11?access_token=$testToken'),
      );

      debugPrint('📡 Style API 回應: ${styleResponse.statusCode}');

      if (styleResponse.statusCode == 200) {
        // 測試 tiles API
        final tilesResponse = await http.get(
          Uri.parse('https://api.mapbox.com/v4/mapbox.mapbox-streets-v8/1/0/0@2x.png?access_token=$testToken'),
        );

        debugPrint('🗺️ Tiles API 回應: ${tilesResponse.statusCode}');

        if (tilesResponse.statusCode == 200) {
          return TokenValidationResult.valid;
        } else if (tilesResponse.statusCode == 401) {
          return TokenValidationResult.invalid;
        } else {
          return TokenValidationResult.apiError;
        }
      } else if (styleResponse.statusCode == 401) {
        return TokenValidationResult.invalid;
      } else if (styleResponse.statusCode == 403) {
        return TokenValidationResult.rateLimited;
      } else {
        return TokenValidationResult.apiError;
      }
    } catch (e) {
      debugPrint('❌ 網路錯誤: $e');
      return TokenValidationResult.networkError;
    }
  }

  /// 顯示詳細的檢查結果
  static void debugPrintValidationResult(TokenValidationResult result, [String? token]) {
    final testToken = token ?? MapboxTokenChecker.testToken;

    debugPrint('\n${'=' * 50}');
    debugPrint('🧪 Mapbox Token 檢查結果');
    debugPrint('=' * 50);

    debugPrint('🔑 Token: ${testToken.substring(0, 20)}...');
    debugPrint('📏 長度: ${testToken.length} 字符');

    switch (result) {
      case TokenValidationResult.valid:
        debugPrint('✅ 狀態: Token 有效');
        debugPrint('🎉 恭喜！您的 Mapbox token 工作正常');
        debugPrint('💡 如果地圖仍無法載入，請檢查：');
        debugPrint('   • 網路連接');
        debugPrint('   • 應用權限');
        debugPrint('   • 防火牆設定');
        break;

      case TokenValidationResult.invalid:
        debugPrint('❌ 狀態: Token 無效或過期');
        debugPrint('🔧 解決方案：');
        debugPrint('   1. 前往 https://account.mapbox.com/');
        debugPrint('   2. 登入您的帳號');
        debugPrint('   3. 創建新的 access token');
        debugPrint('   4. 更新應用中的 token');
        break;

      case TokenValidationResult.rateLimited:
        debugPrint('⏱️ 狀態: API 請求過於頻繁');
        debugPrint('💡 請稍等幾分鐘後重試');
        break;

      case TokenValidationResult.apiError:
        debugPrint('🚨 狀態: Mapbox API 錯誤');
        debugPrint('💡 請檢查網路連接或稍後重試');
        break;

      case TokenValidationResult.networkError:
        debugPrint('🌐 狀態: 網路連接錯誤');
        debugPrint('💡 請檢查您的網路連接');
        break;
    }

    debugPrint('=' * 50);
  }

  /// 互動式檢查工具
  static Future<void> interactiveCheck() async {
    debugPrint('🗺️ Mapbox Token 檢查工具');
    debugPrint('輸入您的 Mapbox token (或按 Enter 使用預設值):');

    final input = stdin.readLineSync()?.trim();
    final tokenToCheck = input?.isNotEmpty == true ? input! : testToken;

    if (!isValidTokenFormat(tokenToCheck)) {
      debugPrint('❌ Token 格式不正確！Mapbox token 應該以 "pk." 開頭');
      return;
    }

    final result = await validateToken(tokenToCheck);
    debugPrintValidationResult(result, tokenToCheck);
  }
}

enum TokenValidationResult {
  valid,
  invalid,
  rateLimited,
  apiError,
  networkError,
}
