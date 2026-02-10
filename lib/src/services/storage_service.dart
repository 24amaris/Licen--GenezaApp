import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';

/// Service pentru upload-uri în Firebase Storage
/// FUTURE: Va fi folosit în Admin Panel pentru upload poze evenimente
class StorageService {
  // Singleton pattern
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // ========================================================================
  // FUTURE: Upload imagine eveniment în Firebase Storage
  // ========================================================================
  
  /// Upload-ează o imagine pentru eveniment și returnează URL-ul
  /// 
  /// Folosit în Admin Panel când admin-ul creează/editează un eveniment
  /// 
  /// Steps:
  /// 1. Admin selectează imaginea din galerie/cameră
  /// 2. Compresia imaginii (opțional, pentru optimizare)
  /// 3. Upload în Firebase Storage la path: events/{eventId}.jpg
  /// 4. Returnează URL-ul public al imaginii
  /// 
  /// Example usage:
  /// ```dart
  /// final imageUrl = await StorageService().uploadEventImage(
  ///   eventId: 'event_123',
  ///   imageFile: selectedFile,
  /// );
  /// ```
  Future<String?> uploadEventImage({
    required String eventId,
    required File imageFile,
  }) async {
    // TODO: Implementează când ai Firebase Storage configurat
    
    // try {
    //   // Reference la Firebase Storage
    //   final storageRef = FirebaseStorage.instance
    //     .ref()
    //     .child('events')
    //     .child('$eventId.jpg');
    //   
    //   // Upload file
    //   final uploadTask = storageRef.putFile(imageFile);
    //   
    //   // Așteaptă finalizarea upload-ului
    //   final snapshot = await uploadTask;
    //   
    //   // Obține URL-ul public
    //   final downloadUrl = await snapshot.ref.getDownloadURL();
    //   
    //   return downloadUrl;
    // } catch (e) {
    //   print('Error uploading image: $e');
    //   return null;
    // }
    
    // CURRENT: Returnează un placeholder
    return 'https://images.unsplash.com/photo-1766145605687-fde866d32ae1?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxM3x8fGVufDB8fHx8fA%3D%3D';
  }

  /// Șterge imaginea unui eveniment din Firebase Storage
  Future<bool> deleteEventImage(String eventId) async {
    // TODO: Implementează în viitor
    
    // try {
    //   final storageRef = FirebaseStorage.instance
    //     .ref()
    //     .child('events')
    //     .child('$eventId.jpg');
    //   
    //   await storageRef.delete();
    //   return true;
    // } catch (e) {
    //   print('Error deleting image: $e');
    //   return false;
    // }
    
    return true;
  }

  /// Selectează imagine din galerie
  /// Folosește image_picker package
  Future<File?> pickImageFromGallery() async {
    // TODO: Implementează când adaugi image_picker
    
    // final picker = ImagePicker();
    // final pickedFile = await picker.pickImage(
    //   source: ImageSource.gallery,
    //   maxWidth: 1920,
    //   maxHeight: 1080,
    //   imageQuality: 85,
    // );
    // 
    // if (pickedFile != null) {
    //   return File(pickedFile.path);
    // }
    
    return null;
  }

  /// Selectează imagine din cameră
  Future<File?> pickImageFromCamera() async {
    // TODO: Implementează când adaugi image_picker
    
    // final picker = ImagePicker();
    // final pickedFile = await picker.pickImage(
    //   source: ImageSource.camera,
    //   maxWidth: 1920,
    //   maxHeight: 1080,
    //   imageQuality: 85,
    // );
    // 
    // if (pickedFile != null) {
    //   return File(pickedFile.path);
    // }
    
    return null;
  }

  /// Compresie imagine (pentru optimizare)
  /// Folosește flutter_image_compress package
  Future<File?> compressImage(File imageFile) async {
    // TODO: Implementează pentru optimizare (opțional)
    
    // final compressedImage = await FlutterImageCompress.compressAndGetFile(
    //   imageFile.absolute.path,
    //   '${imageFile.parent.path}/compressed_${imageFile.uri.pathSegments.last}',
    //   quality: 85,
    //   minWidth: 1920,
    //   minHeight: 1080,
    // );
    // 
    // return compressedImage != null ? File(compressedImage.path) : null;
    
    return imageFile;
  }
}

// ========================================================================
// EXAMPLE: Cum va fi folosit în Admin Panel (viitor)
// ========================================================================

/// Widget exemplu pentru Admin Panel - Creare Eveniment
/// 
/// ```dart
/// class CreateEventPage extends StatefulWidget {
///   @override
///   State<CreateEventPage> createState() => _CreateEventPageState();
/// }
/// 
/// class _CreateEventPageState extends State<CreateEventPage> {
///   File? _selectedImage;
///   final _storageService = StorageService();
///   final _eventService = EventService();
///   
///   Future<void> _pickImage() async {
///     final image = await _storageService.pickImageFromGallery();
///     setState(() => _selectedImage = image);
///   }
///   
///   Future<void> _saveEvent() async {
///     if (_selectedImage == null) {
///       // Arată eroare: "Te rog adaugă o imagine"
///       return;
///     }
///     
///     // 1. Upload imagine în Firebase Storage
///     final imageUrl = await _storageService.uploadEventImage(
///       eventId: 'event_${DateTime.now().millisecondsSinceEpoch}',
///       imageFile: _selectedImage!,
///     );
///     
///     if (imageUrl == null) {
///       // Arată eroare: "Eroare la upload imagine"
///       return;
///     }
///     
///     // 2. Creează evenimentul cu URL-ul imaginii
///     final event = EventItem(
///       title: _titleController.text,
///       date: _selectedDate,
///       // ... alte câmpuri
///       imageUrl: imageUrl, // ← URL-ul imaginii din Firebase Storage
///     );
///     
///     // 3. Salvează evenimentul în Firestore
///     final success = await _eventService.createEvent(event);
///     
///     if (success) {
///       // Success! Navigare înapoi la dashboard
///       Navigator.pop(context);
///     }
///   }
///   
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(title: Text('Creare Eveniment')),
///       body: Column(
///         children: [
///           // Preview imagine selectată
///           if (_selectedImage != null)
///             Image.file(_selectedImage!, height: 200),
///           
///           // Buton selectare imagine
///           ElevatedButton.icon(
///             onPressed: _pickImage,
///             icon: Icon(Icons.image),
///             label: Text('Selectează Afiș'),
///           ),
///           
///           // Formular...
///           TextField(
///             controller: _titleController,
///             decoration: InputDecoration(labelText: 'Titlu'),
///           ),
///           
///           // Buton salvare
///           ElevatedButton(
///             onPressed: _saveEvent,
///             child: Text('Salvează Eveniment'),
///           ),
///         ],
///       ),
///     );
///   }
/// }
/// ```