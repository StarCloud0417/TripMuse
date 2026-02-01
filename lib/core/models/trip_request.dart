import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'destination.dart';
import 'user_preference_analysis.dart';

part 'trip_request.freezed.dart';
part 'trip_request.g.dart';

/// Represents a request to generate a trip itinerary
@freezed
@HiveType(typeId: 11)
class TripRequest with _$TripRequest {
  const factory TripRequest({
    @HiveField(0) required Destination destination,
    @HiveField(1) required TripDuration duration,
    @HiveField(2) required String travelDescription,
    @HiveField(3) required BasicPreferences basicPreferences,
    @HiveField(4) @Default('zh-TW') String locale,
  }) = _TripRequest;

  factory TripRequest.fromJson(Map<String, dynamic> json) =>
      _$TripRequestFromJson(json);
}

/// Represents the duration of a trip
@freezed
@HiveType(typeId: 12)
class TripDuration with _$TripDuration {
  const factory TripDuration({
    @HiveField(0) required int days,
    @HiveField(1) required DateTime startDate,
    @HiveField(2) required DateTime endDate,
  }) = _TripDuration;

  factory TripDuration.fromJson(Map<String, dynamic> json) =>
      _$TripDurationFromJson(json);
}

/// Extension methods for TripDuration
extension TripDurationExtension on TripDuration {
  /// Validate that the duration is consistent
  bool get isValid {
    final calculatedDays = endDate.difference(startDate).inDays + 1;
    return calculatedDays == days && 
           (startDate.isBefore(endDate) || startDate.isAtSameMomentAs(endDate));
  }

  /// Get list of dates for the trip
  List<DateTime> get dateList {
    final dates = <DateTime>[];
    for (int i = 0; i < days; i++) {
      dates.add(startDate.add(Duration(days: i)));
    }
    return dates;
  }
}