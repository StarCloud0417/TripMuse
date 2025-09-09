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
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  bool get isGuest => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get googleId => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;

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
      bool isGuest,
      DateTime createdAt,
      DateTime updatedAt,
      String? googleId,
      String? avatarUrl});
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
    Object? isGuest = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? googleId = freezed,
    Object? avatarUrl = freezed,
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
      googleId: freezed == googleId
          ? _value.googleId
          : googleId // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
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
      bool isGuest,
      DateTime createdAt,
      DateTime updatedAt,
      String? googleId,
      String? avatarUrl});
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
    Object? isGuest = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? googleId = freezed,
    Object? avatarUrl = freezed,
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
      googleId: freezed == googleId
          ? _value.googleId
          : googleId // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
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
      required this.isGuest,
      required this.createdAt,
      required this.updatedAt,
      this.googleId,
      this.avatarUrl});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  final bool isGuest;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? googleId;
  @override
  final String? avatarUrl;

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, isGuest: $isGuest, createdAt: $createdAt, updatedAt: $updatedAt, googleId: $googleId, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.isGuest, isGuest) || other.isGuest == isGuest) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.googleId, googleId) ||
                other.googleId == googleId) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, email, isGuest,
      createdAt, updatedAt, googleId, avatarUrl);

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
      required final bool isGuest,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? googleId,
      final String? avatarUrl}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get email;
  @override
  bool get isGuest;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get googleId;
  @override
  String? get avatarUrl;
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
  String get language => throw _privateConstructorUsedError;
  String get theme => throw _privateConstructorUsedError;
  String get defaultCurrency => throw _privateConstructorUsedError;
  String get defaultMapStyle => throw _privateConstructorUsedError;
  bool get enableNotifications => throw _privateConstructorUsedError;
  bool get enableLocationTracking => throw _privateConstructorUsedError;
  bool get enableOfflineMode => throw _privateConstructorUsedError;
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
      bool enableNotifications,
      bool enableLocationTracking,
      bool enableOfflineMode,
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
    Object? enableNotifications = null,
    Object? enableLocationTracking = null,
    Object? enableOfflineMode = null,
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
      bool enableNotifications,
      bool enableLocationTracking,
      bool enableOfflineMode,
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
    Object? enableNotifications = null,
    Object? enableLocationTracking = null,
    Object? enableOfflineMode = null,
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
      {required this.language,
      required this.theme,
      required this.defaultCurrency,
      required this.defaultMapStyle,
      required this.enableNotifications,
      required this.enableLocationTracking,
      required this.enableOfflineMode,
      required this.updatedAt});

  factory _$UserPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPreferencesImplFromJson(json);

  @override
  final String language;
  @override
  final String theme;
  @override
  final String defaultCurrency;
  @override
  final String defaultMapStyle;
  @override
  final bool enableNotifications;
  @override
  final bool enableLocationTracking;
  @override
  final bool enableOfflineMode;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UserPreferences(language: $language, theme: $theme, defaultCurrency: $defaultCurrency, defaultMapStyle: $defaultMapStyle, enableNotifications: $enableNotifications, enableLocationTracking: $enableLocationTracking, enableOfflineMode: $enableOfflineMode, updatedAt: $updatedAt)';
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
            (identical(other.enableNotifications, enableNotifications) ||
                other.enableNotifications == enableNotifications) &&
            (identical(other.enableLocationTracking, enableLocationTracking) ||
                other.enableLocationTracking == enableLocationTracking) &&
            (identical(other.enableOfflineMode, enableOfflineMode) ||
                other.enableOfflineMode == enableOfflineMode) &&
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
      enableNotifications,
      enableLocationTracking,
      enableOfflineMode,
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
      {required final String language,
      required final String theme,
      required final String defaultCurrency,
      required final String defaultMapStyle,
      required final bool enableNotifications,
      required final bool enableLocationTracking,
      required final bool enableOfflineMode,
      required final DateTime updatedAt}) = _$UserPreferencesImpl;

  factory _UserPreferences.fromJson(Map<String, dynamic> json) =
      _$UserPreferencesImpl.fromJson;

  @override
  String get language;
  @override
  String get theme;
  @override
  String get defaultCurrency;
  @override
  String get defaultMapStyle;
  @override
  bool get enableNotifications;
  @override
  bool get enableLocationTracking;
  @override
  bool get enableOfflineMode;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
