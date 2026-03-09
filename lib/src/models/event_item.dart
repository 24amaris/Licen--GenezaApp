
/// Model simplificat pentru evenimente
class EventItem {
  final String id;
  final String title;
  final String date;              // Ex: "24 Decembrie"
  final String time;              // Ex: "19:00"
  final String location;          // Ex: "Biserica Geneza Oradea"
  final String description;       // Descriere completă (pentru pagina de detalii)
  final String? imageUrl;         // Imagine eveniment
  final String registrationLink;  // Link Google Forms
  final String? cost;             // Cost (opțional)
  final List<String>? whatToBring; // Ce să aduci (opțional)

  EventItem({
    String? id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    this.imageUrl,
    this.registrationLink = 'https://genezaoradea.ro',
    this.cost,
    this.whatToBring,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  /// Convert to Map (pentru Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'location': location,
      'description': description,
      'imageUrl': imageUrl,
      'registrationLink': registrationLink,
      'cost': cost,
      'whatToBring': whatToBring,
    };
  }

  /// Create from Map (din Firebase)
  factory EventItem.fromMap(Map<String, dynamic> map) {
    return EventItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'],
      registrationLink: map['registrationLink'] ?? 'https://genezaoradea.ro',
      cost: map['cost'],
      whatToBring: map['whatToBring'] != null 
        ? List<String>.from(map['whatToBring']) 
        : null,
    );
  }

  /// Copy with
  EventItem copyWith({
    String? id,
    String? title,
    String? date,
    String? time,
    String? location,
    String? description,
    String? imageUrl,
    String? registrationLink,
    String? cost,
    List<String>? whatToBring,
  }) {
    return EventItem(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      registrationLink: registrationLink ?? this.registrationLink,
      cost: cost ?? this.cost,
      whatToBring: whatToBring ?? this.whatToBring,
    );
  }
}