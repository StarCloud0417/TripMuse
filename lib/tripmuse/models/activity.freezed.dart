// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Activity _$ActivityFromJson(Map<String, dynamic> json) {
  return _Activity.fromJson(json);
}

/// @nodoc
mixin _$Activity {
  /// 活動唯一識別碼
  String get id => throw _privateConstructorUsedError;

  /// 活動名稱
  String get name => throw _privateConstructorUsedError;

  /// 活動描述
  String get description => throw _privateConstructorUsedError;

  /// 緯度座標
  double get lat => throw _privateConstructorUsedError;

  /// 經度座標
  double get lng => throw _privateConstructorUsedError;

  /// 開始時間 (HH:mm 格式)
  String get timeFrom => throw _privateConstructorUsedError;

  /// 結束時間 (HH:mm 格式)
  String get timeTo => throw _privateConstructorUsedError;

  /// 活動類別
  ActivityCategory get category => throw _privateConstructorUsedError;

  /// 活動優先級
  ActivityPriority get priority => throw _privateConstructorUsedError;

  /// 預估花費
  String? get estimatedCost => throw _privateConstructorUsedError;

  /// 旅行小貼士
  String? get tips => throw _privateConstructorUsedError;

  /// 地點照片 URLs
  List<String> get photos => throw _privateConstructorUsedError;

  /// Google Places ID
  String? get placeId => throw _privateConstructorUsedError;

  /// 地址
  String? get address => throw _privateConstructorUsedError;

  /// 評分 (1-5)
  double? get rating => throw _privateConstructorUsedError;

  /// 建議停留時間（分鐘）
  int? get suggestedDurationMinutes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivityCopyWith<Activity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityCopyWith<$Res> {
  factory $ActivityCopyWith(Activity value, $Res Function(Activity) then) =
      _$ActivityCopyWithImpl<$Res, Activity>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      double lat,
      double lng,
      String timeFrom,
      String timeTo,
      ActivityCategory category,
      ActivityPriority priority,
      String? estimatedCost,
      String? tips,
      List<String> photos,
      String? placeId,
      String? address,
      double? rating,
      int? suggestedDurationMinutes});
}

/// @nodoc
class _$ActivityCopyWithImpl<$Res, $Val extends Activity>
    implements $ActivityCopyWith<$Res> {
  _$ActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? lat = null,
    Object? lng = null,
    Object? timeFrom = null,
    Object? timeTo = null,
    Object? category = null,
    Object? priority = null,
    Object? estimatedCost = freezed,
    Object? tips = freezed,
    Object? photos = null,
    Object? placeId = freezed,
    Object? address = freezed,
    Object? rating = freezed,
    Object? suggestedDurationMinutes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      timeFrom: null == timeFrom
          ? _value.timeFrom
          : timeFrom // ignore: cast_nullable_to_non_nullable
              as String,
      timeTo: null == timeTo
          ? _value.timeTo
          : timeTo // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ActivityCategory,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as ActivityPriority,
      estimatedCost: freezed == estimatedCost
          ? _value.estimatedCost
          : estimatedCost // ignore: cast_nullable_to_non_nullable
              as String?,
      tips: freezed == tips
          ? _value.tips
          : tips // ignore: cast_nullable_to_non_nullable
              as String?,
      photos: null == photos
          ? _value.photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      placeId: freezed == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      suggestedDurationMinutes: freezed == suggestedDurationMinutes
          ? _value.suggestedDurationMinutes
          : suggestedDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityImplCopyWith<$Res>
    implements $ActivityCopyWith<$Res> {
  factory _$$ActivityImplCopyWith(
          _$ActivityImpl value, $Res Function(_$ActivityImpl) then) =
      __$$ActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      double lat,
      double lng,
      String timeFrom,
      String timeTo,
      ActivityCategory category,
      ActivityPriority priority,
      String? estimatedCost,
      String? tips,
      List<String> photos,
      String? placeId,
      String? address,
      double? rating,
      int? suggestedDurationMinutes});
}

