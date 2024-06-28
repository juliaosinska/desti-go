import 'package:desti_go/providers/authorization_provider.dart';
import 'package:desti_go/widgets/diary_entry_card.dart';
import 'package:desti_go/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desti_go/models/diary_entry.dart';
import 'package:desti_go/providers/diary_provider.dart';
import 'add_diary_entry_screen.dart';
import 'package:intl/intl.dart';

class DayDiaryScreen extends ConsumerWidget {
  final DateTime date;
  final String tripId;

  DayDiaryScreen({required this.date, required this.tripId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String dayId = DateFormat('yyyy-MM-dd').format(date);

    final diaryProviderState = ref.watch(diaryProvider);
    
    ref.read(diaryProvider.notifier).fetchDiaryEntries(tripId, date);

    return Scaffold(
      appBar: MyAppBar(
        title: 'Add a diary entry',
        onLogout: () async {
          try {
            await ref.read(authProvider.notifier).signOut();
            Navigator.pushNamed(context, '/');
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error signing out.')),
            );
          }
        },
      ),
      body: diaryProviderState.isEmpty
          ? const Center(
              child: Text('No entries for this day.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: diaryProviderState.length,
              itemBuilder: (context, index) {
                DiaryEntry entry = diaryProviderState[index];
                return DiaryEntryCard(
                  entry: entry, tripId: tripId, dayId: dayId,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDiaryEntryScreen(date: date, tripId: tripId),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 97, 64, 187),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
