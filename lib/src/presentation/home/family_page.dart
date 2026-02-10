import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';  // ✅ Necesar pentru jsonEncode/jsonDecode
import '../home/widgets/blurred_background.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  // Paleta de culori
  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);

  // Lista membri familie
  List<Map<String, String>> _familyMembers = [];

  @override
  void initState() {
    super.initState();
    _loadFamilyMembers();
  }

  // ✅ ÎNCARCĂ MEMBRII FAMILIEI SALVAȚI
  Future<void> _loadFamilyMembers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? familyData = prefs.getString('family_members');
    if (familyData != null) {
      final List<dynamic> decoded = jsonDecode(familyData);
      setState(() {
        _familyMembers = decoded.map((item) => Map<String, String>.from(item)).toList();
      });
    }
  }

  // ✅ SALVEAZĂ MEMBRII FAMILIEI
  Future<void> _saveFamilyMembers() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_familyMembers);
    await prefs.setString('family_members', encoded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlurredBackground(
        blurAmount: 15.0,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Familia mea',
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: lightGrey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Butoane adaugă membri
                      _buildAddButton('Adaugă soț/soție', Icons.favorite, 'spouse'),
                      const SizedBox(height: 12),
                      _buildAddButton('Adaugă părinte', Icons.person, 'parent'),
                      const SizedBox(height: 12),
                      _buildAddButton('Adaugă copil', Icons.child_care, 'child'),
                      
                      const SizedBox(height: 40),
                      
                      // Lista membri familie
                      if (_familyMembers.isNotEmpty) ...[
                        Text(
                          'Membri familiei',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: lightGrey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ..._familyMembers.map((member) => _buildFamilyMemberCard(member)),
                      ] else
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Text(
                              'Nu ai adăugat încă membri ai familiei',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: beige,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
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
        ],
      ),
    );
  }

  Widget _buildAddButton(String label, IconData icon, String type) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton.icon(
        onPressed: () => _showAddMemberDialog(type),
        style: OutlinedButton.styleFrom(
          foregroundColor: lightGrey,
          side: BorderSide(color: navy, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildFamilyMemberCard(Map<String, String> member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: navy.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: navy.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(_getIconForType(member['type']!), color: lightGrey, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member['name']!,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: lightGrey,
                  ),
                ),
                Text(
                  _getLabelForType(member['type']!),
                  style: GoogleFonts.inter(fontSize: 12, color: beige),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
            onPressed: () async {
              setState(() => _familyMembers.remove(member));
              await _saveFamilyMembers();  // ✅ SALVEAZĂ
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Membru șters',
                      style: GoogleFonts.inter(),
                    ),
                    backgroundColor: navy,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showAddMemberDialog(String type) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: navy,
        title: Text(
          'Adaugă ${_getLabelForType(type)}',
          style: GoogleFonts.inter(color: lightGrey, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: nameController,
          style: GoogleFonts.inter(color: lightGrey),
          decoration: InputDecoration(
            hintText: 'Nume complet',
            hintStyle: GoogleFonts.inter(color: beige.withValues(alpha: 0.5)),
            filled: true,
            fillColor: lightGrey.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Anulează', style: GoogleFonts.inter(color: beige)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _familyMembers.add({'name': nameController.text, 'type': type});
                });
                await _saveFamilyMembers();  // ✅ SALVEAZĂ
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Membru adăugat cu succes',
                        style: GoogleFonts.inter(),
                      ),
                      backgroundColor: navy,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: lightGrey,
              foregroundColor: navy,
            ),
            child: Text('Adaugă', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'spouse': return Icons.favorite;
      case 'parent': return Icons.person;
      case 'child': return Icons.child_care;
      default: return Icons.person;
    }
  }

  String _getLabelForType(String type) {
    switch (type) {
      case 'spouse': return 'Soț/Soție';
      case 'parent': return 'Părinte';
      case 'child': return 'Copil';
      default: return 'Membru familie';
    }
  }
}