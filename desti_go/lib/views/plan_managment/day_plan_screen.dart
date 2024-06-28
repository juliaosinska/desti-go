import 'package:desti_go/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desti_go/views/plan_managment/explore_screen.dart';
import 'package:desti_go/widgets/place_card.dart';
import 'package:desti_go/providers/place_provider.dart';
import 'package:desti_go/providers/authorization_provider.dart';

class DayPlanScreen extends ConsumerWidget {
  final String tripId;
  final DateTime day;
  final String formattedDate;

  DayPlanScreen({
    required this.tripId,
    required this.day,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placeNotifier = ref.watch(placeProvider.notifier);
    final placeState = ref.watch(placeProvider);

    //fetching places for the day
    WidgetsBinding.instance.addPostFrameCallback((_) {
      placeNotifier.fetchPlaces(tripId, day);
    });

    return Scaffold(
      appBar: MyAppBar(
        title: 'Plan for $formattedDate',
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.calendar_today, size: 100, color: Colors.black),
                SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    "Plan your day!",
                    style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            if (placeState.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (placeState.error.isNotEmpty)
              Center(child: Text('Error: ${placeState.error}'))
            else if (placeState.places[day] == null || placeState.places[day]!.isEmpty)
              const Center(child: Text('No places added for this day yet.'))
            else
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: placeState.places[day]!.length,
                  itemBuilder: (context, index) {
                    return PlaceCard(
                      place: placeState.places[day]![index],
                      day: day,
                      tripId: tripId,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExploreScreen(tripId: tripId, day: day),
              ),
            );
          },
          backgroundColor: const Color.fromARGB(255, 97, 64, 187),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
