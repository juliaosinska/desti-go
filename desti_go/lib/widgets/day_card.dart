import 'package:flutter/material.dart';
import 'package:desti_go/views/day_plan/day_plan_screen.dart';

class DayCard extends StatelessWidget {
  final DateTime day;
  final String formattedDate;
  final int index;
  final String tripId; // Add tripId here

  DayCard({
    required this.day,
    required this.formattedDate,
    required this.index,
    required this.tripId, // Initialize tripId in constructor
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.calendar_today_rounded, color: Colors.black),
        title: Text('DAY ${index + 1}'), // Use index to display sequential order
        subtitle: Text(formattedDate),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DayPlanScreen(
                day: day,
                formattedDate: formattedDate,
                tripId: tripId, // Pass tripId to DayPlanScreen
              ),
            ),
          );
        },
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
    );
  }
}
