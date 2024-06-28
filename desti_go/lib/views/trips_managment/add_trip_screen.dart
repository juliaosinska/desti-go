import 'package:desti_go/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desti_go/providers/authorization_provider.dart';
import 'package:desti_go/providers/trip_provider.dart';

//state providers for dates so that we can update controllers with picked dates
final departureDateProvider = StateProvider<DateTime?>((ref) => null);
final returnDateProvider = StateProvider<DateTime?>((ref) => null);

class AddTripScreen extends ConsumerWidget {
  final TextEditingController _destinationController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripNotifier = ref.watch(tripProvider.notifier);
    
    final authState = ref.watch(authProvider);
    final userId = authState?.uid;

    final departureDate = ref.watch(departureDateProvider);
    final returnDate = ref.watch(returnDateProvider);

    return Scaffold(
      appBar: MyAppBar(
        title: 'Add a trip',
        onLogout: () async {
          try {
            await ref.read(authProvider.notifier).signOut();
            Navigator.pushNamed(context, '/');
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error signing out.')),
            );
          }
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _destinationController,
                decoration: const InputDecoration(
                  labelText: 'Destination',
                  hintText: 'Please, enter your city of choice.',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.input_rounded),
                ),
              ),
              const SizedBox(height: 30.0),
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
                      const Text('Select date', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 10.0),
                      const Text('Enter date of departure', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10.0),
                      InkWell(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 10),
                          );
                          if (pickedDate != null) {
                            ref.read(departureDateProvider.notifier).state = pickedDate;
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Date',
                          ),
                          child: Text(
                            departureDate == null
                                ? 'mm/dd/yyyy'
                                : DateFormat.yMd().format(departureDate),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
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
                      const Text('Enter return date', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10.0),
                      InkWell(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 10),
                          );
                          if (pickedDate != null) {
                            ref.read(returnDateProvider.notifier).state = pickedDate;
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Date',
                          ),
                          child: Text(
                            returnDate == null
                                ? 'mm/dd/yyyy'
                                : DateFormat.yMd().format(returnDate),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              SizedBox(
                width: double.infinity,
                height: 50,
                //adding trip
                child: ElevatedButton(
                  onPressed: () async {
                    final destination = _destinationController.text;

                    //error if any field is empty  
                    if (destination.isEmpty || departureDate == null || returnDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all the fields')),
                      );
                      return;
                    }

                    await tripNotifier.addTrip(userId!, destination, departureDate, returnDate);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 97, 64, 187),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 5.0,
                    shadowColor: Colors.black.withOpacity(1),
                  ),
                  child: const Text('Add trip', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
