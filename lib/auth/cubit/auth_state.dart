part of 'auth_cubit.dart';



// AuthState'i tanımlıyoruz. equatable ile state'lerin karşılaştırılmasını kolaylaştırıyoruz.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Başlangıç durumu
class AuthInitial extends AuthState {}

// Kullanıcı giriş yapmış durumu
class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

// Kullanıcı giriş yapmamış durumu
class Unauthenticated extends AuthState {}

// Hata durumu
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
