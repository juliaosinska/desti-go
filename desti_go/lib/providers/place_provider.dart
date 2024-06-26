import 'package:flutter/material.dart';
import 'package:desti_go/controllers/place_controller.dart';
import 'package:desti_go/models/place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';

class PlaceProvider with ChangeNotifier {
  final PlaceController placeController;
  Map<DateTime, List<Place>> _places = {};
  List<AutocompletePrediction> _autocompletePredictions = [];
  List<SearchResult> _nearbyPlaces = [];
  List<SearchResult> _textSearchResults = [];
  bool isLoading = false;
  String error = '';
  Position? _currentPosition;

  PlaceProvider({required this.placeController});

  Position? get currentPosition => _currentPosition;

  Map<DateTime, List<Place>> get places => _places;
  List<AutocompletePrediction> get autocompletePredictions => _autocompletePredictions;
  List<SearchResult> get nearbyPlaces => _nearbyPlaces;
  List<SearchResult> get textSearchResults => _textSearchResults;

  Future<void> addPlace(String tripId, DateTime day, Place place) async {
    try {
      String placeId = await placeController.addPlace(tripId, day, place);

      Place newPlace = Place(
        id: placeId,
        name: place.name,
        address: place.address,
        latitude: place.latitude,
        longitude: place.longitude,
        photos: place.photos,
      );

      if (_places.containsKey(day)) {
        _places[day]!.add(newPlace);
      } else {
        _places[day] = [newPlace];
      }

      notifyListeners();
    } catch (error) {
      print('Error adding place: $error');
      rethrow;
    }
  }

  Future<void> fetchPlaces(String tripId, DateTime day) async {
    try {
      _places[day] = await placeController.getPlaces(tripId, day);
      notifyListeners();
    } catch (error) {
      print('Error fetching places: $error');
      rethrow;
    }
  }

  Future<void> deletePlace(String tripId, DateTime day, String placeId) async {
    try {
      await placeController.deletePlace(tripId, day, placeId);
      if (_places.containsKey(day)) {
        _places[day]!.removeWhere((place) => place.id == placeId);
        notifyListeners();
      }
    } catch (error) {
      print('Error deleting place: $error');
      rethrow;
    }
  }

  Future<void> autocompletePlaces(String input) async {
    isLoading = true;
    notifyListeners();
    try {
      _autocompletePredictions = await placeController.autocompletePlaces(input);
      error = '';
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<List<SearchResult>> getNearbyPlaces(Location location, int radius) async {
    isLoading = true;
    notifyListeners();
    try {
      _nearbyPlaces = await placeController.nearbySearch(location, radius);
      error = '';
    } catch (e) {
      error = e.toString();
      _nearbyPlaces = [];
    }
    isLoading = false;
    notifyListeners();
    return _nearbyPlaces;
  }

  Future<void> searchTextPlaces(String query) async {
    isLoading = true;
    notifyListeners();
    try {
      _textSearchResults = await placeController.textSearch(query);
      error = '';
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<DetailsResult> getPlaceDetails(String placeId) async {
    try {
      return await placeController.getPlaceDetails(placeId);
    } catch (error) {
      print('Error getting place details: $error');
      throw error;
    }
  }

  Future<List<Photo>> getPlacePhotos(String placeId) async {
    try {
      return await placeController.getPlacePhotos(placeId);
    } catch (error) {
      print('Error getting place photos: $error');
      throw error;
    }
  }

  Future<void> initCurrentLocation() async {
    try {
      _currentPosition = await placeController.getCurrentPosition();
      notifyListeners();
    } catch (error) {
      print('Error getting current position: $error');
      throw error;
    }
  }
}
