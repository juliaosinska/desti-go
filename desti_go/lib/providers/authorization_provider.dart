import 'package:flutter/material.dart';
import 'package:desti_go/models/user.dart';
import 'package:desti_go/repositories/authorization_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  UserModel? _user;

  UserModel? get user => _user;

  Future<UserModel?> signIn(String email, String password) async {
    _user = await _authRepository.signIn(email, password);
    notifyListeners();
    return _user;
  }

  Future<UserModel?> register(String email, String password) async {
    _user = await _authRepository.register(email, password);
    notifyListeners();
    return _user;
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    _user = null;
    notifyListeners();
  }
}
