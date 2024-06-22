import 'package:flutter/material.dart';

class TripCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.location_city, color: Colors.black),
        title: Text('CITY'),
        subtitle: Text('DATE DEPARTURE - DATE RETURN'),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Add navigation to trip details
        },
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
    );
  }
}