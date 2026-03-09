import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../home/widgets/blurred_background.dart';

class UserProfilePage extends StatefulWidget {
  final AppUser user;

  const UserProfilePage({super.key, required this.user});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);

  static const List<String> _allDepartments = [
    'Muzică / Worship',
    'Tineret',
    'Copii',
    'Tehnic',
    'Intercessiune',
    'Evanghelizare',
    'Administrație',
    'Pastorație',
    'Grupuri mici',
    'Social',
  ];

  final AuthService _authService = AuthService();
  late AppUser _user;
  bool _isEditing = false;
  bool _isLoading = false;
  String? _profileImagePath;

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _churchController;
  late TextEditingController _bioController;
  late List<String> _selectedDepartments;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _selectedDepartments = List<String>.from(_user.departments);
    _initializeControllers();
    _loadProfileImage();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: _user.displayName);
    _phoneController = TextEditingController(text: _user.phoneNumber ?? '');
    _churchController = TextEditingController(text: _user.church ?? '');
    _bioController = TextEditingController(text: _user.bio ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _churchController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profile_imagePath_${_user.id}');
    if (mounted) {
      setState(() => _profileImagePath = path);
    }
  }

  Future<void> _pickImage() async {
    final choice = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: const Color(0xFF1A2A3A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Alege poza',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: lightGrey,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_library, color: beige),
                title: Text('Galerie', style: GoogleFonts.inter(color: lightGrey)),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: beige),
                title: Text('Cameră', style: GoogleFonts.inter(color: lightGrey)),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );

    if (choice == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: choice, imageQuality: 80);
    if (picked == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_imagePath_${_user.id}', picked.path);

    if (mounted) {
      setState(() => _profileImagePath = picked.path);
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    try {
      await _authService.updateUserProfile(
        uid: _user.id,
        displayName: _nameController.text,
        phoneNumber: _phoneController.text.isEmpty ? null : _phoneController.text,
        church: _churchController.text.isEmpty ? null : _churchController.text,
        bio: _bioController.text.isEmpty ? null : _bioController.text,
        departments: _selectedDepartments,
      );

      if (mounted) {
        setState(() {
          _isEditing = false;
          _user = _user.copyWith(
            displayName: _nameController.text,
            phoneNumber: _phoneController.text.isEmpty ? null : _phoneController.text,
            church: _churchController.text.isEmpty ? null : _churchController.text,
            bio: _bioController.text.isEmpty ? null : _bioController.text,
            departments: _selectedDepartments,
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil actualizat cu succes!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Eroare: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ieși din cont?', style: GoogleFonts.inter(color: navy)),
        content: Text('Ești sigur că vrei să ieși?', style: GoogleFonts.inter(color: navy)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Anulează'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ieși'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlurredBackground(
        blurAmount: 15.0,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: navy.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: lightGrey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Profil',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: lightGrey,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Avatar tappable
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: navy.withValues(alpha: 0.3),
                            border: Border.all(color: beige, width: 2),
                          ),
                          child: _profileImagePath != null &&
                                  File(_profileImagePath!).existsSync()
                              ? ClipOval(
                                  child: Image.file(
                                    File(_profileImagePath!),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : _user.avatarUrl != null
                                  ? ClipOval(
                                      child: Image.network(
                                        _user.avatarUrl!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: beige,
                                    ),
                        ),
                        // Buton cameră
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: navy,
                              shape: BoxShape.circle,
                              border: Border.all(color: lightGrey, width: 1.5),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: lightGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Edit mode toggle
                if (!_isEditing)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => setState(() => _isEditing = true),
                      icon: const Icon(Icons.edit),
                      label: const Text('Editează'),
                      style: TextButton.styleFrom(foregroundColor: beige),
                    ),
                  ),

                // Nume
                _buildLabel('Nume'),
                const SizedBox(height: 8),
                _buildTextField(_nameController, readOnly: !_isEditing),

                const SizedBox(height: 16),

                // Email (read-only)
                _buildLabel('Email'),
                const SizedBox(height: 8),
                _buildTextField(
                  TextEditingController(text: _user.email),
                  readOnly: true,
                  dimmed: true,
                ),

                const SizedBox(height: 16),

                // Telefon
                _buildLabel('Telefon'),
                const SizedBox(height: 8),
                _buildTextField(
                  _phoneController,
                  readOnly: !_isEditing,
                  hint: '+40...',
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 16),

                // Biserica
                _buildLabel('Biserica'),
                const SizedBox(height: 8),
                _buildTextField(
                  _churchController,
                  readOnly: !_isEditing,
                  hint: 'Biserica ta',
                ),

                const SizedBox(height: 16),

                // Bio
                _buildLabel('Despre tine'),
                const SizedBox(height: 8),
                _buildTextField(
                  _bioController,
                  readOnly: !_isEditing,
                  hint: 'Spune-ne ceva despre tine...',
                  maxLines: 4,
                ),

                const SizedBox(height: 16),

                // Departamente
                _buildLabel('Departamente în care slujesc'),
                const SizedBox(height: 8),
                _buildDepartmentsSection(),

                const SizedBox(height: 32),

                // Action buttons (edit mode)
                if (_isEditing)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _isEditing = false;
                              _selectedDepartments = List<String>.from(_user.departments);
                            });
                            _initializeControllers();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: beige,
                            side: const BorderSide(color: beige),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Anulează',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: navy,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFFF1EFEC),
                                    ),
                                  ),
                                )
                              : Text(
                                  'Salvează',
                                  style: GoogleFonts.inter(
                                    color: lightGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 32),

                // Logout button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    label: Text(
                      'Ieși din cont',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: beige,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    bool readOnly = false,
    bool dimmed = false,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: navy.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: navy.withValues(alpha: 0.3)),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: dimmed ? beige.withValues(alpha: 0.6) : lightGrey,
          height: maxLines > 1 ? 1.6 : null,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: beige.withValues(alpha: 0.4)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          filled: false,
        ),
      ),
    );
  }

  Widget _buildDepartmentsSection() {
    if (!_isEditing) {
      // View mode: chips
      if (_user.departments.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: navy.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: navy.withValues(alpha: 0.3)),
          ),
          child: Text(
            'Niciun departament selectat',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: beige.withValues(alpha: 0.5),
            ),
          ),
        );
      }
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _user.departments
            .map(
              (d) => Chip(
                label: Text(
                  d,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: lightGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: navy.withValues(alpha: 0.6),
                side: BorderSide(color: navy.withValues(alpha: 0.8)),
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
            )
            .toList(),
      );
    }

    // Edit mode: checkboxes
    return Container(
      decoration: BoxDecoration(
        color: navy.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: navy.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: _allDepartments.map((dept) {
          final selected = _selectedDepartments.contains(dept);
          return CheckboxListTile(
            value: selected,
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  _selectedDepartments.add(dept);
                } else {
                  _selectedDepartments.remove(dept);
                }
              });
            },
            title: Text(
              dept,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: lightGrey,
              ),
            ),
            activeColor: navy,
            checkColor: lightGrey,
            side: BorderSide(color: beige.withValues(alpha: 0.5)),
            dense: true,
            controlAffinity: ListTileControlAffinity.leading,
          );
        }).toList(),
      ),
    );
  }
}
