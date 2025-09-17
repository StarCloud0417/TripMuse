import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../utils/sample_trip_with_transport.dart';
import '../widgets/transport_mode_selector.dart';
import '../widgets/transport_info_widget.dart';
import '../services/transport_service.dart';


/// 交通信息演示頁面
/// 
/// 展示交通信息功能的使用方式
class TransportDemoScreen extends ConsumerStatefulWidget {
  const TransportDemoScreen({super.key});

  @override
  ConsumerState<TransportDemoScreen> createState() => _TransportDemoScreenState();
}

class _TransportDemoScreenState extends ConsumerState<TransportDemoScreen> {
  late Trip sampleTrip;
  TransportMode selectedMode = TransportMode.walking;

  @override
  void initState() {
    super.initState();
    sampleTrip = SampleTripWithTransport.createTaipeiDayTrip();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('交通信息演示'),
        backgroundColor: const Color(0xFF4ECDC4),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 交通方式選擇器
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF4ECDC4), Colors.white],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '選擇交通方式',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                TransportModeSelector(
                  selectedMode: selectedMode,
                  onModeChanged: (mode) {
                    setState(() {
                      selectedMode = mode;
                      _updateTransportMode();
                    });
                  },
                  isCompact: true,
                ),
              ],
            ),
          ),
          
          // 行程列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sampleTrip.days.length,
              itemBuilder: (context, dayIndex) {
                final dayPlan = sampleTrip.days[dayIndex];
                return _buildDayPlanCard(dayPlan);
              },
            ),
          ),
          
          // 底部操作按鈕
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildDayPlanCard(DayPlan dayPlan) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 日期標題
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${dayPlan.dayIndex}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dayPlan.formattedDate,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        dayPlan.theme,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 活動列表
            ...dayPlan.activities.asMap().entries.map((entry) {
              final index = entry.key;
              final activity = entry.value;
              final isLastActivity = index == dayPlan.activities.length - 1;
              
              return Column(
                children: [
                  _buildActivityItem(activity),
                  if (!isLastActivity) _buildTransportItem(dayPlan, index),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(Activity activity) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // 活動圖標
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getCategoryColor(activity.category).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getCategoryIcon(activity.category),
              color: _getCategoryColor(activity.category),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          
          // 活動信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${activity.timeFrom} - ${activity.timeTo}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportItem(DayPlan dayPlan, int activityIndex) {
    final transportInfo = dayPlan.getTransportAfter(activityIndex);
    
    if (transportInfo == null) {
      return Container(
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 2,
              height: 40,
              color: Colors.grey.shade300,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '前往下一個活動',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return TransportDivider(
      transportInfo: transportInfo,
      onTap: () => _showTransportModeDialog(dayPlan, activityIndex),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _generateAllTransport,
              icon: const Icon(Icons.directions),
              label: const Text('生成所有交通'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4ECDC4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _autoRecommend,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('智能推薦'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF4ECDC4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateTransportMode() {
    setState(() {
      sampleTrip = TransportService.generateTransportForTrip(sampleTrip, selectedMode);
    });
  }

  void _generateAllTransport() {
    setState(() {
      sampleTrip = TransportService.generateTransportForTrip(sampleTrip, selectedMode);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已生成 ${selectedMode.displayName} 交通信息'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _autoRecommend() {
    setState(() {
      final updatedDays = sampleTrip.days.map((dayPlan) {
        if (dayPlan.activities.length <= 1) return dayPlan;
        
        final transports = <TransportInfo>[];
        for (int i = 0; i < dayPlan.activities.length - 1; i++) {
          final fromActivity = dayPlan.activities[i];
          final toActivity = dayPlan.activities[i + 1];
          
          // 計算距離並推薦交通方式
          final tempTransport = TransportService.calculateTransport(
            fromActivity: fromActivity,
            toActivity: toActivity,
            mode: TransportMode.walking,
          );
          
          final distance = tempTransport.distanceMeters?.toDouble() ?? 0.0;
          final recommendedMode = TransportService.recommendTransportMode(
            fromActivity: fromActivity,
            toActivity: toActivity,
            distanceMeters: distance,
          );
          
          final transport = TransportService.calculateTransport(
            fromActivity: fromActivity,
            toActivity: toActivity,
            mode: recommendedMode,
          );
          
          transports.add(transport);
        }
        
        return dayPlan.copyWith(transports: transports);
      }).toList();
      
      sampleTrip = sampleTrip.copyWith(days: updatedDays);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已自動推薦最適合的交通方式'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showTransportModeDialog(DayPlan dayPlan, int activityIndex) async {
    final transportInfo = dayPlan.getTransportAfter(activityIndex);
    if (transportInfo == null) return;
    
    final fromActivity = dayPlan.activities[activityIndex];
    final toActivity = dayPlan.activities[activityIndex + 1];
    
    final selectedMode = await showDialog<TransportMode>(
      context: context,
      builder: (context) => TransportModeDialog(
        initialMode: transportInfo.mode,
        fromActivityName: fromActivity.name,
        toActivityName: toActivity.name,
      ),
    );
    
    if (selectedMode != null && selectedMode != transportInfo.mode) {
      setState(() {
        final newTransport = TransportService.calculateTransport(
          fromActivity: fromActivity,
          toActivity: toActivity,
          mode: selectedMode,
        );
        
        final updatedTransports = List<TransportInfo>.from(dayPlan.transports);
        updatedTransports[activityIndex] = newTransport;
        
        final updatedDayPlan = dayPlan.copyWith(transports: updatedTransports);
        final updatedDays = List<DayPlan>.from(sampleTrip.days);
        final dayIndex = sampleTrip.days.indexOf(dayPlan);
        updatedDays[dayIndex] = updatedDayPlan;
        
        sampleTrip = sampleTrip.copyWith(days: updatedDays);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('已更新交通方式為 ${selectedMode.displayName}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Color _getCategoryColor(ActivityCategory category) {
    switch (category) {
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

  IconData _getCategoryIcon(ActivityCategory category) {
    switch (category) {
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
}