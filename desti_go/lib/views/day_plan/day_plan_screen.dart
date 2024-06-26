import 'package:desti_go/providers/authorization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:desti_go/providers/place_provider.dart';
import 'package:desti_go/views/day_plan/explore_screen.dart';
import 'package:desti_go/widgets/place_card.dart';

class DayPlanScreen extends StatelessWidget {
  final String tripId;
  final DateTime day;
  final String formattedDate;

  DayPlanScreen({required this.tripId, required this.day, required this.formattedDate});

  @override
  Widget build(BuildContext context) {
    final placeProvider = Provider.of<PlaceProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Fetch places for the current day and tripId
    WidgetsBinding.instance.addPostFrameCallback((_) {
      placeProvider.fetchPlaces(tripId, day);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plan for $formattedDate',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 97, 64, 187),
        foregroundColor: Colors.white,
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(1),
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
        padding: const EdgeInsets.all(24.0), // Padding around the Column
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, size: 100, color: Colors.black),
                SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    "Adjust your plan!",
                    style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0), // Vertical padding around ListView
                child: Consumer<PlaceProvider>(
                  builder: (context, placeProvider, _) {
                    final places = placeProvider.places[day];
                    if (places == null || places.isEmpty) {
                      return Center(
                        child: Text('No places added for this day yet.'),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero, // Remove default padding inside ListView
                      itemCount: places.length,
                      itemBuilder: (context, index) {
                        return PlaceCard(place: places[index], day: day, tripId: tripId
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around FloatingActionButton
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExploreScreen(tripId: tripId, day: day)),
            );
          },
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Color.fromARGB(255, 97, 64, 187),
        ),
      ),
    );
  }
}
