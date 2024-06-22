import 'package:desti_go/diary_card.dart';
import 'package:flutter/material.dart';

class DiaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              child: ListView(
                children: [
                  DiaryCard(),
                  DiaryCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

