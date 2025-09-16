/// TripMuse 活動拖拉目標區域組件
///
/// 提供活動拖拉的目標區域，支援時間段調整

import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class ActivityDropTarget extends StatefulWidget {
  final String timeSlot;
  final Function(Activity, String)? onActivityDropped;
  final Widget child;
  final bool isActive;

  const ActivityDropTarget({
    super.key,
    required this.timeSlot,
    required this.child,
    this.onActivityDropped,
    this.isActive = true,
  });

  @override
  State<ActivityDropTarget> createState() => _ActivityDropTargetState();
}

class _ActivityDropTargetState extends State<ActivityDropTarget>
    with TickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: DragTarget<Activity>(
            onWillAcceptWithDetails: (details) {
              return true;
            },
            onAcceptWithDetails: (details) {
              widget.onActivityDropped?.call(details.data, widget.timeSlot);
              setState(() => _isHovering = false);
              _scaleController.reverse();
            },
            onMove: (details) {
              if (!_isHovering) {
                setState(() => _isHovering = true);
                _scaleController.forward();
              }
            },
            onLeave: (activity) {
              setState(() => _isHovering = false);
              _scaleController.reverse();
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: _isHovering
                      ? Border.all(
                          color: TripMuseTheme.primaryColor,
                          width: 2,
                        )
                      : null,
                  boxShadow: _isHovering
                      ? [
                          BoxShadow(
                            color: TripMuseTheme.primaryColor.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Stack(
                  children: [
                    widget.child,
                    if (_isHovering)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: TripMuseTheme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: TripMuseTheme.primaryColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: TripMuseTheme.primaryColor.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '放置到 ${widget.timeSlot}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
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
              );
            },
          ),
        );
      },
    );
  }
}

/// 時間段拖拉目標組件
class TimeSlotDropTarget extends StatelessWidget {
  final String timeSlot;
  final Function(Activity, String)? onActivityDropped;
  final bool isEmpty;

  const TimeSlotDropTarget({
    super.key,
    required this.timeSlot,
    this.onActivityDropped,
    this.isEmpty = true,
  });

  @override
  Widget build(BuildContext context) {
    return ActivityDropTarget(
      timeSlot: timeSlot,
      onActivityDropped: onActivityDropped,
      child: Container(
        height: isEmpty ? 80 : 40,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isEmpty ? Colors.grey.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isEmpty
              ? Border.all(
                  color: Colors.grey.shade300,
                  style: BorderStyle.solid,
                )
              : null,
        ),
        child: isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: Colors.grey.shade400,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeSlot,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeSlot,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

/// 日期間拖拉目標組件
class DayDropTarget extends StatefulWidget {
  final int dayNumber;
  final String dayTitle;
  final Function(Activity, int)? onActivityDropped;

  const DayDropTarget({
    super.key,
    required this.dayNumber,
    required this.dayTitle,
    this.onActivityDropped,
  });

  @override
  State<DayDropTarget> createState() => _DayDropTargetState();
}

class _DayDropTargetState extends State<DayDropTarget>
    with TickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: DragTarget<Activity>(
            onWillAcceptWithDetails: (details) => true,
            onAcceptWithDetails: (details) {
              widget.onActivityDropped?.call(details.data, widget.dayNumber);
              setState(() => _isHovering = false);
              _pulseController.stop();
            },
            onMove: (details) {
              if (!_isHovering) {
                setState(() => _isHovering = true);
                _pulseController.repeat(reverse: true);
              }
            },
            onLeave: (activity) {
              setState(() => _isHovering = false);
              _pulseController.stop();
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: _isHovering
                      ? LinearGradient(
                          colors: [
                            TripMuseTheme.primaryColor.withValues(alpha: 0.2),
                            TripMuseTheme.primaryColor.withValues(alpha: 0.1),
                          ],
                        )
                      : LinearGradient(
                          colors: [
                            Colors.grey.shade100,
                            Colors.grey.shade50,
                          ],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isHovering
                        ? TripMuseTheme.primaryColor
                        : Colors.grey.shade300,
                    width: _isHovering ? 2 : 1,
                  ),
                  boxShadow: _isHovering
                      ? [
                          BoxShadow(
                            color: TripMuseTheme.primaryColor.withValues(alpha: 0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _isHovering
                                ? TripMuseTheme.primaryColor
                                : Colors.grey.shade400,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${widget.dayNumber}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.dayTitle,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _isHovering
                                  ? TripMuseTheme.primaryColor
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_isHovering) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: TripMuseTheme.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              '移動到此日',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}