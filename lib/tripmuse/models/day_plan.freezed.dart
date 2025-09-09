// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DayPlan _$DayPlanFromJson(Map<String, dynamic> json) {
  return _DayPlan.fromJson(json);
}

/// @nodoc
mixin _$DayPlan {
  /// 日期索引 (從 1 開始)
  int get dayIndex => throw _privateConstructorUsedError;

  /// 日期
  DateTime get date => throw _privateConstructorUsedError;

  /// 當日主題
  String get theme => throw _privateConstructorUsedError;

  /// 當日活動列表
  List<Activity> get activities => throw _privateConstructorUsedError;

  /// 當日備註
  String? get notes => throw _privateConstructorUsedError;

  /// 預估總花費
  String? get estimatedTotalCost => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DayPlanCopyWith<DayPlan> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DayPlanCopyWith<$Res> {
  factory $DayPlanCopyWith(DayPlan value, $Res Function(DayPlan) then) =
      _$DayPlanCopyWithImpl<$Res, DayPlan>;
  @useResult
  $Res call(
      {int dayIndex,
      DateTime date,
      String theme,
      List<Activity> activities,
      String? notes,
      String? estimatedTotalCost});
}

/// @nodoc
class _$DayPlanCopyWithImpl<$Res, $Val extends DayPlan>
    implements $DayPlanCopyWith<$Res> {
  _$DayPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayIndex = null,
    Object? date = null,
    Object? theme = null,
    Object? activities = null,
    Object? notes = freezed,
    Object? estimatedTotalCost = freezed,
  }) {
    return _then(_value.copyWith(
      dayIndex: null == dayIndex
          ? _value.dayIndex
          : dayIndex // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      activities: null == activities
          ? _value.activities
          : activities // ignore: cast_nullable_to_non_nullable
              as List<Activity>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedTotalCost: freezed == estimatedTotalCost
          ? _value.estimatedTotalCost
          : estimatedTotalCost // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DayPlanImplCopyWith<$Res> implements $DayPlanCopyWith<$Res> {
  factory _$$DayPlanImplCopyWith(
          _$DayPlanImpl value, $Res Function(_$DayPlanImpl) then) =
      __$$DayPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int dayIndex,
      DateTime date,
      String theme,
      List<Activity> activities,
      String? notes,
      String? estimatedTotalCost});
}

/// @nodoc
class __$$DayPlanImplCopyWithImpl<$Res>
    extends _$DayPlanCopyWithImpl<$Res, _$DayPlanImpl>
    implements _$$DayPlanImplCopyWith<$Res> {
  __$$DayPlanImplCopyWithImpl(
      _$DayPlanImpl _value, $Res Function(_$DayPlanImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayIndex = null,
    Object? date = null,
    Object? theme = null,
    Object? activities = null,
    Object? notes = freezed,
    Object? estimatedTotalCost = freezed,
  }) {
    return _then(_$DayPlanImpl(
      dayIndex: null == dayIndex
          ? _value.dayIndex
          : dayIndex // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      activities: null == activities
          ? _value._activities
          : activities // ignore: cast_nullable_to_non_nullable
              as List<Activity>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedTotalCost: freezed == estimatedTotalCost
          ? _value.estimatedTotalCost
          : estimatedTotalCost // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DayPlanImpl implements _DayPlan {
  const _$DayPlanImpl(
      {required this.dayIndex,
      required this.date,
      required this.theme,
      final List<Activity> activities = const [],
      this.notes,
      this.estimatedTotalCost})
      : _activities = activities;

  factory _$DayPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$DayPlanImplFromJson(json);

  /// 日期索引 (從 1 開始)
  @override
  final int dayIndex;

  /// 日期
  @override
  final DateTime date;

  /// 當日主題
  @override
  final String theme;

  /// 當日活動列表
  final List<Activity> _activities;

  /// 當日活動列表
  @override
  @JsonKey()
  List<Activity> get activities {
    if (_activities is EqualUnmodifiableListView) return _activities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activities);
  }

  /// 當日備註
  @override
  final String? notes;

  /// 預估總花費
  @override
  final String? estimatedTotalCost;

  @override
  String toString() {
    return 'DayPlan(dayIndex: $dayIndex, date: $date, theme: $theme, activities: $activities, notes: $notes, estimatedTotalCost: $estimatedTotalCost)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DayPlanImpl &&
            (identical(other.dayIndex, dayIndex) ||
                other.dayIndex == dayIndex) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            const DeepCollectionEquality()
                .equals(other._activities, _activities) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.estimatedTotalCost, estimatedTotalCost) ||
                other.estimatedTotalCost == estimatedTotalCost));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      dayIndex,
      date,
      theme,
      const DeepCollectionEquality().hash(_activities),
      notes,
      estimatedTotalCost);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DayPlanImplCopyWith<_$DayPlanImpl> get copyWith =>
      __$$DayPlanImplCopyWithImpl<_$DayPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DayPlanImplToJson(
      this,
    );
  }
}

abstract class _DayPlan implements DayPlan {
  const factory _DayPlan(
      {required final int dayIndex,
      required final DateTime date,
      required final String theme,
      final List<Activity> activities,
      final String? notes,
      final String? estimatedTotalCost}) = _$DayPlanImpl;

  factory _DayPlan.fromJson(Map<String, dynamic> json) = _$DayPlanImpl.fromJson;

  @override

  /// 日期索引 (從 1 開始)
  int get dayIndex;
  @override

  /// 日期
  DateTime get date;
  @override

  /// 當日主題
  String get theme;
  @override

  /// 當日活動列表
  List<Activity> get activities;
  @override

  /// 當日備註
  String? get notes;
  @override

  /// 預估總花費
  String? get estimatedTotalCost;
  @override
  @JsonKey(ignore: true)
  _$$DayPlanImplCopyWith<_$DayPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
