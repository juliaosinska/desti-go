import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:desti_go/controllers/trip_controller.dart';
import 'package:desti_go/models/trip.dart';
import 'package:desti_go/providers/authorization_provider.dart';
import 'package:desti_go/trip_card.dart';

class TripsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text('User not logged in!'),
        ),
      );
    }

    return ChangeNotifierProvider<TripController>(
      create: (_) => TripController()..refreshTrips(user.uid),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Your trips',
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
              SizedBox(height: 16.0),
              Expanded(
                  child: Consumer<TripController>(
                  builder: (context, tripController, _) {
                    if (tripController.trips.isEmpty) {
                      return Center(child: Text('No trips added yet.'));
                    }
                    return ListView.builder(
                      itemCount: tripController.trips.length,
                      itemBuilder: (context, index) {
                        return TripCard(trip: tripController.trips[index]);
                      },
                    );
                  },
                )
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add-trip');
          },
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Color.fromARGB(255, 97, 64, 187),
        ),
      ),
    );
  }
}
