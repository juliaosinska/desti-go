import 'package:flutter/material.dart';

class DayCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.calendar_month_rounded, color: Colors.black),
        title: Text('DAY'),
        subtitle: Text('DATE'),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // add navigation to day plan details
        },
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
    );
  }
}