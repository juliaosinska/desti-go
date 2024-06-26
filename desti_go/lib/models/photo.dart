class Photo {
  final String photoReference;

  Photo({
    required this.photoReference,
  });

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      photoReference: map['photo_reference'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'photo_reference': photoReference,
    };
  }
}
