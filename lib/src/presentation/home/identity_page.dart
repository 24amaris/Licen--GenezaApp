import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/blurred_background.dart';

class IdentityPage extends StatelessWidget {
  const IdentityPage({super.key});

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
                      // Titlu principal
                      Text(
                        'PASTOR DOREL CORAȘ',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFF1EFEC), // ✅ Light Grey
                          letterSpacing: 1.2,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Imagine pastor
                      Center(
                        child: Container(
                          width: 200,
                          height: 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/images/dorel.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: navy,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 80,
                                      color: lightGrey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Descriere
                      Text(
                        'Biserica Geneza este o expresie vizibilă a dragostei lui Dumnezeu, '
                        'care ne strânge pe toți laolaltă. Este un loc în care orice căutător '
                        'de Dumnezeu este binevenit și în care poate să crească în cunoașterea '
                        'lui Hristos. Aici vei găsi oameni cu povești de viață diferite, veniți '
                        'din medii diverse, dar care sunt uniți de experiența comună a căutării '
                        'și întâlnirii cu Hristos.',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: lightGrey,
                          height: 1.7,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      Text(
                        'Viziunea noastră este aceea de a-L cunoaște pe Isus și de a-L face '
                        'cunoscut și altora. Prin toate activitățile pe care le desfășurăm în '
                        'comunitatea noastră, căutăm să împlinim acest scop suprem.',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: lightGrey,
                          height: 1.7,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      Text(
                        'Dacă ești nou-venit printre noi, această aplicație îți va oferi o imagine '
                        'din interior despre Biserica Geneza. Iar dacă faci deja parte din '
                        'comunitatea noastră, te va ajuta să fii informat despre activitățile '
                        'și evenimentele pe care le avem programate în acest an bisericesc.',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: lightGrey,
                          height: 1.7,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      Text(
                        'Sunt nerăbdător să începem un nou capitol din umblarea noastră cu '
                        'Dumnezeu ca biserică și încrezător că ceea ce este mai bun de acum '
                        'înainte urmează să vină.',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: lightGrey,
                          height: 1.7,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        'Pastor Dorel Coraș',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: beige,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Program
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: navy.withOpacity(0.2),  // ✅ Navy background
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: navy,  // ✅ Navy border
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Ne întâlnim în fiecare duminică de la 10:00 și 18:00',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: lightGrey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'pentru un timp de socializare, închinare, ascultare a '
                              'Cuvântului și rugăciune. În timpul programelor, copiii '
                              'sunt bineveniți la grupele de școală duminicală!',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: beige,
                                height: 1.6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
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
            'Identitate, viziune și misiune',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: lightGrey,
            ),
          ),
        ],
      ),
    );
  }
}