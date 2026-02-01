@echo off
echo 🗺️ Mapbox Token 檢查工具
echo.

cd /d "%~dp0.."
if exist "flutter.bat" (
    echo 正在檢查 Flutter 環境...
    call flutter pub get
    echo.
    echo 啟動 Token 檢查器...
    call dart run bin/check_mapbox_token.dart
) else (
    echo ❌ 找不到 Flutter 環境
    echo 請確保在 TripMuse 專案目錄中運行此腳本
)
echo.
pause
