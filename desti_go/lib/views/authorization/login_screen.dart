import 'package:desti_go/controllers/authorization_controller.dart';
import 'package:desti_go/models/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  final AuthController _authController = AuthController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 97, 64, 187),
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome!',
                style: TextStyle(fontSize: 70.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'Please, enter your e-mail.',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.input_rounded),
                  filled: true,
                  fillColor: Color.fromARGB(255, 235, 227, 242),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Please enter your password.',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.input_rounded),
                  filled: true,
                  fillColor: Color.fromARGB(255, 235, 227, 242),
                ),
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () async {
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();
                  try {
                    UserModel? user = await _authController.signIn(email, password);
                    if (user != null) {
                      Navigator.pushNamed(context, '/trips');
                    }
                  } on FirebaseAuthException catch (e) {
                    switch (e.code) {
                      case 'user-not-found':
                        _showError(context, 'No user found for that email.');
                        break;
                      case 'wrong-password':
                        _showError(context, 'Wrong password provided.');
                        break;
                      case 'invalid-email':
                        _showError(context, 'The email address is badly formatted.');
                        break;
                      case 'user-disabled':
                        _showError(context, 'The user account has been disabled by an administrator.');
                        break;
                      default:
                        _showError(context, 'An unknown error occurred.');
                    }
                  } catch (e) {
                    _showError(context, 'An unknown error occurred.');
                  }
                },
                child: Text(
                  'LOG IN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  backgroundColor: Color.fromARGB(255, 97, 64, 187),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 10.0,
                  shadowColor: Colors.black.withOpacity(1),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Are you new here?'),
                  SizedBox(width: 8.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text('Register now'),
                    style: TextButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 97, 64, 187),
                      backgroundColor: Color.fromARGB(255, 196, 188, 238),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
