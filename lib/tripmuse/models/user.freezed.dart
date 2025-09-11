// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  /// 使用者唯一識別碼
  String get id => throw _privateConstructorUsedError;

  /// 使用者名稱
  String get name => throw _privateConstructorUsedError;

  /// 電子郵件
  String get email => throw _privateConstructorUsedError;

  /// 頭像 URL
  String? get avatarUrl => throw _privateConstructorUsedError;

  /// Google ID（如果是 Google 登入）
  String? get googleId => throw _privateConstructorUsedError;

  /// 是否為訪客模式
  bool get isGuest => throw _privateConstructorUsedError;

  /// 建立時間
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 更新時間
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String id,
      String name,
      String email,
      String? avatarUrl,
      String? googleId,
      bool isGuest,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? avatarUrl = freezed,
    Object? googleId = freezed,
    Object? isGuest = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      googleId: freezed == googleId
          ? _value.googleId
          : googleId // ignore: cast_nullable_to_non_nullable
              as String?,
      isGuest: null == isGuest
          ? _value.isGuest
          : isGuest // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String email,
      String? avatarUrl,
      String? googleId,
      bool isGuest,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? avatarUrl = freezed,
    Object? googleId = freezed,
    Object? isGuest = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$UserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      googleId: freezed == googleId
          ? _value.googleId
          : googleId // ignore: cast_nullable_to_non_nullable
              as String?,
      isGuest: null == isGuest
          ? _value.isGuest
          : isGuest // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl(
      {required this.id,
      required this.name,
      required this.email,
      this.avatarUrl,
      this.googleId,
      this.isGuest = false,
      required this.createdAt,
      required this.updatedAt});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  /// 使用者唯一識別碼
  @override
  final String id;

  /// 使用者名稱
  @override
  final String name;

  /// 電子郵件
  @override
  final String email;

  /// 頭像 URL
  @override
  final String? avatarUrl;

  /// Google ID（如果是 Google 登入）
  @override
  final String? googleId;

  /// 是否為訪客模式
  @override
  @JsonKey()
  final bool isGuest;

  /// 建立時間
  @override
  final DateTime createdAt;

  /// 更新時間
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl, googleId: $googleId, isGuest: $isGuest, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.googleId, googleId) ||
                other.googleId == googleId) &&
            (identical(other.isGuest, isGuest) || other.isGuest == isGuest) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, email, avatarUrl,
      googleId, isGuest, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String id,
      required final String name,
      required final String email,
      final String? avatarUrl,
      final String? googleId,
      final bool isGuest,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override

  /// 使用者唯一識別碼
  String get id;
  @override

  /// 使用者名稱
  String get name;
  @override

  /// 電子郵件
  String get email;
  @override

  /// 頭像 URL
  String? get avatarUrl;
  @override

  /// Google ID（如果是 Google 登入）
  String? get googleId;
  @override

  /// 是否為訪客模式
  bool get isGuest;
  @override

  /// 建立時間
  DateTime get createdAt;
  @override

  /// 更新時間
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) {
  return _UserPreferences.fromJson(json);
}

