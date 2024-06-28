import 'package:desti_go/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:desti_go/widgets/day_card.dart';
import 'package:desti_go/models/trip.dart';
import 'package:desti_go/providers/authorization_provider.dart';

class PlanScreen extends ConsumerWidget {
  final Trip trip;

  PlanScreen({required this.trip});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //dynamically adding days
    final List<DateTime> tripDates = [];
    DateTime date = trip.departureDate;
    while (date.isBefore(trip.returnDate) || date.isAtSameMomentAs(trip.returnDate)) {
      tripDates.add(date);
      date = date.add(const Duration(days: 1));
    }
    
    return Scaffold(
      appBar: MyAppBar(
        title: 'Plan',
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
                Icon(Icons.directions_ferry_outlined, size: 100, color: Colors.black),
                SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    "Add some fun activities!",
                    style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: tripDates.length,
                itemBuilder: (context, index) {
                  DateTime day = tripDates[index];
                  String formattedDate = DateFormat.yMd().format(day);
                  return DayCard(day: day, formattedDate: formattedDate, index: index, tripId: trip.id!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
