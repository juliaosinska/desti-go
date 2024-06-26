import 'package:desti_go/models/trip.dart';
import 'package:desti_go/providers/authorization_provider.dart';
import 'package:desti_go/widgets/diary_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Import DateFormat for date formatting

class DiaryScreen extends StatelessWidget {
  final Trip trip;

  DiaryScreen({required this.trip});

  @override
  Widget build(BuildContext context) {
    final List<DateTime> diaryDates = [];
    DateTime date = trip.departureDate;
    while (date.isBefore(trip.returnDate) || date.isAtSameMomentAs(trip.returnDate)) {
      diaryDates.add(date);
      date = date.add(Duration(days: 1));
    }
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Diary',
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
                Icon(Icons.photo_album_outlined, size: 100, color: Colors.black),
                SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    "Save the memories!",
                    style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: diaryDates.length,
                itemBuilder: (context, index) {
                  DateTime day = diaryDates[index];
                  String formattedDate = DateFormat.yMd().format(day);
                  return DiaryCard(day: day, formattedDate: formattedDate, index: index,);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
