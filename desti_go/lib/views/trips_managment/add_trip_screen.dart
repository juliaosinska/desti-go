import 'package:desti_go/providers/trip_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
                      Text('Enter return date', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final destination = _destinationController.text;
                    final departureDate = _departureDate;
                    final returnDate = _returnDate;

                    if (destination.isEmpty || departureDate == null || returnDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill all the fields')),
                      );
                      return;
                    }

                    final tripProvider = Provider.of<TripProvider>(context, listen: false);
                    await tripProvider.addTrip(userId, destination, departureDate, returnDate);
                    Navigator.pop(context);
                  },
                  child: Text('Add trip', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 97, 64, 187),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 5.0,
                    shadowColor: Colors.black.withOpacity(1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
