import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desti_go/models/diary_entry.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class DiaryRepository {
  final CollectionReference _tripsCollection = FirebaseFirestore.instance.collection('trips');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addDiaryEntry(String tripId, DateTime date, {String? text, String? imageURL}) async {
    try {
      String dayId = DateFormat('yyyy-MM-dd').format(date);
      await _tripsCollection
          .doc(tripId)
          .collection('days')
          .doc(dayId)
          .collection('diaries')
          .add({
        'text': text,
        'imageURL': imageURL,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print('Error adding diary entry: $e');
      throw e;
    }
  }

  Future<List<DiaryEntry>> getDiaryEntries(String tripId, DateTime date) async {
    try {
      String dayId = DateFormat('yyyy-MM-dd').format(date);
      QuerySnapshot querySnapshot = await _tripsCollection
          .doc(tripId)
          .collection('days')
          .doc(dayId)
          .collection('diaries')
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => DiaryEntry.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting diary entries: $e');
      throw e;
    }
  }

  Future<void> deleteDiaryEntry(String tripId, String dayId, String entryId) async {
    try {
      await _tripsCollection
          .doc(tripId)
          .collection('days')
          .doc(dayId)
          .collection('diaries')
          .doc(entryId)
          .delete();
    } catch (e) {
      print('Error deleting diary entry: $e');
      throw e;
    }
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = _storage.ref().child('images/$fileName');
      UploadTask uploadTask = reference.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }
}
