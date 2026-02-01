import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'destination.freezed.dart';
part 'destination.g.dart';

/// Represents a travel destination with location information
@freezed
@HiveType(typeId: 9)
class Destination with _$Destination {
  const factory Destination({
    @HiveField(0) required String name,
    @HiveField(1) required String city,
    @HiveField(2) required String country,
    @HiveField(3) required double lat,
    @HiveField(4) required double lng,
    @HiveField(5) String? placeId,
  }) = _Destination;

  factory Destination.fromJson(Map<String, dynamic> json) =>
      _$DestinationFromJson(json);
}

/// Represents coordinates for a location
@freezed
@HiveType(typeId: 10)
class Coordinates with _$Coordinates {
  const factory Coordinates({
    @HiveField(0) required double lat,
    @HiveField(1) required double lng,
  }) = _Coordinates;

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);
}