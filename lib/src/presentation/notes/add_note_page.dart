import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/sermon_item.dart';
import '../../services/sermon_service.dart';
import '../home/widgets/blurred_background.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);

  final SermonService _sermonService = SermonService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final text = _noteController.text.trim();
    if (title.isEmpty || text.isEmpty) return;

    final note = SermonNote(
      id: 'note_${DateTime.now().millisecondsSinceEpoch}',
      sermonId: '',
      sermonTitle: title,
      noteText: text,
      createdAt: DateTime.now(),
    );

    await _sermonService.saveNote(note);

    if (mounted) {
      Navigator.pop(context, true);
    }
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
                      // Titlu
                      Text(
                        'Titlu',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: beige,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: navy.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: navy.withValues(alpha: 0.3)),
                        ),
                        child: TextField(
                          controller: _titleController,
                          style: GoogleFonts.inter(fontSize: 16, color: lightGrey),
                          decoration: InputDecoration(
                            hintText: 'Dă un titlu notiței...',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 16,
                              color: beige.withValues(alpha: 0.4),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                            filled: false,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Notiță
                      Text(
                        'Notița ta',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: beige,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: navy.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: navy.withValues(alpha: 0.3)),
                        ),
                        child: TextField(
                          controller: _noteController,
                          maxLines: 10,
                          style: GoogleFonts.inter(fontSize: 14, color: lightGrey, height: 1.6),
                          decoration: InputDecoration(
                            hintText: 'Scrie notița aici...',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 14,
                              color: beige.withValues(alpha: 0.4),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                            filled: false,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Buton salvare
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: _saveNote,
                          icon: const Icon(Icons.save, size: 20),
                          label: Text(
                            'Salvează notiță',
                            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: navy,
                            foregroundColor: lightGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
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
          const SizedBox(width: 12),
          Text(
            'Notiță nouă',
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
}
