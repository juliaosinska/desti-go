import 'package:desti_go/providers/authorization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:desti_go/models/place.dart';
import 'package:desti_go/models/photo.dart' as myPhoto;
import 'package:desti_go/providers/place_provider.dart';
import 'package:google_place/google_place.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  final String tripId;
  final DateTime day;

  ExploreScreen({required this.tripId, required this.day});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    final placeNotifier = ref.read(placeProvider.notifier);
    placeNotifier.getCurrentPosition();
  }

  //handling user tapping on the place =>
  //getting place's details =>
  //adding it to the places for the day plan
  void _handlePlaceSelection(String placeId) async {
    final placeNotifier = ref.read(placeProvider.notifier);
    try {
      final details = await placeNotifier.getPlaceDetails(placeId);
      final place = Place(
        id: details.placeId!,
        name: details.name!,
        address: details.formattedAddress!,
        latitude: details.geometry!.location!.lat!,
        longitude: details.geometry!.location!.lng!,
        photos: details.photos
            ?.map((photo) => myPhoto.Photo(photoReference: photo.photoReference!))
            .toList(),
      );
      await placeNotifier.addPlace(widget.tripId, widget.day, place);
      Navigator.pop(context);
      placeNotifier.clearResults();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add place: $error'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  //handling searching for nearby places based on user's location
  void _handleNearbyPlaces() async {
    final placeNotifier = ref.read(placeProvider.notifier);
    final placeState = ref.watch(placeProvider);

    try {
      placeNotifier.clearAutocompleteResults();
      if (placeState.currentPosition != null) {
        await placeNotifier.nearbySearch(
          Location(
            lat: placeState.currentPosition!.latitude,
            lng: placeState.currentPosition!.longitude,
          ),
          1000,
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch nearby places: $error'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String googlePlacesApiKey = dotenv.env['GOOGLE_PLACES_API_KEY'] ?? '';
    final placeNotifier = ref.read(placeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explore',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 97, 64, 187),
        foregroundColor: Colors.white,
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            placeNotifier.clearResults();
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () async {
                try {
                  await ref.read(authProvider.notifier).signOut();
                  Navigator.pushNamed(context, '/');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error signing out.')),
                  );
                }
              },
              child: const Icon(Icons.logout, color: Colors.white),
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
                    decoration: const InputDecoration(
                      labelText: 'Search for places',
                      border: OutlineInputBorder(),
                    ),
                    //when user starts typing in text controller => autocomplete
                    onChanged: (input) async {
                      await ref.read(placeProvider.notifier).autocompletePlaces(input);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                //button to search for nearby places
                ElevatedButton(
                  onPressed: _handleNearbyPlaces,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      const Color.fromARGB(255, 97, 64, 187),
                    ),
                    foregroundColor: WidgetStateProperty.all<Color>(
                      Colors.white,
                    ),
                  ),
                  child: const Text(
                    'Nearby Places',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          //UI handling for changes between text search and nearby search
          Consumer(
            builder: (context, ref, _) {
              final placeState = ref.watch(placeProvider);

              if (placeState.isLoading) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (placeState.autocompletePredictions.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: placeState.autocompletePredictions.length,
                    itemBuilder: (context, index) {
                      final prediction = placeState.autocompletePredictions[index];
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(prediction.description ?? ''),
                          onTap: () => _handlePlaceSelection(prediction.placeId!),
                        ),
                      );
                    },
                  ),
                );
              } else if (placeState.nearbyPlaces.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: placeState.nearbyPlaces.length,
                    itemBuilder: (context, index) {
                      final place = placeState.nearbyPlaces[index];
                      return Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              place.name ?? '',
                              style: const TextStyle(
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
                            leading: place.photos != null && place.photos!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        'https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&photoreference=${place.photos![0].photoReference}&key=$googlePlacesApiKey',
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      ),
                                    )
                                : Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    child: Icon(Icons.camera_alt, color: Colors.grey[600]),
                                  ),
                            onTap: () => _handlePlaceSelection(place.placeId!),
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            indent: 16,
                            endIndent: 16,
                            color: Colors.grey[400],
                          ),
                        ],
                      );  
                    },
                  ),
                );
              } else {
                return const Expanded(
                  child: Center(child: Text('No places found')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
