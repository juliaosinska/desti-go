import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:desti_go/repositories/diary_repository.dart';
import 'package:desti_go/models/diary_entry.dart';

class DiaryController {
  final DiaryRepository diaryRepository;

  DiaryController({required this.diaryRepository});

  Future<void> addDiaryEntry({
    required String tripId,
    required DateTime date,
    String? text,
    String? imageURL,
  }) async {
    try {
      await diaryRepository.addDiaryEntry(tripId, date, text: text, imageURL: imageURL);
    } catch (error) {
      print('Error adding diary entry: $error');
      rethrow;
    }
  }

  Future<List<DiaryEntry>> getDiaryEntries(String tripId, DateTime date) async {
    try {
      return await diaryRepository.getDiaryEntries(tripId, date);
    } catch (error) {
      print('Error getting diary entries: $error');
      rethrow;
    }
  }

  Future<void> deleteDiaryEntry(String tripId, String dayId, String entryId) async {
    try {
      await diaryRepository.deleteDiaryEntry(tripId, dayId, entryId);
    } catch (error) {
      print('Error deleting diary entry: $error');
      rethrow;
    }
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance.ref().child('diary_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }
}
