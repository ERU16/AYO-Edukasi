import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/user.dart';
import '../helpers/encryption_helper.dart';

class AuthService {
  static const String userBoxName = "users";

  static Future<void> registerUser(String username, String password) async {
    final box = await Hive.openBox<User>(userBoxName);
    if (box.containsKey(username)) throw Exception("User already exists.");

    final hashedPassword = hashPassword(password);
    final user = User(username: username, passwordHash: hashedPassword);

    await box.put(username, user);
    if (kDebugMode) {
      print('User registered: $username');
    }
  }

  static Future<bool> loginUser(String username, String password) async {
    final box = await Hive.openBox<User>(userBoxName);
    final user = box.get(username);

    if (user == null) return false;

    final hashedPassword = hashPassword(password);
    return user.passwordHash == hashedPassword;
  }
}
