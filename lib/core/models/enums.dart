// Core enums for the TripMind application
//
// This file contains all the enum types used across the data models

import 'package:hive/hive.dart';

part 'enums.g.dart';

/// Activity category types
@HiveType(typeId: 4)
enum ActivityCategory {
  @HiveField(0) food,
  @HiveField(1) sightseeing,
  @HiveField(2) culture,
  @HiveField(3) nature,
  @HiveField(4) shopping,
}

/// Activity priority levels
@HiveType(typeId: 5)
enum ActivityPriority {
  @HiveField(0) high,
  @HiveField(1) medium,
  @HiveField(2) low,
}

/// Travel pace preferences
@HiveType(typeId: 6)
enum TravelPace {
  @HiveField(0) slow,
  @HiveField(1) medium,
  @HiveField(2) fast,
}

/// Budget range options
@HiveType(typeId: 7)
enum BudgetRange {
  @HiveField(0) low,
  @HiveField(1) mid,
  @HiveField(2) high,
}

/// Travel style preferences
@HiveType(typeId: 8)
enum TravelStyle {
  @HiveField(0) leisure,
  @HiveField(1) adventure,
  @HiveField(2) cultural,
  @HiveField(3) business,
}