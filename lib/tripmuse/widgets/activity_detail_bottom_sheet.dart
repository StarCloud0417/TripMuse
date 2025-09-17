/// TripMuse 活動詳情底部彈窗組件
///
/// 顯示活動的完整詳細資訊，包含描述、照片、交通建議等

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class ActivityDetailBottomSheet extends StatefulWidget {
  final Activity activity;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ActivityDetailBottomSheet({
    super.key,
    required this.activity,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<ActivityDetailBottomSheet> createState() => _ActivityDetailBottomSheetState();
}

class _ActivityDetailBottomSheetState extends State<ActivityDetailBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _photoController = PageController();
  int _currentPhotoIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _photoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TripMuseRadius.xl),
        ),
      ),
      child: Column(
        children: [
          _buildDragHandle(),
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildDetailsTab(),
                _buildPhotosTab(),
              ],
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: TripMuseSpacing.sm),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: TripMuseTheme.dividerColor,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(TripMuseSpacing.lg),
      child: Row(
        children: [
          // 活動類別圖標
          Container(
            padding: const EdgeInsets.all(TripMuseSpacing.md),
            decoration: BoxDecoration(
              color: _getCategoryColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TripMuseRadius.md),
            ),
            child: Icon(
              _getCategoryIcon(),
              color: _getCategoryColor(),
              size: 32,
            ),
          ),
          
          const SizedBox(width: TripMuseSpacing.md),
          
          // 活動基本資訊
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.activity.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: TripMuseSpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: TripMuseTheme.textSecondary,
                    ),
                    const SizedBox(width: TripMuseSpacing.xs),
                    Text(
                      widget.activity.timeRange,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: TripMuseTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(width: TripMuseSpacing.md),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TripMuseSpacing.sm,
                        vertical: TripMuseSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(),
                        borderRadius: BorderRadius.circular(TripMuseRadius.sm),
                      ),
                      child: Text(
                        widget.activity.priority.displayName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 關閉按鈕
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              foregroundColor: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TripMuseSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(TripMuseRadius.md),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: TripMuseTheme.primaryColor,
          borderRadius: BorderRadius.circular(TripMuseRadius.md),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: TripMuseTheme.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: '概覽'),
          Tab(text: '詳情'),
          Tab(text: '照片'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TripMuseSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 活動描述
          _buildSectionTitle('活動描述'),
          const SizedBox(height: TripMuseSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(TripMuseSpacing.md),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(TripMuseRadius.md),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              widget.activity.description.isNotEmpty 
                  ? widget.activity.description 
                  : '暫無活動描述',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
          ),
          
          const SizedBox(height: TripMuseSpacing.lg),
          
          // 快速資訊
          _buildSectionTitle('快速資訊'),
          const SizedBox(height: TripMuseSpacing.sm),
          _buildQuickInfoGrid(),
          
          const SizedBox(height: TripMuseSpacing.lg),
          
          // 小貼士
          if (widget.activity.tips != null && widget.activity.tips!.isNotEmpty) ...[
            _buildSectionTitle('旅行小貼士'),
            const SizedBox(height: TripMuseSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(TripMuseSpacing.md),
              decoration: BoxDecoration(
                color: TripMuseTheme.infoColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TripMuseRadius.md),
                border: Border.all(
                  color: TripMuseTheme.infoColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: TripMuseTheme.infoColor,
                    size: 20,
                  ),
                  const SizedBox(width: TripMuseSpacing.sm),
                  Expanded(
                    child: Text(
                      widget.activity.tips!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TripMuseSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 地點資訊
          if (widget.activity.address != null) ...[
            _buildSectionTitle('地點資訊'),
            const SizedBox(height: TripMuseSpacing.sm),
            _buildDetailCard(
              icon: Icons.location_on,
              title: '地址',
              content: widget.activity.address!,
              onTap: () => _openInMaps(),
            ),
            const SizedBox(height: TripMuseSpacing.lg),
          ],
          
          // 時間安排
          _buildSectionTitle('時間安排'),
          const SizedBox(height: TripMuseSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _buildTimeCard('開始時間', widget.activity.timeFrom),
              ),
              const SizedBox(width: TripMuseSpacing.md),
              Expanded(
                child: _buildTimeCard('結束時間', widget.activity.timeTo),
              ),
            ],
          ),
          
          const SizedBox(height: TripMuseSpacing.sm),
          
          _buildDetailCard(
            icon: Icons.schedule,
            title: '建議停留時間',
            content: widget.activity.suggestedDurationMinutes != null
                ? '${widget.activity.suggestedDurationMinutes} 分鐘'
                : '${widget.activity.durationMinutes} 分鐘',
          ),
          
          const SizedBox(height: TripMuseSpacing.lg),
          
          // 費用資訊
          if (widget.activity.estimatedCost != null) ...[
            _buildSectionTitle('費用資訊'),
            const SizedBox(height: TripMuseSpacing.sm),
            _buildDetailCard(
              icon: Icons.attach_money,
              title: '預估費用',
              content: widget.activity.estimatedCost!,
            ),
            const SizedBox(height: TripMuseSpacing.lg),
          ],
          
          // 評分資訊
          if (widget.activity.rating != null) ...[
            _buildSectionTitle('評分資訊'),
            const SizedBox(height: TripMuseSpacing.sm),
            _buildRatingCard(),
            const SizedBox(height: TripMuseSpacing.lg),
          ],
          
          // 交通建議
          _buildSectionTitle('交通建議'),
          const SizedBox(height: TripMuseSpacing.sm),
          _buildTransportationSuggestions(),
        ],
      ),
    );
  }

  Widget _buildPhotosTab() {
    if (widget.activity.photos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: TripMuseSpacing.md),
            Text(
              '暫無照片',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // 照片輪播
        Expanded(
          child: PageView.builder(
            controller: _photoController,
            onPageChanged: (index) {
              setState(() {
                _currentPhotoIndex = index;
              });
            },
            itemCount: widget.activity.photos.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(TripMuseSpacing.md),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(TripMuseRadius.lg),
                  boxShadow: TripMuseShadows.medium,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(TripMuseRadius.lg),
                  child: Image.network(
                    widget.activity.photos[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: TripMuseSpacing.sm),
                              Text(
                                '圖片載入失敗',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        
        // 照片指示器
        if (widget.activity.photos.length > 1) ...[
          Container(
            padding: const EdgeInsets.all(TripMuseSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.activity.photos.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentPhotoIndex
                        ? TripMuseTheme.primaryColor
                        : Colors.grey.shade300,
                  ),
                ),
              ),
            ),
          ),
        ],
        
        // 照片計數
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TripMuseSpacing.lg,
            vertical: TripMuseSpacing.sm,
          ),
          child: Text(
            '${_currentPhotoIndex + 1} / ${widget.activity.photos.length}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: TripMuseTheme.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(TripMuseSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 在地圖中查看
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _openInMaps,
              icon: const Icon(Icons.map),
              label: const Text('在地圖中查看'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: TripMuseSpacing.md),
              ),
            ),
          ),
          
          const SizedBox(width: TripMuseSpacing.md),
          
          // 編輯活動
          if (widget.onEdit != null)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onEdit?.call();
                },
                icon: const Icon(Icons.edit),
                label: const Text('編輯活動'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TripMuseTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: TripMuseSpacing.md),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildQuickInfoGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildQuickInfoCard(
                Icons.category,
                '類別',
                widget.activity.category.displayName,
                _getCategoryColor(),
              ),
            ),
            const SizedBox(width: TripMuseSpacing.md),
            Expanded(
              child: _buildQuickInfoCard(
                Icons.schedule,
                '持續時間',
                '${widget.activity.durationMinutes} 分鐘',
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: TripMuseSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildQuickInfoCard(
                Icons.flag,
                '優先級',
                widget.activity.priority.displayName,
                _getPriorityColor(),
              ),
            ),
            const SizedBox(width: TripMuseSpacing.md),
            Expanded(
              child: _buildQuickInfoCard(
                Icons.location_on,
                '座標',
                '${widget.activity.lat.toStringAsFixed(4)}, ${widget.activity.lng.toStringAsFixed(4)}',
                Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickInfoCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(TripMuseSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TripMuseRadius.md),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: TripMuseSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: TripMuseTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: TripMuseSpacing.xs),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String content,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(TripMuseSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(TripMuseRadius.md),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: onTap != null ? TripMuseShadows.small : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(TripMuseSpacing.sm),
              decoration: BoxDecoration(
                color: TripMuseTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TripMuseRadius.sm),
              ),
              child: Icon(
                icon,
                color: TripMuseTheme.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: TripMuseSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: TripMuseTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: TripMuseSpacing.xs),
                  Text(
                    content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCard(String label, String time) {
    return Container(
      padding: const EdgeInsets.all(TripMuseSpacing.md),
      decoration: BoxDecoration(
        color: TripMuseTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TripMuseRadius.md),
        border: Border.all(
          color: TripMuseTheme.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: TripMuseTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: TripMuseSpacing.xs),
          Text(
            time,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: TripMuseTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingCard() {
    final rating = widget.activity.rating!;
    return Container(
      padding: const EdgeInsets.all(TripMuseSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TripMuseRadius.md),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(TripMuseSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TripMuseRadius.sm),
            ),
            child: const Icon(
              Icons.star,
              color: Colors.amber,
              size: 20,
            ),
          ),
          const SizedBox(width: TripMuseSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '用戶評分',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: TripMuseTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: TripMuseSpacing.xs),
                Row(
                  children: [
                    Text(
                      rating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: TripMuseSpacing.sm),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < rating.floor()
                              ? Icons.star
                              : index < rating
                                  ? Icons.star_half
                                  : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportationSuggestions() {
    return Column(
      children: [
        _buildTransportCard(
          Icons.directions_walk,
          '步行',
          '適合短距離移動，可欣賞沿途風景',
          Colors.green,
        ),
        const SizedBox(height: TripMuseSpacing.sm),
        _buildTransportCard(
          Icons.directions_bus,
          '大眾運輸',
          '經濟實惠，體驗當地交通文化',
          Colors.blue,
        ),
        const SizedBox(height: TripMuseSpacing.sm),
        _buildTransportCard(
          Icons.local_taxi,
          '計程車',
          '快速便利，適合攜帶行李時使用',
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildTransportCard(IconData icon, String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(TripMuseSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TripMuseRadius.md),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(TripMuseSpacing.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(TripMuseRadius.sm),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: TripMuseSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: TripMuseSpacing.xs),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: TripMuseTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  void _openInMaps() async {
    final lat = widget.activity.lat;
    final lng = widget.activity.lng;
    
    if (lat == 0.0 && lng == 0.0) {
      _showSnackBar('無法取得地點座標');
      return;
    }

    // 嘗試開啟 Google Maps
    final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    
    try {
      final uri = Uri.parse(googleMapsUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // 如果無法開啟，複製座標到剪貼簿
        await Clipboard.setData(ClipboardData(text: '$lat, $lng'));
        _showSnackBar('已複製座標到剪貼簿：$lat, $lng');
      }
    } catch (e) {
      // 複製座標到剪貼簿作為備用方案
      await Clipboard.setData(ClipboardData(text: '$lat, $lng'));
      _showSnackBar('已複製座標到剪貼簿：$lat, $lng');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}