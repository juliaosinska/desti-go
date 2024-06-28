import 'package:desti_go/providers/authorization_provider.dart';
import 'package:desti_go/providers/trip_provider.dart';
import 'package:desti_go/views/diary_managment/diary_screen.dart';
import 'package:desti_go/views/plan_managment/plan_screen.dart';
import 'package:desti_go/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:desti_go/models/trip.dart';

class TripDetailsScreen extends ConsumerWidget {
  final Trip trip;
  final String tripId;

  TripDetailsScreen({required this.trip, required this.tripId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //calculating days until trip
    final now = DateTime.now();
    final daysUntilTrip = trip.departureDate.difference(now).inDays + 1;

    String formattedDepartureDate = DateFormat.yMd().format(trip.departureDate);
    String formattedReturnDate = DateFormat.yMd().format(trip.returnDate);

    return Scaffold(
      appBar: MyAppBar(
        title: 'Plan your trip',
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        trip.destination.toUpperCase(),
                        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$formattedDepartureDate - $formattedReturnDate',
                        style: const TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.airplanemode_active, size: 100, color: Colors.black),
              ],
            ),
            const Divider(
              height: 40,
              thickness: 2,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Your trip is in ',
                  style: TextStyle(fontSize: 30),
                ),
                CircleAvatar(
                  radius: 35,
                  backgroundColor: const Color.fromARGB(255, 97, 64, 187),
                  foregroundColor: Colors.white,
                  child: Text(
                    '$daysUntilTrip',
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const Text(
                  ' days!',
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
            const Divider(
              height: 40,
              thickness: 2,
              color: Colors.grey,
            ),
            const Center(
              child: Text(
                "Let's start!",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlanScreen(trip: trip),
                      ),
                    );
                  },
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                  label: const Text(
                    'PLAN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                    backgroundColor: const Color.fromARGB(255, 97, 64, 187),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 10.0,
                    shadowColor: Colors.black.withOpacity(1),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DiaryScreen(trip: trip, tripId: tripId,),
                      ),
                    );
                  },
                  icon: const Icon(Icons.star, color: Color.fromARGB(255, 97, 64, 187)),
                  label: const Text(
                    'DIARY',
                    style: TextStyle(
                      color: Color.fromARGB(255, 97, 64, 187),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                    backgroundColor: const Color.fromARGB(255, 196, 188, 238),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 10.0,
                    shadowColor: Colors.black.withOpacity(1),
                  ),
                ),
              ],
            ),
            const Spacer(),
            //deleting trip
            //confirm in a dialog window
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(Icons.delete, size: 30),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Are you sure you want to delete the trip?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Yes'),
                            onPressed: () async {
                              try {
                                await ref.read(tripProvider.notifier).deleteTrip(trip.id!);
                                //pop twice out of dialog window and trip details screen
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Error deleting trip.')),
                                );
                              }
                            },
                          ),
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
