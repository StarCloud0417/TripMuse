# TripMuse ProviderScope 錯誤修復

## 問題描述

在編輯模式中點擊日期移動按鈕時，出現了以下錯誤：
```
Bad state: No ProviderScope found
```

## 問題原因

這個錯誤發生在 `MoveActivityDialog` 中嘗試使用 Riverpod Provider 時。問題的根本原因是：

1. **ProviderScope 缺失**：通過 `showDialog` 創建的對話框沒有繼承父 Widget 的 ProviderScope
2. **Context 隔離**：對話框的 BuildContext 與主應用的 ProviderScope 隔離
3. **Provider 訪問失敗**：在對話框中使用 `ref.read()` 時找不到對應的 Provider

## 解決方案

### 1. 重構對話框架構

將 `MoveActivityDialog` 從 `ConsumerStatefulWidget` 改為普通的 `StatefulWidget`：

**修改前：**
```dart
class MoveActivityDialog extends ConsumerStatefulWidget {
  // 直接在對話框中使用 Provider
  final activityEditNotifier = ref.read(activityEditProvider.notifier);
}
```

**修改後：**
```dart
class MoveActivityDialog extends StatefulWidget {
  // 通過回調函數處理業務邏輯
  final Function(int fromDayIndex, int toDayIndex, Activity activity) onMoveActivity;
}
```

### 2. 使用回調函數模式

將 Provider 的使用移到有正確 ProviderScope 的地方：

```dart
// 在 draggable_activity_card.dart 中
showDialog(
  context: context,
  builder: (context) => MoveActivityDialog(
    activity: widget.activity,
    trip: trip,
    currentDayIndex: _getCurrentDayIndex(trip),
    onMoveActivity: (fromDayIndex, toDayIndex, activity) async {
      // 在這裡使用 Provider，因為這裡有正確的 ProviderScope
      final activityEditNotifier = ref.read(activityEditProvider.notifier);
      final success = await activityEditNotifier.moveActivityBetweenDays(
        widget.tripId!,
        fromDayIndex,
        toDayIndex,
        activity,
      );
      
      if (!success) {
        throw Exception('移動失敗');
      }
    },
  ),
);
```

### 3. 改進錯誤處理

在對話框中添加了適當的錯誤處理和載入狀態：

```dart
void _moveActivity() async {
  setState(() {
    _isLoading = true;
  });

  try {
    await widget.onMoveActivity(
      widget.currentDayIndex,
      _selectedDayIndex!,
      widget.activity,
    );
    // 成功處理
  } catch (e) {
    // 錯誤處理
    setState(() {
      _isLoading = false;
    });
  }
}
```

## 修改的檔案

### 1. `lib/tripmuse/widgets/move_activity_dialog.dart`
- 從 `ConsumerStatefulWidget` 改為 `StatefulWidget`
- 移除直接的 Provider 使用
- 添加回調函數參數
- 改進錯誤處理和載入狀態

### 2. `lib/tripmuse/widgets/draggable_activity_card.dart`
- 更新對話框調用方式
- 在正確的 context 中使用 Provider
- 添加 `activity_edit_provider` import

## 技術細節

### ProviderScope 的工作原理

Riverpod 的 Provider 需要在 Widget 樹中有一個 `ProviderScope` 作為根節點。當使用 `showDialog` 創建對話框時：

1. 對話框會創建一個新的 Widget 樹
2. 這個新的 Widget 樹可能不會繼承原有的 ProviderScope
3. 因此在對話框中使用 `ref.read()` 會失敗

### 解決方案的優點

1. **架構清晰**：業務邏輯與 UI 分離
2. **可重用性**：對話框不依賴特定的 Provider
3. **錯誤處理**：更好的錯誤處理和用戶反饋
4. **測試友好**：更容易進行單元測試

## 測試步驟

### 1. 進入編輯模式
1. 開啟 TripMuse 應用程式
2. 點擊任一行程進入詳情頁面
3. 點擊右上角選單（三個點）→「編輯行程」

### 2. 測試跨日期移動
1. 在編輯模式下，找到任一活動卡片
2. 點擊活動卡片上的日曆圖示（紫色按鈕）
3. 應該會彈出日期選擇對話框，不再出現 ProviderScope 錯誤
4. 選擇目標日期並點擊「移動」
5. 活動應該成功移動到選定的日期

### 3. 驗證功能
- ✅ 對話框正常顯示
- ✅ 可以選擇目標日期
- ✅ 移動操作成功執行
- ✅ 顯示成功/失敗提示
- ✅ 行程資料正確更新

## 其他類似問題的預防

為了避免類似的 ProviderScope 問題，建議：

1. **對話框設計**：避免在對話框中直接使用 Provider
2. **回調模式**：使用回調函數將業務邏輯保留在有正確 ProviderScope 的地方
3. **Context 檢查**：在使用 Provider 前確保有正確的 context
4. **錯誤處理**：添加適當的錯誤處理機制

## 結論

這個修復解決了 ProviderScope 錯誤，現在跨日期移動功能可以正常使用。這種解決方案不僅修復了當前問題，還提供了一個更好的架構模式，可以應用到其他類似的對話框組件中。