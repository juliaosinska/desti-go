import 'package:desti_go/controllers/trip_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:desti_go/firebase_options.dart';
import 'package:desti_go/controllers/authorization_controller.dart' as myAuthController;
import 'package:desti_go/providers/authorization_provider.dart';
import 'package:desti_go/providers/trip_provider.dart'; // Import TripProvider
import 'package:desti_go/views/authorization/login_screen.dart';
import 'package:desti_go/views/authorization/register_screen.dart';
import 'package:desti_go/logo_screen.dart';
import 'package:desti_go/views/trips_managment/trips_screen.dart';
import 'package:desti_go/trip_details_screen.dart';
import 'package:desti_go/views/trips_managment/add_trip_screen.dart';
import 'package:desti_go/plan_screen.dart';
import 'package:desti_go/diary_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TripController()), // Provide TripController
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final authController = myAuthController.AuthController(authProvider: authProvider);

          return MaterialApp(
            title: 'Your App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              '/': (context) => LogoScreen(),
              '/login': (context) => LoginScreen(authController: authController),
              '/register': (context) => RegisterScreen(authController: authController),
              '/trips': (context) => TripsScreen(),
              //'/trip-details': (context) => TripDetailsScreen(trip: ,),
              '/add-trip': (context) => AddTripScreen(),
              '/plan': (context) => PlanScreen(),
              '/diary': (context) => DiaryScreen(),
            },
          );
        },
      ),
    );
  }
}
