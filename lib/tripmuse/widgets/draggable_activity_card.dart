/// TripMuse 可拖拉活動卡片組件
///
/// 支援拖拉操作、長按選單和編輯功能的活動卡片

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/trip_edit_mode_provider.dart';
import 'activity_detail_bottom_sheet.dart';

class DraggableActivityCard extends ConsumerStatefulWidget {
  final Activity activity;
  final bool isLastActivity;
  final bool isFirstActivity;
  final String? tripId;
  final Function(Activity, String, String)? onTimeChanged;
  final Function(Activity)? onDelete;
  final Function(Activity, int)? onMoveToDay;
  final Function(Activity)? onReplace;
  final Function(Activity)? onEdit;
  final Function(Activity)? onMoveUp;
  final Function(Activity)? onMoveDown;
  final VoidCallback? onMapSync;
  final VoidCallback? onEnterEditMode;

  const DraggableActivityCard({
    super.key,
    required this.activity,
    this.isLastActivity = false,
    this.isFirstActivity = false,
    this.tripId,
    this.onTimeChanged,
    this.onDelete,
    this.onMoveToDay,
    this.onReplace,
    this.onEdit,
    this.onMoveUp,
    this.onMoveDown,
    this.onMapSync,
    this.onEnterEditMode,
  });

  @override
  ConsumerState<DraggableActivityCard> createState() => _DraggableActivityCardState();
}

