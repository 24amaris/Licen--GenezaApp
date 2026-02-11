import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sermon_item.dart';

class SermonService {
  static final SermonService _instance = SermonService._internal();
  factory SermonService() => _instance;
  SermonService._internal();

  String get _userSuffix {
    final user = FirebaseAuth.instance.currentUser;
    return user != null ? user.uid : 'guest';
  }

  String get _notesKey => 'sermon_notes_$_userSuffix';
  String get _watchedKey => 'sermon_watched_$_userSuffix';

  /// Returnează toate seriile de predici
  List<SermonSeries> getAllSeries() {
    return [
      SermonSeries(
        id: 'series_1',
        title: 'Geneza - Începuturile',
        description: 'O serie de predici prin cartea Genezei, explorând începuturile creației, '
            'căderea omului și planul lui Dumnezeu de răscumpărare.',
        imageUrl: 'assets/images/event1.jpg',
        sermons: [
          const SermonItem(
            id: 'sermon_1_1',
            title: 'La început - Dumnezeu',
            date: '5 Ianuarie 2025',
            speaker: 'Pastor Dorel Coraș',
            youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
            imageUrl: 'assets/images/event1.jpg',
            seriesId: 'series_1',
            description: 'Descoperim ce ne spune Geneza 1 despre caracterul lui Dumnezeu '
                'și despre rolul nostru în creație.',
          ),
          const SermonItem(
            id: 'sermon_1_2',
            title: 'Creați după chipul Lui',
            date: '12 Ianuarie 2025',
            speaker: 'Pastor Dorel Coraș',
            youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
            imageUrl: 'assets/images/event1.jpg',
            seriesId: 'series_1',
            description: 'Ce înseamnă să fim creați după chipul și asemănarea lui Dumnezeu? '
                'Cum ne definește acest adevăr identitatea?',
          ),
          const SermonItem(
            id: 'sermon_1_3',
            title: 'Căderea și promisiunea',
            date: '19 Ianuarie 2025',
            speaker: 'Pastor Dorel Coraș',
            youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
            imageUrl: 'assets/images/event1.jpg',
            seriesId: 'series_1',
            description: 'Geneza 3 - Căderea omenirii în păcat și prima promisiune de răscumpărare.',
          ),
          const SermonItem(
            id: 'sermon_1_4',
            title: 'Credința lui Avraam',
            date: '26 Ianuarie 2025',
            speaker: 'Pastor Dorel Coraș',
            youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
            imageUrl: 'assets/images/event1.jpg',
            seriesId: 'series_1',
            description: 'Chemarea lui Avraam și lecții despre credință și ascultare.',
          ),
        ],
      ),
      SermonSeries(
        id: 'series_2',
        title: 'Viața în Hristos',
        description: 'Explorăm ce înseamnă să trăim o viață transformată prin credința în Isus Hristos, '
            'bazată pe epistolele Noului Testament.',
        imageUrl: 'assets/images/event2.jpg',
        sermons: [
          const SermonItem(
            id: 'sermon_2_1',
            title: 'O nouă identitate',
            date: '2 Februarie 2025',
            speaker: 'Pastor Dorel Coraș',
            youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
            imageUrl: 'assets/images/event2.jpg',
            seriesId: 'series_2',
            description: 'Cine suntem noi în Hristos? Descoperim identitatea noastră spirituală.',
          ),
          const SermonItem(
            id: 'sermon_2_2',
            title: 'Roada Duhului',
            date: '9 Februarie 2025',
            speaker: 'Pastor Dorel Coraș',
            youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
            imageUrl: 'assets/images/event2.jpg',
            seriesId: 'series_2',
            description: 'Galateni 5 - Cum se manifestă Duhul Sfânt în viața noastră de zi cu zi.',
          ),
          const SermonItem(
            id: 'sermon_2_3',
            title: 'Harul care transformă',
            date: '16 Februarie 2025',
            speaker: 'Pastor Dorel Coraș',
            youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
            imageUrl: 'assets/images/event2.jpg',
            seriesId: 'series_2',
            description: 'Cum ne transformă harul lui Dumnezeu din interior spre exterior.',
          ),
        ],
      ),
      SermonSeries(
        id: 'series_3',
        title: 'Rugăciunea care schimbă',
        description: 'O serie despre puterea rugăciunii și cum putem dezvolta o viață '
            'de rugăciune mai profundă și mai autentică.',
        imageUrl: 'assets/images/event3.jpg',
        sermons: [
          const SermonItem(
            id: 'sermon_3_1',
            title: 'De ce ne rugăm?',
            date: '2 Martie 2025',
            speaker: 'Pastor Dorel Coraș',
            youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
            imageUrl: 'assets/images/event3.jpg',
            seriesId: 'series_3',
            description: 'Fundamentele rugăciunii - ce este rugăciunea și de ce este esențială.',
          ),
          const SermonItem(
            id: 'sermon_3_2',
            title: 'Rugăciunea Tatăl Nostru',
            date: '9 Martie 2025',
            speaker: 'Pastor Dorel Coraș',
            youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
            imageUrl: 'assets/images/event3.jpg',
            seriesId: 'series_3',
            description: 'Isus ne învață cum să ne rugăm - un model pentru viața noastră de rugăciune.',
          ),
          const SermonItem(
            id: 'sermon_3_3',
            title: 'Rugăciunea de mijlocire',
            date: '16 Martie 2025',
            speaker: 'Pastor Dorel Coraș',
            youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
            imageUrl: 'assets/images/event3.jpg',
            seriesId: 'series_3',
            description: 'Puterea rugăciunii pentru alții și cum să fim mijlocitori credincioși.',
          ),
        ],
      ),
    ];
  }

