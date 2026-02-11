import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/sermon_item.dart';
import '../../services/sermon_service.dart';
import '../home/sermon_detail_page.dart';
import 'add_note_page.dart';
import 'note_detail_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);

  final SermonService _sermonService = SermonService();
  List<SermonNote> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _sermonService.getAllNotes();
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (mounted) {
      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteNote(String noteId) async {
    await _sermonService.deleteNote(noteId);
    await _loadNotes();
  }

  void _onNoteTap(SermonNote note) {
    if (note.sermonId.isNotEmpty) {
      // Notița e legată de o predică → deschide pagina predicii
      final sermon = _sermonService.getSermonById(note.sermonId);
      if (sermon != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SermonDetailPage(sermon: sermon),
          ),
        ).then((_) => _loadNotes());
      }
    } else {
      // Notiță standalone → deschide pagina de detaliu
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NoteDetailPage(note: note),
        ),
      ).then((_) => _loadNotes());
    }
  }

  void _openAddNotePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNotePage()),
    );
    if (result == true) {
      await _loadNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF123458)),
      );
    }

    return Stack(
      children: [
        if (_notes.isEmpty)
          _buildEmptyState()
        else
          RefreshIndicator(
            onRefresh: _loadNotes,
            color: navy,
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 80),
              itemCount: _notes.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return _buildPageHeader();
                return _buildNoteCard(_notes[index - 1]);
              },
            ),
          ),

        // FAB - Adaugă notiță
        Positioned(
          bottom: 16,
          right: 20,
          child: FloatingActionButton.extended(
            onPressed: _openAddNotePage,
            backgroundColor: navy,
            foregroundColor: lightGrey,
            icon: const Icon(Icons.add),
            label: Text(
              'Notiță nouă',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.note_alt_outlined,
              size: 64,
              color: beige.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Nicio notiță încă',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: lightGrey.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Notițele pe care le scrii la predici\nvor apărea aici',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: beige.withValues(alpha: 0.4),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notițele mele',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: lightGrey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_notes.length} ${_notes.length == 1 ? 'notiță' : 'notițe'} salvate',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: beige.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(SermonNote note) {
    final isLinkedToSermon = note.sermonId.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _onNoteTap(note),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: navy.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: navy.withValues(alpha: 0.25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titlu (chip-ul cu titlul predicii sau titlul custom)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: navy.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLinkedToSermon)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(Icons.play_circle_outline, size: 12, color: beige),
                      ),
                    Flexible(
                      child: Text(
                        note.sermonTitle,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: beige,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Text notiță
              Text(
                note.noteText,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: lightGrey,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 10),

              // Footer: data + ștergere
              Row(
                children: [
                  Icon(Icons.access_time, size: 12, color: beige.withValues(alpha: 0.5)),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(note.createdAt),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: beige.withValues(alpha: 0.5),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => _showDeleteDialog(note),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: beige.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(SermonNote note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D2640),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Șterge notiță?',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: lightGrey,
          ),
        ),
        content: Text(
          'Această notiță va fi ștearsă permanent.',
          style: GoogleFonts.inter(color: beige),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Anulează',
              style: GoogleFonts.inter(color: beige),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteNote(note.id);
            },
            child: Text(
              'Șterge',
              style: GoogleFonts.inter(color: const Color(0xFFEF233C)),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Ian', 'Feb', 'Mar', 'Apr', 'Mai', 'Iun',
      'Iul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
