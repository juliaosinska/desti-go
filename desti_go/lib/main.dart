import 'package:desti_go/add_trip_screen.dart';
import 'package:desti_go/diary_screen.dart';
import 'package:desti_go/firebase_options.dart';
import 'package:desti_go/views/authorization/login_screen.dart';
import 'package:desti_go/logo_screen.dart';
import 'package:desti_go/plan_screen.dart';
import 'package:desti_go/views/authorization/register_screen.dart';
import 'package:desti_go/trip_details_screen.dart';
import 'package:desti_go/trips_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LogoScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/trips': (context) => TripsScreen(),
        '/trips-details': (context) => TripDetailsScreen(),
        '/add-trip': (context) => AddTripScreen(),
        '/plan': (context) => PlanScreen(),
        '/diary': (context) => DiaryScreen()
      },
    );
  }
}