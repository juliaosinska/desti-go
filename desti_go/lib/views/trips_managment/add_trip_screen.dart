import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:desti_go/controllers/trip_controller.dart';
import 'package:desti_go/models/trip.dart';
import 'package:desti_go/providers/authorization_provider.dart';

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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add a new trip',
          style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 97, 64, 187),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 10),
                          );
                          if (pickedDate != null && pickedDate != _departureDate) {
                            setState(() {
                              _departureDate = pickedDate;
                            });
                          }
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
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 10),
                          );
                          if (pickedDate != null && pickedDate != _returnDate) {
                            setState(() {
                              _returnDate = pickedDate;
                            });
                          }
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
              SizedBox(height: 30.0),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: Color.fromARGB(255, 97, 64, 187),
                    textStyle: TextStyle(fontSize: 20),
                    foregroundColor: Colors.white
                  ),
                  onPressed: () async {
                    if (_destinationController.text.isEmpty ||
                        _departureDate == null ||
                        _returnDate == null) {
                      // Show some error or warning
                      return;
                    }

                    try {
                      await Provider.of<TripController>(context, listen: false)
                          .addTrip(
                        userId,
                        _destinationController.text,
                        _departureDate!,
                        _returnDate!,
                      );
                      
                      // Navigate back after adding the trip
                      Navigator.pop(context);
                    } catch (e) {
                      print('Error adding trip: $e');
                    }
                  },
                  child: Text('Add Trip')
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
