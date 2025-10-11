import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:translation_project/models/user_model.dart';
import 'package:translation_project/repository/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(AuthInitial()) {
    // Gerçek bir uygulamada burada kayıtlı bir oturum token'ı kontrol edilir.
    // Bu örnek için kimlik doğrulanmamış olarak başlıyoruz.
    emit(Unauthenticated());
  }

  final AuthRepository _authRepository;

  // Basit bir login fonksiyonu. Gerçek bir projede burada API'ye istek atılır.
  Future<void> loginUser(String email, String password) async {
    try {
      final user = await _authRepository.login(email: email, password: password);
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
      // Hata sonrası kimlik doğrulanmamış duruma geri dönmek,
      // BlocListener'ın tekrar tetiklenmesini engeller.
      emit(Unauthenticated());
    }
  }

  // Basit bir signup fonksiyonu.
  Future<void> signUpUser(String email, String password) async {
    try {
      final user =
          await _authRepository.signUp(email: email, password: password);
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
      emit(Unauthenticated());
    }
  }

  void logout() {
    emit(Unauthenticated());
  }
}
