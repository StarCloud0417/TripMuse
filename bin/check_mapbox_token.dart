import 'package:flutter/material.dart';
import 'package:tripmuse/utils/mapbox_token_checker.dart';

/// 獨立的 Mapbox Token 檢查工具
void main() async {
  // ignore: avoid_print
  debugPrint('🚀 啟動 Mapbox Token 檢查器...\n');

  await MapboxTokenChecker.interactiveCheck();
}
