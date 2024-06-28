import 'package:desti_go/models/photo.dart';

class Place {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final List<Photo>? photos;

  Place({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.photos,
  });

  Place copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    List<Photo>? photos,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      photos: photos ?? this.photos,
    );
  }

  factory Place.fromMap(String id, Map<String, dynamic> data) {
    return Place(
      id: id,
      name: data['name'],
      address: data['address'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      photos: (data['photos'] as List<dynamic>?)
          ?.map((photoData) => Photo.fromMap(photoData))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'photos': photos?.map((photo) => photo.toMap()).toList(),
    };
  }
}
