import 'package:desti_go/controllers/authorization_controller.dart';
import 'package:desti_go/models/user.dart';
import 'package:desti_go/repositories/authorization_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends StateNotifier<UserModel?> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(null);

  Future<UserModel?> signIn(String email, String password) async {
    state = await _authRepository.signIn(email, password);
    return state;
  }

  Future<UserModel?> register(String email, String password) async {
    state = await _authRepository.register(email, password);
    return state;
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    state = null;
  }
}

final authControllerProvider = Provider((ref) {
  final authNotifier = ref.watch(authProvider.notifier);
  return AuthController(authNotifier);
});

final authProvider = StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  return AuthNotifier(AuthRepository());
});
