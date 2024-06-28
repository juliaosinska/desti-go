import 'package:desti_go/models/trip.dart';

class TripState {
  final List<Trip> trips;
  final bool isLoading;
  final String error;

  TripState({
    required this.trips,
    required this.isLoading,
    required this.error,
  });
}