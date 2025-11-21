

import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({required this.email, required this.password, this.score = 0});

  final String email;
  // ÖNEMLİ: Gerçek bir uygulamada şifreler asla bu şekilde düz metin olarak
  // tutulmamalıdır. Mutlaka hash'lenerek (bcrypt, argon2 gibi) saklanmalıdır.
  final String password;
  final int score;

  @override
  List<Object> get props => [email, password, score];

  String get rank {
    if (score >= 70) {
      return 'Uzman';
    } else if (score >= 50) {
      return 'Profesyonel';
    } else if (score >= 30) {
      return 'Amatör';
    } else {
      return 'Acemi';
    }
  }

  User copyWith({String? email, String? password, int? score}) {
    return User(
      email: email ?? this.email,
      password: password ?? this.password,
      score: score ?? this.score,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
    email: json['email'] as String,
    password: json['password'] as String,
    score: json['score'] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'score': score,
  };
}
