import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/blurred_background.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // Paleta de culori
  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);
  static const Color deepBlack = Color(0xFF030303);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlurredBackground(
        blurAmount: 15.0,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titlu
                      Text(
                        'Ești nou aici?',
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: lightGrey,
                          height: 1.2,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Prezentare biserică
                      _buildInfoCard(
                        title: 'Bine ai venit!',
                        description: 'Biserica Geneza este o comunitate vie, '
                            'dinamică și relevantă, alcătuită din oameni care au '
                            'povești de viață unice și diferite în felul lor, dar '
                            'care sunt uniți de credința în Isus Hristos.',
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildInfoCard(
                        title: 'Program de închinare',
                        description: 'Ne întâlnim în fiecare duminică de la '
                            '10:00 și 18:00 pentru un timp de socializare, '
                            'închinare, ascultare a Cuvântului și rugăciune. '
                            'În timpul programelor, copiii sunt bineveniți la '
                            'grupele de școală duminicală!',
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Departamente
                      Text(
                        'Departamente',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: lightGrey,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildDepartmentCard(
                        icon: Icons.handshake,
                        title: 'Departamentul de întâmpinare',
                        description: 'Echipa care te primește cu căldură la fiecare program.',
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildDepartmentCard(
                        icon: Icons.volunteer_activism,
                        title: 'Departamentul social',
                        description: 'Ajutăm și sprijinim comunitatea locală.',
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildDepartmentCard(
                        icon: Icons.child_care,
                        title: 'Departamentul de școală duminicală',
                        description: 'Copiii învață despre Dumnezeu într-un mod interactiv.',
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildDepartmentCard(
                        icon: Icons.cleaning_services,
                        title: 'Departamentul de întreținere și curățenie',
                        description: 'Menținem spațiul curat și primitor.',
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildDepartmentCard(
                        icon: Icons.camera_alt,
                        title: 'Departamentul media',
                        description: 'Sound, video și streaming live pentru programele noastre.',
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildDepartmentCard(
                        icon: Icons.group,
                        title: 'Departamentul de tineret',
                        description: 'Creștem împreună în credință și prietenie.',
                      ),
                      
                      const SizedBox(height: 40),
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
              color: navy.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: lightGrey),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Despre noi',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: lightGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: navy.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: navy.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: lightGrey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: beige,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: navy.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: navy.withOpacity(0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: navy,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: lightGrey, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: lightGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: beige,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}