import 'package:desti_go/models/trip.dart';
import 'package:flutter/material.dart';
import 'package:desti_go/controllers/authorization_controller.dart' as myAuthController;
import 'package:desti_go/views/logo/logo_screen.dart';
import 'package:desti_go/views/authorization/login_screen.dart';
import 'package:desti_go/views/authorization/register_screen.dart';
import 'package:desti_go/views/trips_managment/trips_screen.dart';
import 'package:desti_go/views/trips_managment/trip_details_screen.dart';
import 'package:desti_go/views/trips_managment/add_trip_screen.dart';
import 'package:desti_go/views/plan/plan_screen.dart';
import 'package:desti_go/views/diary/diary_screen.dart';
import 'package:desti_go/views/day_plan/day_plan_screen.dart';
import 'package:desti_go/views/day_plan/explore_screen.dart';

class Routes {
  static const String initialRoute = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String trips = '/trips';
  static const String tripDetails = '/trip-details';
  static const String addTrip = '/add-trip';
  static const String plan = '/plan';
  static const String diary = '/diary';
  static const String dayPlan = '/day-plan';
  static const String explore = '/explore';
  static const String dayDiary = '/day-diary';
  static const String addEntry = '/add-entry';

  static Map<String, WidgetBuilder> routes(BuildContext context, myAuthController.AuthController authController) {
    return {
      initialRoute: (context) => LogoScreen(),
      login: (context) => LoginScreen(authController: authController),
      register: (context) => RegisterScreen(authController: authController),
      trips: (context) => TripsScreen(),
      tripDetails: (context) {
        final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        final trip = arguments['trip'] as Trip; // Adjust the type according to your needs
        return TripDetailsScreen(trip: trip);
      },
      addTrip: (context) => AddTripScreen(),
      plan: (context) {
        final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        final trip = arguments['trip'] as Trip; // Adjust the type according to your needs
        return PlanScreen(trip: trip);
      },
      diary: (context) {
        final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        final trip = arguments['trip'] as Trip; // Adjust the type according to your needs
        return DiaryScreen(trip: trip);
      },
      dayPlan: (context) {
        final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        final tripId = arguments['tripId'] as String;
        final day = arguments['day'] as DateTime;
        final formattedDate = arguments['formattedDate'] as String;
        return DayPlanScreen(tripId: tripId, day: day, formattedDate: formattedDate);
      },
      explore: (context) {
        final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        final tripId = arguments['tripId'] as String;
        final day = arguments['day'] as DateTime;
        return ExploreScreen(tripId: tripId, day: day);
      },
      //dayDiary: (context) => DayDiaryScreen(),
      //addEntry: (context) => AddEntryScreen(),
    };
  }
}
