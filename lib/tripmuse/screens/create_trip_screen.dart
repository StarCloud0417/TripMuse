/// TripMuse 建立行程頁面
///
/// 提供使用者輸入旅行資訊和描述，生成個人化行程的介面

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/simple_progress_dialog.dart';
import '../widgets/debug_progress_dialog.dart';
import '../services/services.dart';
import '../providers/providers.dart';

class CreateTripScreen extends ConsumerStatefulWidget {
  const CreateTripScreen({super.key});

  @override
  ConsumerState<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends ConsumerState<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController();
  final _descriptionController = TextEditingController();

  int _days = 3;
  int _groupSize = 2;
  BudgetRange _budgetRange = BudgetRange.mid;
  bool _isGenerating = false;

  // 目的地搜尋相關
  List<Destination> _destinationSuggestions = [];
  Destination? _selectedDestination;

  @override
  void initState() {
    super.initState();
    // 添加監聽器來監聽控制器變化
    _destinationController.addListener(_updateFormState);
    _descriptionController.addListener(_updateFormState);
  }

  @override
  void dispose() {
    // 移除監聽器
    _destinationController.removeListener(_updateFormState);
    _descriptionController.removeListener(_updateFormState);
    _destinationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateFormState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('建立新行程'),
        backgroundColor: TripMuseTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TripMuseSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 頁面標題和描述
              _buildHeader(),

              const SizedBox(height: TripMuseSpacing.xl),

              // 目的地選擇
              _buildDestinationSection(),

              const SizedBox(height: TripMuseSpacing.xl),

              // 日期和天數設定
              _buildDateSection(),

              const SizedBox(height: TripMuseSpacing.xl),

              // 旅行描述
              _buildDescriptionSection(),

              const SizedBox(height: TripMuseSpacing.xl),

              // 選擇性設定
              _buildOptionalSettings(),

              const SizedBox(height: TripMuseSpacing.xxl),

              // 生成按鈕
              _buildGenerateButton(),

              const SizedBox(height: TripMuseSpacing.md),

              // 除錯按鈕
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showDebugDialog,
                  icon: const Icon(Icons.bug_report),
                  label: const Text('🔍 除錯測試'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange),
                  ),
                ),
              ),

              const SizedBox(height: TripMuseSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '✈️ 開始規劃你的旅程',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: TripMuseTheme.textPrimary,
              ),
        ),
        const SizedBox(height: TripMuseSpacing.sm),
        Text(
          '告訴我們你想要的旅行體驗，我們將為你量身打造完美的行程',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: TripMuseTheme.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildDestinationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('🌍 目的地', '你想去哪裡旅行？'),

        const SizedBox(height: TripMuseSpacing.md),

        // 目的地輸入框
        TextFormField(
          controller: _destinationController,
          decoration: InputDecoration(
            hintText: '搜尋城市或國家...',
            prefixIcon: const Icon(
              Icons.location_on,
              color: TripMuseTheme.primaryColor,
            ),
            suffixIcon: _destinationController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _destinationController.clear();
                      setState(() {
                        _selectedDestination = null;
                      });
                    },
                    icon: const Icon(Icons.clear),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TripMuseRadius.lg),
              borderSide: const BorderSide(color: TripMuseTheme.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TripMuseRadius.lg),
              borderSide: const BorderSide(
                color: TripMuseTheme.primaryColor,
                width: 2,
              ),
            ),
          ),
          onChanged: _onDestinationChanged,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return '請選擇目的地';
            }
            return null;
          },
        ),

        // 已選擇的目的地顯示
        if (_selectedDestination != null) ...[
          const SizedBox(height: TripMuseSpacing.md),
          _buildSelectedDestination(),
        ],
      ],
    );
  }

  Widget _buildSelectedDestination() {
    return Container(
      padding: const EdgeInsets.all(TripMuseSpacing.md),
      decoration: BoxDecoration(
        color: TripMuseTheme.primaryColor.withValues(alpha: 25.5),
        borderRadius: BorderRadius.circular(TripMuseRadius.lg),
        border: Border.all(
          color: TripMuseTheme.primaryColor.withValues(alpha: 76.5),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: TripMuseTheme.primaryColor,
          ),
          const SizedBox(width: TripMuseSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedDestination!.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: TripMuseTheme.primaryColor,
                  ),
                ),
                Text(
                  '${_selectedDestination!.city}, ${_selectedDestination!.country}',
                  style: TextStyle(
                    color: TripMuseTheme.primaryColor.withValues(alpha: 204.0),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('📅 旅行時間', '設定你的旅行日期'),

        const SizedBox(height: TripMuseSpacing.md),

        // 天數選擇器
        _buildDaysSelector(),
      ],
    );
  }

  Widget _buildDaysSelector() {
    return Container(
      padding: const EdgeInsets.all(TripMuseSpacing.md),
      decoration: BoxDecoration(
        color: TripMuseTheme.surfaceColor,
        borderRadius: BorderRadius.circular(TripMuseRadius.lg),
        border: Border.all(color: TripMuseTheme.borderColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '旅行天數',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: TripMuseTheme.textPrimary,
                ),
              ),
              Text(
                '$_days 天',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: TripMuseTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: TripMuseSpacing.md),
          Slider(
            value: _days.toDouble(),
            min: 1,
            max: 14,
            divisions: 13,
            activeColor: TripMuseTheme.primaryColor,
            onChanged: (value) {
              setState(() {
                _days = value.round();
              });
            },
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1天',
                style: TextStyle(
                  fontSize: 12,
                  color: TripMuseTheme.textSecondary,
                ),
              ),
              Text(
                '14天',
                style: TextStyle(
                  fontSize: 12,
                  color: TripMuseTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('✨ 旅行描述', '描述你想要的旅行體驗'),

        const SizedBox(height: TripMuseSpacing.md),

        // 範例提示
        _buildExamplePrompts(),

        const SizedBox(height: TripMuseSpacing.md),

        // 描述輸入框
        TextFormField(
          controller: _descriptionController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: '例如：我想要一趟放鬆的美食之旅，體驗當地文化和歷史...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TripMuseRadius.lg),
              borderSide: const BorderSide(color: TripMuseTheme.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TripMuseRadius.lg),
              borderSide: const BorderSide(
                color: TripMuseTheme.primaryColor,
                width: 2,
              ),
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return '請描述你想要的旅行體驗';
            }
            if (value!.length < 10) {
              return '請提供更詳細的描述（至少10個字）';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildExamplePrompts() {
    final examples = [
      '🍜 放鬆的美食之旅',
      '🏛️ 體驗當地文化和歷史',
      '🌸 浪漫的情侶旅行',
      '👨‍👩‍👧‍👦 適合全家的親子行程',
      '🎒 冒險刺激的戶外活動',
      '🛍️ 購物和城市探索',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '💡 靈感提示',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: TripMuseTheme.textSecondary,
          ),
        ),
        const SizedBox(height: TripMuseSpacing.sm),
        Wrap(
          spacing: TripMuseSpacing.sm,
          runSpacing: TripMuseSpacing.sm,
          children: examples.map((example) {
            return InkWell(
              onTap: () => _addExampleToDescription(example),
              borderRadius: BorderRadius.circular(TripMuseRadius.md),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TripMuseSpacing.md,
                  vertical: TripMuseSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(TripMuseRadius.md),
                  border: Border.all(
                    color: Colors.blue.shade200,
                  ),
                ),
                child: Text(
                  example,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOptionalSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('⚙️ 其他設定', '選擇性設定（可跳過）'),

        const SizedBox(height: TripMuseSpacing.md),

        // 旅伴數量
        _buildGroupSizeSelector(),

        const SizedBox(height: TripMuseSpacing.lg),

        // 預算範圍
        _buildBudgetSelector(),
      ],
    );
  }

  Widget _buildGroupSizeSelector() {
    return Container(
      padding: const EdgeInsets.all(TripMuseSpacing.md),
      decoration: BoxDecoration(
        color: TripMuseTheme.surfaceColor,
        borderRadius: BorderRadius.circular(TripMuseRadius.lg),
        border: Border.all(color: TripMuseTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.group,
                color: TripMuseTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: TripMuseSpacing.sm),
              const Text(
                '旅伴數量',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: TripMuseTheme.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '$_groupSize 人',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: TripMuseTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: TripMuseSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [1, 2, 3, 4, 5, 6].map((size) {
              final isSelected = _groupSize == size;
              return InkWell(
                onTap: () {
                  setState(() {
                    _groupSize = size;
                  });
                },
                borderRadius: BorderRadius.circular(TripMuseRadius.md),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? TripMuseTheme.primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(TripMuseRadius.md),
                    border: Border.all(
                      color: isSelected
                          ? TripMuseTheme.primaryColor
                          : TripMuseTheme.borderColor,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      size.toString(),
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : TripMuseTheme.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetSelector() {
    return Container(
      padding: const EdgeInsets.all(TripMuseSpacing.md),
      decoration: BoxDecoration(
        color: TripMuseTheme.surfaceColor,
        borderRadius: BorderRadius.circular(TripMuseRadius.lg),
        border: Border.all(color: TripMuseTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.attach_money,
                color: TripMuseTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: TripMuseSpacing.sm),
              const Text(
                '預算範圍',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: TripMuseTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: TripMuseSpacing.md),
          Column(
            children: BudgetRange.values.map((budget) {
              final isSelected = _budgetRange == budget;
              return InkWell(
                onTap: () {
                  setState(() {
                    _budgetRange = budget;
                  });
                },
                borderRadius: BorderRadius.circular(TripMuseRadius.md),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: TripMuseSpacing.md,
                    vertical: TripMuseSpacing.sm,
                  ),
                  margin: const EdgeInsets.only(bottom: TripMuseSpacing.sm),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? TripMuseTheme.primaryColor.withValues(alpha: 25.5)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(TripMuseRadius.md),
                    border: Border.all(
                      color: isSelected
                          ? TripMuseTheme.primaryColor
                          : TripMuseTheme.borderColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: isSelected
                            ? TripMuseTheme.primaryColor
                            : TripMuseTheme.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: TripMuseSpacing.sm),
                      Text(
                        budget.displayName,
                        style: TextStyle(
                          color: isSelected
                              ? TripMuseTheme.primaryColor
                              : TripMuseTheme.textPrimary,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    final isFormValid = _destinationController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _descriptionController.text.length >= 10;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isFormValid && !_isGenerating ? _generateTrip : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: TripMuseTheme.primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: TripMuseTheme.textSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TripMuseRadius.lg),
          ),
          elevation: isFormValid ? 4 : 0,
        ),
        child: _isGenerating
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
                  SizedBox(width: TripMuseSpacing.md),
                  Text(
                    '正在生成行程...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 24,
                  ),
                  SizedBox(width: TripMuseSpacing.sm),
                  Text(
                    '🚀 智能生成行程',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: TripMuseTheme.textPrimary,
          ),
        ),
        const SizedBox(height: TripMuseSpacing.xs),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: TripMuseTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  // 事件處理方法
  void _onDestinationChanged(String value) {
    setState(() {
      _selectedDestination = null;
    });

    if (value.isNotEmpty) {
      _searchDestinations(value);
    } else {
      setState(() {
        _destinationSuggestions.clear();
      });
    }
  }

  void _searchDestinations(String query) {
    // TODO: 整合 Google Places API
    // 目前使用模擬資料
    final mockDestinations = [
      const Destination(
        name: '台北',
        city: '台北',
        country: '台灣',
        lat: 25.0330,
        lng: 121.5654,
      ),
      const Destination(
        name: '東京',
        city: '東京',
        country: '日本',
        lat: 35.6762,
        lng: 139.6503,
      ),
      const Destination(
        name: '首爾',
        city: '首爾',
        country: '韓國',
        lat: 37.5665,
        lng: 126.9780,
      ),
      const Destination(
        name: '曼谷',
        city: '曼谷',
        country: '泰國',
        lat: 13.7563,
        lng: 100.5018,
      ),
    ];

    setState(() {
      _destinationSuggestions = mockDestinations
          .where((dest) =>
              dest.name.toLowerCase().contains(query.toLowerCase()) ||
              dest.city.toLowerCase().contains(query.toLowerCase()) ||
              dest.country.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });

    // 如果找到完全匹配的目的地，自動選擇
    final exactMatch = mockDestinations.firstWhere(
      (dest) => dest.name.toLowerCase() == query.toLowerCase(),
      orElse: () => mockDestinations.first,
    );

    if (exactMatch.name.toLowerCase() == query.toLowerCase()) {
      setState(() {
        _selectedDestination = exactMatch;
      });
    }
  }

  void _addExampleToDescription(String example) {
    final currentText = _descriptionController.text;
    final cleanExample =
        example.replaceAll(RegExp(r'^[🍜🏛️🌸👨‍👩‍👧‍👦🎒🛍️]\\s*'), '');

    if (currentText.isEmpty) {
      _descriptionController.text = '我想要$cleanExample';
    } else {
      _descriptionController.text = '$currentText，還有$cleanExample';
    }

    // 移動游標到文字末尾
    _descriptionController.selection = TextSelection.fromPosition(
      TextPosition(offset: _descriptionController.text.length),
    );
  }

  Future<void> _generateTrip() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 建立 TripRequest
    final tripRequest = _buildTripRequest();

    // 驗證請求 - 檢查基本欄位是否已填寫
    if (tripRequest.destination.isEmpty || tripRequest.description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ 請填寫目的地和行程描述'),
          backgroundColor: TripMuseTheme.errorColor,
        ),
      );
      return;
    }

    // 顯示進度對話框
    if (mounted) {
      final result = await showDialog<Trip>(
        context: context,
        barrierDismissible: false,
        builder: (context) => ProviderScope(
          child: SimpleProgressDialog(
            request: tripRequest,
            onSuccess: (trip) async {
              // 儲存生成的行程到本地
              try {
                // 確保 StorageManager 已初始化
                final storageManager = StorageManager.instance;
                if (!storageManager.isInitialized) {
                  print('🔄 StorageManager 尚未初始化，正在初始化...');
                  await storageManager.initialize();
                  print('✅ StorageManager 初始化完成');
                }
                
                final tripRepository = ref.read(tripRepositoryProvider);
                await tripRepository.saveTrip(trip);
                print('✅ 行程已儲存到本地: ${trip.id}');
                
                // 刷新相關的 Provider 以更新 UI
                ref.invalidate(userTripsProvider);
                ref.invalidate(recentTripsProvider);
                ref.read(tripNotifierProvider.notifier).refresh();
                
              } catch (e) {
                print('⚠️ 儲存行程失敗: $e');
                // 顯示錯誤提示給用戶
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('儲存行程失敗: $e'),
                      backgroundColor: TripMuseTheme.errorColor,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              }
            },
            onError: (error) {
              // 錯誤處理
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('❌ 生成行程失敗：$error'),
                  backgroundColor: TripMuseTheme.errorColor,
                  duration: const Duration(seconds: 5),
                  action: SnackBarAction(
                    label: '重試',
                    textColor: Colors.white,
                    onPressed: () => _generateTrip(),
                  ),
                ),
              );
            },
            onCancel: () {
              // 取消回調
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('行程生成已取消'),
                  backgroundColor: TripMuseTheme.warningColor,
                ),
              );
            },
          ),
        ),
      );

      // 如果成功生成行程
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '🎉 行程生成成功！\n目的地：${result.destination.city}\n天數：${result.days.length} 天',
            ),
            backgroundColor: TripMuseTheme.successColor,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: '查看',
              textColor: Colors.white,
              onPressed: () {
                // TODO: 導航到行程詳情頁面
              },
            ),
          ),
        );

        // 導航回到行程列表頁面
        Navigator.pop(context);
      }
    }
  }

  TripRequest _buildTripRequest() {
    final destinationText = _destinationController.text;
    return TripRequest(
      destination: destinationText,
      days: _days,
      description: _descriptionController.text,
      preferences: TripPreferences(
        budget: _mapBudgetRangeToString(_budgetRange),
        pace: 'medium',
        interests: [],
        companions: _groupSize,
      ),
    );
  }

  String _mapBudgetRangeToString(BudgetRange budgetRange) {
    switch (budgetRange) {
      case BudgetRange.low:
        return 'low';
      case BudgetRange.mid:
        return 'medium';
      case BudgetRange.high:
        return 'high';
    }
  }

  void _showDebugDialog() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final tripRequest = _buildTripRequest();

    showDialog(
      context: context,
      builder: (context) => ProviderScope(
        child: DebugProgressDialog(
          request: tripRequest,
          onSuccess: (trip) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('🎉 除錯測試成功！${trip.title}'),
                backgroundColor: Colors.green,
              ),
            );
          },
          onError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ 除錯測試失敗：$error'),
                backgroundColor: Colors.red,
              ),
            );
          },
        ),
      ),
    );
  }
}
