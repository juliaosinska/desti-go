import 'package:flutter/material.dart';

class DiaryCard extends StatelessWidget {
  final DateTime day;
  final String formattedDate;
  final int index;

  DiaryCard({required this.day, required this.formattedDate, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.camera, color: Colors.black),
        title: Text('DAY ${index + 1}'),
        subtitle: Text(formattedDate),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          //Navigator.push(
            //context,
            //MaterialPageRoute(
              //builder: (context) => DiaryEntryScreen(date: day),
            //),
          //);
        },
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
    );
  }
}
