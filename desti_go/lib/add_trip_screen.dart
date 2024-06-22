import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTripScreen extends StatefulWidget {
  @override
  _AddTripScreenState createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final TextEditingController _destinationController = TextEditingController();
  DateTime? _departureDate;
  DateTime? _returnDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new trip', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 97, 64, 187),
        iconTheme: IconThemeData(color: Colors.black),
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
          children: <Widget>[
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(
                labelText: 'Destination',
                hintText: 'Please, enter your city of choice.',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.input_rounded),
              ),
            ),
            SizedBox(height: 30.0),
            Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Select date', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10.0),
                    Text('Enter date of departure', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10.0),
                    InkWell(
                      onTap: () {
                        // Do nothing for now
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Date',
                        ),
                        child: Text(
                          _departureDate == null
                              ? 'mm/dd/yyyy'
                              : DateFormat.yMd().format(_departureDate!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Select date', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10.0),
                    Text('Enter date of return', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10.0),
                    InkWell(
                      onTap: () {
                        // Do nothing for now
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Date',
                        ),
                        child: Text(
                          _returnDate == null
                              ? 'mm/dd/yyyy'
                              : DateFormat.yMd().format(_returnDate!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
