import 'package:desti_go/views/diary_managment/day_diary_screen.dart';
import 'package:flutter/material.dart';

class DiaryCard extends StatelessWidget {
  final DateTime day;
  final String formattedDate;
  final int index;
  final String tripId;

  DiaryCard({required this.day, required this.formattedDate, required this.index, required this.tripId});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
      child: ListTile(
        leading: const Icon(Icons.camera, color: Colors.black),
        title: Text('DAY ${index + 1}'),
        subtitle: Text(formattedDate),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DayDiaryScreen(date: day, tripId: tripId,),
            ),
          );
        },
      ),
    );
  }
}
