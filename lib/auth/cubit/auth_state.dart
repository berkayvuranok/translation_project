part of 'auth_cubit.dart';

// AuthState'i tanımlıyoruz. equatable ile state'lerin karşılaştırılmasını kolaylaştırıyoruz.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

// Başlangıç durumu
class AuthInitial extends AuthState {}

// Kullanıcı giriş yapmış durumu
class Authenticated extends AuthState {
  final String username;

  const Authenticated(this.username);

  @override
  List<Object> get props => [username];
}

// Kullanıcı giriş yapmamış durumu
class Unauthenticated extends AuthState {}
