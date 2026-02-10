import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F172A),
      child: Center(
        child: Text(
          'Notițe',
          style: GoogleFonts.indieFlower(
            fontSize: 32,
            color: Colors.white.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}