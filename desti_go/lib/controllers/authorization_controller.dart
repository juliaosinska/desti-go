import 'package:desti_go/models/user.dart';
import 'package:desti_go/repositories/authorization_repository.dart';

class AuthController {
  final AuthRepository _authRepository = AuthRepository();

  Future<UserModel?> signIn(String email, String password) async {
    return await _authRepository.signIn(email, password);
  }

  Future<UserModel?> register(String email, String password) async {
    return await _authRepository.register(email, password);
  }

  Future<void> signOut() async {
    return await _authRepository.signOut();
  }
}
