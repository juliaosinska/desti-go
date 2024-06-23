import 'package:desti_go/models/trip.dart';
import 'package:desti_go/repositories/trip_repository.dart';
import 'package:flutter/foundation.dart';

class TripController extends ChangeNotifier {
  final TripRepository _tripRepository = TripRepository();
  List<Trip> _trips = [];

  List<Trip> get trips => _trips;

  Future<void> addTrip(String userId, String destination, DateTime departureDate, DateTime returnDate) async {
    try {
      Trip trip = Trip(
        userId: userId,
        destination: destination,
        departureDate: departureDate,
        returnDate: returnDate,
      );
      await _tripRepository.addTrip(trip);
      print('Trip added successfully');
      await refreshTrips(userId); // Refresh trips after adding a new one
    } catch (e) {
      print('Error adding trip: $e');
      throw e;
    }
  }

  Future<void> refreshTrips(String userId) async {
    try {
      _trips = await _tripRepository.getTripsForUser(userId);
      print('Trips refreshed: ${_trips.length} trips found');
      notifyListeners();
    } catch (e) {
      print('Error refreshing trips: $e');
      throw e;
    }
  }

  Future<void> deleteTrip(String tripId, String userId) async {
    try {
      await _tripRepository.deleteTrip(tripId);
      print('Trip deleted successfully');
      await refreshTrips(userId); // Refresh trips after deleting one
    } catch (e) {
      print('Error deleting trip: $e');
      throw e;
    }
  }
}
