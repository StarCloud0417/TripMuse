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
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  String get description => throw _privateConstructorUsedError;
  @HiveField(3)
  double get lat => throw _privateConstructorUsedError;
  @HiveField(4)
  double get lng => throw _privateConstructorUsedError;
  @HiveField(5)
  String get timeFrom => throw _privateConstructorUsedError;
  @HiveField(6)
  String get timeTo => throw _privateConstructorUsedError;
  @HiveField(7)
  ActivityCategory get category => throw _privateConstructorUsedError;
  @HiveField(8)
  ActivityPriority get priority => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get estimatedCost => throw _privateConstructorUsedError;
  @HiveField(10)
  String? get tips => throw _privateConstructorUsedError;
  @HiveField(11)
  String? get address => throw _privateConstructorUsedError;
  @HiveField(12)
  List<String> get photos => throw _privateConstructorUsedError;
  @HiveField(13)
  double? get rating => throw _privateConstructorUsedError;
  @HiveField(14)
  String? get placeId => throw _privateConstructorUsedError;

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
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String description,
      @HiveField(3) double lat,
      @HiveField(4) double lng,
      @HiveField(5) String timeFrom,
      @HiveField(6) String timeTo,
      @HiveField(7) ActivityCategory category,
      @HiveField(8) ActivityPriority priority,
      @HiveField(9) String? estimatedCost,
      @HiveField(10) String? tips,
      @HiveField(11) String? address,
      @HiveField(12) List<String> photos,
      @HiveField(13) double? rating,
      @HiveField(14) String? placeId});
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
    Object? address = freezed,
    Object? photos = null,
    Object? rating = freezed,
    Object? placeId = freezed,
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
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      photos: null == photos
          ? _value.photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      placeId: freezed == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String description,
      @HiveField(3) double lat,
      @HiveField(4) double lng,
      @HiveField(5) String timeFrom,
      @HiveField(6) String timeTo,
      @HiveField(7) ActivityCategory category,
      @HiveField(8) ActivityPriority priority,
      @HiveField(9) String? estimatedCost,
      @HiveField(10) String? tips,
      @HiveField(11) String? address,
      @HiveField(12) List<String> photos,
      @HiveField(13) double? rating,
      @HiveField(14) String? placeId});
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
    Object? address = freezed,
    Object? photos = null,
    Object? rating = freezed,
    Object? placeId = freezed,
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
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      photos: null == photos
          ? _value._photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      placeId: freezed == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityImpl implements _Activity {
  const _$ActivityImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.name,
      @HiveField(2) required this.description,
      @HiveField(3) required this.lat,
      @HiveField(4) required this.lng,
      @HiveField(5) required this.timeFrom,
      @HiveField(6) required this.timeTo,
      @HiveField(7) required this.category,
      @HiveField(8) required this.priority,
      @HiveField(9) this.estimatedCost,
      @HiveField(10) this.tips,
      @HiveField(11) this.address,
      @HiveField(12) final List<String> photos = const [],
      @HiveField(13) this.rating,
      @HiveField(14) this.placeId})
      : _photos = photos;

  factory _$ActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String description;
  @override
  @HiveField(3)
  final double lat;
  @override
  @HiveField(4)
  final double lng;
  @override
  @HiveField(5)
  final String timeFrom;
  @override
  @HiveField(6)
  final String timeTo;
  @override
  @HiveField(7)
  final ActivityCategory category;
  @override
  @HiveField(8)
  final ActivityPriority priority;
  @override
  @HiveField(9)
  final String? estimatedCost;
  @override
  @HiveField(10)
  final String? tips;
  @override
  @HiveField(11)
  final String? address;
  final List<String> _photos;
  @override
  @JsonKey()
  @HiveField(12)
  List<String> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  @override
  @HiveField(13)
  final double? rating;
  @override
  @HiveField(14)
  final String? placeId;

  @override
  String toString() {
    return 'Activity(id: $id, name: $name, description: $description, lat: $lat, lng: $lng, timeFrom: $timeFrom, timeTo: $timeTo, category: $category, priority: $priority, estimatedCost: $estimatedCost, tips: $tips, address: $address, photos: $photos, rating: $rating, placeId: $placeId)';
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
            (identical(other.address, address) || other.address == address) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.placeId, placeId) || other.placeId == placeId));
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
      address,
      const DeepCollectionEquality().hash(_photos),
      rating,
      placeId);

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
      {@HiveField(0) required final String id,
      @HiveField(1) required final String name,
      @HiveField(2) required final String description,
      @HiveField(3) required final double lat,
      @HiveField(4) required final double lng,
      @HiveField(5) required final String timeFrom,
      @HiveField(6) required final String timeTo,
      @HiveField(7) required final ActivityCategory category,
      @HiveField(8) required final ActivityPriority priority,
      @HiveField(9) final String? estimatedCost,
      @HiveField(10) final String? tips,
      @HiveField(11) final String? address,
      @HiveField(12) final List<String> photos,
      @HiveField(13) final double? rating,
      @HiveField(14) final String? placeId}) = _$ActivityImpl;

  factory _Activity.fromJson(Map<String, dynamic> json) =
      _$ActivityImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  String get description;
  @override
  @HiveField(3)
  double get lat;
  @override
  @HiveField(4)
  double get lng;
  @override
  @HiveField(5)
  String get timeFrom;
  @override
  @HiveField(6)
  String get timeTo;
  @override
  @HiveField(7)
  ActivityCategory get category;
  @override
  @HiveField(8)
  ActivityPriority get priority;
  @override
  @HiveField(9)
  String? get estimatedCost;
  @override
  @HiveField(10)
  String? get tips;
  @override
  @HiveField(11)
  String? get address;
  @override
  @HiveField(12)
  List<String> get photos;
  @override
  @HiveField(13)
  double? get rating;
  @override
  @HiveField(14)
  String? get placeId;
  @override
  @JsonKey(ignore: true)
  _$$ActivityImplCopyWith<_$ActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
