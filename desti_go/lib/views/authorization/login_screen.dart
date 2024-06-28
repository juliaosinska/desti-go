import 'package:desti_go/providers/authorization_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desti_go/models/user.dart';

class LoginScreen extends ConsumerWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //error message snackbar
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //watcher to observe changes
    final authNotifier = ref.watch(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 97, 64, 187),
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
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
              const Text(
                'Welcome!',
                style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40.0),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'Please, enter your e-mail.',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.input_rounded),
                  filled: true,
                  fillColor: Color.fromARGB(255, 235, 227, 242),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Please enter your password.',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.input_rounded),
                  filled: true,
                  fillColor: Color.fromARGB(255, 235, 227, 242),
                ),
              ),
              const SizedBox(height: 40.0),
              //logging in with the credentials provided in text controllers
              ElevatedButton(
                onPressed: () async {
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();
                  
                  try {
                    UserModel? user = await authNotifier.signIn(email, password);
                    
                    if (user != null) {
                      Navigator.pushNamed(context, '/trips');
                    }
                  } catch (e) {
                    //handling firebase errors
                    String errorMessage = 'An error occurred. Please try again later.';
                    if (e is FirebaseAuthException) {
                      switch (e.code) {
                        case 'user-not-found':
                          errorMessage = 'No user found for that email.';
                          break;
                        case 'wrong-password':
                          errorMessage = 'Wrong password provided.';
                          break;
                        case 'invalid-email':
                          errorMessage = 'The email address is badly formatted.';
                          break;
                        case 'user-disabled':
                          errorMessage = 'The user account has been disabled by an administrator.';
                          break;
                        default:
                          errorMessage = 'Authentication failed. ${e.message}';
                          break;
                      }
                    }
                    _showError(context, errorMessage);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  backgroundColor: const Color.fromARGB(255, 97, 64, 187),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 10.0,
                  shadowColor: Colors.black.withOpacity(1),
                ),
                child: const Text(
                  'LOG IN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Are you new here?'),
                  const SizedBox(width: 8.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 97, 64, 187),
                      backgroundColor: const Color.fromARGB(255, 196, 188, 238),
                    ),
                    child: const Text('Register now'),
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
