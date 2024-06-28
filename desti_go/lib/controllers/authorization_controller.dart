import 'package:desti_go/models/user.dart';
import 'package:desti_go/providers/authorization_provider.dart';

class AuthController {
  final AuthNotifier authNotifier;

  AuthController(this.authNotifier);

  Future<UserModel?> signIn(String email, String password) async {
    try {
      await authNotifier.signIn(email, password);
      return authNotifier.state;
    } catch (e) {
      throw e;
    }
  }

  Future<UserModel?> register(String email, String password) async {
    try {
      await authNotifier.register(email, password);
      return authNotifier.state;
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await authNotifier.signOut();
  }
}
