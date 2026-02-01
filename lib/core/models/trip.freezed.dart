// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Trip _$TripFromJson(Map<String, dynamic> json) {
  return _Trip.fromJson(json);
}

/// @nodoc
mixin _$Trip {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get title => throw _privateConstructorUsedError;
  @HiveField(2)
  Destination get destination => throw _privateConstructorUsedError;
  @HiveField(3)
  List<DayPlan> get days => throw _privateConstructorUsedError;
  @HiveField(4)
  UserPreferenceAnalysis get preferenceAnalysis =>
      throw _privateConstructorUsedError;
  @HiveField(5)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get userId => throw _privateConstructorUsedError;
  @HiveField(8)
  String? get generatedBy => throw _privateConstructorUsedError;
  @HiveField(9)
  bool get isFavorite => throw _privateConstructorUsedError;
  @HiveField(10)
  bool get isShared => throw _privateConstructorUsedError;
  @HiveField(11)
  String? get shareToken => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TripCopyWith<Trip> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripCopyWith<$Res> {
  factory $TripCopyWith(Trip value, $Res Function(Trip) then) =
      _$TripCopyWithImpl<$Res, Trip>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) Destination destination,
      @HiveField(3) List<DayPlan> days,
      @HiveField(4) UserPreferenceAnalysis preferenceAnalysis,
      @HiveField(5) DateTime createdAt,
      @HiveField(6) DateTime updatedAt,
      @HiveField(7) String? userId,
      @HiveField(8) String? generatedBy,
      @HiveField(9) bool isFavorite,
      @HiveField(10) bool isShared,
      @HiveField(11) String? shareToken});

  $DestinationCopyWith<$Res> get destination;
  $UserPreferenceAnalysisCopyWith<$Res> get preferenceAnalysis;
}

