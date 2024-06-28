import 'package:desti_go/models/place_state.dart';
import 'package:desti_go/repositories/place_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desti_go/controllers/place_controller.dart';
import 'package:desti_go/models/place.dart';
import 'package:google_place/google_place.dart';

class PlaceNotifier extends StateNotifier<PlaceState> {
  final PlaceController placeController;
  final GooglePlace googlePlace;

  PlaceNotifier(this.placeController, this.googlePlace)
      : super(PlaceState(
          places: {},
          autocompletePredictions: [],
          nearbyPlaces: [],
          textSearchResults: [],
          isLoading: false,
          error: '',
        ));

  Future<void> addPlace(String tripId, DateTime day, Place place) async {
    try {
      final placeId = await placeController.addPlace(tripId, day, place);

      final newPlace = Place(
        id: placeId,
        name: place.name,
        address: place.address,
        latitude: place.latitude,
        longitude: place.longitude,
        photos: place.photos,
      );

      final updatedPlaces = {...state.places};
      if (updatedPlaces.containsKey(day)) {
        updatedPlaces[day]!.add(newPlace);
      } else {
        updatedPlaces[day] = [newPlace];
      }

      state = state.copyWith(places: updatedPlaces, error: '');
    } catch (error) {
      state = state.copyWith(error: 'Error adding place: $error');
    }
  }

  Future<void> fetchPlaces(String tripId, DateTime day) async {
    try {
      final fetchedPlaces = await placeController.getPlaces(tripId, day);
      final updatedPlaces = {...state.places};
      updatedPlaces[day] = fetchedPlaces;

      state = state.copyWith(places: updatedPlaces, error: '');
    } catch (error) {
      state = state.copyWith(error: 'Error fetching places: $error');
    }
  }

  Future<void> deletePlace(String tripId, DateTime day, String placeId) async {
    try {
      await placeController.deletePlace(tripId, day, placeId);

      final updatedPlaces = {...state.places};
      updatedPlaces[day] = updatedPlaces[day]!.where((place) => place.id != placeId).toList();

      state = state.copyWith(places: updatedPlaces, error: '');
    } catch (error) {
      state = state.copyWith(error: 'Error deleting place: $error');
    }
  }

  Future<void> autocompletePlaces(String input) async {
    try {
      final predictions = await placeController.autocompletePlaces(input);
      state = state.copyWith(autocompletePredictions: predictions, error: '');
    } catch (error) {
      state = state.copyWith(error: 'Error autocompleting places: $error');
    }
  }

  Future<void> nearbySearch(Location location, int radius, {String? type, String? keyword}) async {
    try {
      final nearbyResults = await placeController.nearbySearch(location, radius, type: type, keyword: keyword);
      state = state.copyWith(nearbyPlaces: nearbyResults, error: '');
    } catch (error) {
      state = state.copyWith(error: 'Error fetching nearby places: $error');
    }
  }

  Future<void> textSearch(String query) async {
    try {
      final searchResults = await placeController.textSearch(query);
      state = state.copyWith(textSearchResults: searchResults, error: '');
    } catch (error) {
      state = state.copyWith(error: 'Error fetching text search results: $error');
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

  Future<void> getCurrentPosition() async {
    try {
      final position = await placeController.getCurrentPosition();
      state = state.copyWith(currentPosition: position, error: '');
    } catch (error) {
      state = state.copyWith(error: 'Error getting current position: $error');
    }
  }

  void clearAutocompleteResults() {
    state = state.copyWith(autocompletePredictions: []);
  }

  void clearNearbyResults() {
    state = state.copyWith(nearbyPlaces: []);
  }

  void clearResults() {
    clearAutocompleteResults();
    clearNearbyResults();
  }
}
final placeRepositoryProvider = Provider<PlaceRepository>((ref) {
  return PlaceRepository();
});

final placeControllerProvider = Provider((ref) {
  final placeRepository = ref.watch(placeRepositoryProvider);
  final googlePlace = GooglePlace(dotenv.env['GOOGLE_PLACES_API_KEY']!);
  return PlaceController(placeRepository: placeRepository, googlePlace: googlePlace);
});

final placeProvider = StateNotifierProvider<PlaceNotifier, PlaceState>((ref) {
  final googlePlace = GooglePlace(dotenv.env['GOOGLE_PLACES_API_KEY']!);
  final placeController = PlaceController(placeRepository: PlaceRepository(), googlePlace: googlePlace);
  return PlaceNotifier(placeController, googlePlace);
});




