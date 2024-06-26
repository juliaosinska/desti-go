import 'package:desti_go/providers/authorization_provider.dart';
import 'package:desti_go/providers/trip_provider.dart';
import 'package:desti_go/views/diary/diary_screen.dart';
import 'package:desti_go/views/plan/plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:desti_go/models/trip.dart';
import 'package:provider/provider.dart';

class TripDetailsScreen extends StatelessWidget {
  final Trip trip;

  TripDetailsScreen({required this.trip});

  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Calculate days until the trip
    final now = DateTime.now();
    final daysUntilTrip = trip.departureDate.difference(now).inDays;

    String formattedDepartureDate = DateFormat.yMd().format(trip.departureDate);
    String formattedReturnDate = DateFormat.yMd().format(trip.returnDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plan your trip',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 97, 64, 187),
        iconTheme: IconThemeData(color: Colors.white),
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
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$formattedDepartureDate - $formattedReturnDate',
                        style: TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.airplanemode_active, size: 100, color: Colors.black),
              ],
            ),
            Divider(
              height: 40,
              thickness: 2,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your trip is in ',
                  style: TextStyle(fontSize: 30),
                ),
                CircleAvatar(
                  radius: 35,
                  child: Text(
                    '$daysUntilTrip',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Color.fromARGB(255, 97, 64, 187),
                  foregroundColor: Colors.white,
                ),
                Text(
                  ' days!',
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
            Divider(
              height: 40,
              thickness: 2,
              color: Colors.grey,
            ),
            Center(
              child: Text(
                "Let's start!",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
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
                  icon: Icon(Icons.calendar_today, color: Colors.white),
                  label: Text(
                    'PLAN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                    backgroundColor: Color.fromARGB(255, 97, 64, 187),
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
                        builder: (context) => DiaryScreen(trip: trip),
                      ),
                    );
                  },
                  icon: Icon(Icons.star, color: Color.fromARGB(255, 97, 64, 187)),
                  label: Text(
                    'DIARY',
                    style: TextStyle(
                      color: Color.fromARGB(255, 97, 64, 187), 
                      fontSize: 18, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                    backgroundColor: Color.fromARGB(255, 196, 188, 238),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 10.0,
                    shadowColor: Colors.black.withOpacity(1),
                  ),
                ),
              ],
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: Icon(Icons.delete, size: 30),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Are you sure you want to delete the trip?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () async {
                              try {
                                await tripProvider.deleteTrip(trip.id!, trip.userId);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop(); // Pop twice to go back to previous screen
                              } catch (e) {
                                print('Error deleting trip: $e');
                                // Handle error, e.g., show error message
                              }
                            },
                          ),
                          TextButton(
                            child: Text('Cancel'),
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