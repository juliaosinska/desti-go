import 'package:desti_go/providers/authorization_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:desti_go/widgets/day_card.dart';
import 'package:desti_go/models/trip.dart';
import 'package:provider/provider.dart';

class PlanScreen extends StatelessWidget {
  final Trip trip;

  PlanScreen({required this.trip});

  @override
  Widget build(BuildContext context) {
    // Calculate trip duration
    final List<DateTime> tripDates = [];
    DateTime date = trip.departureDate;
    while (date.isBefore(trip.returnDate) || date.isAtSameMomentAs(trip.returnDate)) {
      tripDates.add(date);
      date = date.add(Duration(days: 1));
    }
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plan',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 97, 64, 187),
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  try {
                    await authProvider.signOut();
                    Navigator.pushNamed(context, '/');
                  } catch (e) {
                    print('Error signing out: $e');
                  }
                },
                child: Icon(Icons.logout, color: Colors.white),
              ),
            ),
          ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
            SizedBox(height: 16.0),
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
