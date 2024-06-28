import 'package:desti_go/providers/trip_provider.dart';
import 'package:desti_go/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desti_go/providers/authorization_provider.dart';
import 'package:desti_go/widgets/trip_card.dart';

class TripsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider); 
    final tripState = ref.watch(tripProvider);
    final tripNotifier = ref.watch(tripProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (authState != null) {
        await tripNotifier.fetchTrips(authState.uid);
      }
    });

    //checking if user logged in (should be)
    if (authState == null) {
      return const Scaffold(
        body: Center(
          child: Text('User not logged in!'),
        ),
      );
    }

    return Scaffold(
      appBar: MyAppBar(
        title: 'Your trips',
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
                Icon(Icons.list_alt_rounded, size: 100, color: Colors.black),
                SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    "Let's plan your next adventure!",
                    style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: tripState.trips.isEmpty
                  ? const Center(child: Text('No trips added yet!'))
                  : tripState.error.isNotEmpty
                      ? Center(child: Text('Error: ${tripState.error}'))
                      : ListView.builder(
                          itemCount: tripState.trips.length,
                          itemBuilder: (context, index) {
                            final trip = tripState.trips[index];
                            return TripCard(trip: trip, tripId: trip.id!,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-trip');
        },
        backgroundColor: const Color.fromARGB(255, 97, 64, 187),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