/// @nodoc
class _$TripCopyWithImpl<$Res, $Val extends Trip>
    implements $TripCopyWith<$Res> {
  _$TripCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? destination = null,
    Object? days = null,
    Object? preferenceAnalysis = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userId = freezed,
    Object? generatedBy = freezed,
    Object? isFavorite = null,
    Object? isShared = null,
    Object? shareToken = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as Destination,
      days: null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as List<DayPlan>,
      preferenceAnalysis: null == preferenceAnalysis
          ? _value.preferenceAnalysis
          : preferenceAnalysis // ignore: cast_nullable_to_non_nullable
              as UserPreferenceAnalysis,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      generatedBy: freezed == generatedBy
          ? _value.generatedBy
          : generatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isShared: null == isShared
          ? _value.isShared
          : isShared // ignore: cast_nullable_to_non_nullable
              as bool,
      shareToken: freezed == shareToken
          ? _value.shareToken
          : shareToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DestinationCopyWith<$Res> get destination {
    return $DestinationCopyWith<$Res>(_value.destination, (value) {
      return _then(_value.copyWith(destination: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserPreferenceAnalysisCopyWith<$Res> get preferenceAnalysis {
    return $UserPreferenceAnalysisCopyWith<$Res>(_value.preferenceAnalysis,
        (value) {
      return _then(_value.copyWith(preferenceAnalysis: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TripImplCopyWith<$Res> implements $TripCopyWith<$Res> {
  factory _$$TripImplCopyWith(
          _$TripImpl value, $Res Function(_$TripImpl) then) =
      __$$TripImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) Destination destination,
      @HiveField(3) List<DayPlan> days,
      @HiveField(4) UserPreferenceAnalysis preferenceAnalysis,
      @HiveField(5) DateTime createdAt,
      @HiveField(6) DateTime updatedAt,
      @HiveField(7) String? userId,
      @HiveField(8) String? generatedBy,
      @HiveField(9) bool isFavorite,
      @HiveField(10) bool isShared,
      @HiveField(11) String? shareToken});

  @override
  $DestinationCopyWith<$Res> get destination;
  @override
  $UserPreferenceAnalysisCopyWith<$Res> get preferenceAnalysis;
}

/// @nodoc
class __$$TripImplCopyWithImpl<$Res>
    extends _$TripCopyWithImpl<$Res, _$TripImpl>
    implements _$$TripImplCopyWith<$Res> {
  __$$TripImplCopyWithImpl(_$TripImpl _value, $Res Function(_$TripImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? destination = null,
    Object? days = null,
    Object? preferenceAnalysis = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userId = freezed,
    Object? generatedBy = freezed,
    Object? isFavorite = null,
    Object? isShared = null,
    Object? shareToken = freezed,
  }) {
    return _then(_$TripImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as Destination,
      days: null == days
          ? _value._days
          : days // ignore: cast_nullable_to_non_nullable
              as List<DayPlan>,
      preferenceAnalysis: null == preferenceAnalysis
          ? _value.preferenceAnalysis
          : preferenceAnalysis // ignore: cast_nullable_to_non_nullable
              as UserPreferenceAnalysis,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      generatedBy: freezed == generatedBy
          ? _value.generatedBy
          : generatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isShared: null == isShared
          ? _value.isShared
          : isShared // ignore: cast_nullable_to_non_nullable
              as bool,
      shareToken: freezed == shareToken
          ? _value.shareToken
          : shareToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TripImpl implements _Trip {
  const _$TripImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.title,
      @HiveField(2) required this.destination,
      @HiveField(3) required final List<DayPlan> days,
      @HiveField(4) required this.preferenceAnalysis,
      @HiveField(5) required this.createdAt,
      @HiveField(6) required this.updatedAt,
      @HiveField(7) this.userId,
      @HiveField(8) this.generatedBy,
      @HiveField(9) this.isFavorite = false,
      @HiveField(10) this.isShared = false,
      @HiveField(11) this.shareToken})
      : _days = days;

  factory _$TripImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String title;
  @override
  @HiveField(2)
  final Destination destination;
  final List<DayPlan> _days;
  @override
  @HiveField(3)
  List<DayPlan> get days {
    if (_days is EqualUnmodifiableListView) return _days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_days);
  }

  @override
  @HiveField(4)
  final UserPreferenceAnalysis preferenceAnalysis;
  @override
  @HiveField(5)
  final DateTime createdAt;
  @override
  @HiveField(6)
  final DateTime updatedAt;
  @override
  @HiveField(7)
  final String? userId;
  @override
  @HiveField(8)
  final String? generatedBy;
  @override
  @JsonKey()
  @HiveField(9)
  final bool isFavorite;
  @override
  @JsonKey()
  @HiveField(10)
  final bool isShared;
  @override
  @HiveField(11)
  final String? shareToken;

  @override
  String toString() {
    return 'Trip(id: $id, title: $title, destination: $destination, days: $days, preferenceAnalysis: $preferenceAnalysis, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, generatedBy: $generatedBy, isFavorite: $isFavorite, isShared: $isShared, shareToken: $shareToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            const DeepCollectionEquality().equals(other._days, _days) &&
            (identical(other.preferenceAnalysis, preferenceAnalysis) ||
                other.preferenceAnalysis == preferenceAnalysis) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.generatedBy, generatedBy) ||
                other.generatedBy == generatedBy) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.isShared, isShared) ||
                other.isShared == isShared) &&
            (identical(other.shareToken, shareToken) ||
                other.shareToken == shareToken));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      destination,
      const DeepCollectionEquality().hash(_days),
      preferenceAnalysis,
      createdAt,
      updatedAt,
      userId,
      generatedBy,
      isFavorite,
      isShared,
      shareToken);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      __$$TripImplCopyWithImpl<_$TripImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripImplToJson(
      this,
    );
  }
}

abstract class _Trip implements Trip {
  const factory _Trip(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String title,
      @HiveField(2) required final Destination destination,
      @HiveField(3) required final List<DayPlan> days,
      @HiveField(4) required final UserPreferenceAnalysis preferenceAnalysis,
      @HiveField(5) required final DateTime createdAt,
      @HiveField(6) required final DateTime updatedAt,
      @HiveField(7) final String? userId,
      @HiveField(8) final String? generatedBy,
      @HiveField(9) final bool isFavorite,
      @HiveField(10) final bool isShared,
      @HiveField(11) final String? shareToken}) = _$TripImpl;

  factory _Trip.fromJson(Map<String, dynamic> json) = _$TripImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get title;
  @override
  @HiveField(2)
  Destination get destination;
  @override
  @HiveField(3)
  List<DayPlan> get days;
  @override
  @HiveField(4)
  UserPreferenceAnalysis get preferenceAnalysis;
  @override
  @HiveField(5)
  DateTime get createdAt;
  @override
  @HiveField(6)
  DateTime get updatedAt;
  @override
  @HiveField(7)
  String? get userId;
  @override
  @HiveField(8)
  String? get generatedBy;
  @override
  @HiveField(9)
  bool get isFavorite;
  @override
  @HiveField(10)
  bool get isShared;
  @override
  @HiveField(11)
  String? get shareToken;
  @override
  @JsonKey(ignore: true)
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
