import 'package:desti_go/day_card.dart';
import 'package:flutter/material.dart';

class PlanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
              child: ListView(
                children: [
                  DayCard(),
                  DayCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

