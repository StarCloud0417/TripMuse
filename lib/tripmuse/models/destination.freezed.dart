// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'destination.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Destination _$DestinationFromJson(Map<String, dynamic> json) {
  return _Destination.fromJson(json);
}

/// @nodoc
mixin _$Destination {
  /// 目的地名稱
  String get name => throw _privateConstructorUsedError;

  /// 城市名稱
  String get city => throw _privateConstructorUsedError;

  /// 國家名稱
  String get country => throw _privateConstructorUsedError;

  /// 緯度座標
  double get lat => throw _privateConstructorUsedError;

  /// 經度座標
  double get lng => throw _privateConstructorUsedError;

  /// Google Places ID
  String? get placeId => throw _privateConstructorUsedError;

  /// 完整地址
  String? get fullAddress => throw _privateConstructorUsedError;

  /// 時區
  String? get timezone => throw _privateConstructorUsedError;

  /// 貨幣代碼
  String? get currencyCode => throw _privateConstructorUsedError;

  /// 語言代碼
  String? get languageCode => throw _privateConstructorUsedError;

  /// 目的地照片 URLs
  List<String> get photos => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DestinationCopyWith<Destination> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DestinationCopyWith<$Res> {
  factory $DestinationCopyWith(
          Destination value, $Res Function(Destination) then) =
      _$DestinationCopyWithImpl<$Res, Destination>;
  @useResult
  $Res call(
      {String name,
      String city,
      String country,
      double lat,
      double lng,
      String? placeId,
      String? fullAddress,
      String? timezone,
      String? currencyCode,
      String? languageCode,
      List<String> photos});
}

/// @nodoc
class _$DestinationCopyWithImpl<$Res, $Val extends Destination>
    implements $DestinationCopyWith<$Res> {
  _$DestinationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? city = null,
    Object? country = null,
    Object? lat = null,
    Object? lng = null,
    Object? placeId = freezed,
    Object? fullAddress = freezed,
    Object? timezone = freezed,
    Object? currencyCode = freezed,
    Object? languageCode = freezed,
    Object? photos = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      placeId: freezed == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String?,
      fullAddress: freezed == fullAddress
          ? _value.fullAddress
          : fullAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: freezed == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      languageCode: freezed == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String?,
      photos: null == photos
          ? _value.photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DestinationImplCopyWith<$Res>
    implements $DestinationCopyWith<$Res> {
  factory _$$DestinationImplCopyWith(
          _$DestinationImpl value, $Res Function(_$DestinationImpl) then) =
      __$$DestinationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String city,
      String country,
      double lat,
      double lng,
      String? placeId,
      String? fullAddress,
      String? timezone,
      String? currencyCode,
      String? languageCode,
      List<String> photos});
}

/// @nodoc
class __$$DestinationImplCopyWithImpl<$Res>
    extends _$DestinationCopyWithImpl<$Res, _$DestinationImpl>
    implements _$$DestinationImplCopyWith<$Res> {
  __$$DestinationImplCopyWithImpl(
      _$DestinationImpl _value, $Res Function(_$DestinationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? city = null,
    Object? country = null,
    Object? lat = null,
    Object? lng = null,
    Object? placeId = freezed,
    Object? fullAddress = freezed,
    Object? timezone = freezed,
    Object? currencyCode = freezed,
    Object? languageCode = freezed,
    Object? photos = null,
  }) {
    return _then(_$DestinationImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      placeId: freezed == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String?,
      fullAddress: freezed == fullAddress
          ? _value.fullAddress
          : fullAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: freezed == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      languageCode: freezed == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String?,
      photos: null == photos
          ? _value._photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DestinationImpl implements _Destination {
  const _$DestinationImpl(
      {required this.name,
      required this.city,
      required this.country,
      this.lat = 0.0,
      this.lng = 0.0,
      this.placeId,
      this.fullAddress,
      this.timezone,
      this.currencyCode,
      this.languageCode,
      final List<String> photos = const []})
      : _photos = photos;

  factory _$DestinationImpl.fromJson(Map<String, dynamic> json) =>
      _$$DestinationImplFromJson(json);

  /// 目的地名稱
  @override
  final String name;

  /// 城市名稱
  @override
  final String city;

  /// 國家名稱
  @override
  final String country;

  /// 緯度座標
  @override
  @JsonKey()
  final double lat;

  /// 經度座標
  @override
  @JsonKey()
  final double lng;

  /// Google Places ID
  @override
  final String? placeId;

  /// 完整地址
  @override
  final String? fullAddress;

  /// 時區
  @override
  final String? timezone;

  /// 貨幣代碼
  @override
  final String? currencyCode;

  /// 語言代碼
  @override
  final String? languageCode;

  /// 目的地照片 URLs
  final List<String> _photos;

  /// 目的地照片 URLs
  @override
  @JsonKey()
  List<String> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  @override
  String toString() {
    return 'Destination(name: $name, city: $city, country: $country, lat: $lat, lng: $lng, placeId: $placeId, fullAddress: $fullAddress, timezone: $timezone, currencyCode: $currencyCode, languageCode: $languageCode, photos: $photos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DestinationImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.fullAddress, fullAddress) ||
                other.fullAddress == fullAddress) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            const DeepCollectionEquality().equals(other._photos, _photos));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      city,
      country,
      lat,
      lng,
      placeId,
      fullAddress,
      timezone,
      currencyCode,
      languageCode,
      const DeepCollectionEquality().hash(_photos));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DestinationImplCopyWith<_$DestinationImpl> get copyWith =>
      __$$DestinationImplCopyWithImpl<_$DestinationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DestinationImplToJson(
      this,
    );
  }
}

abstract class _Destination implements Destination {
  const factory _Destination(
      {required final String name,
      required final String city,
      required final String country,
      final double lat,
      final double lng,
      final String? placeId,
      final String? fullAddress,
      final String? timezone,
      final String? currencyCode,
      final String? languageCode,
      final List<String> photos}) = _$DestinationImpl;

  factory _Destination.fromJson(Map<String, dynamic> json) =
      _$DestinationImpl.fromJson;

  @override

  /// 目的地名稱
  String get name;
  @override

  /// 城市名稱
  String get city;
  @override

  /// 國家名稱
  String get country;
  @override

  /// 緯度座標
  double get lat;
  @override

  /// 經度座標
  double get lng;
  @override

  /// Google Places ID
  String? get placeId;
  @override

  /// 完整地址
  String? get fullAddress;
  @override

  /// 時區
  String? get timezone;
  @override

  /// 貨幣代碼
  String? get currencyCode;
  @override

  /// 語言代碼
  String? get languageCode;
  @override

  /// 目的地照片 URLs
  List<String> get photos;
  @override
  @JsonKey(ignore: true)
  _$$DestinationImplCopyWith<_$DestinationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
