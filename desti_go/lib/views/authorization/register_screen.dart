import 'package:desti_go/controllers/authorization_controller.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';

class RegisterScreen extends StatelessWidget {
  final AuthController _authController = AuthController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
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
                'Nice to meet you!',
                style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
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
                  UserModel? user = await _authController.register(email, password);
                  if (user != null) {
                    Navigator.pushNamed(context, '/trips');
                  }
                },
                child: Text(
                  'REGISTER',
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
            ],
          ),
        ),
      ),
    );
  }
}