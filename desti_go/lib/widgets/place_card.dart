import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desti_go/models/place.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:desti_go/providers/place_provider.dart';

class PlaceCard extends ConsumerWidget {
  final Place place;
  final String tripId;
  final DateTime day;

  PlaceCard({required this.place, required this.day, required this.tripId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String googlePlacesApiKey = dotenv.env['GOOGLE_PLACES_API_KEY'] ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Icons.place, color: Colors.black),
            title: Text(place.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(place.address),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref.read(placeProvider.notifier).deletePlace(tripId, day, place.id);
              },
              color: Colors.red,
            ),
          ),
          if (place.photos != null && place.photos!.isNotEmpty)
            SizedBox(
              height: 100.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: place.photos!.length,
                itemBuilder: (context, index) {
                  final photo = place.photos![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photo.photoReference}&key=$googlePlacesApiKey',
                        width: 100.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
