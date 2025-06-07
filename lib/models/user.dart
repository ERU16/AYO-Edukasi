import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String passwordHash;

  @HiveField(2)
  String? profileImage;

  @HiveField(3)
  String? gender;

  @HiveField(4)
  int? age;

  @HiveField(5)
  String? description;

  User({
    required this.username,
    required this.passwordHash,
    this.profileImage,
    this.gender,
    this.age,
    this.description,
  });
}
