import 'package:desti_go/models/trip.dart';
import 'package:desti_go/repositories/trip_repository.dart';

class TripController {
  final TripRepository tripRepository;

  TripController({required this.tripRepository});

  Future<String> addTrip(Trip trip) async {
    try {
      return await tripRepository.addTrip(trip);
    } catch (error) {
      print('Error adding trip: $error');
      rethrow;
    }
  }

  Future<List<Trip>> getTrips(String userId) async {
    try {
      return await tripRepository.getTripsForUser(userId);
    } catch (error) {
      print('Error getting trips: $error');
      rethrow;
    }
  }

  Future<void> deleteTrip(String tripId) async {
    try {
      await tripRepository.deleteTrip(tripId);
    } catch (error) {
      print('Error deleting trip: $error');
      rethrow;
    }
  }
}
