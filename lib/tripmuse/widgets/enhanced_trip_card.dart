/// TripMuse 增強版行程卡片組件
/// 
/// 提供更豐富的行程預覽功能，包含預覽地圖、狀態標籤、收藏功能等

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/trip_provider.dart';
import '../services/destination_image_service.dart';

class EnhancedTripCard extends ConsumerWidget {
  const EnhancedTripCard({
    super.key,
    required this.trip,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onDuplicate,
    this.showActions = true,
    this.cardType = TripCardType.standard,
  });

  final Trip trip;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onDuplicate;
  final bool showActions;
  final TripCardType cardType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (cardType) {
      case TripCardType.compact:
        return _buildCompactCard(context, ref);
      case TripCardType.featured:
        return _buildFeaturedCard(context, ref);
      case TripCardType.standard:
        return _buildStandardCard(context, ref);
    }
  }

  /// 建立標準卡片
  Widget _buildStandardCard(BuildContext context, WidgetRef ref) {
    final imageService = DestinationImageService();
    final imageUrl = imageService.getDestinationThumbnail(
      trip.destination.city,
      trip.destination.country,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 圖片區域
              _buildImageSection(imageUrl, ref),
              
              // 內容區域
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 標題和收藏按鈕
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            trip.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (showActions) _buildFavoriteButton(ref),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // 目的地和天數
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${trip.destination.city}, ${trip.destination.country}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4ECDC4).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${trip.days.length}天',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4ECDC4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // 日期和狀態
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTripDate(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const Spacer(),
                        _buildStatusChip(),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // 統計信息
                    Row(
                      children: [
                        _buildStatItem(
                          Icons.event,
                          '${_getTotalActivities()}個景點',
                        ),
                        const SizedBox(width: 16),
                        _buildStatItem(
                          Icons.access_time,
                          trip.formattedCreatedAt,
                        ),
                        const Spacer(),
                        if (showActions) _buildActionMenu(context),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 建立精簡卡片
  Widget _buildCompactCard(BuildContext context, WidgetRef ref) {
    final imageService = DestinationImageService();
    final imageUrl = imageService.getDestinationThumbnail(
      trip.destination.city,
      trip.destination.country,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // 縮圖
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // 內容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${trip.destination.city} • ${trip.days.length}天',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildStatusChip(),
                  ],
                ),
              ),
              
              // 收藏按鈕
              if (showActions) _buildFavoriteButton(ref),
            ],
          ),
        ),
      ),
    );
  }

  /// 建立特色卡片
  Widget _buildFeaturedCard(BuildContext context, WidgetRef ref) {
    final imageService = DestinationImageService();
    final imageUrl = imageService.getDestinationThumbnail(
      trip.destination.city,
      trip.destination.country,
    );

    return Container(
      height: 250,
      margin: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // 背景圖片
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                        stops: const [0.3, 1.0],
                      ),
                    ),
                  ),
                ),
                
                // 頂部操作區
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Row(
                    children: [
                      _buildStatusChip(isOverlay: true),
                      const Spacer(),
                      if (showActions) _buildFavoriteButton(ref, isOverlay: true),
                    ],
                  ),
                ),
                
                // 底部內容
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 4,
                              color: Colors.black45,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${trip.destination.city}, ${trip.destination.country}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.white.withValues(alpha: 0.8),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${trip.days.length}天 • ${_formatTripDate()}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 建立圖片區域
  Widget _buildImageSection(String imageUrl, WidgetRef ref) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // 漸層遮罩
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                ],
              ),
            ),
          ),
          
          // 狀態標籤
          Positioned(
            top: 16,
            left: 16,
            child: _buildStatusChip(isOverlay: true),
          ),
        ],
      ),
    );
  }

  /// 建立收藏按鈕
  Widget _buildFavoriteButton(WidgetRef ref, {bool isOverlay = false}) {
    final isFavorite = ref.watch(favoriteTripProvider).contains(trip.id);
    
    return GestureDetector(
      onTap: () {
        ref.read(favoriteTripProvider.notifier).toggleFavorite(trip.id);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isOverlay 
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isOverlay 
              ? Colors.white 
              : (isFavorite ? Colors.red : Colors.grey.shade600),
          size: 20,
        ),
      ),
    );
  }

  /// 建立狀態標籤
  Widget _buildStatusChip({bool isOverlay = false}) {
    final now = DateTime.now();
    final startDate = trip.days.isNotEmpty ? trip.days.first.date : DateTime.now();
    final endDate = trip.days.isNotEmpty ? trip.days.last.date : DateTime.now();
    
    String statusText;
    Color statusColor;
    
    if (now.isBefore(startDate)) {
      statusText = '即將開始';
      statusColor = const Color(0xFF2196F3);
    } else if (now.isAfter(endDate)) {
      statusText = '已完成';
      statusColor = Colors.grey.shade600;
    } else {
      statusText = '進行中';
      statusColor = const Color(0xFF4CAF50);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOverlay 
            ? statusColor.withValues(alpha: 0.9)
            : statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: isOverlay ? Colors.white : statusColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// 建立統計項目
  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.grey.shade500,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  /// 建立操作選單
  Widget _buildActionMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'duplicate':
            onDuplicate?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 20, color: Color(0xFF4ECDC4)),
              SizedBox(width: 8),
              Text('編輯'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'duplicate',
          child: Row(
            children: [
              Icon(Icons.copy, size: 20, color: Color(0xFF4ECDC4)),
              SizedBox(width: 8),
              Text('複製'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 20, color: Colors.red),
              SizedBox(width: 8),
              Text('刪除', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.more_vert,
          color: Colors.grey.shade600,
          size: 16,
        ),
      ),
    );
  }

  /// 格式化行程日期
  String _formatTripDate() {
    if (trip.days.isEmpty) return '未設定日期';
    
    final startDate = trip.days.first.date;
    final endDate = trip.days.last.date;
    
    if (trip.days.length == 1) {
      return '${startDate.month}/${startDate.day}';
    }
    
    if (startDate.year == endDate.year && startDate.month == endDate.month) {
      return '${startDate.month}/${startDate.day} - ${endDate.day}';
    }
    
    return '${startDate.month}/${startDate.day} - ${endDate.month}/${endDate.day}';
  }

  /// 取得總活動數
  int _getTotalActivities() {
    return trip.days.fold(0, (total, day) => total + day.activities.length);
  }
}

/// 行程卡片類型
enum TripCardType {
  standard,   // 標準卡片
  compact,    // 精簡卡片
  featured,   // 特色卡片
}