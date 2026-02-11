/// Model pentru o serie de predici
class SermonSeries {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<SermonItem> sermons;

  const SermonSeries({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.sermons,
  });
}

/// Model pentru o predică individuală
class SermonItem {
  final String id;
  final String title;
  final String date;
  final String speaker;
  final String youtubeUrl;
  final String imageUrl;
  final String seriesId;
  final String? description;

  const SermonItem({
    required this.id,
    required this.title,
    required this.date,
    required this.speaker,
    required this.youtubeUrl,
    required this.imageUrl,
    required this.seriesId,
    this.description,
  });
}

/// Model pentru o notiță la o predică
class SermonNote {
  final String id;
  final String sermonId;
  final String sermonTitle;
  final String noteText;
  final DateTime createdAt;

  SermonNote({
    required this.id,
    required this.sermonId,
    required this.sermonTitle,
    required this.noteText,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'sermonId': sermonId,
    'sermonTitle': sermonTitle,
    'noteText': noteText,
    'createdAt': createdAt.toIso8601String(),
  };

  factory SermonNote.fromJson(Map<String, dynamic> json) => SermonNote(
    id: json['id'] as String,
    sermonId: json['sermonId'] as String,
    sermonTitle: json['sermonTitle'] as String,
    noteText: json['noteText'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}
