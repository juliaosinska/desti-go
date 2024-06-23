class Trip {
  String? id; // Make id nullable
  final String userId;
  final String destination;
  final DateTime departureDate;
  final DateTime returnDate;

  Trip({
    this.id,
    required this.userId,
    required this.destination,
    required this.departureDate,
    required this.returnDate,
  });
}
