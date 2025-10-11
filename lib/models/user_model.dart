

import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({required this.email, required this.password, this.highScore = 0});

  final String email;
  // ÖNEMLİ: Gerçek bir uygulamada şifreler asla bu şekilde düz metin olarak
  // tutulmamalıdır. Mutlaka hash'lenerek (bcrypt, argon2 gibi) saklanmalıdır.
  final String password;
  final int highScore;

  @override
  List<Object> get props => [email, password, highScore];

  User copyWith({String? email, String? password, int? highScore}) {
    return User(
      email: email ?? this.email,
      password: password ?? this.password,
      highScore: highScore ?? this.highScore,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
    email: json['email'] as String,
    password: json['password'] as String,
    highScore: json['highScore'] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'highScore': highScore,
  };
}
