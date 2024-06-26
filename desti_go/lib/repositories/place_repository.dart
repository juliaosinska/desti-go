import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desti_go/models/place.dart';
import 'package:intl/intl.dart';

class PlaceRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> addPlaceToDay(String tripId, DateTime day, Place place) async {
    try {
      final String dayId = DateFormat('yyyy-MM-dd').format(day);
      final DocumentReference tripRef = firestore.collection('trips').doc(tripId);
      final CollectionReference dayPlacesRef = tripRef.collection('days').doc(dayId).collection('places');
      final docRef = await dayPlacesRef.add(place.toMap());
      return docRef.id; // Return the document ID
    } catch (error) {
      print('Error adding place to day: $error');
      rethrow;
    }
  }

  Future<List<Place>> getPlacesForDay(String tripId, DateTime day) async {
    try {
      final String dayId = DateFormat('yyyy-MM-dd').format(day);
      final DocumentReference tripRef = firestore.collection('trips').doc(tripId);
      final CollectionReference dayPlacesRef = tripRef.collection('days').doc(dayId).collection('places');
      final QuerySnapshot snapshot = await dayPlacesRef.get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => Place.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (error) {
      print('Error getting places for day: $error');
      rethrow;
    }
  }

  Future<void> deletePlaceFromDay(String tripId, DateTime day, String placeId) async {
    try {
      final String dayId = DateFormat('yyyy-MM-dd').format(day);
      final DocumentReference tripRef = firestore.collection('trips').doc(tripId);
      final CollectionReference dayPlacesRef = tripRef.collection('days').doc(dayId).collection('places');
      await dayPlacesRef.doc(placeId).delete();
    } catch (error) {
      print('Error deleting place from day: $error');
      rethrow;
    }
  }
}