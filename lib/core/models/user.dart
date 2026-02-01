import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
@HiveType(typeId: 15)
class User with _$User {
  const factory User({
    @HiveField(0) required String id,
    @HiveField(1) required String email,
    @HiveField(2) required String name,
    @HiveField(3) String? googleId,
    @HiveField(4) String? avatarUrl,
    @HiveField(5) @Default(false) bool isGuest,
    @HiveField(6) DateTime? createdAt,
    @HiveField(7) DateTime? updatedAt,
    @HiveField(8) DateTime? lastSyncAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  
  /// Create a guest user
  factory User.guest() => User(
    id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
    email: '',
    name: 'Guest User',
    isGuest: true,
    createdAt: DateTime.now(),
  );
}