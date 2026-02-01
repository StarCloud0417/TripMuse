import 'package:hive_flutter/hive_flutter.dart';

import '../models/activity.dart';
import '../models/day_plan.dart';
import '../models/destination.dart';
import '../models/enums.dart';
import '../models/trip.dart';
import '../models/trip_request.dart';
import '../models/user.dart';
import '../models/user_preference_analysis.dart';

/// Hive type adapters for all models
class HiveAdapters {
  static const int userTypeId = 15;
  static const int tripTypeId = 1;
  static const int dayPlanTypeId = 2;
  static const int activityTypeId = 3;
  static const int destinationTypeId = 9;
  static const int coordinatesTypeId = 10;
  static const int tripRequestTypeId = 11;
  static const int tripDurationTypeId = 12;
  static const int userPreferenceAnalysisTypeId = 13;
  static const int basicPreferencesTypeId = 14;
  
  /// Register all Hive adapters
  static void registerAdapters() {
    // Register auto-generated adapters
    Hive.registerAdapter(TripAdapter());
    Hive.registerAdapter(DayPlanAdapter());
    Hive.registerAdapter(ActivityAdapter());
    Hive.registerAdapter(DestinationAdapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(TripRequestAdapter());
    Hive.registerAdapter(UserPreferenceAnalysisAdapter());
    Hive.registerAdapter(TripDurationAdapter());
    Hive.registerAdapter(BasicPreferencesAdapter());
    
    // Register enum adapters
    Hive.registerAdapter(ActivityCategoryAdapter());
    Hive.registerAdapter(ActivityPriorityAdapter());
    Hive.registerAdapter(TravelPaceAdapter());
    Hive.registerAdapter(BudgetRangeAdapter());
    Hive.registerAdapter(TravelStyleAdapter());
  }
}

