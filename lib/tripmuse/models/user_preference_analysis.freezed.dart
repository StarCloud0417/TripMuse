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
  /// 主要關注重點
  String get primaryFocus => throw _privateConstructorUsedError;

  /// 旅行節奏
  TravelPace get travelPace => throw _privateConstructorUsedError;

  /// 興趣列表
  List<String> get interests => throw _privateConstructorUsedError;

  /// 要避免的事項
  List<String> get avoidances => throw _privateConstructorUsedError;

  /// 旅行情調/氛圍
  String get mood => throw _privateConstructorUsedError;

  /// 關鍵字列表
  List<String> get keywords => throw _privateConstructorUsedError;

  /// 分析信心度 (0.0 - 1.0)
  double get confidence => throw _privateConstructorUsedError;

  /// 分析時間戳記
  DateTime? get analyzedAt => throw _privateConstructorUsedError;

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
      {String primaryFocus,
      TravelPace travelPace,
      List<String> interests,
      List<String> avoidances,
      String mood,
      List<String> keywords,
      double confidence,
      DateTime? analyzedAt});
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
    Object? confidence = null,
    Object? analyzedAt = freezed,
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
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      analyzedAt: freezed == analyzedAt
          ? _value.analyzedAt
          : analyzedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      {String primaryFocus,
      TravelPace travelPace,
      List<String> interests,
      List<String> avoidances,
      String mood,
      List<String> keywords,
      double confidence,
      DateTime? analyzedAt});
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
    Object? confidence = null,
    Object? analyzedAt = freezed,
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
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      analyzedAt: freezed == analyzedAt
          ? _value.analyzedAt
          : analyzedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPreferenceAnalysisImpl implements _UserPreferenceAnalysis {
  const _$UserPreferenceAnalysisImpl(
      {required this.primaryFocus,
      required this.travelPace,
      final List<String> interests = const [],
      final List<String> avoidances = const [],
      required this.mood,
      final List<String> keywords = const [],
      this.confidence = 0.0,
      this.analyzedAt})
      : _interests = interests,
        _avoidances = avoidances,
        _keywords = keywords;

  factory _$UserPreferenceAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPreferenceAnalysisImplFromJson(json);

  /// 主要關注重點
  @override
  final String primaryFocus;

  /// 旅行節奏
  @override
  final TravelPace travelPace;

  /// 興趣列表
  final List<String> _interests;

  /// 興趣列表
  @override
  @JsonKey()
  List<String> get interests {
    if (_interests is EqualUnmodifiableListView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interests);
  }

  /// 要避免的事項
  final List<String> _avoidances;

  /// 要避免的事項
  @override
  @JsonKey()
  List<String> get avoidances {
    if (_avoidances is EqualUnmodifiableListView) return _avoidances;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_avoidances);
  }

  /// 旅行情調/氛圍
  @override
  final String mood;

  /// 關鍵字列表
  final List<String> _keywords;

  /// 關鍵字列表
  @override
  @JsonKey()
  List<String> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
  }

  /// 分析信心度 (0.0 - 1.0)
  @override
  @JsonKey()
  final double confidence;

  /// 分析時間戳記
  @override
  final DateTime? analyzedAt;

  @override
  String toString() {
    return 'UserPreferenceAnalysis(primaryFocus: $primaryFocus, travelPace: $travelPace, interests: $interests, avoidances: $avoidances, mood: $mood, keywords: $keywords, confidence: $confidence, analyzedAt: $analyzedAt)';
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
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.analyzedAt, analyzedAt) ||
                other.analyzedAt == analyzedAt));
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
      confidence,
      analyzedAt);

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
      {required final String primaryFocus,
      required final TravelPace travelPace,
      final List<String> interests,
      final List<String> avoidances,
      required final String mood,
      final List<String> keywords,
      final double confidence,
      final DateTime? analyzedAt}) = _$UserPreferenceAnalysisImpl;

  factory _UserPreferenceAnalysis.fromJson(Map<String, dynamic> json) =
      _$UserPreferenceAnalysisImpl.fromJson;

  @override

  /// 主要關注重點
  String get primaryFocus;
  @override

  /// 旅行節奏
  TravelPace get travelPace;
  @override

  /// 興趣列表
  List<String> get interests;
  @override

  /// 要避免的事項
  List<String> get avoidances;
  @override

  /// 旅行情調/氛圍
  String get mood;
  @override

  /// 關鍵字列表
  List<String> get keywords;
  @override

  /// 分析信心度 (0.0 - 1.0)
  double get confidence;
  @override

  /// 分析時間戳記
  DateTime? get analyzedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserPreferenceAnalysisImplCopyWith<_$UserPreferenceAnalysisImpl>
      get copyWith => throw _privateConstructorUsedError;
}
