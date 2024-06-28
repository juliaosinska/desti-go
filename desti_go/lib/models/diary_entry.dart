import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryEntry {
  final String id;
  final String? text;
  final String? imageURL;
  final DateTime timestamp;

  DiaryEntry({
    required this.id,
    this.text,
    this.imageURL,
    required this.timestamp,
  });

  factory DiaryEntry.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return DiaryEntry(
      id: doc.id,
      text: data['text'],
      imageURL: data['imageURL'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
