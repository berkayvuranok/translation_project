import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(Unauthenticated()); // Başlangıçta kullanıcı giriş yapmamış

  // Basit bir login fonksiyonu. Gerçek bir projede burada API'ye istek atılır.
  void login(String username, String password) {
    // Şimdilik her girişi başarılı kabul edelim
    if (username.isNotEmpty && password.isNotEmpty) {
      emit(Authenticated(username));
    }
  }

  // Basit bir signup fonksiyonu.
  void signup(String username, String password) {
    if (username.isNotEmpty && password.isNotEmpty) {
      emit(Authenticated(username));
    }
  }

  void logout() {
    emit(Unauthenticated());
  }
}
