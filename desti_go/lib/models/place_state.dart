import 'package:desti_go/models/place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';

class PlaceState {
  final Map<DateTime, List<Place>> places;
  final List<AutocompletePrediction> autocompletePredictions;
  final List<SearchResult> nearbyPlaces;
  final List<SearchResult> textSearchResults;
  final bool isLoading;
  final String error;
  final Position? currentPosition;

  PlaceState({
    required this.places,
    required this.autocompletePredictions,
    required this.nearbyPlaces,
    required this.textSearchResults,
    required this.isLoading,
    required this.error,
    this.currentPosition,
  });

  PlaceState copyWith({
    Map<DateTime, List<Place>>? places,
    List<AutocompletePrediction>? autocompletePredictions,
    List<SearchResult>? nearbyPlaces,
    List<SearchResult>? textSearchResults,
    bool? isLoading,
    String? error,
    Position? currentPosition,
  }) {
    return PlaceState(
      places: places ?? this.places,
      autocompletePredictions: autocompletePredictions ?? this.autocompletePredictions,
      nearbyPlaces: nearbyPlaces ?? this.nearbyPlaces,
      textSearchResults: textSearchResults ?? this.textSearchResults,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentPosition: currentPosition ?? this.currentPosition,
    );
  }
}