import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desti_go/models/trip.dart';

class TripRepository {
  final CollectionReference _tripsCollection =
      FirebaseFirestore.instance.collection('trips');

  Future<String> addTrip(Trip trip) async {
    try {
      final DocumentReference tripRef = await _tripsCollection.add({
        'userId': trip.userId,
        'destination': trip.destination,
        'departureDate': trip.departureDate,
        'returnDate': trip.returnDate,
        'isDeleted': trip.isDeleted,
      });
      return tripRef.id;
    } catch (e) {
      print('Error adding trip: $e');
      throw e;
    }
  }

  Future<List<Trip>> getTripsForUser(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _tripsCollection
          .where('userId', isEqualTo: userId)
          .where('isDeleted', isEqualTo: false)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Trip(
          id: doc.id,
          userId: data['userId'],
          destination: data['destination'],
          departureDate: (data['departureDate'] as Timestamp).toDate(),
          returnDate: (data['returnDate'] as Timestamp).toDate(),
          isDeleted: data['isDeleted'] ?? false,
        );
      }).toList();
    } catch (e) {
      print('Error getting trips: $e');
      throw e;
    }
  }

  Future<void> deleteTrip(String tripId) async {
    try {
      await _tripsCollection.doc(tripId).update({
        'isDeleted': true,
      });
      print('Trip deleted successfully');
    } catch (e) {
      print('Error deleting trip: $e');
      throw e;
    }
  }
}
