// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_preference_analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserPreferenceAnalysis _$UserPreferenceAnalysisFromJson(
    Map<String, dynamic> json) {
  return _UserPreferenceAnalysis.fromJson(json);
}

/// @nodoc
mixin _$UserPreferenceAnalysis {
  @HiveField(0)
  String get primaryFocus => throw _privateConstructorUsedError;
  @HiveField(1)
  TravelPace get travelPace => throw _privateConstructorUsedError;
  @HiveField(2)
  List<String> get interests => throw _privateConstructorUsedError;
  @HiveField(3)
  List<String> get avoidances => throw _privateConstructorUsedError;
  @HiveField(4)
  String get mood => throw _privateConstructorUsedError;
  @HiveField(5)
  List<String> get keywords => throw _privateConstructorUsedError;
  @HiveField(6)
  List<String> get detectedInterests => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserPreferenceAnalysisCopyWith<UserPreferenceAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPreferenceAnalysisCopyWith<$Res> {
  factory $UserPreferenceAnalysisCopyWith(UserPreferenceAnalysis value,
          $Res Function(UserPreferenceAnalysis) then) =
      _$UserPreferenceAnalysisCopyWithImpl<$Res, UserPreferenceAnalysis>;
  @useResult
  $Res call(
      {@HiveField(0) String primaryFocus,
      @HiveField(1) TravelPace travelPace,
      @HiveField(2) List<String> interests,
      @HiveField(3) List<String> avoidances,
      @HiveField(4) String mood,
      @HiveField(5) List<String> keywords,
      @HiveField(6) List<String> detectedInterests});
}

/// @nodoc
class _$UserPreferenceAnalysisCopyWithImpl<$Res,
        $Val extends UserPreferenceAnalysis>
    implements $UserPreferenceAnalysisCopyWith<$Res> {
  _$UserPreferenceAnalysisCopyWithImpl(this._value, this._then);

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
    Object? detectedInterests = null,
  }) {
    return _then(_value.copyWith(
      primaryFocus: null == primaryFocus
          ? _value.primaryFocus
          : primaryFocus // ignore: cast_nullable_to_non_nullable
              as String,
      travelPace: null == travelPace
          ? _value.travelPace
          : travelPace // ignore: cast_nullable_to_non_nullable
              as TravelPace,
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
      detectedInterests: null == detectedInterests
          ? _value.detectedInterests
          : detectedInterests // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserPreferenceAnalysisImplCopyWith<$Res>
    implements $UserPreferenceAnalysisCopyWith<$Res> {
  factory _$$UserPreferenceAnalysisImplCopyWith(
          _$UserPreferenceAnalysisImpl value,
          $Res Function(_$UserPreferenceAnalysisImpl) then) =
      __$$UserPreferenceAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String primaryFocus,
      @HiveField(1) TravelPace travelPace,
      @HiveField(2) List<String> interests,
      @HiveField(3) List<String> avoidances,
      @HiveField(4) String mood,
      @HiveField(5) List<String> keywords,
      @HiveField(6) List<String> detectedInterests});
}

/// @nodoc
class __$$UserPreferenceAnalysisImplCopyWithImpl<$Res>
    extends _$UserPreferenceAnalysisCopyWithImpl<$Res,
        _$UserPreferenceAnalysisImpl>
    implements _$$UserPreferenceAnalysisImplCopyWith<$Res> {
  __$$UserPreferenceAnalysisImplCopyWithImpl(
      _$UserPreferenceAnalysisImpl _value,
      $Res Function(_$UserPreferenceAnalysisImpl) _then)
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
    Object? detectedInterests = null,
  }) {
    return _then(_$UserPreferenceAnalysisImpl(
      primaryFocus: null == primaryFocus
          ? _value.primaryFocus
          : primaryFocus // ignore: cast_nullable_to_non_nullable
              as String,
      travelPace: null == travelPace
          ? _value.travelPace
          : travelPace // ignore: cast_nullable_to_non_nullable
              as TravelPace,
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
      detectedInterests: null == detectedInterests
          ? _value._detectedInterests
          : detectedInterests // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPreferenceAnalysisImpl implements _UserPreferenceAnalysis {
  const _$UserPreferenceAnalysisImpl(
      {@HiveField(0) required this.primaryFocus,
      @HiveField(1) required this.travelPace,
      @HiveField(2) required final List<String> interests,
      @HiveField(3) required final List<String> avoidances,
      @HiveField(4) required this.mood,
      @HiveField(5) required final List<String> keywords,
      @HiveField(6) final List<String> detectedInterests = const []})
      : _interests = interests,
        _avoidances = avoidances,
        _keywords = keywords,
        _detectedInterests = detectedInterests;

  factory _$UserPreferenceAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPreferenceAnalysisImplFromJson(json);

  @override
  @HiveField(0)
  final String primaryFocus;
  @override
  @HiveField(1)
  final TravelPace travelPace;
  final List<String> _interests;
  @override
  @HiveField(2)
  List<String> get interests {
    if (_interests is EqualUnmodifiableListView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interests);
  }

  final List<String> _avoidances;
  @override
  @HiveField(3)
  List<String> get avoidances {
    if (_avoidances is EqualUnmodifiableListView) return _avoidances;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_avoidances);
  }

  @override
  @HiveField(4)
  final String mood;
  final List<String> _keywords;
  @override
  @HiveField(5)
  List<String> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
  }

  final List<String> _detectedInterests;
  @override
  @JsonKey()
  @HiveField(6)
  List<String> get detectedInterests {
    if (_detectedInterests is EqualUnmodifiableListView)
      return _detectedInterests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_detectedInterests);
  }

  @override
  String toString() {
    return 'UserPreferenceAnalysis(primaryFocus: $primaryFocus, travelPace: $travelPace, interests: $interests, avoidances: $avoidances, mood: $mood, keywords: $keywords, detectedInterests: $detectedInterests)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPreferenceAnalysisImpl &&
            (identical(other.primaryFocus, primaryFocus) ||
                other.primaryFocus == primaryFocus) &&
            (identical(other.travelPace, travelPace) ||
                other.travelPace == travelPace) &&
            const DeepCollectionEquality()
                .equals(other._interests, _interests) &&
            const DeepCollectionEquality()
                .equals(other._avoidances, _avoidances) &&
            (identical(other.mood, mood) || other.mood == mood) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords) &&
            const DeepCollectionEquality()
                .equals(other._detectedInterests, _detectedInterests));
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
      const DeepCollectionEquality().hash(_keywords),
      const DeepCollectionEquality().hash(_detectedInterests));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPreferenceAnalysisImplCopyWith<_$UserPreferenceAnalysisImpl>
      get copyWith => __$$UserPreferenceAnalysisImplCopyWithImpl<
          _$UserPreferenceAnalysisImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPreferenceAnalysisImplToJson(
      this,
    );
  }
}

