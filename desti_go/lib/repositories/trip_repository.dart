import 'package:desti_go/models/trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TripRepository {
  final CollectionReference _tripsCollection =
      FirebaseFirestore.instance.collection('trips');

  Future<void> addTrip(Trip trip) async {
    try {
      // Use set method instead of add to set the document with a custom ID
      await _tripsCollection.doc(trip.id).set({
        'userId': trip.userId,
        'destination': trip.destination,
        'departureDate': trip.departureDate,
        'returnDate': trip.returnDate,
      });
    } catch (e) {
      print('Error adding trip: $e');
      throw e;
    }
  }

  Future<List<Trip>> getTripsForUser(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _tripsCollection
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Trip(
          id: doc.id,
          userId: data['userId'],
          destination: data['destination'],
          departureDate: (data['departureDate'] as Timestamp).toDate(),
          returnDate: (data['returnDate'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      print('Error getting trips: $e');
      throw e;
    }
  }

   Future<void> deleteTrip(String tripId) async {
    try {
      await _tripsCollection.doc(tripId).delete();
      print('Trip deleted successfully');
    } catch (e) {
      print('Error deleting trip: $e');
      throw e;
    }
  }
}


