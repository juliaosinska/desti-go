import 'package:desti_go/models/trip_state.dart';
import 'package:desti_go/repositories/trip_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desti_go/controllers/trip_controller.dart';
import 'package:desti_go/models/trip.dart';

class TripNotifier extends StateNotifier<TripState> {
  final TripController tripController;

  TripNotifier(this.tripController)
      : super(TripState(
          trips: [],
          isLoading: true,
          error: '',
        ));

  Future<void> fetchTrips(String userId) async {
    try {
      //state = TripState(trips: state.trips, isLoading: true, error: '');
      final fetchedTrips = await tripController.getTrips(userId);
      state = TripState(trips: fetchedTrips, isLoading: false, error: '');
    } catch (e) {
      state = TripState(trips: [], isLoading: false, error: 'Error loading trips: $e');
    }
  }

  Future<void> addTrip(String userId, String destination, DateTime departureDate, DateTime returnDate) async {
    try {
      final tripId = await tripController.addTrip(Trip(
        userId: userId,
        destination: destination,
        departureDate: departureDate,
        returnDate: returnDate,
        isDeleted: false,
      ));
      final newTrip = Trip(
        id: tripId,
        userId: userId,
        destination: destination,
        departureDate: departureDate,
        returnDate: returnDate,
        isDeleted: false,
      );
      state = TripState(trips: [...state.trips, newTrip], isLoading: false, error: '');
    } catch (e) {
      state = TripState(trips: state.trips, isLoading: false, error: 'Error adding trip: $e');
    }
  }

  Future<void> deleteTrip(String tripId) async {
    try {
      await tripController.deleteTrip(tripId);
      state = TripState(trips: state.trips.where((trip) => trip.id != tripId).toList(), isLoading: false, error: '');
    } catch (e) {
      state = TripState(trips: state.trips, isLoading: false, error: 'Error deleting trip: $e');
    }
  }
}

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  return TripRepository();
});

final tripControllerProvider = Provider((ref) {
  final tripRepository = ref.watch(tripRepositoryProvider);
  return TripController(tripRepository: tripRepository);
});

final tripProvider = StateNotifierProvider<TripNotifier, TripState>((ref) {
  return TripNotifier(TripController(
    tripRepository: TripRepository(),
  ));
});
