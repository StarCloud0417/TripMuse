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
  /// 行程唯一識別碼
  String get id => throw _privateConstructorUsedError;

  /// 行程標題
  String get title => throw _privateConstructorUsedError;

  /// 目的地資訊
  Destination get destination => throw _privateConstructorUsedError;

  /// 每日行程計畫
  List<DayPlan> get days => throw _privateConstructorUsedError;

  /// 使用者偏好分析
  @JsonKey(includeFromJson: false, includeToJson: false)
  UserPreferenceAnalysis? get preferenceAnalysis =>
      throw _privateConstructorUsedError;

  /// 建立時間
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 最後更新時間
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// 使用者 ID（可為空，Guest 模式）
  String? get userId => throw _privateConstructorUsedError;

  /// 生成此行程的 AI 模型
  String? get generatedBy => throw _privateConstructorUsedError;

  /// 行程狀態
  TripStatus get status => throw _privateConstructorUsedError;

  /// 行程備註
  String? get notes => throw _privateConstructorUsedError;

  /// 是否為收藏
  bool get isFavorite => throw _privateConstructorUsedError;

  /// 分享設定
  TripSharingSettings? get sharingSettings =>
      throw _privateConstructorUsedError;

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
      {String id,
      String title,
      Destination destination,
      List<DayPlan> days,
      @JsonKey(includeFromJson: false, includeToJson: false)
      UserPreferenceAnalysis? preferenceAnalysis,
      DateTime createdAt,
      DateTime updatedAt,
      String? userId,
      String? generatedBy,
      TripStatus status,
      String? notes,
      bool isFavorite,
      TripSharingSettings? sharingSettings});

  $DestinationCopyWith<$Res> get destination;
  $UserPreferenceAnalysisCopyWith<$Res>? get preferenceAnalysis;
  $TripSharingSettingsCopyWith<$Res>? get sharingSettings;
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
    Object? preferenceAnalysis = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userId = freezed,
    Object? generatedBy = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? isFavorite = null,
    Object? sharingSettings = freezed,
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
      preferenceAnalysis: freezed == preferenceAnalysis
          ? _value.preferenceAnalysis
          : preferenceAnalysis // ignore: cast_nullable_to_non_nullable
              as UserPreferenceAnalysis?,
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TripStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      sharingSettings: freezed == sharingSettings
          ? _value.sharingSettings
          : sharingSettings // ignore: cast_nullable_to_non_nullable
              as TripSharingSettings?,
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
  $UserPreferenceAnalysisCopyWith<$Res>? get preferenceAnalysis {
    if (_value.preferenceAnalysis == null) {
      return null;
    }

    return $UserPreferenceAnalysisCopyWith<$Res>(_value.preferenceAnalysis!,
        (value) {
      return _then(_value.copyWith(preferenceAnalysis: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TripSharingSettingsCopyWith<$Res>? get sharingSettings {
    if (_value.sharingSettings == null) {
      return null;
    }

    return $TripSharingSettingsCopyWith<$Res>(_value.sharingSettings!, (value) {
      return _then(_value.copyWith(sharingSettings: value) as $Val);
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
      {String id,
      String title,
      Destination destination,
      List<DayPlan> days,
      @JsonKey(includeFromJson: false, includeToJson: false)
      UserPreferenceAnalysis? preferenceAnalysis,
      DateTime createdAt,
      DateTime updatedAt,
      String? userId,
      String? generatedBy,
      TripStatus status,
      String? notes,
      bool isFavorite,
      TripSharingSettings? sharingSettings});

  @override
  $DestinationCopyWith<$Res> get destination;
  @override
  $UserPreferenceAnalysisCopyWith<$Res>? get preferenceAnalysis;
  @override
  $TripSharingSettingsCopyWith<$Res>? get sharingSettings;
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
    Object? preferenceAnalysis = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userId = freezed,
    Object? generatedBy = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? isFavorite = null,
    Object? sharingSettings = freezed,
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
      preferenceAnalysis: freezed == preferenceAnalysis
          ? _value.preferenceAnalysis
          : preferenceAnalysis // ignore: cast_nullable_to_non_nullable
              as UserPreferenceAnalysis?,
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TripStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      sharingSettings: freezed == sharingSettings
          ? _value.sharingSettings
          : sharingSettings // ignore: cast_nullable_to_non_nullable
              as TripSharingSettings?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TripImpl implements _Trip {
  const _$TripImpl(
      {required this.id,
      required this.title,
      required this.destination,
      final List<DayPlan> days = const [],
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.preferenceAnalysis,
      required this.createdAt,
      required this.updatedAt,
      this.userId,
      this.generatedBy,
      this.status = TripStatus.draft,
      this.notes,
      this.isFavorite = false,
      this.sharingSettings})
      : _days = days;

  factory _$TripImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripImplFromJson(json);

  /// 行程唯一識別碼
  @override
  final String id;

  /// 行程標題
  @override
  final String title;

  /// 目的地資訊
  @override
  final Destination destination;

  /// 每日行程計畫
  final List<DayPlan> _days;

  /// 每日行程計畫
  @override
  @JsonKey()
  List<DayPlan> get days {
    if (_days is EqualUnmodifiableListView) return _days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_days);
  }

  /// 使用者偏好分析
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final UserPreferenceAnalysis? preferenceAnalysis;

  /// 建立時間
  @override
  final DateTime createdAt;

  /// 最後更新時間
  @override
  final DateTime updatedAt;

  /// 使用者 ID（可為空，Guest 模式）
  @override
  final String? userId;

  /// 生成此行程的 AI 模型
  @override
  final String? generatedBy;

  /// 行程狀態
  @override
  @JsonKey()
  final TripStatus status;

  /// 行程備註
  @override
  final String? notes;

  /// 是否為收藏
  @override
  @JsonKey()
  final bool isFavorite;

  /// 分享設定
  @override
  final TripSharingSettings? sharingSettings;

  @override
  String toString() {
    return 'Trip(id: $id, title: $title, destination: $destination, days: $days, preferenceAnalysis: $preferenceAnalysis, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, generatedBy: $generatedBy, status: $status, notes: $notes, isFavorite: $isFavorite, sharingSettings: $sharingSettings)';
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
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.sharingSettings, sharingSettings) ||
                other.sharingSettings == sharingSettings));
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
      status,
      notes,
      isFavorite,
      sharingSettings);

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
      {required final String id,
      required final String title,
      required final Destination destination,
      final List<DayPlan> days,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final UserPreferenceAnalysis? preferenceAnalysis,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? userId,
      final String? generatedBy,
      final TripStatus status,
      final String? notes,
      final bool isFavorite,
      final TripSharingSettings? sharingSettings}) = _$TripImpl;

  factory _Trip.fromJson(Map<String, dynamic> json) = _$TripImpl.fromJson;

  @override

  /// 行程唯一識別碼
  String get id;
  @override

  /// 行程標題
  String get title;
  @override

  /// 目的地資訊
  Destination get destination;
  @override

  /// 每日行程計畫
  List<DayPlan> get days;
  @override

  /// 使用者偏好分析
  @JsonKey(includeFromJson: false, includeToJson: false)
  UserPreferenceAnalysis? get preferenceAnalysis;
  @override

  /// 建立時間
  DateTime get createdAt;
  @override

  /// 最後更新時間
  DateTime get updatedAt;
  @override

  /// 使用者 ID（可為空，Guest 模式）
  String? get userId;
  @override

  /// 生成此行程的 AI 模型
  String? get generatedBy;
  @override

  /// 行程狀態
  TripStatus get status;
  @override

  /// 行程備註
  String? get notes;
  @override

  /// 是否為收藏
  bool get isFavorite;
  @override

  /// 分享設定
  TripSharingSettings? get sharingSettings;
  @override
  @JsonKey(ignore: true)
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TripSharingSettings _$TripSharingSettingsFromJson(Map<String, dynamic> json) {
  return _TripSharingSettings.fromJson(json);
}

/// @nodoc
mixin _$TripSharingSettings {
  /// 是否啟用分享
  bool get isEnabled => throw _privateConstructorUsedError;

  /// 分享 Token
  String? get shareToken => throw _privateConstructorUsedError;

  /// 分享連結過期時間
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// 分享建立時間
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TripSharingSettingsCopyWith<TripSharingSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripSharingSettingsCopyWith<$Res> {
  factory $TripSharingSettingsCopyWith(
          TripSharingSettings value, $Res Function(TripSharingSettings) then) =
      _$TripSharingSettingsCopyWithImpl<$Res, TripSharingSettings>;
  @useResult
  $Res call(
      {bool isEnabled,
      String? shareToken,
      DateTime? expiresAt,
      DateTime? createdAt});
}

/// @nodoc
class _$TripSharingSettingsCopyWithImpl<$Res, $Val extends TripSharingSettings>
    implements $TripSharingSettingsCopyWith<$Res> {
  _$TripSharingSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isEnabled = null,
    Object? shareToken = freezed,
    Object? expiresAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      shareToken: freezed == shareToken
          ? _value.shareToken
          : shareToken // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TripSharingSettingsImplCopyWith<$Res>
    implements $TripSharingSettingsCopyWith<$Res> {
  factory _$$TripSharingSettingsImplCopyWith(_$TripSharingSettingsImpl value,
          $Res Function(_$TripSharingSettingsImpl) then) =
      __$$TripSharingSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isEnabled,
      String? shareToken,
      DateTime? expiresAt,
      DateTime? createdAt});
}

/// @nodoc
class __$$TripSharingSettingsImplCopyWithImpl<$Res>
    extends _$TripSharingSettingsCopyWithImpl<$Res, _$TripSharingSettingsImpl>
    implements _$$TripSharingSettingsImplCopyWith<$Res> {
  __$$TripSharingSettingsImplCopyWithImpl(_$TripSharingSettingsImpl _value,
      $Res Function(_$TripSharingSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isEnabled = null,
    Object? shareToken = freezed,
    Object? expiresAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$TripSharingSettingsImpl(
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      shareToken: freezed == shareToken
          ? _value.shareToken
          : shareToken // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TripSharingSettingsImpl implements _TripSharingSettings {
  const _$TripSharingSettingsImpl(
      {this.isEnabled = false,
      this.shareToken,
      this.expiresAt,
      this.createdAt});

  factory _$TripSharingSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripSharingSettingsImplFromJson(json);

  /// 是否啟用分享
  @override
  @JsonKey()
  final bool isEnabled;

  /// 分享 Token
  @override
  final String? shareToken;

  /// 分享連結過期時間
  @override
  final DateTime? expiresAt;

  /// 分享建立時間
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'TripSharingSettings(isEnabled: $isEnabled, shareToken: $shareToken, expiresAt: $expiresAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripSharingSettingsImpl &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.shareToken, shareToken) ||
                other.shareToken == shareToken) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, isEnabled, shareToken, expiresAt, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TripSharingSettingsImplCopyWith<_$TripSharingSettingsImpl> get copyWith =>
      __$$TripSharingSettingsImplCopyWithImpl<_$TripSharingSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripSharingSettingsImplToJson(
      this,
    );
  }
}

abstract class _TripSharingSettings implements TripSharingSettings {
  const factory _TripSharingSettings(
      {final bool isEnabled,
      final String? shareToken,
      final DateTime? expiresAt,
      final DateTime? createdAt}) = _$TripSharingSettingsImpl;

  factory _TripSharingSettings.fromJson(Map<String, dynamic> json) =
      _$TripSharingSettingsImpl.fromJson;

  @override

  /// 是否啟用分享
  bool get isEnabled;
  @override

  /// 分享 Token
  String? get shareToken;
  @override

  /// 分享連結過期時間
  DateTime? get expiresAt;
  @override

  /// 分享建立時間
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$TripSharingSettingsImplCopyWith<_$TripSharingSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
