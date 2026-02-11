import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../../auth/login_screen.dart';
import '../contact_page.dart';
import '../profile_page.dart';
import '../notifications_page.dart';
import '../family_page.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  // Paleta de culori
  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);
  static const Color deepBlack = Color(0xFF030303);

  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  // ✅ ÎNCARCĂ POZA DE PROFIL
  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImagePath = prefs.getString('profile_imagePath');
    });
  }

  // ✅ REFRESH CÂND TE ÎNTORCI DIN PROFILE PAGE
  void _openProfilePage() async {
    Navigator.of(context).pop();
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
    // După ce revii, reîncarcă poza
    _loadProfileImage();
  }

  Future<bool> _isGuest() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_guest') ?? false;
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: navy,
        title: Text(
          'Deconectare',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: lightGrey,
          ),
        ),
        content: Text(
          'Ești sigur că vrei să te deconectezi?',
          style: GoogleFonts.inter(color: beige),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Anulează',
              style: GoogleFonts.inter(color: beige),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: Text(
              'Deconectează-te',
              style: GoogleFonts.inter(color: lightGrey),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await FirebaseAuth.instance.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('is_guest');

      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  Future<void> _handleDeleteAccount(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: navy,
        title: Row(
          children: [
            const Icon(Icons.warning, color: Color(0xFFEF4444)),
            const SizedBox(width: 12),
            Text(
              'Atenție!',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: lightGrey,
              ),
            ),
          ],
        ),
        content: Text(
          'Această acțiune este PERMANENTĂ și va șterge toate datele tale. Ești absolut sigur?',
          style: GoogleFonts.inter(color: beige),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Anulează',
              style: GoogleFonts.inter(color: beige),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: Text(
              'Șterge',
              style: GoogleFonts.inter(color: lightGrey),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Funcția de ștergere cont va fi implementată în curând',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: navy,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: deepBlack,
      child: SafeArea(
        child: FutureBuilder<bool>(
          future: _isGuest(),
          builder: (context, snapshot) {
            final isGuest = snapshot.data ?? false;
            final user = FirebaseAuth.instance.currentUser;

            return Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.3),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logoG.png',
                      width: 170,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isGuest && user != null) ...[
                          // Utilizator autentificat
                          _buildProfileCard(user, context),
                          const SizedBox(height: 24),
                          _buildMenuItem(
                            icon: Icons.info_outline,
                            title: 'Despre',
                            onTap: _openProfilePage,  // ✅ Folosește funcția nouă
                          ),
                          const SizedBox(height: 12),
                          _buildMenuItem(
                            icon: Icons.notifications_outlined,
                            title: 'Notificări',
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const NotificationsPage()),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildMenuItem(
                            icon: Icons.family_restroom,
                            title: 'Familia mea',
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const FamilyPage()),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildMenuItem(
                            icon: Icons.phone_outlined,
                            title: 'Contact',
                            subtitle: 'Contactează-ne',
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ContactPage()),
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                          // Logout
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () => _handleLogout(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: navy.withValues(alpha: 0.3),
                                foregroundColor: lightGrey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Deconectare',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () => _handleDeleteAccount(context),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFFEF4444),
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Șterge cont',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFEF4444),
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          // Vizitator (guest)
                          _buildMenuItem(
                            icon: Icons.phone_outlined,
                            title: 'Contact',
                            subtitle: 'Contactează-ne',
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ContactPage()),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: navy,
                                foregroundColor: lightGrey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Creează cont / Login',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileCard(User user, BuildContext context) {
    return InkWell(
      onTap: _openProfilePage,  // ✅ Folosește funcția nouă
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: navy.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: navy.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Avatar cu poză sau inițiale
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: navy,
                border: Border.all(color: lightGrey, width: 2),
              ),
              child: _profileImagePath != null && File(_profileImagePath!).existsSync()
                  ? ClipOval(
                      child: Image.file(
                        File(_profileImagePath!),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: Text(
                        user.displayName?.substring(0, 1).toUpperCase() ??
                            user.email?.substring(0, 1).toUpperCase() ??
                            'U',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: lightGrey,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.displayName ?? 'Utilizator',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: lightGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email ?? '',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: beige,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: beige.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: navy.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: navy.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: navy, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: lightGrey,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: beige,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: beige.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}