/// @nodoc
class __$$ActivityImplCopyWithImpl<$Res>
    extends _$ActivityCopyWithImpl<$Res, _$ActivityImpl>
    implements _$$ActivityImplCopyWith<$Res> {
  __$$ActivityImplCopyWithImpl(
      _$ActivityImpl _value, $Res Function(_$ActivityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? lat = null,
    Object? lng = null,
    Object? timeFrom = null,
    Object? timeTo = null,
    Object? category = null,
    Object? priority = null,
    Object? estimatedCost = freezed,
    Object? tips = freezed,
    Object? photos = null,
    Object? placeId = freezed,
    Object? address = freezed,
    Object? rating = freezed,
    Object? suggestedDurationMinutes = freezed,
  }) {
    return _then(_$ActivityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      timeFrom: null == timeFrom
          ? _value.timeFrom
          : timeFrom // ignore: cast_nullable_to_non_nullable
              as String,
      timeTo: null == timeTo
          ? _value.timeTo
          : timeTo // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ActivityCategory,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as ActivityPriority,
      estimatedCost: freezed == estimatedCost
          ? _value.estimatedCost
          : estimatedCost // ignore: cast_nullable_to_non_nullable
              as String?,
      tips: freezed == tips
          ? _value.tips
          : tips // ignore: cast_nullable_to_non_nullable
              as String?,
      photos: null == photos
          ? _value._photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      placeId: freezed == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      suggestedDurationMinutes: freezed == suggestedDurationMinutes
          ? _value.suggestedDurationMinutes
          : suggestedDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityImpl implements _Activity {
  const _$ActivityImpl(
      {required this.id,
      required this.name,
      required this.description,
      this.lat = 0.0,
      this.lng = 0.0,
      this.timeFrom = '09:00',
      this.timeTo = '10:00',
      required this.category,
      required this.priority,
      this.estimatedCost,
      this.tips,
      final List<String> photos = const [],
      this.placeId,
      this.address,
      this.rating,
      this.suggestedDurationMinutes})
      : _photos = photos;

  factory _$ActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityImplFromJson(json);

  /// 活動唯一識別碼
  @override
  final String id;

  /// 活動名稱
  @override
  final String name;

  /// 活動描述
  @override
  final String description;

  /// 緯度座標
  @override
  @JsonKey()
  final double lat;

  /// 經度座標
  @override
  @JsonKey()
  final double lng;

  /// 開始時間 (HH:mm 格式)
  @override
  @JsonKey()
  final String timeFrom;

  /// 結束時間 (HH:mm 格式)
  @override
  @JsonKey()
  final String timeTo;

  /// 活動類別
  @override
  final ActivityCategory category;

  /// 活動優先級
  @override
  final ActivityPriority priority;

  /// 預估花費
  @override
  final String? estimatedCost;

  /// 旅行小貼士
  @override
  final String? tips;

  /// 地點照片 URLs
  final List<String> _photos;

  /// 地點照片 URLs
  @override
  @JsonKey()
  List<String> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  /// Google Places ID
  @override
  final String? placeId;

  /// 地址
  @override
  final String? address;

  /// 評分 (1-5)
  @override
  final double? rating;

  /// 建議停留時間（分鐘）
  @override
  final int? suggestedDurationMinutes;

  @override
  String toString() {
    return 'Activity(id: $id, name: $name, description: $description, lat: $lat, lng: $lng, timeFrom: $timeFrom, timeTo: $timeTo, category: $category, priority: $priority, estimatedCost: $estimatedCost, tips: $tips, photos: $photos, placeId: $placeId, address: $address, rating: $rating, suggestedDurationMinutes: $suggestedDurationMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.timeFrom, timeFrom) ||
                other.timeFrom == timeFrom) &&
            (identical(other.timeTo, timeTo) || other.timeTo == timeTo) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.estimatedCost, estimatedCost) ||
                other.estimatedCost == estimatedCost) &&
            (identical(other.tips, tips) || other.tips == tips) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(
                    other.suggestedDurationMinutes, suggestedDurationMinutes) ||
                other.suggestedDurationMinutes == suggestedDurationMinutes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      lat,
      lng,
      timeFrom,
      timeTo,
      category,
      priority,
      estimatedCost,
      tips,
      const DeepCollectionEquality().hash(_photos),
      placeId,
      address,
      rating,
      suggestedDurationMinutes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityImplCopyWith<_$ActivityImpl> get copyWith =>
      __$$ActivityImplCopyWithImpl<_$ActivityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityImplToJson(
      this,
    );
  }
}

abstract class _Activity implements Activity {
  const factory _Activity(
      {required final String id,
      required final String name,
      required final String description,
      final double lat,
      final double lng,
      final String timeFrom,
      final String timeTo,
      required final ActivityCategory category,
      required final ActivityPriority priority,
      final String? estimatedCost,
      final String? tips,
      final List<String> photos,
      final String? placeId,
      final String? address,
      final double? rating,
      final int? suggestedDurationMinutes}) = _$ActivityImpl;

  factory _Activity.fromJson(Map<String, dynamic> json) =
      _$ActivityImpl.fromJson;

  @override

  /// 活動唯一識別碼
  String get id;
  @override

  /// 活動名稱
  String get name;
  @override

  /// 活動描述
  String get description;
  @override

  /// 緯度座標
  double get lat;
  @override

  /// 經度座標
  double get lng;
  @override

  /// 開始時間 (HH:mm 格式)
  String get timeFrom;
  @override

  /// 結束時間 (HH:mm 格式)
  String get timeTo;
  @override

  /// 活動類別
  ActivityCategory get category;
  @override

  /// 活動優先級
  ActivityPriority get priority;
  @override

  /// 預估花費
  String? get estimatedCost;
  @override

  /// 旅行小貼士
  String? get tips;
  @override

  /// 地點照片 URLs
  List<String> get photos;
  @override

  /// Google Places ID
  String? get placeId;
  @override

  /// 地址
  String? get address;
  @override

  /// 評分 (1-5)
  double? get rating;
  @override

  /// 建議停留時間（分鐘）
  int? get suggestedDurationMinutes;
  @override
  @JsonKey(ignore: true)
  _$$ActivityImplCopyWith<_$ActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
