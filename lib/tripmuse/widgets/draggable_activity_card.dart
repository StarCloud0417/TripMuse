/// TripMuse 可拖拉活動卡片組件
///
/// 支援拖拉操作、長按選單和編輯功能的活動卡片

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';

class DraggableActivityCard extends StatefulWidget {
  final Activity activity;
  final bool isLastActivity;
  final Function(Activity, String, String)? onTimeChanged;
  final Function(Activity)? onDelete;
  final Function(Activity, int)? onMoveToDay;
  final Function(Activity)? onReplace;
  final Function(Activity)? onEdit;
  final VoidCallback? onMapSync;

  const DraggableActivityCard({
    super.key,
    required this.activity,
    this.isLastActivity = false,
    this.onTimeChanged,
    this.onDelete,
    this.onMoveToDay,
    this.onReplace,
    this.onEdit,
    this.onMapSync,
  });

  @override
  State<DraggableActivityCard> createState() => _DraggableActivityCardState();
}

class _DraggableActivityCardState extends State<DraggableActivityCard>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _elevationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  bool _isEditing = false;

  late TextEditingController _timeFromController;
  late TextEditingController _timeToController;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _elevationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 4.0,
      end: 12.0,
    ).animate(CurvedAnimation(
      parent: _elevationController,
      curve: Curves.easeInOut,
    ));

    _timeFromController = TextEditingController(text: widget.activity.timeFrom);
    _timeToController = TextEditingController(text: widget.activity.timeTo);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _elevationController.dispose();
    _timeFromController.dispose();
    _timeToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 可拖拉的活動卡片
        AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _elevationAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Draggable<Activity>(
                data: widget.activity,
                feedback: _buildDragFeedback(context),
                childWhenDragging: _buildDragPlaceholder(context),
                onDragStarted: _onDragStarted,
                onDragEnd: _onDragEnd,
                child: GestureDetector(
                  onLongPress: _showContextMenu,
                  onTap: () => widget.onEdit?.call(widget.activity),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _getCategoryColor().withValues(alpha: 0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: _elevationAnimation.value,
                          offset: Offset(0, _elevationAnimation.value / 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // 時間標籤區域
                        _buildTimeSection(context),

                        // 活動內容區域
                        _buildActivityContent(context),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // 活動間連接線（除了最後一個活動）
        if (!widget.isLastActivity) _buildActivityConnector(),
      ],
    );
  }

  Widget _buildTimeSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getCategoryColor().withValues(alpha: 0.1),
            _getCategoryColor().withValues(alpha: 0.05),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          // 拖拉手柄
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _getCategoryColor().withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.drag_handle,
              size: 16,
              color: _getCategoryColor(),
            ),
          ),
          const SizedBox(width: 8),

          // 時間顯示/編輯
          if (_isEditing) ...[
            _buildTimeEditor(context),
          ] else ...[
            _buildTimeDisplay(context),
          ],

          const Spacer(),

          // 優先級標籤
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getPriorityColor(),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: _getPriorityColor().withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              widget.activity.priority.displayName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDisplay(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isEditing = true),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _getCategoryColor().withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.access_time,
              size: 14,
              color: _getCategoryColor(),
            ),
            const SizedBox(width: 4),
            Text(
              widget.activity.timeRange,
              style: TextStyle(
                color: _getCategoryColor(),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.edit,
              size: 12,
              color: _getCategoryColor().withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeEditor(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 開始時間編輯
        SizedBox(
          width: 60,
          child: TextFormField(
            controller: _timeFromController,
            style: TextStyle(
              color: _getCategoryColor(),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: _getCategoryColor()),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: _getCategoryColor(), width: 2),
              ),
            ),
            onTap: () => _selectTime(context, true),
            readOnly: true,
          ),
        ),

        const SizedBox(width: 8),
        Text(
          '-',
          style: TextStyle(
            color: _getCategoryColor(),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),

        // 結束時間編輯
        SizedBox(
          width: 60,
          child: TextFormField(
            controller: _timeToController,
            style: TextStyle(
              color: _getCategoryColor(),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: _getCategoryColor()),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: _getCategoryColor(), width: 2),
              ),
            ),
            onTap: () => _selectTime(context, false),
            readOnly: true,
          ),
        ),

        const SizedBox(width: 8),

        // 確認按鈕
        GestureDetector(
          onTap: _saveTimeChanges,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.check,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(width: 4),

        // 取消按鈕
        GestureDetector(
          onTap: _cancelTimeEdit,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.close,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 活動標題和類別
          Row(
            children: [
              // 類別圖標
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getCategoryColor().withValues(alpha: 0.2),
                      _getCategoryColor().withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: _getCategoryColor().withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  _getCategoryIcon(),
                  size: 18,
                  color: _getCategoryColor(),
                ),
              ),
              const SizedBox(width: 12),

              // 活動名稱
              Expanded(
                child: Text(
                  widget.activity.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 活動描述
          Text(
            widget.activity.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),

          // 額外資訊
          if (widget.activity.estimatedCost != null ||
              widget.activity.address != null) ...[
            const SizedBox(height: 12),
            _buildExtraInfo(context),
          ],

          // 旅行小貼士
          if (widget.activity.tips != null &&
              widget.activity.tips!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildTipsSection(context),
          ],
        ],
      ),
    );
  }

  Widget _buildExtraInfo(BuildContext context) {
    return Column(
      children: [
        // 費用資訊
        if (widget.activity.estimatedCost != null)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.attach_money,
                    size: 14,
                    color: Colors.green.shade600,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.activity.estimatedCost!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

        // 地址資訊
        if (widget.activity.address != null)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.location_on,
                  size: 14,
                  color: Colors.blue.shade600,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.activity.address!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildTipsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade50,
            Colors.orange.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.shade200,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.lightbulb_outline,
              size: 14,
              color: Colors.amber.shade700,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.activity.tips!,
              style: TextStyle(
                fontSize: 13,
                color: Colors.amber.shade800,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityConnector() {
    return Container(
      width: 3,
      height: 20,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _getCategoryColor().withValues(alpha: 0.6),
            _getCategoryColor().withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildDragFeedback(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _getCategoryColor(),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getCategoryIcon(),
              color: _getCategoryColor(),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.activity.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDragPlaceholder(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.drag_handle,
              color: Colors.grey.shade400,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              '拖拉中...',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onDragStarted() {
    _scaleController.forward();
    _elevationController.forward();
    HapticFeedback.mediumImpact();
  }

  void _onDragEnd(DraggableDetails details) {
    _scaleController.reverse();
    _elevationController.reverse();
  }

  void _showContextMenu() {
    HapticFeedback.heavyImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildContextMenu(context),
    );
  }

  Widget _buildContextMenu(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 標題
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getCategoryColor().withValues(alpha: 0.1),
                  _getCategoryColor().withValues(alpha: 0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getCategoryIcon(),
                  color: _getCategoryColor(),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.activity.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 選項列表
          _buildMenuOption(
            context,
            Icons.edit,
            '編輯活動',
            Colors.blue,
            () {
              Navigator.pop(context);
              widget.onEdit?.call(widget.activity);
            },
          ),

          _buildMenuOption(
            context,
            Icons.swap_horiz,
            '替換活動',
            Colors.orange,
            () {
              Navigator.pop(context);
              widget.onReplace?.call(widget.activity);
            },
          ),

          _buildMenuOption(
            context,
            Icons.calendar_today,
            '移動到其他日期',
            Colors.purple,
            () {
              Navigator.pop(context);
              _showMoveTodayDialog(context);
            },
          ),

          _buildMenuOption(
            context,
            Icons.map,
            '同步到地圖',
            Colors.green,
            () {
              Navigator.pop(context);
              widget.onMapSync?.call();
            },
          ),

          const Divider(height: 1),

          _buildMenuOption(
            context,
            Icons.delete,
            '刪除活動',
            Colors.red,
            () {
              Navigator.pop(context);
              _showDeleteConfirmation(context);
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showMoveTodayDialog(BuildContext context) {
    // 這裡應該顯示日期選擇對話框
    // 暫時用簡單的對話框代替
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('移動到其他日期'),
        content: const Text('選擇要移動到的日期'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // 這裡應該實作移動邏輯
              widget.onMoveToDay?.call(widget.activity, 2); // 示例：移動到第2天
            },
            child: const Text('確定'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('刪除活動'),
        content: Text('確定要刪除「${widget.activity.name}」嗎？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete?.call(widget.activity);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('刪除'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: _getCategoryColor(),
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final timeString =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';

      if (isStartTime) {
        _timeFromController.text = timeString;
      } else {
        _timeToController.text = timeString;
      }
    }
  }

  void _saveTimeChanges() {
    final newTimeFrom = _timeFromController.text;
    final newTimeTo = _timeToController.text;

    // 驗證時間格式和邏輯
    if (_validateTimeRange(newTimeFrom, newTimeTo)) {
      widget.onTimeChanged?.call(widget.activity, newTimeFrom, newTimeTo);
      setState(() => _isEditing = false);
      HapticFeedback.lightImpact();
    } else {
      // 顯示錯誤訊息
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('時間設定無效，請檢查時間格式和邏輯'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _cancelTimeEdit() {
    _timeFromController.text = widget.activity.timeFrom;
    _timeToController.text = widget.activity.timeTo;
    setState(() => _isEditing = false);
  }

  bool _validateTimeRange(String timeFrom, String timeTo) {
    try {
      final fromParts = timeFrom.split(':');
      final toParts = timeTo.split(':');

      if (fromParts.length != 2 || toParts.length != 2) return false;

      final fromHour = int.parse(fromParts[0]);
      final fromMinute = int.parse(fromParts[1]);
      final toHour = int.parse(toParts[0]);
      final toMinute = int.parse(toParts[1]);

      if (fromHour < 0 || fromHour > 23 || toHour < 0 || toHour > 23)
        return false;
      if (fromMinute < 0 || fromMinute > 59 || toMinute < 0 || toMinute > 59)
        return false;

      final fromTotalMinutes = fromHour * 60 + fromMinute;
      final toTotalMinutes = toHour * 60 + toMinute;

      return toTotalMinutes > fromTotalMinutes;
    } catch (e) {
      return false;
    }
  }

  Color _getCategoryColor() {
    switch (widget.activity.category) {
      case ActivityCategory.food:
        return Colors.orange;
      case ActivityCategory.sightseeing:
        return Colors.blue;
      case ActivityCategory.culture:
        return Colors.purple;
      case ActivityCategory.nature:
        return Colors.green;
      case ActivityCategory.shopping:
        return Colors.pink;
      case ActivityCategory.outdoor:
        return Colors.teal;
      case ActivityCategory.transportation:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon() {
    switch (widget.activity.category) {
      case ActivityCategory.food:
        return Icons.restaurant;
      case ActivityCategory.sightseeing:
        return Icons.camera_alt;
      case ActivityCategory.culture:
        return Icons.museum;
      case ActivityCategory.nature:
        return Icons.park;
      case ActivityCategory.shopping:
        return Icons.shopping_bag;
      case ActivityCategory.outdoor:
        return Icons.directions_run;
      case ActivityCategory.transportation:
        return Icons.directions_bus;
    }
  }

  Color _getPriorityColor() {
    switch (widget.activity.priority) {
      case ActivityPriority.high:
        return Colors.red;
      case ActivityPriority.medium:
        return Colors.orange;
      case ActivityPriority.low:
        return Colors.green;
    }
  }
}
