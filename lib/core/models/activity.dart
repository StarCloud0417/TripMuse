import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'enums.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

/// Represents a single activity/location in a travel itinerary
@freezed
@HiveType(typeId: 3)
class Activity with _$Activity {
  const factory Activity({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String description,
    @HiveField(3) required double lat,
    @HiveField(4) required double lng,
    @HiveField(5) required String timeFrom,
    @HiveField(6) required String timeTo,
    @HiveField(7) required ActivityCategory category,
    @HiveField(8) required ActivityPriority priority,
    @HiveField(9) String? estimatedCost,
    @HiveField(10) String? tips,
    @HiveField(11) String? address,
    @HiveField(12) @Default([]) List<String> photos,
    @HiveField(13) double? rating,
    @HiveField(14) String? placeId,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}

/// Extension methods for Activity
extension ActivityExtension on Activity {
  /// Calculate duration in minutes
  int get durationInMinutes {
    final now = DateTime.now();
    final from = _parseTime(timeFrom, now);
    final to = _parseTime(timeTo, now);
    return to.difference(from).inMinutes;
  }

  /// Check if activity is currently active based on current time
  bool isActiveAt(DateTime currentTime) {
    final from = _parseTime(timeFrom, currentTime);
    final to = _parseTime(timeTo, currentTime);
    final current = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      currentTime.hour,
      currentTime.minute,
    );
    return (current.isAfter(from) || current.isAtSameMomentAs(from)) && 
           current.isBefore(to);
  }

  DateTime _parseTime(String timeString, DateTime referenceDate) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(referenceDate.year, referenceDate.month, referenceDate.day, hour, minute);
  }
}