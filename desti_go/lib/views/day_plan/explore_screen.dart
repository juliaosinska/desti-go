import 'package:desti_go/providers/authorization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:desti_go/providers/place_provider.dart';
import 'package:google_place/google_place.dart';
import 'package:desti_go/models/place.dart';
import 'package:desti_go/models/photo.dart' as myPhoto;

class ExploreScreen extends StatefulWidget {
  final String tripId;
  final DateTime day;

  ExploreScreen({required this.tripId, required this.day});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  TextEditingController _searchController = TextEditingController();
  bool _showNearbyResults = false;
  String googlePlacesApiKey = dotenv.env['GOOGLE_PLACES_API_KEY'] ?? '';

  @override
  void initState() {
    super.initState();
    Provider.of<PlaceProvider>(context, listen: false).initCurrentLocation();
    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty) {
        Provider.of<PlaceProvider>(context, listen: false)
            .autocompletePlaces(_searchController.text);
        setState(() {
          _showNearbyResults = false; // Switch back to text search results
        });
      }
    });
  }

  void _handlePlaceSelection(String placeId) async {
    final placeProvider = Provider.of<PlaceProvider>(context, listen: false);
    try {
      final details = await placeProvider.getPlaceDetails(placeId);
      final place = Place(
        id: details.placeId!,
        name: details.name!,
        address: details.formattedAddress!,
        latitude: details.geometry!.location!.lat!,
        longitude: details.geometry!.location!.lng!,
        photos: details.photos
            ?.map((photo) =>
                myPhoto.Photo(photoReference: photo.photoReference!))
            .toList(),
      );
      await placeProvider.addPlace(widget.tripId, widget.day, place);
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add place: $error'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  void _handleNearbyPlaces() async {
    final placeProvider = Provider.of<PlaceProvider>(context, listen: false);
    try {
      if (placeProvider.currentPosition != null) {
        await placeProvider.getNearbyPlaces(
          Location(
            lat: placeProvider.currentPosition!.latitude,
            lng: placeProvider.currentPosition!.longitude,
          ),
          1000, // Define a suitable radius
        );

        setState(() {
          _showNearbyResults = true; // Switch to nearby results
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to fetch nearby places: $error'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final placeProvider = Provider.of<PlaceProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Explore',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 97, 64, 187),
        foregroundColor: Colors.white,
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(1),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search for places',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _handleNearbyPlaces,
                  child: Text('Nearby Places', style: TextStyle(fontWeight: FontWeight.bold),),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Color.fromARGB(255, 97, 64, 187),
                    ),
                    foregroundColor: WidgetStateProperty.all<Color>(
                      Colors.white
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (placeProvider.currentPosition == null)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (placeProvider.isLoading)
            Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (placeProvider.autocompletePredictions.isNotEmpty &&
              !_showNearbyResults)
            Expanded(
              child: ListView.builder(
                itemCount: placeProvider.autocompletePredictions.length,
                itemBuilder: (context, index) {
                  final prediction =
                      placeProvider.autocompletePredictions[index];
                  return Card(
                    elevation: 5,
                    margin:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(prediction.description ?? ''),
                      onTap: () =>
                          _handlePlaceSelection(prediction.placeId!),
                    ),
                  );
                },
              ),
            )
          else if (_showNearbyResults &&
              placeProvider.nearbyPlaces.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: placeProvider.nearbyPlaces.length,
                itemBuilder: (context, index) {
                  final place = placeProvider.nearbyPlaces[index];
                  return Card(
                    elevation: 5,
                    margin:
                      EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        place.name ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: place.vicinity != null
                          ? Text(
                              place.vicinity!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            )
                          : null,
                      leading: place.photos != null &&
                              place.photos!.isNotEmpty
                          ? Image.network(
                              'https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&photoreference=${place.photos![0].photoReference}&key=$googlePlacesApiKey',
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            )
                          : Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[300],
                              child: Icon(Icons.camera_alt,
                                  color: Colors.grey[600]),
                            ),
                      onTap: () => _handlePlaceSelection(place.placeId!),
                    ),
                  );
                },
              ),
            )
          else
            Expanded(
              child: Center(child: Text('No places found')),
            ),
        ],
      ),
    );
  }
}