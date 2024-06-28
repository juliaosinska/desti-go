import 'package:desti_go/models/place.dart';
import 'package:desti_go/repositories/place_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';

class PlaceController {
  final PlaceRepository placeRepository;
  final GooglePlace googlePlace;

  PlaceController({required this.placeRepository, required this.googlePlace});

  Future<String> addPlace(String tripId, DateTime day, Place place) async {
    try {
      return await placeRepository.addPlaceToDay(tripId, day, place);
    } catch (error) {
      print('Error adding place: $error');
      rethrow;
    }
  }

  Future<List<Place>> getPlaces(String tripId, DateTime day) async {
    try {
      return await placeRepository.getPlacesForDay(tripId, day);
    } catch (error) {
      print('Error getting places: $error');
      rethrow;
    }
  }

  Future<void> deletePlace(String tripId, DateTime day, String placeId) async {
    try {
      await placeRepository.deletePlaceFromDay(tripId, day, placeId);
    } catch (error) {
      print('Error deleting place: $error');
      rethrow;
    }
  }

  Future<List<AutocompletePrediction>> autocompletePlaces(String input) async {
    try {
      final response = await googlePlace.autocomplete.get(input);
      return response?.predictions ?? [];
    } catch (error) {
      print('Error autocompleting places: $error');
      throw Exception('Failed to autocomplete places: $error');
    }
  }

  Future<List<SearchResult>> nearbySearch(Location location, int radius, {String? type, String? keyword}) async {
    try {
      final response = await googlePlace.search.getNearBySearch(
        Location(lat: location.lat, lng: location.lng),
        radius,
        type: type,
        keyword: keyword,
      );
      return response?.results ?? [];
    } catch (error) {
      print('Error nearby search: $error');
      throw Exception('Failed nearby search: $error');
    }
  }

  Future<List<SearchResult>> textSearch(String query) async {
    try {
      final response = await googlePlace.search.getTextSearch(query);
      return response?.results ?? [];
    } catch (error) {
      print('Error text search: $error');
      throw Exception('Failed text search: $error');
    }
  }

  Future<DetailsResult> getPlaceDetails(String placeId) async {
    try {
      final response = await googlePlace.details.get(placeId);
      return response!.result!;
    } catch (error) {
      print('Error getting place details: $error');
      throw Exception('Failed to get place details: $error');
    }
  }

  Future<List<Photo>> getPlacePhotos(String placeId) async {
    try {
      final response = await googlePlace.details.get(placeId);
      return response?.result?.photos ?? [];
    } catch (error) {
      print('Error getting place photos: $error');
      throw Exception('Failed to get place photos: $error');
    }
  }

  Future<Position> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
    } catch (e) {
      print('Error getting location: $e');
      throw Exception('Failed to get current location');
    }
  }
}