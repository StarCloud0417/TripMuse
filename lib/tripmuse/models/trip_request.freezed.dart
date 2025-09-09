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
  /// 請求唯一識別碼
  String get requestId => throw _privateConstructorUsedError;

  /// 請求時間戳記
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// 使用者 ID（可為空，Guest 模式）
  String? get userId => throw _privateConstructorUsedError;

  /// 目的地資訊
  Destination get destination => throw _privateConstructorUsedError;

  /// 旅行天數
  int get days => throw _privateConstructorUsedError;

  /// 開始日期
  DateTime get startDate => throw _privateConstructorUsedError;

  /// 結束日期
  DateTime get endDate => throw _privateConstructorUsedError;

  /// 旅行描述（使用者輸入的自然語言）
  String get travelDescription => throw _privateConstructorUsedError;

  /// 預算範圍
  BudgetRange? get budget => throw _privateConstructorUsedError;

  /// 旅伴數量
  int get groupSize => throw _privateConstructorUsedError;

  /// 旅行風格
  TravelStyle? get travelStyle => throw _privateConstructorUsedError;

  /// 語言偏好
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
      {String requestId,
      DateTime timestamp,
      String? userId,
      Destination destination,
      int days,
      DateTime startDate,
      DateTime endDate,
      String travelDescription,
      BudgetRange? budget,
      int groupSize,
      TravelStyle? travelStyle,
      String locale});

  $DestinationCopyWith<$Res> get destination;
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
    Object? requestId = null,
    Object? timestamp = null,
    Object? userId = freezed,
    Object? destination = null,
    Object? days = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? travelDescription = null,
    Object? budget = freezed,
    Object? groupSize = null,
    Object? travelStyle = freezed,
    Object? locale = null,
  }) {
    return _then(_value.copyWith(
      requestId: null == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as Destination,
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
      travelDescription: null == travelDescription
          ? _value.travelDescription
          : travelDescription // ignore: cast_nullable_to_non_nullable
              as String,
      budget: freezed == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as BudgetRange?,
      groupSize: null == groupSize
          ? _value.groupSize
          : groupSize // ignore: cast_nullable_to_non_nullable
              as int,
      travelStyle: freezed == travelStyle
          ? _value.travelStyle
          : travelStyle // ignore: cast_nullable_to_non_nullable
              as TravelStyle?,
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
      {String requestId,
      DateTime timestamp,
      String? userId,
      Destination destination,
      int days,
      DateTime startDate,
      DateTime endDate,
      String travelDescription,
      BudgetRange? budget,
      int groupSize,
      TravelStyle? travelStyle,
      String locale});

  @override
  $DestinationCopyWith<$Res> get destination;
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
    Object? requestId = null,
    Object? timestamp = null,
    Object? userId = freezed,
    Object? destination = null,
    Object? days = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? travelDescription = null,
    Object? budget = freezed,
    Object? groupSize = null,
    Object? travelStyle = freezed,
    Object? locale = null,
  }) {
    return _then(_$TripRequestImpl(
      requestId: null == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as Destination,
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
      travelDescription: null == travelDescription
          ? _value.travelDescription
          : travelDescription // ignore: cast_nullable_to_non_nullable
              as String,
      budget: freezed == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as BudgetRange?,
      groupSize: null == groupSize
          ? _value.groupSize
          : groupSize // ignore: cast_nullable_to_non_nullable
              as int,
      travelStyle: freezed == travelStyle
          ? _value.travelStyle
          : travelStyle // ignore: cast_nullable_to_non_nullable
              as TravelStyle?,
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
      {required this.requestId,
      required this.timestamp,
      this.userId,
      required this.destination,
      required this.days,
      required this.startDate,
      required this.endDate,
      required this.travelDescription,
      this.budget,
      this.groupSize = 1,
      this.travelStyle,
      this.locale = 'zh-TW'});

  factory _$TripRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripRequestImplFromJson(json);

  /// 請求唯一識別碼
  @override
  final String requestId;

  /// 請求時間戳記
  @override
  final DateTime timestamp;

  /// 使用者 ID（可為空，Guest 模式）
  @override
  final String? userId;

  /// 目的地資訊
  @override
  final Destination destination;

  /// 旅行天數
  @override
  final int days;

  /// 開始日期
  @override
  final DateTime startDate;

  /// 結束日期
  @override
  final DateTime endDate;

  /// 旅行描述（使用者輸入的自然語言）
  @override
  final String travelDescription;

  /// 預算範圍
  @override
  final BudgetRange? budget;

  /// 旅伴數量
  @override
  @JsonKey()
  final int groupSize;

  /// 旅行風格
  @override
  final TravelStyle? travelStyle;

  /// 語言偏好
  @override
  @JsonKey()
  final String locale;

  @override
  String toString() {
    return 'TripRequest(requestId: $requestId, timestamp: $timestamp, userId: $userId, destination: $destination, days: $days, startDate: $startDate, endDate: $endDate, travelDescription: $travelDescription, budget: $budget, groupSize: $groupSize, travelStyle: $travelStyle, locale: $locale)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripRequestImpl &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.days, days) || other.days == days) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.travelDescription, travelDescription) ||
                other.travelDescription == travelDescription) &&
            (identical(other.budget, budget) || other.budget == budget) &&
            (identical(other.groupSize, groupSize) ||
                other.groupSize == groupSize) &&
            (identical(other.travelStyle, travelStyle) ||
                other.travelStyle == travelStyle) &&
            (identical(other.locale, locale) || other.locale == locale));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      requestId,
      timestamp,
      userId,
      destination,
      days,
      startDate,
      endDate,
      travelDescription,
      budget,
      groupSize,
      travelStyle,
      locale);

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
      {required final String requestId,
      required final DateTime timestamp,
      final String? userId,
      required final Destination destination,
      required final int days,
      required final DateTime startDate,
      required final DateTime endDate,
      required final String travelDescription,
      final BudgetRange? budget,
      final int groupSize,
      final TravelStyle? travelStyle,
      final String locale}) = _$TripRequestImpl;

  factory _TripRequest.fromJson(Map<String, dynamic> json) =
      _$TripRequestImpl.fromJson;

  @override

  /// 請求唯一識別碼
  String get requestId;
  @override

  /// 請求時間戳記
  DateTime get timestamp;
  @override

  /// 使用者 ID（可為空，Guest 模式）
  String? get userId;
  @override

  /// 目的地資訊
  Destination get destination;
  @override

  /// 旅行天數
  int get days;
  @override

  /// 開始日期
  DateTime get startDate;
  @override

  /// 結束日期
  DateTime get endDate;
  @override

  /// 旅行描述（使用者輸入的自然語言）
  String get travelDescription;
  @override

  /// 預算範圍
  BudgetRange? get budget;
  @override

  /// 旅伴數量
  int get groupSize;
  @override

  /// 旅行風格
  TravelStyle? get travelStyle;
  @override

  /// 語言偏好
  String get locale;
  @override
  @JsonKey(ignore: true)
  _$$TripRequestImplCopyWith<_$TripRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
