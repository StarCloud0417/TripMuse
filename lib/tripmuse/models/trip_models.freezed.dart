// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_models.dart';

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
  String get destination => throw _privateConstructorUsedError;
  int get days => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  TripPreferences? get preferences => throw _privateConstructorUsedError;

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
      {String destination,
      int days,
      String description,
      TripPreferences? preferences});

  $TripPreferencesCopyWith<$Res>? get preferences;
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
    Object? days = null,
    Object? description = null,
    Object? preferences = freezed,
  }) {
    return _then(_value.copyWith(
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String,
      days: null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      preferences: freezed == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as TripPreferences?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TripPreferencesCopyWith<$Res>? get preferences {
    if (_value.preferences == null) {
      return null;
    }

    return $TripPreferencesCopyWith<$Res>(_value.preferences!, (value) {
      return _then(_value.copyWith(preferences: value) as $Val);
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
      {String destination,
      int days,
      String description,
      TripPreferences? preferences});

  @override
  $TripPreferencesCopyWith<$Res>? get preferences;
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
    Object? days = null,
    Object? description = null,
    Object? preferences = freezed,
  }) {
    return _then(_$TripRequestImpl(
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String,
      days: null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      preferences: freezed == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as TripPreferences?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TripRequestImpl implements _TripRequest {
  const _$TripRequestImpl(
      {required this.destination,
      required this.days,
      required this.description,
      this.preferences});

  factory _$TripRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripRequestImplFromJson(json);

  @override
  final String destination;
  @override
  final int days;
  @override
  final String description;
  @override
  final TripPreferences? preferences;

  @override
  String toString() {
    return 'TripRequest(destination: $destination, days: $days, description: $description, preferences: $preferences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripRequestImpl &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.days, days) || other.days == days) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.preferences, preferences) ||
                other.preferences == preferences));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, destination, days, description, preferences);

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
      {required final String destination,
      required final int days,
      required final String description,
      final TripPreferences? preferences}) = _$TripRequestImpl;

  factory _TripRequest.fromJson(Map<String, dynamic> json) =
      _$TripRequestImpl.fromJson;

  @override
  String get destination;
  @override
  int get days;
  @override
  String get description;
  @override
  TripPreferences? get preferences;
  @override
  @JsonKey(ignore: true)
  _$$TripRequestImplCopyWith<_$TripRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TripPreferences _$TripPreferencesFromJson(Map<String, dynamic> json) {
  return _TripPreferences.fromJson(json);
}

/// @nodoc
mixin _$TripPreferences {
  String get budget => throw _privateConstructorUsedError; // low, medium, high
  String get pace => throw _privateConstructorUsedError; // slow, medium, fast
  List<String> get interests => throw _privateConstructorUsedError;
  int get companions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TripPreferencesCopyWith<TripPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripPreferencesCopyWith<$Res> {
  factory $TripPreferencesCopyWith(
          TripPreferences value, $Res Function(TripPreferences) then) =
      _$TripPreferencesCopyWithImpl<$Res, TripPreferences>;
  @useResult
  $Res call(
      {String budget, String pace, List<String> interests, int companions});
}

/// @nodoc
class _$TripPreferencesCopyWithImpl<$Res, $Val extends TripPreferences>
    implements $TripPreferencesCopyWith<$Res> {
  _$TripPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budget = null,
    Object? pace = null,
    Object? interests = null,
    Object? companions = null,
  }) {
    return _then(_value.copyWith(
      budget: null == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as String,
      pace: null == pace
          ? _value.pace
          : pace // ignore: cast_nullable_to_non_nullable
              as String,
      interests: null == interests
          ? _value.interests
          : interests // ignore: cast_nullable_to_non_nullable
              as List<String>,
      companions: null == companions
          ? _value.companions
          : companions // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TripPreferencesImplCopyWith<$Res>
    implements $TripPreferencesCopyWith<$Res> {
  factory _$$TripPreferencesImplCopyWith(_$TripPreferencesImpl value,
          $Res Function(_$TripPreferencesImpl) then) =
      __$$TripPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String budget, String pace, List<String> interests, int companions});
}

/// @nodoc
class __$$TripPreferencesImplCopyWithImpl<$Res>
    extends _$TripPreferencesCopyWithImpl<$Res, _$TripPreferencesImpl>
    implements _$$TripPreferencesImplCopyWith<$Res> {
  __$$TripPreferencesImplCopyWithImpl(
      _$TripPreferencesImpl _value, $Res Function(_$TripPreferencesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budget = null,
    Object? pace = null,
    Object? interests = null,
    Object? companions = null,
  }) {
    return _then(_$TripPreferencesImpl(
      budget: null == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as String,
      pace: null == pace
          ? _value.pace
          : pace // ignore: cast_nullable_to_non_nullable
              as String,
      interests: null == interests
          ? _value._interests
          : interests // ignore: cast_nullable_to_non_nullable
              as List<String>,
      companions: null == companions
          ? _value.companions
          : companions // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TripPreferencesImpl implements _TripPreferences {
  const _$TripPreferencesImpl(
      {this.budget = 'medium',
      this.pace = 'medium',
      final List<String> interests = const [],
      this.companions = 2})
      : _interests = interests;

  factory _$TripPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripPreferencesImplFromJson(json);

  @override
  @JsonKey()
  final String budget;
// low, medium, high
  @override
  @JsonKey()
  final String pace;
// slow, medium, fast
  final List<String> _interests;
// slow, medium, fast
  @override
  @JsonKey()
  List<String> get interests {
    if (_interests is EqualUnmodifiableListView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interests);
  }

  @override
  @JsonKey()
  final int companions;

  @override
  String toString() {
    return 'TripPreferences(budget: $budget, pace: $pace, interests: $interests, companions: $companions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripPreferencesImpl &&
            (identical(other.budget, budget) || other.budget == budget) &&
            (identical(other.pace, pace) || other.pace == pace) &&
            const DeepCollectionEquality()
                .equals(other._interests, _interests) &&
            (identical(other.companions, companions) ||
                other.companions == companions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, budget, pace,
      const DeepCollectionEquality().hash(_interests), companions);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TripPreferencesImplCopyWith<_$TripPreferencesImpl> get copyWith =>
      __$$TripPreferencesImplCopyWithImpl<_$TripPreferencesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripPreferencesImplToJson(
      this,
    );
  }
}

abstract class _TripPreferences implements TripPreferences {
  const factory _TripPreferences(
      {final String budget,
      final String pace,
      final List<String> interests,
      final int companions}) = _$TripPreferencesImpl;

  factory _TripPreferences.fromJson(Map<String, dynamic> json) =
      _$TripPreferencesImpl.fromJson;

  @override
  String get budget;
  @override // low, medium, high
  String get pace;
  @override // slow, medium, fast
  List<String> get interests;
  @override
  int get companions;
  @override
  @JsonKey(ignore: true)
  _$$TripPreferencesImplCopyWith<_$TripPreferencesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PreferenceAnalysis _$PreferenceAnalysisFromJson(Map<String, dynamic> json) {
  return _PreferenceAnalysis.fromJson(json);
}

/// @nodoc
mixin _$PreferenceAnalysis {
  String get primaryFocus => throw _privateConstructorUsedError;
  String get travelPace => throw _privateConstructorUsedError;
  List<String> get interests => throw _privateConstructorUsedError;
  List<String> get avoidances => throw _privateConstructorUsedError;
  String get mood => throw _privateConstructorUsedError;
  List<String> get keywords => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PreferenceAnalysisCopyWith<PreferenceAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PreferenceAnalysisCopyWith<$Res> {
  factory $PreferenceAnalysisCopyWith(
          PreferenceAnalysis value, $Res Function(PreferenceAnalysis) then) =
      _$PreferenceAnalysisCopyWithImpl<$Res, PreferenceAnalysis>;
  @useResult
  $Res call(
      {String primaryFocus,
      String travelPace,
      List<String> interests,
      List<String> avoidances,
      String mood,
      List<String> keywords});
}

/// @nodoc
class _$PreferenceAnalysisCopyWithImpl<$Res, $Val extends PreferenceAnalysis>
    implements $PreferenceAnalysisCopyWith<$Res> {
  _$PreferenceAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryFocus = null,
    Object? travelPace = null,
    Object? interests = null,
    Object? avoidances = null,
    Object? mood = null,
    Object? keywords = null,
  }) {
    return _then(_value.copyWith(
      primaryFocus: null == primaryFocus
          ? _value.primaryFocus
          : primaryFocus // ignore: cast_nullable_to_non_nullable
              as String,
      travelPace: null == travelPace
          ? _value.travelPace
          : travelPace // ignore: cast_nullable_to_non_nullable
              as String,
      interests: null == interests
          ? _value.interests
          : interests // ignore: cast_nullable_to_non_nullable
              as List<String>,
      avoidances: null == avoidances
          ? _value.avoidances
          : avoidances // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mood: null == mood
          ? _value.mood
          : mood // ignore: cast_nullable_to_non_nullable
              as String,
      keywords: null == keywords
          ? _value.keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PreferenceAnalysisImplCopyWith<$Res>
    implements $PreferenceAnalysisCopyWith<$Res> {
  factory _$$PreferenceAnalysisImplCopyWith(_$PreferenceAnalysisImpl value,
          $Res Function(_$PreferenceAnalysisImpl) then) =
      __$$PreferenceAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String primaryFocus,
      String travelPace,
      List<String> interests,
      List<String> avoidances,
      String mood,
      List<String> keywords});
}

/// @nodoc
class __$$PreferenceAnalysisImplCopyWithImpl<$Res>
    extends _$PreferenceAnalysisCopyWithImpl<$Res, _$PreferenceAnalysisImpl>
    implements _$$PreferenceAnalysisImplCopyWith<$Res> {
  __$$PreferenceAnalysisImplCopyWithImpl(_$PreferenceAnalysisImpl _value,
      $Res Function(_$PreferenceAnalysisImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryFocus = null,
    Object? travelPace = null,
    Object? interests = null,
    Object? avoidances = null,
    Object? mood = null,
    Object? keywords = null,
  }) {
    return _then(_$PreferenceAnalysisImpl(
      primaryFocus: null == primaryFocus
          ? _value.primaryFocus
          : primaryFocus // ignore: cast_nullable_to_non_nullable
              as String,
      travelPace: null == travelPace
          ? _value.travelPace
          : travelPace // ignore: cast_nullable_to_non_nullable
              as String,
      interests: null == interests
          ? _value._interests
          : interests // ignore: cast_nullable_to_non_nullable
              as List<String>,
      avoidances: null == avoidances
          ? _value._avoidances
          : avoidances // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mood: null == mood
          ? _value.mood
          : mood // ignore: cast_nullable_to_non_nullable
              as String,
      keywords: null == keywords
          ? _value._keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PreferenceAnalysisImpl implements _PreferenceAnalysis {
  const _$PreferenceAnalysisImpl(
      {required this.primaryFocus,
      required this.travelPace,
      required final List<String> interests,
      required final List<String> avoidances,
      required this.mood,
      required final List<String> keywords})
      : _interests = interests,
        _avoidances = avoidances,
        _keywords = keywords;

  factory _$PreferenceAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$PreferenceAnalysisImplFromJson(json);

  @override
  final String primaryFocus;
  @override
  final String travelPace;
  final List<String> _interests;
  @override
  List<String> get interests {
    if (_interests is EqualUnmodifiableListView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interests);
  }

  final List<String> _avoidances;
  @override
  List<String> get avoidances {
    if (_avoidances is EqualUnmodifiableListView) return _avoidances;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_avoidances);
  }

  @override
  final String mood;
  final List<String> _keywords;
  @override
  List<String> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
  }

  @override
  String toString() {
    return 'PreferenceAnalysis(primaryFocus: $primaryFocus, travelPace: $travelPace, interests: $interests, avoidances: $avoidances, mood: $mood, keywords: $keywords)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PreferenceAnalysisImpl &&
            (identical(other.primaryFocus, primaryFocus) ||
                other.primaryFocus == primaryFocus) &&
            (identical(other.travelPace, travelPace) ||
                other.travelPace == travelPace) &&
            const DeepCollectionEquality()
                .equals(other._interests, _interests) &&
            const DeepCollectionEquality()
                .equals(other._avoidances, _avoidances) &&
            (identical(other.mood, mood) || other.mood == mood) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      primaryFocus,
      travelPace,
      const DeepCollectionEquality().hash(_interests),
      const DeepCollectionEquality().hash(_avoidances),
      mood,
      const DeepCollectionEquality().hash(_keywords));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PreferenceAnalysisImplCopyWith<_$PreferenceAnalysisImpl> get copyWith =>
      __$$PreferenceAnalysisImplCopyWithImpl<_$PreferenceAnalysisImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PreferenceAnalysisImplToJson(
      this,
    );
  }
}

abstract class _PreferenceAnalysis implements PreferenceAnalysis {
  const factory _PreferenceAnalysis(
      {required final String primaryFocus,
      required final String travelPace,
      required final List<String> interests,
      required final List<String> avoidances,
      required final String mood,
      required final List<String> keywords}) = _$PreferenceAnalysisImpl;

  factory _PreferenceAnalysis.fromJson(Map<String, dynamic> json) =
      _$PreferenceAnalysisImpl.fromJson;

  @override
  String get primaryFocus;
  @override
  String get travelPace;
  @override
  List<String> get interests;
  @override
  List<String> get avoidances;
  @override
  String get mood;
  @override
  List<String> get keywords;
  @override
  @JsonKey(ignore: true)
  _$$PreferenceAnalysisImplCopyWith<_$PreferenceAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Place _$PlaceFromJson(Map<String, dynamic> json) {
  return _Place.fromJson(json);
}

/// @nodoc
mixin _$Place {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  PlaceLocation get location => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  int? get priceLevel => throw _privateConstructorUsedError;
  List<String>? get types => throw _privateConstructorUsedError;
  List<PlacePhoto>? get photos => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlaceCopyWith<Place> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceCopyWith<$Res> {
  factory $PlaceCopyWith(Place value, $Res Function(Place) then) =
      _$PlaceCopyWithImpl<$Res, Place>;
  @useResult
  $Res call(
      {String id,
      String name,
      String address,
      PlaceLocation location,
      double? rating,
      int? priceLevel,
      List<String>? types,
      List<PlacePhoto>? photos});

  $PlaceLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$PlaceCopyWithImpl<$Res, $Val extends Place>
    implements $PlaceCopyWith<$Res> {
  _$PlaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? location = null,
    Object? rating = freezed,
    Object? priceLevel = freezed,
    Object? types = freezed,
    Object? photos = freezed,
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
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as PlaceLocation,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      priceLevel: freezed == priceLevel
          ? _value.priceLevel
          : priceLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      types: freezed == types
          ? _value.types
          : types // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      photos: freezed == photos
          ? _value.photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<PlacePhoto>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PlaceLocationCopyWith<$Res> get location {
    return $PlaceLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlaceImplCopyWith<$Res> implements $PlaceCopyWith<$Res> {
  factory _$$PlaceImplCopyWith(
          _$PlaceImpl value, $Res Function(_$PlaceImpl) then) =
      __$$PlaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String address,
      PlaceLocation location,
      double? rating,
      int? priceLevel,
      List<String>? types,
      List<PlacePhoto>? photos});

  @override
  $PlaceLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$PlaceImplCopyWithImpl<$Res>
    extends _$PlaceCopyWithImpl<$Res, _$PlaceImpl>
    implements _$$PlaceImplCopyWith<$Res> {
  __$$PlaceImplCopyWithImpl(
      _$PlaceImpl _value, $Res Function(_$PlaceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? location = null,
    Object? rating = freezed,
    Object? priceLevel = freezed,
    Object? types = freezed,
    Object? photos = freezed,
  }) {
    return _then(_$PlaceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as PlaceLocation,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      priceLevel: freezed == priceLevel
          ? _value.priceLevel
          : priceLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      types: freezed == types
          ? _value._types
          : types // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      photos: freezed == photos
          ? _value._photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<PlacePhoto>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaceImpl implements _Place {
  const _$PlaceImpl(
      {required this.id,
      required this.name,
      required this.address,
      required this.location,
      this.rating,
      this.priceLevel,
      final List<String>? types,
      final List<PlacePhoto>? photos})
      : _types = types,
        _photos = photos;

  factory _$PlaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String address;
  @override
  final PlaceLocation location;
  @override
  final double? rating;
  @override
  final int? priceLevel;
  final List<String>? _types;
  @override
  List<String>? get types {
    final value = _types;
    if (value == null) return null;
    if (_types is EqualUnmodifiableListView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<PlacePhoto>? _photos;
  @override
  List<PlacePhoto>? get photos {
    final value = _photos;
    if (value == null) return null;
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Place(id: $id, name: $name, address: $address, location: $location, rating: $rating, priceLevel: $priceLevel, types: $types, photos: $photos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.priceLevel, priceLevel) ||
                other.priceLevel == priceLevel) &&
            const DeepCollectionEquality().equals(other._types, _types) &&
            const DeepCollectionEquality().equals(other._photos, _photos));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      address,
      location,
      rating,
      priceLevel,
      const DeepCollectionEquality().hash(_types),
      const DeepCollectionEquality().hash(_photos));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceImplCopyWith<_$PlaceImpl> get copyWith =>
      __$$PlaceImplCopyWithImpl<_$PlaceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceImplToJson(
      this,
    );
  }
}

abstract class _Place implements Place {
  const factory _Place(
      {required final String id,
      required final String name,
      required final String address,
      required final PlaceLocation location,
      final double? rating,
      final int? priceLevel,
      final List<String>? types,
      final List<PlacePhoto>? photos}) = _$PlaceImpl;

  factory _Place.fromJson(Map<String, dynamic> json) = _$PlaceImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get address;
  @override
  PlaceLocation get location;
  @override
  double? get rating;
  @override
  int? get priceLevel;
  @override
  List<String>? get types;
  @override
  List<PlacePhoto>? get photos;
  @override
  @JsonKey(ignore: true)
  _$$PlaceImplCopyWith<_$PlaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlaceLocation _$PlaceLocationFromJson(Map<String, dynamic> json) {
  return _PlaceLocation.fromJson(json);
}

/// @nodoc
mixin _$PlaceLocation {
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlaceLocationCopyWith<PlaceLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceLocationCopyWith<$Res> {
  factory $PlaceLocationCopyWith(
          PlaceLocation value, $Res Function(PlaceLocation) then) =
      _$PlaceLocationCopyWithImpl<$Res, PlaceLocation>;
  @useResult
  $Res call({double lat, double lng});
}

/// @nodoc
class _$PlaceLocationCopyWithImpl<$Res, $Val extends PlaceLocation>
    implements $PlaceLocationCopyWith<$Res> {
  _$PlaceLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lng = null,
  }) {
    return _then(_value.copyWith(
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlaceLocationImplCopyWith<$Res>
    implements $PlaceLocationCopyWith<$Res> {
  factory _$$PlaceLocationImplCopyWith(
          _$PlaceLocationImpl value, $Res Function(_$PlaceLocationImpl) then) =
      __$$PlaceLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double lat, double lng});
}

/// @nodoc
class __$$PlaceLocationImplCopyWithImpl<$Res>
    extends _$PlaceLocationCopyWithImpl<$Res, _$PlaceLocationImpl>
    implements _$$PlaceLocationImplCopyWith<$Res> {
  __$$PlaceLocationImplCopyWithImpl(
      _$PlaceLocationImpl _value, $Res Function(_$PlaceLocationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lng = null,
  }) {
    return _then(_$PlaceLocationImpl(
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaceLocationImpl implements _PlaceLocation {
  const _$PlaceLocationImpl({required this.lat, required this.lng});

  factory _$PlaceLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceLocationImplFromJson(json);

  @override
  final double lat;
  @override
  final double lng;

  @override
  String toString() {
    return 'PlaceLocation(lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceLocationImpl &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, lat, lng);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceLocationImplCopyWith<_$PlaceLocationImpl> get copyWith =>
      __$$PlaceLocationImplCopyWithImpl<_$PlaceLocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceLocationImplToJson(
      this,
    );
  }
}

abstract class _PlaceLocation implements PlaceLocation {
  const factory _PlaceLocation(
      {required final double lat,
      required final double lng}) = _$PlaceLocationImpl;

  factory _PlaceLocation.fromJson(Map<String, dynamic> json) =
      _$PlaceLocationImpl.fromJson;

  @override
  double get lat;
  @override
  double get lng;
  @override
  @JsonKey(ignore: true)
  _$$PlaceLocationImplCopyWith<_$PlaceLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlacePhoto _$PlacePhotoFromJson(Map<String, dynamic> json) {
  return _PlacePhoto.fromJson(json);
}

/// @nodoc
mixin _$PlacePhoto {
  String get reference => throw _privateConstructorUsedError;
  int get width => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlacePhotoCopyWith<PlacePhoto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlacePhotoCopyWith<$Res> {
  factory $PlacePhotoCopyWith(
          PlacePhoto value, $Res Function(PlacePhoto) then) =
      _$PlacePhotoCopyWithImpl<$Res, PlacePhoto>;
  @useResult
  $Res call({String reference, int width, int height});
}

/// @nodoc
class _$PlacePhotoCopyWithImpl<$Res, $Val extends PlacePhoto>
    implements $PlacePhotoCopyWith<$Res> {
  _$PlacePhotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reference = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_value.copyWith(
      reference: null == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlacePhotoImplCopyWith<$Res>
    implements $PlacePhotoCopyWith<$Res> {
  factory _$$PlacePhotoImplCopyWith(
          _$PlacePhotoImpl value, $Res Function(_$PlacePhotoImpl) then) =
      __$$PlacePhotoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String reference, int width, int height});
}

/// @nodoc
class __$$PlacePhotoImplCopyWithImpl<$Res>
    extends _$PlacePhotoCopyWithImpl<$Res, _$PlacePhotoImpl>
    implements _$$PlacePhotoImplCopyWith<$Res> {
  __$$PlacePhotoImplCopyWithImpl(
      _$PlacePhotoImpl _value, $Res Function(_$PlacePhotoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reference = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_$PlacePhotoImpl(
      reference: null == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlacePhotoImpl implements _PlacePhoto {
  const _$PlacePhotoImpl(
      {required this.reference, required this.width, required this.height});

  factory _$PlacePhotoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlacePhotoImplFromJson(json);

  @override
  final String reference;
  @override
  final int width;
  @override
  final int height;

  @override
  String toString() {
    return 'PlacePhoto(reference: $reference, width: $width, height: $height)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlacePhotoImpl &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, reference, width, height);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlacePhotoImplCopyWith<_$PlacePhotoImpl> get copyWith =>
      __$$PlacePhotoImplCopyWithImpl<_$PlacePhotoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlacePhotoImplToJson(
      this,
    );
  }
}

abstract class _PlacePhoto implements PlacePhoto {
  const factory _PlacePhoto(
      {required final String reference,
      required final int width,
      required final int height}) = _$PlacePhotoImpl;

  factory _PlacePhoto.fromJson(Map<String, dynamic> json) =
      _$PlacePhotoImpl.fromJson;

  @override
  String get reference;
  @override
  int get width;
  @override
  int get height;
  @override
  @JsonKey(ignore: true)
  _$$PlacePhotoImplCopyWith<_$PlacePhotoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MapConfig _$MapConfigFromJson(Map<String, dynamic> json) {
  return _MapConfig.fromJson(json);
}

/// @nodoc
mixin _$MapConfig {
  String get accessToken => throw _privateConstructorUsedError;
  String get style => throw _privateConstructorUsedError;
  double get maxZoom => throw _privateConstructorUsedError;
  double get minZoom => throw _privateConstructorUsedError;
  List<double> get defaultCenter => throw _privateConstructorUsedError;
  double get defaultZoom => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MapConfigCopyWith<MapConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapConfigCopyWith<$Res> {
  factory $MapConfigCopyWith(MapConfig value, $Res Function(MapConfig) then) =
      _$MapConfigCopyWithImpl<$Res, MapConfig>;
  @useResult
  $Res call(
      {String accessToken,
      String style,
      double maxZoom,
      double minZoom,
      List<double> defaultCenter,
      double defaultZoom});
}

/// @nodoc
class _$MapConfigCopyWithImpl<$Res, $Val extends MapConfig>
    implements $MapConfigCopyWith<$Res> {
  _$MapConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? style = null,
    Object? maxZoom = null,
    Object? minZoom = null,
    Object? defaultCenter = null,
    Object? defaultZoom = null,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as String,
      maxZoom: null == maxZoom
          ? _value.maxZoom
          : maxZoom // ignore: cast_nullable_to_non_nullable
              as double,
      minZoom: null == minZoom
          ? _value.minZoom
          : minZoom // ignore: cast_nullable_to_non_nullable
              as double,
      defaultCenter: null == defaultCenter
          ? _value.defaultCenter
          : defaultCenter // ignore: cast_nullable_to_non_nullable
              as List<double>,
      defaultZoom: null == defaultZoom
          ? _value.defaultZoom
          : defaultZoom // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MapConfigImplCopyWith<$Res>
    implements $MapConfigCopyWith<$Res> {
  factory _$$MapConfigImplCopyWith(
          _$MapConfigImpl value, $Res Function(_$MapConfigImpl) then) =
      __$$MapConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accessToken,
      String style,
      double maxZoom,
      double minZoom,
      List<double> defaultCenter,
      double defaultZoom});
}

/// @nodoc
class __$$MapConfigImplCopyWithImpl<$Res>
    extends _$MapConfigCopyWithImpl<$Res, _$MapConfigImpl>
    implements _$$MapConfigImplCopyWith<$Res> {
  __$$MapConfigImplCopyWithImpl(
      _$MapConfigImpl _value, $Res Function(_$MapConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? style = null,
    Object? maxZoom = null,
    Object? minZoom = null,
    Object? defaultCenter = null,
    Object? defaultZoom = null,
  }) {
    return _then(_$MapConfigImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as String,
      maxZoom: null == maxZoom
          ? _value.maxZoom
          : maxZoom // ignore: cast_nullable_to_non_nullable
              as double,
      minZoom: null == minZoom
          ? _value.minZoom
          : minZoom // ignore: cast_nullable_to_non_nullable
              as double,
      defaultCenter: null == defaultCenter
          ? _value._defaultCenter
          : defaultCenter // ignore: cast_nullable_to_non_nullable
              as List<double>,
      defaultZoom: null == defaultZoom
          ? _value.defaultZoom
          : defaultZoom // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MapConfigImpl implements _MapConfig {
  const _$MapConfigImpl(
      {required this.accessToken,
      required this.style,
      required this.maxZoom,
      required this.minZoom,
      required final List<double> defaultCenter,
      required this.defaultZoom})
      : _defaultCenter = defaultCenter;

  factory _$MapConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$MapConfigImplFromJson(json);

  @override
  final String accessToken;
  @override
  final String style;
  @override
  final double maxZoom;
  @override
  final double minZoom;
  final List<double> _defaultCenter;
  @override
  List<double> get defaultCenter {
    if (_defaultCenter is EqualUnmodifiableListView) return _defaultCenter;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_defaultCenter);
  }

  @override
  final double defaultZoom;

  @override
  String toString() {
    return 'MapConfig(accessToken: $accessToken, style: $style, maxZoom: $maxZoom, minZoom: $minZoom, defaultCenter: $defaultCenter, defaultZoom: $defaultZoom)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapConfigImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.maxZoom, maxZoom) || other.maxZoom == maxZoom) &&
            (identical(other.minZoom, minZoom) || other.minZoom == minZoom) &&
            const DeepCollectionEquality()
                .equals(other._defaultCenter, _defaultCenter) &&
            (identical(other.defaultZoom, defaultZoom) ||
                other.defaultZoom == defaultZoom));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      accessToken,
      style,
      maxZoom,
      minZoom,
      const DeepCollectionEquality().hash(_defaultCenter),
      defaultZoom);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MapConfigImplCopyWith<_$MapConfigImpl> get copyWith =>
      __$$MapConfigImplCopyWithImpl<_$MapConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MapConfigImplToJson(
      this,
    );
  }
}

abstract class _MapConfig implements MapConfig {
  const factory _MapConfig(
      {required final String accessToken,
      required final String style,
      required final double maxZoom,
      required final double minZoom,
      required final List<double> defaultCenter,
      required final double defaultZoom}) = _$MapConfigImpl;

  factory _MapConfig.fromJson(Map<String, dynamic> json) =
      _$MapConfigImpl.fromJson;

  @override
  String get accessToken;
  @override
  String get style;
  @override
  double get maxZoom;
  @override
  double get minZoom;
  @override
  List<double> get defaultCenter;
  @override
  double get defaultZoom;
  @override
  @JsonKey(ignore: true)
  _$$MapConfigImplCopyWith<_$MapConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiResponse _$ApiResponseFromJson(Map<String, dynamic> json) {
  return _ApiResponse.fromJson(json);
}

/// @nodoc
mixin _$ApiResponse {
  bool get success => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApiResponseCopyWith<ApiResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiResponseCopyWith<$Res> {
  factory $ApiResponseCopyWith(
          ApiResponse value, $Res Function(ApiResponse) then) =
      _$ApiResponseCopyWithImpl<$Res, ApiResponse>;
  @useResult
  $Res call(
      {bool success,
      Map<String, dynamic>? data,
      String? error,
      String? message,
      String? note});
}

/// @nodoc
class _$ApiResponseCopyWithImpl<$Res, $Val extends ApiResponse>
    implements $ApiResponseCopyWith<$Res> {
  _$ApiResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? error = freezed,
    Object? message = freezed,
    Object? note = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiResponseImplCopyWith<$Res>
    implements $ApiResponseCopyWith<$Res> {
  factory _$$ApiResponseImplCopyWith(
          _$ApiResponseImpl value, $Res Function(_$ApiResponseImpl) then) =
      __$$ApiResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      Map<String, dynamic>? data,
      String? error,
      String? message,
      String? note});
}

/// @nodoc
class __$$ApiResponseImplCopyWithImpl<$Res>
    extends _$ApiResponseCopyWithImpl<$Res, _$ApiResponseImpl>
    implements _$$ApiResponseImplCopyWith<$Res> {
  __$$ApiResponseImplCopyWithImpl(
      _$ApiResponseImpl _value, $Res Function(_$ApiResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? error = freezed,
    Object? message = freezed,
    Object? note = freezed,
  }) {
    return _then(_$ApiResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiResponseImpl implements _ApiResponse {
  const _$ApiResponseImpl(
      {required this.success,
      final Map<String, dynamic>? data,
      this.error,
      this.message,
      this.note})
      : _data = data;

  factory _$ApiResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiResponseImplFromJson(json);

  @override
  final bool success;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? error;
  @override
  final String? message;
  @override
  final String? note;

  @override
  String toString() {
    return 'ApiResponse(success: $success, data: $data, error: $error, message: $message, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, success,
      const DeepCollectionEquality().hash(_data), error, message, note);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiResponseImplCopyWith<_$ApiResponseImpl> get copyWith =>
      __$$ApiResponseImplCopyWithImpl<_$ApiResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiResponseImplToJson(
      this,
    );
  }
}

abstract class _ApiResponse implements ApiResponse {
  const factory _ApiResponse(
      {required final bool success,
      final Map<String, dynamic>? data,
      final String? error,
      final String? message,
      final String? note}) = _$ApiResponseImpl;

  factory _ApiResponse.fromJson(Map<String, dynamic> json) =
      _$ApiResponseImpl.fromJson;

  @override
  bool get success;
  @override
  Map<String, dynamic>? get data;
  @override
  String? get error;
  @override
  String? get message;
  @override
  String? get note;
  @override
  @JsonKey(ignore: true)
  _$$ApiResponseImplCopyWith<_$ApiResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HealthResponse _$HealthResponseFromJson(Map<String, dynamic> json) {
  return _HealthResponse.fromJson(json);
}

/// @nodoc
mixin _$HealthResponse {
  String get status => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  String? get service => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HealthResponseCopyWith<HealthResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthResponseCopyWith<$Res> {
  factory $HealthResponseCopyWith(
          HealthResponse value, $Res Function(HealthResponse) then) =
      _$HealthResponseCopyWithImpl<$Res, HealthResponse>;
  @useResult
  $Res call({String status, String timestamp, String version, String? service});
}

/// @nodoc
class _$HealthResponseCopyWithImpl<$Res, $Val extends HealthResponse>
    implements $HealthResponseCopyWith<$Res> {
  _$HealthResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? timestamp = null,
    Object? version = null,
    Object? service = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      service: freezed == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthResponseImplCopyWith<$Res>
    implements $HealthResponseCopyWith<$Res> {
  factory _$$HealthResponseImplCopyWith(_$HealthResponseImpl value,
          $Res Function(_$HealthResponseImpl) then) =
      __$$HealthResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status, String timestamp, String version, String? service});
}

/// @nodoc
class __$$HealthResponseImplCopyWithImpl<$Res>
    extends _$HealthResponseCopyWithImpl<$Res, _$HealthResponseImpl>
    implements _$$HealthResponseImplCopyWith<$Res> {
  __$$HealthResponseImplCopyWithImpl(
      _$HealthResponseImpl _value, $Res Function(_$HealthResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? timestamp = null,
    Object? version = null,
    Object? service = freezed,
  }) {
    return _then(_$HealthResponseImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      service: freezed == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthResponseImpl implements _HealthResponse {
  const _$HealthResponseImpl(
      {required this.status,
      required this.timestamp,
      required this.version,
      this.service});

  factory _$HealthResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthResponseImplFromJson(json);

  @override
  final String status;
  @override
  final String timestamp;
  @override
  final String version;
  @override
  final String? service;

  @override
  String toString() {
    return 'HealthResponse(status: $status, timestamp: $timestamp, version: $version, service: $service)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthResponseImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.service, service) || other.service == service));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, status, timestamp, version, service);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthResponseImplCopyWith<_$HealthResponseImpl> get copyWith =>
      __$$HealthResponseImplCopyWithImpl<_$HealthResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthResponseImplToJson(
      this,
    );
  }
}

abstract class _HealthResponse implements HealthResponse {
  const factory _HealthResponse(
      {required final String status,
      required final String timestamp,
      required final String version,
      final String? service}) = _$HealthResponseImpl;

  factory _HealthResponse.fromJson(Map<String, dynamic> json) =
      _$HealthResponseImpl.fromJson;

  @override
  String get status;
  @override
  String get timestamp;
  @override
  String get version;
  @override
  String? get service;
  @override
  @JsonKey(ignore: true)
  _$$HealthResponseImplCopyWith<_$HealthResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
