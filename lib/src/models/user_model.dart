class AppUser {
  final String id;
  final String email;
  final String displayName;
  final String? phoneNumber;
  final String? church;
  final String? bio;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> watchedSermonIds;
  final List<String> favoriteVerses;
  final bool notificationsEnabled;
  final List<String> departments;

  AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.phoneNumber,
    this.church,
    this.bio,
    this.avatarUrl,
    required this.createdAt,
    this.updatedAt,
    this.watchedSermonIds = const [],
    this.favoriteVerses = const [],
    this.notificationsEnabled = true,
    this.departments = const [],
  });

  // Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'church': church,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'watchedSermonIds': watchedSermonIds,
      'favoriteVerses': favoriteVerses,
      'notificationsEnabled': notificationsEnabled,
      'departments': departments,
    };
  }

  // Create from JSON
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? '',
      phoneNumber: json['phoneNumber'],
      church: json['church'],
      bio: json['bio'],
      avatarUrl: json['avatarUrl'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      watchedSermonIds: List<String>.from(json['watchedSermonIds'] ?? []),
      favoriteVerses: List<String>.from(json['favoriteVerses'] ?? []),
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      departments: List<String>.from(json['departments'] ?? []),
    );
  }

  // Copy with
  AppUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? church,
    String? bio,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? watchedSermonIds,
    List<String>? favoriteVerses,
    bool? notificationsEnabled,
    List<String>? departments,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      church: church ?? this.church,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      watchedSermonIds: watchedSermonIds ?? this.watchedSermonIds,
      favoriteVerses: favoriteVerses ?? this.favoriteVerses,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      departments: departments ?? this.departments,
    );
  }
}
