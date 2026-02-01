// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityCategoryAdapter extends TypeAdapter<ActivityCategory> {
  @override
  final int typeId = 4;

  @override
  ActivityCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ActivityCategory.food;
      case 1:
        return ActivityCategory.sightseeing;
      case 2:
        return ActivityCategory.culture;
      case 3:
        return ActivityCategory.nature;
      case 4:
        return ActivityCategory.shopping;
      default:
        return ActivityCategory.food;
    }
  }

  @override
  void write(BinaryWriter writer, ActivityCategory obj) {
    switch (obj) {
      case ActivityCategory.food:
        writer.writeByte(0);
        break;
      case ActivityCategory.sightseeing:
        writer.writeByte(1);
        break;
      case ActivityCategory.culture:
        writer.writeByte(2);
        break;
      case ActivityCategory.nature:
        writer.writeByte(3);
        break;
      case ActivityCategory.shopping:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActivityPriorityAdapter extends TypeAdapter<ActivityPriority> {
  @override
  final int typeId = 5;

  @override
  ActivityPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ActivityPriority.high;
      case 1:
        return ActivityPriority.medium;
      case 2:
        return ActivityPriority.low;
      default:
        return ActivityPriority.high;
    }
  }

  @override
  void write(BinaryWriter writer, ActivityPriority obj) {
    switch (obj) {
      case ActivityPriority.high:
        writer.writeByte(0);
        break;
      case ActivityPriority.medium:
        writer.writeByte(1);
        break;
      case ActivityPriority.low:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TravelPaceAdapter extends TypeAdapter<TravelPace> {
  @override
  final int typeId = 6;

  @override
  TravelPace read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TravelPace.slow;
      case 1:
        return TravelPace.medium;
      case 2:
        return TravelPace.fast;
      default:
        return TravelPace.slow;
    }
  }

  @override
  void write(BinaryWriter writer, TravelPace obj) {
    switch (obj) {
      case TravelPace.slow:
        writer.writeByte(0);
        break;
      case TravelPace.medium:
        writer.writeByte(1);
        break;
      case TravelPace.fast:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TravelPaceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BudgetRangeAdapter extends TypeAdapter<BudgetRange> {
  @override
  final int typeId = 7;

  @override
  BudgetRange read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BudgetRange.low;
      case 1:
        return BudgetRange.mid;
      case 2:
        return BudgetRange.high;
      default:
        return BudgetRange.low;
    }
  }

  @override
  void write(BinaryWriter writer, BudgetRange obj) {
    switch (obj) {
      case BudgetRange.low:
        writer.writeByte(0);
        break;
      case BudgetRange.mid:
        writer.writeByte(1);
        break;
      case BudgetRange.high:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetRangeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TravelStyleAdapter extends TypeAdapter<TravelStyle> {
  @override
  final int typeId = 8;

  @override
  TravelStyle read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TravelStyle.leisure;
      case 1:
        return TravelStyle.adventure;
      case 2:
        return TravelStyle.cultural;
      case 3:
        return TravelStyle.business;
      default:
        return TravelStyle.leisure;
    }
  }

  @override
  void write(BinaryWriter writer, TravelStyle obj) {
    switch (obj) {
      case TravelStyle.leisure:
        writer.writeByte(0);
        break;
      case TravelStyle.adventure:
        writer.writeByte(1);
        break;
      case TravelStyle.cultural:
        writer.writeByte(2);
        break;
      case TravelStyle.business:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TravelStyleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
