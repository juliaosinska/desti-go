import 'package:desti_go/views/trips_managment/trip_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:desti_go/models/trip.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final String tripId;

  TripCard({required this.trip, required this.tripId});

  @override
  Widget build(BuildContext context) {
    String formattedDepartureDate = DateFormat.yMd().format(trip.departureDate);
    String formattedReturnDate = DateFormat.yMd().format(trip.returnDate);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        leading: const Icon(Icons.location_city, color: Colors.black),
        title: Text(
          trip.destination,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        subtitle: Text(
          '$formattedDepartureDate - $formattedReturnDate',
          style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TripDetailsScreen(trip: trip, tripId: tripId,),
            ),
          );
        },
      ),
    );
  }
}
