
  
import 'package:intl/intl.dart';

class Note {
  final int? id;
  final String title;
  final String description;
  final int timestamp;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.timestamp,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'timestamp': timestamp,
    };
  }

  factory Note.fromMap(Map<String, dynamic> dbData) {
    return Note(
      id: dbData['id'],
      title: dbData['title'],
      description: dbData['description'],
      timestamp: dbData['timestamp'],
    );
  }

  String get formattedDate {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('yyyy-MM-dd – hh:mm a').format(dateTime).toString();
  }
}
