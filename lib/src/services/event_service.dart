import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_item.dart';

class EventService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Stream de evenimente din Firestore, ordonate după dată
  Stream<List<EventItem>> getEventsStream() {
    return _db
        .collection('events')
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => _fromFirestore(doc.id, doc.data()))
            .toList());
  }

  EventItem _fromFirestore(String id, Map<String, dynamic> data) {
    String dateStr = '';
    String timeStr = '';

    final dateValue = data['date'];
    if (dateValue is Timestamp) {
      final dt = dateValue.toDate().toLocal();
      const months = [
        'Ianuarie', 'Februarie', 'Martie', 'Aprilie', 'Mai', 'Iunie',
        'Iulie', 'August', 'Septembrie', 'Octombrie', 'Noiembrie', 'Decembrie'
      ];
      dateStr = '${dt.day} ${months[dt.month - 1]} ${dt.year}';
      timeStr =
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } else if (dateValue is String) {
      dateStr = dateValue;
      timeStr = data['time'] ?? '';
    }

    return EventItem(
      id: id,
      title: data['title'] ?? '',
      date: dateStr,
      time: timeStr,
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      registrationLink:
          data['registrationLink'] ?? 'https://genezaoradea.ro',
      cost: data['cost'],
      whatToBring: data['whatToBring'] != null
          ? List<String>.from(data['whatToBring'])
          : null,
    );
  }
}
