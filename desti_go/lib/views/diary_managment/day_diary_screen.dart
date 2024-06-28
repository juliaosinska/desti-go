import 'package:desti_go/providers/authorization_provider.dart';
import 'package:desti_go/widgets/diary_entry_card.dart';
import 'package:desti_go/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desti_go/models/diary_entry.dart';
import 'package:desti_go/providers/diary_provider.dart';
import 'add_diary_entry_screen.dart';
import 'package:intl/intl.dart';

class DayDiaryScreen extends ConsumerStatefulWidget {
  final DateTime date;
  final String tripId;

  DayDiaryScreen({required this.date, required this.tripId});

  @override
  _DayDiaryScreenState createState() => _DayDiaryScreenState();
}

class _DayDiaryScreenState extends ConsumerState<DayDiaryScreen> {
  late Future<void> _fetchEntriesFuture;

  @override
  void initState() {
    super.initState();
    //clearing state after entering new day diary screen to avoid flickering of old state
    ref.read(diaryProvider.notifier).clearDiaryEntries();
    _fetchEntriesFuture = ref.read(diaryProvider.notifier).fetchDiaryEntries(widget.tripId, widget.date);
  }

  @override
  Widget build(BuildContext context) {
    String dayId = DateFormat('yyyy-MM-dd').format(widget.date);

    return Scaffold(
      appBar: MyAppBar(
        title: 'Diary entries',
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
      body: FutureBuilder<void>(
        future: _fetchEntriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final diaryProviderState = ref.watch(diaryProvider);
            if (diaryProviderState.isEmpty) {
              return const Center(
                child: Text('No entries for this day.'),
              );
            } else {
              diaryProviderState.sort((a, b) => b.timestamp.compareTo(a.timestamp));
              
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: diaryProviderState.length,
                itemBuilder: (context, index) {
                  DiaryEntry entry = diaryProviderState[index];
                  return DiaryEntryCard(
                    entry: entry, tripId: widget.tripId, dayId: dayId,
                  );
                },
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDiaryEntryScreen(date: widget.date, tripId: widget.tripId),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 97, 64, 187),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