abstract class _UserPreferenceAnalysis implements UserPreferenceAnalysis {
  const factory _UserPreferenceAnalysis(
          {@HiveField(0) required final String primaryFocus,
          @HiveField(1) required final TravelPace travelPace,
          @HiveField(2) required final List<String> interests,
          @HiveField(3) required final List<String> avoidances,
          @HiveField(4) required final String mood,
          @HiveField(5) required final List<String> keywords,
          @HiveField(6) final List<String> detectedInterests}) =
      _$UserPreferenceAnalysisImpl;

  factory _UserPreferenceAnalysis.fromJson(Map<String, dynamic> json) =
      _$UserPreferenceAnalysisImpl.fromJson;

  @override
  @HiveField(0)
  String get primaryFocus;
  @override
  @HiveField(1)
  TravelPace get travelPace;
  @override
  @HiveField(2)
  List<String> get interests;
  @override
  @HiveField(3)
  List<String> get avoidances;
  @override
  @HiveField(4)
  String get mood;
  @override
  @HiveField(5)
  List<String> get keywords;
  @override
  @HiveField(6)
  List<String> get detectedInterests;
  @override
  @JsonKey(ignore: true)
  _$$UserPreferenceAnalysisImplCopyWith<_$UserPreferenceAnalysisImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BasicPreferences _$BasicPreferencesFromJson(Map<String, dynamic> json) {
  return _BasicPreferences.fromJson(json);
}

/// @nodoc
mixin _$BasicPreferences {
  @HiveField(0)
  BudgetRange get budget => throw _privateConstructorUsedError;
  @HiveField(1)
  int get groupSize => throw _privateConstructorUsedError;
  @HiveField(2)
  TravelStyle get travelStyle => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BasicPreferencesCopyWith<BasicPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BasicPreferencesCopyWith<$Res> {
  factory $BasicPreferencesCopyWith(
          BasicPreferences value, $Res Function(BasicPreferences) then) =
      _$BasicPreferencesCopyWithImpl<$Res, BasicPreferences>;
  @useResult
  $Res call(
      {@HiveField(0) BudgetRange budget,
      @HiveField(1) int groupSize,
      @HiveField(2) TravelStyle travelStyle});
}

/// @nodoc
class _$BasicPreferencesCopyWithImpl<$Res, $Val extends BasicPreferences>
    implements $BasicPreferencesCopyWith<$Res> {
  _$BasicPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budget = null,
    Object? groupSize = null,
    Object? travelStyle = null,
  }) {
    return _then(_value.copyWith(
      budget: null == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as BudgetRange,
      groupSize: null == groupSize
          ? _value.groupSize
          : groupSize // ignore: cast_nullable_to_non_nullable
              as int,
      travelStyle: null == travelStyle
          ? _value.travelStyle
          : travelStyle // ignore: cast_nullable_to_non_nullable
              as TravelStyle,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BasicPreferencesImplCopyWith<$Res>
    implements $BasicPreferencesCopyWith<$Res> {
  factory _$$BasicPreferencesImplCopyWith(_$BasicPreferencesImpl value,
          $Res Function(_$BasicPreferencesImpl) then) =
      __$$BasicPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) BudgetRange budget,
      @HiveField(1) int groupSize,
      @HiveField(2) TravelStyle travelStyle});
}

/// @nodoc
class __$$BasicPreferencesImplCopyWithImpl<$Res>
    extends _$BasicPreferencesCopyWithImpl<$Res, _$BasicPreferencesImpl>
    implements _$$BasicPreferencesImplCopyWith<$Res> {
  __$$BasicPreferencesImplCopyWithImpl(_$BasicPreferencesImpl _value,
      $Res Function(_$BasicPreferencesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budget = null,
    Object? groupSize = null,
    Object? travelStyle = null,
  }) {
    return _then(_$BasicPreferencesImpl(
      budget: null == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as BudgetRange,
      groupSize: null == groupSize
          ? _value.groupSize
          : groupSize // ignore: cast_nullable_to_non_nullable
              as int,
      travelStyle: null == travelStyle
          ? _value.travelStyle
          : travelStyle // ignore: cast_nullable_to_non_nullable
              as TravelStyle,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BasicPreferencesImpl implements _BasicPreferences {
  const _$BasicPreferencesImpl(
      {@HiveField(0) required this.budget,
      @HiveField(1) required this.groupSize,
      @HiveField(2) required this.travelStyle});

  factory _$BasicPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$BasicPreferencesImplFromJson(json);

  @override
  @HiveField(0)
  final BudgetRange budget;
  @override
  @HiveField(1)
  final int groupSize;
  @override
  @HiveField(2)
  final TravelStyle travelStyle;

  @override
  String toString() {
    return 'BasicPreferences(budget: $budget, groupSize: $groupSize, travelStyle: $travelStyle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BasicPreferencesImpl &&
            (identical(other.budget, budget) || other.budget == budget) &&
            (identical(other.groupSize, groupSize) ||
                other.groupSize == groupSize) &&
            (identical(other.travelStyle, travelStyle) ||
                other.travelStyle == travelStyle));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, budget, groupSize, travelStyle);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BasicPreferencesImplCopyWith<_$BasicPreferencesImpl> get copyWith =>
      __$$BasicPreferencesImplCopyWithImpl<_$BasicPreferencesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BasicPreferencesImplToJson(
      this,
    );
  }
}

abstract class _BasicPreferences implements BasicPreferences {
  const factory _BasicPreferences(
          {@HiveField(0) required final BudgetRange budget,
          @HiveField(1) required final int groupSize,
          @HiveField(2) required final TravelStyle travelStyle}) =
      _$BasicPreferencesImpl;

  factory _BasicPreferences.fromJson(Map<String, dynamic> json) =
      _$BasicPreferencesImpl.fromJson;

  @override
  @HiveField(0)
  BudgetRange get budget;
  @override
  @HiveField(1)
  int get groupSize;
  @override
  @HiveField(2)
  TravelStyle get travelStyle;
  @override
  @JsonKey(ignore: true)
  _$$BasicPreferencesImplCopyWith<_$BasicPreferencesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
