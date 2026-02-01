import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'activity.dart';

part 'day_plan.freezed.dart';
part 'day_plan.g.dart';

/// Represents a single day's itinerary within a trip
@freezed
@HiveType(typeId: 2)
class DayPlan with _$DayPlan {
  const factory DayPlan({
    @HiveField(0) required int dayIndex,
    @HiveField(1) required DateTime date,
    @HiveField(2) required String theme,
    @HiveField(3) required List<Activity> activities,
  }) = _DayPlan;

  factory DayPlan.fromJson(Map<String, dynamic> json) =>
      _$DayPlanFromJson(json);
}

/// Extension methods for DayPlan
extension DayPlanExtension on DayPlan {
  /// Get total estimated cost for the day
  String get totalEstimatedCost {
    final costs = activities
        .where((activity) => activity.estimatedCost != null)
        .map((activity) => activity.estimatedCost!)
        .toList();
    
    if (costs.isEmpty) return 'N/A';
    
    // Simple implementation - in real app would parse currency amounts
    return 'NT\$${costs.length * 500}-${costs.length * 1000}';
  }

  /// Get activities by time period
  List<Activity> get morningActivities {
    return activities.where((activity) {
      final hour = int.parse(activity.timeFrom.split(':')[0]);
      return hour >= 6 && hour < 12;
    }).toList();
  }

  List<Activity> get afternoonActivities {
    return activities.where((activity) {
      final hour = int.parse(activity.timeFrom.split(':')[0]);
      return hour >= 12 && hour < 18;
    }).toList();
  }

  List<Activity> get eveningActivities {
    return activities.where((activity) {
      final hour = int.parse(activity.timeFrom.split(':')[0]);
      return hour >= 18;
    }).toList();
  }

  /// Get current activity based on current time
  Activity? getCurrentActivity(DateTime currentTime) {
    try {
      return activities.firstWhere(
        (activity) => activity.isActiveAt(currentTime),
      );
    } catch (e) {
      return activities.isNotEmpty ? activities.first : null;
    }
  }

  /// Get next activity based on current time
  Activity? getNextActivity(DateTime currentTime) {
    final currentHour = currentTime.hour;
    final currentMinute = currentTime.minute;
    
    for (final activity in activities) {
      final activityHour = int.parse(activity.timeFrom.split(':')[0]);
      final activityMinute = int.parse(activity.timeFrom.split(':')[1]);
      
      if (activityHour > currentHour || 
          (activityHour == currentHour && activityMinute > currentMinute)) {
        return activity;
      }
    }
    
    return null; // No more activities for the day
  }
}