import 'dart:io';
import 'package:desti_go/repositories/diary_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desti_go/controllers/diary_controller.dart';
import 'package:desti_go/models/diary_entry.dart';

class DiaryProvider extends StateNotifier<List<DiaryEntry>> {
  final DiaryController diaryController;

  DiaryProvider(this.diaryController) : super([]);

  Future<void> fetchDiaryEntries(String tripId, DateTime date) async {
    try {
      state = await diaryController.getDiaryEntries(tripId, date);
    } catch (e) {
      print('Error fetching diary entries: $e');
      throw e;
    }
  }

  Future<void> addDiaryEntry({
    required String tripId,
    required String text,
    String? imageURL,
    required DateTime timestamp,
    File? imageFile,
  }) async {
    try {
      if (imageFile != null) {
        imageURL = await diaryController.uploadImage(imageFile);
      }

      await diaryController.addDiaryEntry(
        tripId: tripId,
        date: timestamp,
        text: text,
        imageURL: imageURL,
      );
      state = [
        ...state,
        DiaryEntry(
          id: '',
          text: text,
          imageURL: imageURL,
          timestamp: timestamp,
        ),
      ];
    } catch (e) {
      print('Error adding diary entry: $e');
      throw e;
    }
  }

  Future<void> deleteDiaryEntry(String tripId, String dayId, String entryId) async {
    try {
      await diaryController.deleteDiaryEntry(tripId, dayId, entryId);
      state = state.where((entry) => entry.id != entryId).toList();
    } catch (e) {
      print('Error deleting diary entry: $e');
      throw e;
    }
  }
}

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  return DiaryRepository();
});

final diaryControllerProvider = Provider<DiaryController>((ref) {
  final diaryRepository = ref.watch(diaryRepositoryProvider);
  return DiaryController(diaryRepository: diaryRepository);
});

final diaryProvider = StateNotifierProvider<DiaryProvider, List<DiaryEntry>>((ref) {
  final diaryController = ref.watch(diaryControllerProvider);
  return DiaryProvider(diaryController);
});