class _DraggableActivityCardState extends ConsumerState<DraggableActivityCard>
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
    final isEditMode = widget.tripId != null 
        ? ref.watch(isEditingTripProvider(widget.tripId!))
        : false;

    return Column(
      children: [
        // 可拖拉的活動卡片
        AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _elevationAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: isEditMode 
                  ? _buildEditModeCard(context)
                  : _buildNormalModeCard(context),
            );
          },
        ),
        
        // 活動間連接線（除了最後一個活動）
        if (!widget.isLastActivity) _buildActivityConnector(),
      ],
    );
  }

  Widget _buildNormalModeCard(BuildContext context) {
    return GestureDetector(
      onLongPress: _handleLongPress,
      onTap: () => _showActivityDetails(context),
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
    );
  }

  Widget _buildEditModeCard(BuildContext context) {
    return Draggable<Activity>(
      data: widget.activity,
      feedback: _buildDragFeedback(context),
      childWhenDragging: _buildDragPlaceholder(context),
      onDragStarted: _onDragStarted,
      onDragEnd: _onDragEnd,
      child: GestureDetector(
        onLongPress: () => widget.onEdit?.call(widget.activity),
        onTap: () => _showActivityDetails(context),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _getCategoryColor().withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: _getCategoryColor().withValues(alpha: 0.15),
                blurRadius: _elevationAnimation.value,
                offset: Offset(0, _elevationAnimation.value / 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // 編輯模式時間標籤
              _buildEditModeTimeSection(context),
              
              // 活動內容區域
              _buildActivityContent(context),
              
              // 編輯模式控制按鈕區域
              _buildEditModeControls(context),
            ],
          ),
        ),
      ),
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
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _getCategoryColor().withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.access_time,
              size: 14,
              color: _getCategoryColor(),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            widget.activity.timeRange,
            style: TextStyle(
              color: _getCategoryColor(),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const Spacer(),
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

  Widget _buildEditModeTimeSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 12, 16, _isEditing ? 16 : 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getCategoryColor().withValues(alpha: 0.15),
            _getCategoryColor().withValues(alpha: 0.08),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // 第一行：拖拉手柄、時間顯示、優先級
          Row(
            children: [
              // 拖拉手柄（編輯模式下更明顯）
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _getCategoryColor().withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getCategoryColor().withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.drag_handle,
                  size: 18,
                  color: _getCategoryColor(),
                ),
              ),
              const SizedBox(width: 12),
              
              // 時間顯示（非編輯狀態）
              if (!_isEditing) ...[
                Expanded(child: _buildEditModeTimeDisplay(context)),
              ] else ...[
                // 編輯狀態下顯示提示文字
                Expanded(
                  child: Text(
                    '正在編輯時間',
                    style: TextStyle(
                      color: _getCategoryColor(),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
              
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
          
          // 第二行：時間編輯器（編輯狀態時顯示）
          if (_isEditing) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: _buildTimeEditor(context),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEditModeTimeDisplay(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isEditing = true),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _getCategoryColor().withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _getCategoryColor().withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.access_time,
              size: 16,
              color: _getCategoryColor(),
            ),
            const SizedBox(width: 6),
            Text(
              widget.activity.timeRange,
              style: TextStyle(
                color: _getCategoryColor(),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.edit,
              size: 14,
              color: _getCategoryColor().withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeEditor(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 時間輸入區域
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 開始時間編輯
            Container(
              width: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _getCategoryColor(), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: _getCategoryColor().withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextFormField(
                controller: _timeFromController,
                style: TextStyle(
                  color: _getCategoryColor(),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  border: InputBorder.none,
                ),
                onTap: () => _selectTime(context, true),
                readOnly: true,
              ),
            ),
            
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: _getCategoryColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '至',
                style: TextStyle(
                  color: _getCategoryColor(),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            
            // 結束時間編輯
            Container(
              width: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _getCategoryColor(), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: _getCategoryColor().withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextFormField(
                controller: _timeToController,
                style: TextStyle(
                  color: _getCategoryColor(),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  border: InputBorder.none,
                ),
                onTap: () => _selectTime(context, false),
                readOnly: true,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // 操作按鈕區域
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 確認按鈕
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _saveTimeChanges,
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '確認',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 8),
            
            // 取消按鈕
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _cancelTimeEdit,
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.red,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '取消',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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
          if (widget.activity.estimatedCost != null || widget.activity.address != null) ...[
            const SizedBox(height: 12),
            _buildExtraInfo(context),
          ],
          
          // 旅行小貼士
          if (widget.activity.tips != null && widget.activity.tips!.isNotEmpty) ...[
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

  Widget _buildEditModeControls(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getCategoryColor().withValues(alpha: 0.05),
            _getCategoryColor().withValues(alpha: 0.02),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        border: Border(
          top: BorderSide(
            color: _getCategoryColor().withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 左側：拖拽提示
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.drag_handle,
                  size: 16,
                  color: _getCategoryColor().withValues(alpha: 0.6),
                ),
                const SizedBox(width: 8),
                Text(
                  '拖拽調整順序',
                  style: TextStyle(
                    fontSize: 12,
                    color: _getCategoryColor().withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // 右側：操作按鈕
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 上移按鈕
              if (!widget.isFirstActivity) ...[
                _buildControlButton(
                  icon: Icons.keyboard_arrow_up,
                  color: Colors.blue,
                  onTap: () => widget.onMoveUp?.call(widget.activity),
                  tooltip: '上移',
                ),
                const SizedBox(width: 8),
              ],
              
              // 下移按鈕
              if (!widget.isLastActivity) ...[
                _buildControlButton(
                  icon: Icons.keyboard_arrow_down,
                  color: Colors.blue,
                  onTap: () => widget.onMoveDown?.call(widget.activity),
                  tooltip: '下移',
                ),
                const SizedBox(width: 8),
              ],
              
              // 編輯按鈕
              _buildControlButton(
                icon: Icons.edit,
                color: Colors.orange,
                onTap: () => widget.onEdit?.call(widget.activity),
                tooltip: '編輯',
              ),
              
              const SizedBox(width: 8),
              
              // 刪除按鈕
              _buildControlButton(
                icon: Icons.delete,
                color: Colors.red,
                onTap: () => _showDeleteConfirmation(context),
                tooltip: '刪除',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 18,
              color: Colors.white,
            ),
          ),
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

  void _handleLongPress() {
    final isEditMode = widget.tripId != null 
        ? ref.read(isEditingTripProvider(widget.tripId!))
        : false;

    if (isEditMode) {
      // 編輯模式下長按直接編輯活動內容
      widget.onEdit?.call(widget.activity);
    } else {
      // 非編輯模式下長按進入編輯模式
      HapticFeedback.mediumImpact();
      widget.onEnterEditMode?.call();
    }
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
      final timeString = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      
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
      
      if (fromHour < 0 || fromHour > 23 || toHour < 0 || toHour > 23) return false;
      if (fromMinute < 0 || fromMinute > 59 || toMinute < 0 || toMinute > 59) return false;
      
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

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('刪除活動'),
        content: Text('確定要刪除「${widget.activity.name}」嗎？此操作無法復原。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete?.call(widget.activity);
              HapticFeedback.lightImpact();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('刪除'),
          ),
        ],
      ),
    );
  }

  void _showActivityDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ActivityDetailBottomSheet(
        activity: widget.activity,
        onEdit: () => widget.onEdit?.call(widget.activity),
        onDelete: () => widget.onDelete?.call(widget.activity),
      ),
    );
  }
}