// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transport_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransportInfo _$TransportInfoFromJson(Map<String, dynamic> json) {
  return _TransportInfo.fromJson(json);
}

/// @nodoc
mixin _$TransportInfo {
  /// 交通方式
  TransportMode get mode => throw _privateConstructorUsedError;

  /// 通勤時間（分鐘）
  int get durationMinutes => throw _privateConstructorUsedError;

  /// 距離（公尺）
  int? get distanceMeters => throw _privateConstructorUsedError;

  /// 預估費用
  String? get estimatedCost => throw _privateConstructorUsedError;

  /// 路線描述
  String? get routeDescription => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransportInfoCopyWith<TransportInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransportInfoCopyWith<$Res> {
  factory $TransportInfoCopyWith(
          TransportInfo value, $Res Function(TransportInfo) then) =
      _$TransportInfoCopyWithImpl<$Res, TransportInfo>;
  @useResult
  $Res call(
      {TransportMode mode,
      int durationMinutes,
      int? distanceMeters,
      String? estimatedCost,
      String? routeDescription});
}

/// @nodoc
class _$TransportInfoCopyWithImpl<$Res, $Val extends TransportInfo>
    implements $TransportInfoCopyWith<$Res> {
  _$TransportInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? durationMinutes = null,
    Object? distanceMeters = freezed,
    Object? estimatedCost = freezed,
    Object? routeDescription = freezed,
  }) {
    return _then(_value.copyWith(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as TransportMode,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      distanceMeters: freezed == distanceMeters
          ? _value.distanceMeters
          : distanceMeters // ignore: cast_nullable_to_non_nullable
              as int?,
      estimatedCost: freezed == estimatedCost
          ? _value.estimatedCost
          : estimatedCost // ignore: cast_nullable_to_non_nullable
              as String?,
      routeDescription: freezed == routeDescription
          ? _value.routeDescription
          : routeDescription // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransportInfoImplCopyWith<$Res>
    implements $TransportInfoCopyWith<$Res> {
  factory _$$TransportInfoImplCopyWith(
          _$TransportInfoImpl value, $Res Function(_$TransportInfoImpl) then) =
      __$$TransportInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {TransportMode mode,
      int durationMinutes,
      int? distanceMeters,
      String? estimatedCost,
      String? routeDescription});
}

/// @nodoc
class __$$TransportInfoImplCopyWithImpl<$Res>
    extends _$TransportInfoCopyWithImpl<$Res, _$TransportInfoImpl>
    implements _$$TransportInfoImplCopyWith<$Res> {
  __$$TransportInfoImplCopyWithImpl(
      _$TransportInfoImpl _value, $Res Function(_$TransportInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? durationMinutes = null,
    Object? distanceMeters = freezed,
    Object? estimatedCost = freezed,
    Object? routeDescription = freezed,
  }) {
    return _then(_$TransportInfoImpl(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as TransportMode,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      distanceMeters: freezed == distanceMeters
          ? _value.distanceMeters
          : distanceMeters // ignore: cast_nullable_to_non_nullable
              as int?,
      estimatedCost: freezed == estimatedCost
          ? _value.estimatedCost
          : estimatedCost // ignore: cast_nullable_to_non_nullable
              as String?,
      routeDescription: freezed == routeDescription
          ? _value.routeDescription
          : routeDescription // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransportInfoImpl implements _TransportInfo {
  const _$TransportInfoImpl(
      {required this.mode,
      required this.durationMinutes,
      this.distanceMeters,
      this.estimatedCost,
      this.routeDescription});

  factory _$TransportInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransportInfoImplFromJson(json);

  /// 交通方式
  @override
  final TransportMode mode;

  /// 通勤時間（分鐘）
  @override
  final int durationMinutes;

  /// 距離（公尺）
  @override
  final int? distanceMeters;

  /// 預估費用
  @override
  final String? estimatedCost;

  /// 路線描述
  @override
  final String? routeDescription;

  @override
  String toString() {
    return 'TransportInfo(mode: $mode, durationMinutes: $durationMinutes, distanceMeters: $distanceMeters, estimatedCost: $estimatedCost, routeDescription: $routeDescription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransportInfoImpl &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.distanceMeters, distanceMeters) ||
                other.distanceMeters == distanceMeters) &&
            (identical(other.estimatedCost, estimatedCost) ||
                other.estimatedCost == estimatedCost) &&
            (identical(other.routeDescription, routeDescription) ||
                other.routeDescription == routeDescription));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, mode, durationMinutes,
      distanceMeters, estimatedCost, routeDescription);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransportInfoImplCopyWith<_$TransportInfoImpl> get copyWith =>
      __$$TransportInfoImplCopyWithImpl<_$TransportInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransportInfoImplToJson(
      this,
    );
  }
}

abstract class _TransportInfo implements TransportInfo {
  const factory _TransportInfo(
      {required final TransportMode mode,
      required final int durationMinutes,
      final int? distanceMeters,
      final String? estimatedCost,
      final String? routeDescription}) = _$TransportInfoImpl;

  factory _TransportInfo.fromJson(Map<String, dynamic> json) =
      _$TransportInfoImpl.fromJson;

  @override

  /// 交通方式
  TransportMode get mode;
  @override

  /// 通勤時間（分鐘）
  int get durationMinutes;
  @override

  /// 距離（公尺）
  int? get distanceMeters;
  @override

  /// 預估費用
  String? get estimatedCost;
  @override

  /// 路線描述
  String? get routeDescription;
  @override
  @JsonKey(ignore: true)
  _$$TransportInfoImplCopyWith<_$TransportInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
