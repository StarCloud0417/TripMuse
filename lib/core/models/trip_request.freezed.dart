// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TripRequest _$TripRequestFromJson(Map<String, dynamic> json) {
  return _TripRequest.fromJson(json);
}

/// @nodoc
mixin _$TripRequest {
  @HiveField(0)
  Destination get destination => throw _privateConstructorUsedError;
  @HiveField(1)
  TripDuration get duration => throw _privateConstructorUsedError;
  @HiveField(2)
  String get travelDescription => throw _privateConstructorUsedError;
  @HiveField(3)
  BasicPreferences get basicPreferences => throw _privateConstructorUsedError;
  @HiveField(4)
  String get locale => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TripRequestCopyWith<TripRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripRequestCopyWith<$Res> {
  factory $TripRequestCopyWith(
          TripRequest value, $Res Function(TripRequest) then) =
      _$TripRequestCopyWithImpl<$Res, TripRequest>;
  @useResult
  $Res call(
      {@HiveField(0) Destination destination,
      @HiveField(1) TripDuration duration,
      @HiveField(2) String travelDescription,
      @HiveField(3) BasicPreferences basicPreferences,
      @HiveField(4) String locale});

  $DestinationCopyWith<$Res> get destination;
  $TripDurationCopyWith<$Res> get duration;
  $BasicPreferencesCopyWith<$Res> get basicPreferences;
}

/// @nodoc
class _$TripRequestCopyWithImpl<$Res, $Val extends TripRequest>
    implements $TripRequestCopyWith<$Res> {
  _$TripRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? destination = null,
    Object? duration = null,
    Object? travelDescription = null,
    Object? basicPreferences = null,
    Object? locale = null,
  }) {
    return _then(_value.copyWith(
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as Destination,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as TripDuration,
      travelDescription: null == travelDescription
          ? _value.travelDescription
          : travelDescription // ignore: cast_nullable_to_non_nullable
              as String,
      basicPreferences: null == basicPreferences
          ? _value.basicPreferences
          : basicPreferences // ignore: cast_nullable_to_non_nullable
              as BasicPreferences,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
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
  $TripDurationCopyWith<$Res> get duration {
    return $TripDurationCopyWith<$Res>(_value.duration, (value) {
      return _then(_value.copyWith(duration: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BasicPreferencesCopyWith<$Res> get basicPreferences {
    return $BasicPreferencesCopyWith<$Res>(_value.basicPreferences, (value) {
      return _then(_value.copyWith(basicPreferences: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TripRequestImplCopyWith<$Res>
    implements $TripRequestCopyWith<$Res> {
  factory _$$TripRequestImplCopyWith(
          _$TripRequestImpl value, $Res Function(_$TripRequestImpl) then) =
      __$$TripRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) Destination destination,
      @HiveField(1) TripDuration duration,
      @HiveField(2) String travelDescription,
      @HiveField(3) BasicPreferences basicPreferences,
      @HiveField(4) String locale});

  @override
  $DestinationCopyWith<$Res> get destination;
  @override
  $TripDurationCopyWith<$Res> get duration;
  @override
  $BasicPreferencesCopyWith<$Res> get basicPreferences;
}

/// @nodoc
class __$$TripRequestImplCopyWithImpl<$Res>
    extends _$TripRequestCopyWithImpl<$Res, _$TripRequestImpl>
    implements _$$TripRequestImplCopyWith<$Res> {
  __$$TripRequestImplCopyWithImpl(
      _$TripRequestImpl _value, $Res Function(_$TripRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? destination = null,
    Object? duration = null,
    Object? travelDescription = null,
    Object? basicPreferences = null,
    Object? locale = null,
  }) {
    return _then(_$TripRequestImpl(
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as Destination,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as TripDuration,
      travelDescription: null == travelDescription
          ? _value.travelDescription
          : travelDescription // ignore: cast_nullable_to_non_nullable
              as String,
      basicPreferences: null == basicPreferences
          ? _value.basicPreferences
          : basicPreferences // ignore: cast_nullable_to_non_nullable
              as BasicPreferences,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TripRequestImpl implements _TripRequest {
  const _$TripRequestImpl(
      {@HiveField(0) required this.destination,
      @HiveField(1) required this.duration,
      @HiveField(2) required this.travelDescription,
      @HiveField(3) required this.basicPreferences,
      @HiveField(4) this.locale = 'zh-TW'});

  factory _$TripRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripRequestImplFromJson(json);

  @override
  @HiveField(0)
  final Destination destination;
  @override
  @HiveField(1)
  final TripDuration duration;
  @override
  @HiveField(2)
  final String travelDescription;
  @override
  @HiveField(3)
  final BasicPreferences basicPreferences;
  @override
  @JsonKey()
  @HiveField(4)
  final String locale;

  @override
  String toString() {
    return 'TripRequest(destination: $destination, duration: $duration, travelDescription: $travelDescription, basicPreferences: $basicPreferences, locale: $locale)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripRequestImpl &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.travelDescription, travelDescription) ||
                other.travelDescription == travelDescription) &&
            (identical(other.basicPreferences, basicPreferences) ||
                other.basicPreferences == basicPreferences) &&
            (identical(other.locale, locale) || other.locale == locale));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, destination, duration,
      travelDescription, basicPreferences, locale);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TripRequestImplCopyWith<_$TripRequestImpl> get copyWith =>
      __$$TripRequestImplCopyWithImpl<_$TripRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripRequestImplToJson(
      this,
    );
  }
}

abstract class _TripRequest implements TripRequest {
  const factory _TripRequest(
      {@HiveField(0) required final Destination destination,
      @HiveField(1) required final TripDuration duration,
      @HiveField(2) required final String travelDescription,
      @HiveField(3) required final BasicPreferences basicPreferences,
      @HiveField(4) final String locale}) = _$TripRequestImpl;

  factory _TripRequest.fromJson(Map<String, dynamic> json) =
      _$TripRequestImpl.fromJson;

  @override
  @HiveField(0)
  Destination get destination;
  @override
  @HiveField(1)
  TripDuration get duration;
  @override
  @HiveField(2)
  String get travelDescription;
  @override
  @HiveField(3)
  BasicPreferences get basicPreferences;
  @override
  @HiveField(4)
  String get locale;
  @override
  @JsonKey(ignore: true)
  _$$TripRequestImplCopyWith<_$TripRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TripDuration _$TripDurationFromJson(Map<String, dynamic> json) {
  return _TripDuration.fromJson(json);
}

/// @nodoc
mixin _$TripDuration {
  @HiveField(0)
  int get days => throw _privateConstructorUsedError;
  @HiveField(1)
  DateTime get startDate => throw _privateConstructorUsedError;
  @HiveField(2)
  DateTime get endDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TripDurationCopyWith<TripDuration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripDurationCopyWith<$Res> {
  factory $TripDurationCopyWith(
          TripDuration value, $Res Function(TripDuration) then) =
      _$TripDurationCopyWithImpl<$Res, TripDuration>;
  @useResult
  $Res call(
      {@HiveField(0) int days,
      @HiveField(1) DateTime startDate,
      @HiveField(2) DateTime endDate});
}

/// @nodoc
class _$TripDurationCopyWithImpl<$Res, $Val extends TripDuration>
    implements $TripDurationCopyWith<$Res> {
  _$TripDurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? days = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(_value.copyWith(
      days: null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TripDurationImplCopyWith<$Res>
    implements $TripDurationCopyWith<$Res> {
  factory _$$TripDurationImplCopyWith(
          _$TripDurationImpl value, $Res Function(_$TripDurationImpl) then) =
      __$$TripDurationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) int days,
      @HiveField(1) DateTime startDate,
      @HiveField(2) DateTime endDate});
}

/// @nodoc
class __$$TripDurationImplCopyWithImpl<$Res>
    extends _$TripDurationCopyWithImpl<$Res, _$TripDurationImpl>
    implements _$$TripDurationImplCopyWith<$Res> {
  __$$TripDurationImplCopyWithImpl(
      _$TripDurationImpl _value, $Res Function(_$TripDurationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? days = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(_$TripDurationImpl(
      days: null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TripDurationImpl implements _TripDuration {
  const _$TripDurationImpl(
      {@HiveField(0) required this.days,
      @HiveField(1) required this.startDate,
      @HiveField(2) required this.endDate});

  factory _$TripDurationImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripDurationImplFromJson(json);

  @override
  @HiveField(0)
  final int days;
  @override
  @HiveField(1)
  final DateTime startDate;
  @override
  @HiveField(2)
  final DateTime endDate;

  @override
  String toString() {
    return 'TripDuration(days: $days, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripDurationImpl &&
            (identical(other.days, days) || other.days == days) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, days, startDate, endDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TripDurationImplCopyWith<_$TripDurationImpl> get copyWith =>
      __$$TripDurationImplCopyWithImpl<_$TripDurationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripDurationImplToJson(
      this,
    );
  }
}

abstract class _TripDuration implements TripDuration {
  const factory _TripDuration(
      {@HiveField(0) required final int days,
      @HiveField(1) required final DateTime startDate,
      @HiveField(2) required final DateTime endDate}) = _$TripDurationImpl;

  factory _TripDuration.fromJson(Map<String, dynamic> json) =
      _$TripDurationImpl.fromJson;

  @override
  @HiveField(0)
  int get days;
  @override
  @HiveField(1)
  DateTime get startDate;
  @override
  @HiveField(2)
  DateTime get endDate;
  @override
  @JsonKey(ignore: true)
  _$$TripDurationImplCopyWith<_$TripDurationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
