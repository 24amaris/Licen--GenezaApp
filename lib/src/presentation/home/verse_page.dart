import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'widgets/blurred_background.dart';

class VersePage extends StatelessWidget {
  const VersePage({super.key});

  // Paleta de culori
  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);

  // Versetul zilei
  static const String verse = '"Căci atât de mult a iubit Dumnezeu lumea, '
      'că a dat pe singurul Lui Fiu, pentru ca oricine crede în El '
      'să nu piară, ci să aibă viață veșnică."';
  static const String reference = 'Ioan 3:16';

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
                    children: [
                      const SizedBox(height: 0),

                      // Titlu
                      Text(
                        'Versetul zilei',
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: lightGrey,
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Card verset
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: navy.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: navy.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.menu_book,
                              size: 48,
                              color: lightGrey.withOpacity(0.8),
                            ),

                            const SizedBox(height: 24),

                            Text(
                              verse,
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                color: lightGrey,
                                height: 1.6,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 24),

                            Text(
                              reference,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: beige,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Butoane
                      Row(
                        children: [
                          // Buton Share
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Share.share(
                                  '$verse\n\n$reference',
                                  subject: 'Versetul zilei - Geneza Oradea',
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: lightGrey,
                                side: BorderSide(color: navy, width: 2),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.share),
                              label: Text(
                                'Distribuie',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Buton Download
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // TODO: Implementează descărcare imagine
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Funcția de descărcare va fi disponibilă în curând',
                                      style: GoogleFonts.inter(),
                                    ),
                                    backgroundColor: navy,
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: lightGrey,
                                side: BorderSide(color: navy, width: 2),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.download),
                              label: Text(
                                'Descarcă',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
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
              color: navy.withOpacity(0.2),
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
}
