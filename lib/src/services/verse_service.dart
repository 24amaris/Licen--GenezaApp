import 'package:cloud_firestore/cloud_firestore.dart';

class DailyVerse {
  final String text;
  final String reference;

  DailyVerse({required this.text, required this.reference});
}

class VerseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Returnează versetul pentru ziua de azi.
  /// ID-ul documentului în Firestore = data în format YYYY-MM-DD (ex: "2026-03-10")
  Future<DailyVerse?> getTodaysVerse() async {
    final now = DateTime.now();
    final dateId =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final doc = await _db.collection('verses').doc(dateId).get();

    if (!doc.exists || doc.data() == null) return null;

    final data = doc.data()!;
    return DailyVerse(
      text: data['text'] ?? '',
      reference: data['reference'] ?? '',
    );
  }
}
