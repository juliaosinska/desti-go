import 'package:desti_go/models/user.dart';
import 'package:desti_go/providers/authorization_provider.dart';

class AuthController {
  final AuthProvider authProvider;

  AuthController({required this.authProvider});

  Future<UserModel?> signIn(String email, String password) async {
    return await authProvider.signIn(email, password);
  }

  Future<UserModel?> register(String email, String password) async {
    return await authProvider.register(email, password);
  }

  Future<void> signOut() async {
    await authProvider.signOut();
  }
}