/// @nodoc
mixin _$UserPreferences {
  /// 偏好的語言
  String get language => throw _privateConstructorUsedError;

  /// 主題設定
  String get theme => throw _privateConstructorUsedError;

  /// 預設貨幣
  String get defaultCurrency => throw _privateConstructorUsedError;

  /// 預設地圖樣式
  String get defaultMapStyle => throw _privateConstructorUsedError;

  /// 偏好的旅行節奏
  String get travelPace => throw _privateConstructorUsedError;

  /// 偏好的預算範圍
  String get budgetRange => throw _privateConstructorUsedError;

  /// 偏好的旅行風格
  String get travelStyle => throw _privateConstructorUsedError;

  /// 是否啟用推播通知
  bool get enableNotifications => throw _privateConstructorUsedError;

  /// 是否啟用位置追蹤
  bool get enableLocationTracking => throw _privateConstructorUsedError;

  /// 是否啟用離線模式
  bool get enableOfflineMode => throw _privateConstructorUsedError;

  /// 是否自動同步
  bool get autoSync => throw _privateConstructorUsedError;

  /// 建立時間
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 更新時間
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserPreferencesCopyWith<UserPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPreferencesCopyWith<$Res> {
  factory $UserPreferencesCopyWith(
          UserPreferences value, $Res Function(UserPreferences) then) =
      _$UserPreferencesCopyWithImpl<$Res, UserPreferences>;
  @useResult
  $Res call(
      {String language,
      String theme,
      String defaultCurrency,
      String defaultMapStyle,
      String travelPace,
      String budgetRange,
      String travelStyle,
      bool enableNotifications,
      bool enableLocationTracking,
      bool enableOfflineMode,
      bool autoSync,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$UserPreferencesCopyWithImpl<$Res, $Val extends UserPreferences>
    implements $UserPreferencesCopyWith<$Res> {
  _$UserPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = null,
    Object? theme = null,
    Object? defaultCurrency = null,
    Object? defaultMapStyle = null,
    Object? travelPace = null,
    Object? budgetRange = null,
    Object? travelStyle = null,
    Object? enableNotifications = null,
    Object? enableLocationTracking = null,
    Object? enableOfflineMode = null,
    Object? autoSync = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      defaultCurrency: null == defaultCurrency
          ? _value.defaultCurrency
          : defaultCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      defaultMapStyle: null == defaultMapStyle
          ? _value.defaultMapStyle
          : defaultMapStyle // ignore: cast_nullable_to_non_nullable
              as String,
      travelPace: null == travelPace
          ? _value.travelPace
          : travelPace // ignore: cast_nullable_to_non_nullable
              as String,
      budgetRange: null == budgetRange
          ? _value.budgetRange
          : budgetRange // ignore: cast_nullable_to_non_nullable
              as String,
      travelStyle: null == travelStyle
          ? _value.travelStyle
          : travelStyle // ignore: cast_nullable_to_non_nullable
              as String,
      enableNotifications: null == enableNotifications
          ? _value.enableNotifications
          : enableNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      enableLocationTracking: null == enableLocationTracking
          ? _value.enableLocationTracking
          : enableLocationTracking // ignore: cast_nullable_to_non_nullable
              as bool,
      enableOfflineMode: null == enableOfflineMode
          ? _value.enableOfflineMode
          : enableOfflineMode // ignore: cast_nullable_to_non_nullable
              as bool,
      autoSync: null == autoSync
          ? _value.autoSync
          : autoSync // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserPreferencesImplCopyWith<$Res>
    implements $UserPreferencesCopyWith<$Res> {
  factory _$$UserPreferencesImplCopyWith(_$UserPreferencesImpl value,
          $Res Function(_$UserPreferencesImpl) then) =
      __$$UserPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String language,
      String theme,
      String defaultCurrency,
      String defaultMapStyle,
      String travelPace,
      String budgetRange,
      String travelStyle,
      bool enableNotifications,
      bool enableLocationTracking,
      bool enableOfflineMode,
      bool autoSync,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$UserPreferencesImplCopyWithImpl<$Res>
    extends _$UserPreferencesCopyWithImpl<$Res, _$UserPreferencesImpl>
    implements _$$UserPreferencesImplCopyWith<$Res> {
  __$$UserPreferencesImplCopyWithImpl(
      _$UserPreferencesImpl _value, $Res Function(_$UserPreferencesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = null,
    Object? theme = null,
    Object? defaultCurrency = null,
    Object? defaultMapStyle = null,
    Object? travelPace = null,
    Object? budgetRange = null,
    Object? travelStyle = null,
    Object? enableNotifications = null,
    Object? enableLocationTracking = null,
    Object? enableOfflineMode = null,
    Object? autoSync = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$UserPreferencesImpl(
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      defaultCurrency: null == defaultCurrency
          ? _value.defaultCurrency
          : defaultCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      defaultMapStyle: null == defaultMapStyle
          ? _value.defaultMapStyle
          : defaultMapStyle // ignore: cast_nullable_to_non_nullable
              as String,
      travelPace: null == travelPace
          ? _value.travelPace
          : travelPace // ignore: cast_nullable_to_non_nullable
              as String,
      budgetRange: null == budgetRange
          ? _value.budgetRange
          : budgetRange // ignore: cast_nullable_to_non_nullable
              as String,
      travelStyle: null == travelStyle
          ? _value.travelStyle
          : travelStyle // ignore: cast_nullable_to_non_nullable
              as String,
      enableNotifications: null == enableNotifications
          ? _value.enableNotifications
          : enableNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      enableLocationTracking: null == enableLocationTracking
          ? _value.enableLocationTracking
          : enableLocationTracking // ignore: cast_nullable_to_non_nullable
              as bool,
      enableOfflineMode: null == enableOfflineMode
          ? _value.enableOfflineMode
          : enableOfflineMode // ignore: cast_nullable_to_non_nullable
              as bool,
      autoSync: null == autoSync
          ? _value.autoSync
          : autoSync // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPreferencesImpl implements _UserPreferences {
  const _$UserPreferencesImpl(
      {this.language = 'zh-TW',
      this.theme = 'system',
      this.defaultCurrency = 'TWD',
      this.defaultMapStyle = 'standard',
      this.travelPace = 'moderate',
      this.budgetRange = 'medium',
      this.travelStyle = 'balanced',
      this.enableNotifications = true,
      this.enableLocationTracking = true,
      this.enableOfflineMode = true,
      this.autoSync = true,
      required this.createdAt,
      required this.updatedAt});

  factory _$UserPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPreferencesImplFromJson(json);

  /// 偏好的語言
  @override
  @JsonKey()
  final String language;

  /// 主題設定
  @override
  @JsonKey()
  final String theme;

  /// 預設貨幣
  @override
  @JsonKey()
  final String defaultCurrency;

  /// 預設地圖樣式
  @override
  @JsonKey()
  final String defaultMapStyle;

  /// 偏好的旅行節奏
  @override
  @JsonKey()
  final String travelPace;

  /// 偏好的預算範圍
  @override
  @JsonKey()
  final String budgetRange;

  /// 偏好的旅行風格
  @override
  @JsonKey()
  final String travelStyle;

  /// 是否啟用推播通知
  @override
  @JsonKey()
  final bool enableNotifications;

  /// 是否啟用位置追蹤
  @override
  @JsonKey()
  final bool enableLocationTracking;

  /// 是否啟用離線模式
  @override
  @JsonKey()
  final bool enableOfflineMode;

  /// 是否自動同步
  @override
  @JsonKey()
  final bool autoSync;

  /// 建立時間
  @override
  final DateTime createdAt;

  /// 更新時間
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UserPreferences(language: $language, theme: $theme, defaultCurrency: $defaultCurrency, defaultMapStyle: $defaultMapStyle, travelPace: $travelPace, budgetRange: $budgetRange, travelStyle: $travelStyle, enableNotifications: $enableNotifications, enableLocationTracking: $enableLocationTracking, enableOfflineMode: $enableOfflineMode, autoSync: $autoSync, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPreferencesImpl &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.defaultCurrency, defaultCurrency) ||
                other.defaultCurrency == defaultCurrency) &&
            (identical(other.defaultMapStyle, defaultMapStyle) ||
                other.defaultMapStyle == defaultMapStyle) &&
            (identical(other.travelPace, travelPace) ||
                other.travelPace == travelPace) &&
            (identical(other.budgetRange, budgetRange) ||
                other.budgetRange == budgetRange) &&
            (identical(other.travelStyle, travelStyle) ||
                other.travelStyle == travelStyle) &&
            (identical(other.enableNotifications, enableNotifications) ||
                other.enableNotifications == enableNotifications) &&
            (identical(other.enableLocationTracking, enableLocationTracking) ||
                other.enableLocationTracking == enableLocationTracking) &&
            (identical(other.enableOfflineMode, enableOfflineMode) ||
                other.enableOfflineMode == enableOfflineMode) &&
            (identical(other.autoSync, autoSync) ||
                other.autoSync == autoSync) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      language,
      theme,
      defaultCurrency,
      defaultMapStyle,
      travelPace,
      budgetRange,
      travelStyle,
      enableNotifications,
      enableLocationTracking,
      enableOfflineMode,
      autoSync,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      __$$UserPreferencesImplCopyWithImpl<_$UserPreferencesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPreferencesImplToJson(
      this,
    );
  }
}

abstract class _UserPreferences implements UserPreferences {
  const factory _UserPreferences(
      {final String language,
      final String theme,
      final String defaultCurrency,
      final String defaultMapStyle,
      final String travelPace,
      final String budgetRange,
      final String travelStyle,
      final bool enableNotifications,
      final bool enableLocationTracking,
      final bool enableOfflineMode,
      final bool autoSync,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$UserPreferencesImpl;

  factory _UserPreferences.fromJson(Map<String, dynamic> json) =
      _$UserPreferencesImpl.fromJson;

  @override

  /// 偏好的語言
  String get language;
  @override

  /// 主題設定
  String get theme;
  @override

  /// 預設貨幣
  String get defaultCurrency;
  @override

  /// 預設地圖樣式
  String get defaultMapStyle;
  @override

  /// 偏好的旅行節奏
  String get travelPace;
  @override

  /// 偏好的預算範圍
  String get budgetRange;
  @override

  /// 偏好的旅行風格
  String get travelStyle;
  @override

  /// 是否啟用推播通知
  bool get enableNotifications;
  @override

  /// 是否啟用位置追蹤
  bool get enableLocationTracking;
  @override

  /// 是否啟用離線模式
  bool get enableOfflineMode;
  @override

  /// 是否自動同步
  bool get autoSync;
  @override

  /// 建立時間
  DateTime get createdAt;
  @override

  /// 更新時間
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
