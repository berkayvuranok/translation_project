import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translation_project/models/user_model.dart';

class AuthRepository {
  static const String _usersKey = 'users';

  Future<List<User>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) {
      return [];
    }
    final List<dynamic> usersList = jsonDecode(usersJson);
    return usersList.map((json) => User.fromJson(json)).toList();
  }

  Future<void> _saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = jsonEncode(users.map((user) => user.toJson()).toList());
    await prefs.setString(_usersKey, usersJson);
  }

  Future<User> signUp({required String email, required String password}) async {
    final users = await _getUsers();
    if (users.any((user) => user.email == email)) {
      throw Exception('Bu e-posta adresi zaten kullanılıyor.');
    }
    final newUser = User(email: email, password: password);
    users.add(newUser);
    await _saveUsers(users);
    return newUser;
  }

  Future<User> login({required String email, required String password}) async {
    final users = await _getUsers();
    return users.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () => throw Exception('E-posta veya şifre hatalı.'),
    );
  }

  Future<void> updateUserHighScore({required String email, required int score}) async {
    final users = await _getUsers();
    final userIndex = users.indexWhere((user) => user.email == email);
    if (userIndex != -1) {
      final user = users[userIndex];
      if (score > user.highScore) {
        users[userIndex] = user.copyWith(highScore: score);
        await _saveUsers(users);
      }
    }
  }

  Future<int> getUserHighScore({required String email}) async {
    final users = await _getUsers();
    final user = users.firstWhere((user) => user.email == email,
        orElse: () => throw Exception('Kullanıcı bulunamadı.'));
    return user.highScore;
  }
}