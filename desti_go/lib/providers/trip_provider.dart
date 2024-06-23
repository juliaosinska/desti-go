import 'package:flutter/material.dart';
import 'package:desti_go/controllers/trip_controller.dart';
import 'package:provider/provider.dart';

class TripProvider extends StatelessWidget {
  final String userId;
  final Widget child;

  const TripProvider({required this.userId, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TripController>(
      create: (_) {
        final controller = TripController();
        controller.refreshTrips(userId); // Refresh trips when provider is initialized
        return controller;
      },
      child: child,
    );
  }
}