  /// Returnează o serie după ID
  SermonSeries? getSeriesById(String seriesId) {
    final allSeries = getAllSeries();
    try {
      return allSeries.firstWhere((s) => s.id == seriesId);
    } catch (_) {
      return null;
    }
  }

  // ========== WATCHED MANAGEMENT ==========

  /// Marchează o predică ca vizionată
  Future<void> markAsWatched(String sermonId) async {
    final prefs = await SharedPreferences.getInstance();
    final watched = prefs.getStringList(_watchedKey) ?? [];
    if (!watched.contains(sermonId)) {
      watched.add(sermonId);
      await prefs.setStringList(_watchedKey, watched);
    }
  }

  /// Verifică dacă o predică a fost vizionată
  Future<bool> isWatched(String sermonId) async {
    final prefs = await SharedPreferences.getInstance();
    final watched = prefs.getStringList(_watchedKey) ?? [];
    return watched.contains(sermonId);
  }

  /// Returnează set-ul de ID-uri vizionate
  Future<Set<String>> getWatchedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final watched = prefs.getStringList(_watchedKey) ?? [];
    return watched.toSet();
  }

  /// Găsește o predică după ID (din toate seriile)
  SermonItem? getSermonById(String sermonId) {
    for (final series in getAllSeries()) {
      for (final sermon in series.sermons) {
        if (sermon.id == sermonId) {
          return sermon;
        }
      }
    }
    return null;
  }

  // ========== NOTES MANAGEMENT ==========

  /// Salvează o notiță pentru o predică
  Future<void> saveNote(SermonNote note) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await getAllNotes();

    // Verificăm dacă există deja o notiță cu același ID
    final existingIndex = notes.indexWhere((n) => n.id == note.id);
    if (existingIndex != -1) {
      notes[existingIndex] = note;
    } else {
      notes.add(note);
    }

    final jsonList = notes.map((n) => jsonEncode(n.toJson())).toList();
    await prefs.setStringList(_notesKey, jsonList);
  }

  /// Returnează toate notițele
  Future<List<SermonNote>> getAllNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_notesKey) ?? [];

    return jsonList.map((jsonStr) {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return SermonNote.fromJson(map);
    }).toList();
  }

  /// Returnează notițele pentru o predică specifică
  Future<List<SermonNote>> getNotesForSermon(String sermonId) async {
    final allNotes = await getAllNotes();
    return allNotes.where((n) => n.sermonId == sermonId).toList();
  }

  /// Șterge o notiță
  Future<void> deleteNote(String noteId) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await getAllNotes();
    notes.removeWhere((n) => n.id == noteId);

    final jsonList = notes.map((n) => jsonEncode(n.toJson())).toList();
    await prefs.setStringList(_notesKey, jsonList);
  }

  /// Actualizează textul și/sau titlul unei notițe
  Future<void> updateNote(String noteId, String newText, {String? newTitle}) async {
    final notes = await getAllNotes();
    final index = notes.indexWhere((n) => n.id == noteId);
    if (index != -1) {
      final old = notes[index];
      notes[index] = SermonNote(
        id: old.id,
        sermonId: old.sermonId,
        sermonTitle: newTitle ?? old.sermonTitle,
        noteText: newText,
        createdAt: old.createdAt,
      );

      final prefs = await SharedPreferences.getInstance();
      final jsonList = notes.map((n) => jsonEncode(n.toJson())).toList();
      await prefs.setStringList(_notesKey, jsonList);
    }
  }
}
