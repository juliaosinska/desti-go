import 'package:flutter/material.dart';
import 'package:desti_go/controllers/trip_controller.dart';
import 'package:desti_go/models/trip.dart';

class TripProvider with ChangeNotifier {
  final TripController tripController;
  List<Trip> _trips = [];
  bool _isLoading = false;
  String _error = '';

  TripProvider({required this.tripController});

  List<Trip> get trips => _trips;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchTrips(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      _trips = await tripController.getTrips(userId);

      _error = ''; // Reset error message if trips are successfully loaded
    } catch (e) {
      _error = 'Error loading trips: $e';
      _trips = []; // Clear trips in case of error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTrip(String userId, String destination, DateTime departureDate, DateTime returnDate) async {
    try {
      String tripId = await tripController.addTrip(Trip(
        userId: userId,
        destination: destination,
        departureDate: departureDate,
        returnDate: returnDate,
        isDeleted: false,
      ));
      _trips.add(Trip(
        id: tripId,
        userId: userId,
        destination: destination,
        departureDate: departureDate,
        returnDate: returnDate,
        isDeleted: false,
      ));
      notifyListeners();
    } catch (e) {
      print('Error adding trip: $e');
      rethrow;
    }
  }

  Future<void> deleteTrip(String tripId, String userId) async {
    try {
      await tripController.deleteTrip(tripId);
      _trips.removeWhere((trip) => trip.id == tripId);
      notifyListeners();
    } catch (e) {
      print('Error deleting trip: $e');
      rethrow;
    }
  }
}

