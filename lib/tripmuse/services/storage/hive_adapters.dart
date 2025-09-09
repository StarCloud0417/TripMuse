/// Hive TypeAdapter 定義
/// 
/// 為 TripMuse 資料模型建立 Hive 儲存適配器

import 'package:hive/hive.dart';
import '../../models/models.dart';

/// 註冊所有 Hive TypeAdapter
class HiveAdapters {
  static void registerAdapters() {
    // 註冊列舉類型適配器
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ActivityCategoryAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ActivityPriorityAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TravelPaceAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(BudgetRangeAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(TravelStyleAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(TripStatusAdapter());
    }
    
    // 註冊資料模型適配器
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(ActivityAdapter());
    }
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(DayPlanAdapter());
    }
    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(DestinationAdapter());
    }
    if (!Hive.isAdapterRegistered(13)) {
      Hive.registerAdapter(UserPreferenceAnalysisAdapter());
    }
    if (!Hive.isAdapterRegistered(14)) {
      Hive.registerAdapter(TripAdapter());
    }
    if (!Hive.isAdapterRegistered(15)) {
      Hive.registerAdapter(TripSharingSettingsAdapter());
    }
  }
}

/// ActivityCategory Hive Adapter
class ActivityCategoryAdapter extends TypeAdapter<ActivityCategory> {
  @override
  final int typeId = 0;

  @override
  ActivityCategory read(BinaryReader reader) {
    final index = reader.readByte();
    return ActivityCategory.values[index];
  }

  @override
  void write(BinaryWriter writer, ActivityCategory obj) {
    writer.writeByte(obj.index);
  }
}

/// ActivityPriority Hive Adapter
class ActivityPriorityAdapter extends TypeAdapter<ActivityPriority> {
  @override
  final int typeId = 1;

  @override
  ActivityPriority read(BinaryReader reader) {
    final index = reader.readByte();
    return ActivityPriority.values[index];
  }

  @override
  void write(BinaryWriter writer, ActivityPriority obj) {
    writer.writeByte(obj.index);
  }
}

/// TravelPace Hive Adapter
class TravelPaceAdapter extends TypeAdapter<TravelPace> {
  @override
  final int typeId = 2;

  @override
  TravelPace read(BinaryReader reader) {
    final index = reader.readByte();
    return TravelPace.values[index];
  }

  @override
  void write(BinaryWriter writer, TravelPace obj) {
    writer.writeByte(obj.index);
  }
}

/// BudgetRange Hive Adapter
class BudgetRangeAdapter extends TypeAdapter<BudgetRange> {
  @override
  final int typeId = 3;

  @override
  BudgetRange read(BinaryReader reader) {
    final index = reader.readByte();
    return BudgetRange.values[index];
  }

  @override
  void write(BinaryWriter writer, BudgetRange obj) {
    writer.writeByte(obj.index);
  }
}

/// TravelStyle Hive Adapter
class TravelStyleAdapter extends TypeAdapter<TravelStyle> {
  @override
  final int typeId = 4;

  @override
  TravelStyle read(BinaryReader reader) {
    final index = reader.readByte();
    return TravelStyle.values[index];
  }

  @override
  void write(BinaryWriter writer, TravelStyle obj) {
    writer.writeByte(obj.index);
  }
}

/// TripStatus Hive Adapter
class TripStatusAdapter extends TypeAdapter<TripStatus> {
  @override
  final int typeId = 5;

  @override
  TripStatus read(BinaryReader reader) {
    final index = reader.readByte();
    return TripStatus.values[index];
  }

  @override
  void write(BinaryWriter writer, TripStatus obj) {
    writer.writeByte(obj.index);
  }
}

/// Activity Hive Adapter
class ActivityAdapter extends TypeAdapter<Activity> {
  @override
  final int typeId = 10;

  @override
  Activity read(BinaryReader reader) {
    final json = Map<String, dynamic>.from(reader.read());
    return Activity.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
    writer.write(obj.toJson());
  }
}

/// DayPlan Hive Adapter
class DayPlanAdapter extends TypeAdapter<DayPlan> {
  @override
  final int typeId = 11;

  @override
  DayPlan read(BinaryReader reader) {
    final json = Map<String, dynamic>.from(reader.read());
    return DayPlan.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, DayPlan obj) {
    writer.write(obj.toJson());
  }
}

/// Destination Hive Adapter
class DestinationAdapter extends TypeAdapter<Destination> {
  @override
  final int typeId = 12;

  @override
  Destination read(BinaryReader reader) {
    final json = Map<String, dynamic>.from(reader.read());
    return Destination.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, Destination obj) {
    writer.write(obj.toJson());
  }
}

/// UserPreferenceAnalysis Hive Adapter
class UserPreferenceAnalysisAdapter extends TypeAdapter<UserPreferenceAnalysis> {
  @override
  final int typeId = 13;

  @override
  UserPreferenceAnalysis read(BinaryReader reader) {
    final json = Map<String, dynamic>.from(reader.read());
    return UserPreferenceAnalysis.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, UserPreferenceAnalysis obj) {
    writer.write(obj.toJson());
  }
}

/// Trip Hive Adapter
class TripAdapter extends TypeAdapter<Trip> {
  @override
  final int typeId = 14;

  @override
  Trip read(BinaryReader reader) {
    final json = Map<String, dynamic>.from(reader.read());
    return Trip.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, Trip obj) {
    writer.write(obj.toJson());
  }
}

/// TripSharingSettings Hive Adapter
class TripSharingSettingsAdapter extends TypeAdapter<TripSharingSettings> {
  @override
  final int typeId = 15;

  @override
  TripSharingSettings read(BinaryReader reader) {
    final json = Map<String, dynamic>.from(reader.read());
    return TripSharingSettings.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, TripSharingSettings obj) {
    writer.write(obj.toJson());
  }
}