import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'destination.dart';
import 'day_plan.dart';
import 'user_preference_analysis.dart';
import 'activity.dart';
import 'enums.dart';

part 'trip.freezed.dart';
part 'trip.g.dart';

/// Represents a complete travel itinerary
@freezed
@HiveType(typeId: 0)
class Trip with _$Trip {
  const factory Trip({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required Destination destination,
    @HiveField(3) required List<DayPlan> days,
    @HiveField(4) required UserPreferenceAnalysis preferenceAnalysis,
    @HiveField(5) required DateTime createdAt,
    @HiveField(6) required DateTime updatedAt,
    @HiveField(7) String? userId,
    @HiveField(8) String? generatedBy,
    @HiveField(9) @Default(false) bool isFavorite,
    @HiveField(10) @Default(false) bool isShared,
    @HiveField(11) String? shareToken,
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
}

/// Extension methods for Trip
extension TripExtension on Trip {
  /// Get total number of activities across all days
  int get totalActivities {
    return days.fold(0, (sum, day) => sum + day.activities.length);
  }

  /// Get trip duration in days
  int get duration => days.length;

  /// Get start date of the trip
  DateTime get startDate {
    if (days.isEmpty) return createdAt;
    return days.first.date;
  }

  /// Get end date of the trip
  DateTime get endDate {
    if (days.isEmpty) return createdAt;
    return days.last.date;
  }

  /// Get all activities across all days
  List<Activity> get allActivities {
    return days.expand((day) => day.activities).toList();
  }

  /// Get activities by category
  List<Activity> getActivitiesByCategory(ActivityCategory category) {
    return allActivities.where((activity) => activity.category == category).toList();
  }

  /// Get high priority activities
  List<Activity> get highPriorityActivities {
    return allActivities.where((activity) => activity.priority == ActivityPriority.high).toList();
  }

  /// Check if trip is currently active (today falls within trip dates)
  bool get isActive {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    
    return today.isAfter(start.subtract(const Duration(days: 1))) && 
           today.isBefore(end.add(const Duration(days: 1)));
  }

  /// Get current day plan if trip is active
  DayPlan? get currentDayPlan {
    if (!isActive) return null;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return days.firstWhere(
      (day) {
        final dayDate = DateTime(day.date.year, day.date.month, day.date.day);
        return dayDate.isAtSameMomentAs(today);
      },
      orElse: () => days.first,
    );
  }

  /// Create a copy with updated modification time
  Trip copyWithUpdatedTime() {
    return copyWith(updatedAt: DateTime.now());
  }
}