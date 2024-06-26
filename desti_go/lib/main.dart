import 'package:desti_go/controllers/trip_controller.dart';
import 'package:desti_go/repositories/trip_repository.dart';
import 'package:desti_go/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:desti_go/firebase_options.dart';
import 'package:desti_go/controllers/authorization_controller.dart' as myAuthController;
import 'package:desti_go/providers/authorization_provider.dart';
import 'package:desti_go/providers/trip_provider.dart';
import 'package:desti_go/controllers/place_controller.dart';
import 'package:desti_go/providers/place_provider.dart';
import 'package:desti_go/repositories/place_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: "assets/.env"); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PlaceRepository placeRepository = PlaceRepository();
    final GooglePlace googlePlace = GooglePlace(dotenv.env['GOOGLE_PLACES_API_KEY']!);
    final PlaceController placeController = PlaceController(placeRepository: placeRepository, googlePlace: googlePlace);
    final TripRepository tripRepository = TripRepository();
    final TripController tripController = TripController(tripRepository: tripRepository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TripProvider(tripController: tripController)),
        ChangeNotifierProvider(create: (_) => PlaceProvider(placeController: placeController)),
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
            initialRoute: Routes.initialRoute,
            routes: Routes.routes(context, authController), // Using Routes class for defining routes
          );
        },
      ),
    );
  }
}

