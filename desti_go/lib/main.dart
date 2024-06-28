import 'package:desti_go/controllers/authorization_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes.dart';
import 'firebase_options.dart';
import 'providers/authorization_provider.dart';
import 'repositories/authorization_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: "assets/.env");

  final authRepository = AuthRepository();
  final authNotifier = AuthNotifier(authRepository);
  final authController = AuthController(authNotifier);

  runApp(ProviderScope(
    child: MyApp(authController: authController),
  ));
}

class MyApp extends StatelessWidget {
  final AuthController authController;

  MyApp({required this.authController});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.initialRoute,
      routes: Routes.routes(context, authController),
    );
  }
}
