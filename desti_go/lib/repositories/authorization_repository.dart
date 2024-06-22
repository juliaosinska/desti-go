import 'package:desti_go/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user != null ? UserModel(uid: user.uid, email: user.email) : null;
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw Exception('Unknown error occurred');
    }
  }

  Future<UserModel?> register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user != null ? UserModel(uid: user.uid, email: user.email) : null;
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw Exception('Unknown error occurred');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw e;
    }
  }
}
