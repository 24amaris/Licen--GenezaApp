import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  AppUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    // We'll fetch full data from Firestore in getUserData
    return null;
  }

  // Check if user is logged in
  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  // Get current Firebase user
  User? get firebaseUser => _firebaseAuth.currentUser;

  // Sign up with email and password
  Future<AppUser?> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) return null;

      // Update display name
      await user.updateDisplayName(displayName);
      await user.reload();

      // Create user document in Firestore
      final appUser = AppUser(
        id: user.uid,
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.uid).set(appUser.toJson());

      return appUser;
    } on FirebaseAuthException catch (e) {
      print('Sign up error: ${e.message}');
      rethrow;
    }
  }

  // Login with email and password
  Future<AppUser?> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) return null;

      // Fetch user data from Firestore
      return await getUserData(user.uid);
    } on FirebaseAuthException catch (e) {
      print('Login error: ${e.message}');
      rethrow;
    }
  }

  // Get user data from Firestore
  Future<AppUser?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return AppUser.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String uid,
    String? displayName,
    String? phoneNumber,
    String? church,
    String? bio,
    String? avatarUrl,
    List<String>? departments,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (displayName != null) updates['displayName'] = displayName;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (church != null) updates['church'] = church;
      if (bio != null) updates['bio'] = bio;
      if (avatarUrl != null) updates['avatarUrl'] = avatarUrl;
      if (departments != null) updates['departments'] = departments;
      updates['updatedAt'] = DateTime.now().toIso8601String();

      await _firestore.collection('users').doc(uid).set(updates, SetOptions(merge: true));
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  // Update watched sermons
  Future<void> addWatchedSermon(String uid, String sermonId) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'watchedSermonIds': FieldValue.arrayUnion([sermonId]),
      });
    } catch (e) {
      print('Error adding watched sermon: $e');
    }
  }

  // Add favorite verse
  Future<void> addFavoriteVerse(String uid, String verseId) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'favoriteVerses': FieldValue.arrayUnion([verseId]),
      });
    } catch (e) {
      print('Error adding favorite verse: $e');
    }
  }

  // Remove favorite verse
  Future<void> removeFavoriteVerse(String uid, String verseId) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'favoriteVerses': FieldValue.arrayRemove([verseId]),
      });
    } catch (e) {
      print('Error removing favorite verse: $e');
    }
  }

  // Toggle notifications
  Future<void> toggleNotifications(String uid, bool enabled) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'notificationsEnabled': enabled,
      });
    } catch (e) {
      print('Error toggling notifications: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  // Delete account
  Future<void> deleteAccount(String uid) async {
    try {
      // Delete user document from Firestore
      await _firestore.collection('users').doc(uid).delete();
      // Delete Firebase Auth account
      await _firebaseAuth.currentUser?.delete();
    } catch (e) {
      print('Delete account error: $e');
      rethrow;
    }
  }

  // Password reset
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Password reset error: $e');
      rethrow;
    }
  }
}
