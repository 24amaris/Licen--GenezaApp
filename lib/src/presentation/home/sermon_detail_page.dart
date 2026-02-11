import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/sermon_item.dart';
import '../../services/sermon_service.dart';
import 'widgets/blurred_background.dart';

class SermonDetailPage extends StatefulWidget {
  final SermonItem sermon;

  const SermonDetailPage({super.key, required this.sermon});

  @override
  State<SermonDetailPage> createState() => _SermonDetailPageState();
}

class _SermonDetailPageState extends State<SermonDetailPage> {
  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);

  final SermonService _sermonService = SermonService();
  final TextEditingController _noteController = TextEditingController();
  List<SermonNote> _notes = [];
  bool _isLoadingNotes = true;
  bool _isWatched = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _loadWatchedStatus();
  }

  Future<void> _loadWatchedStatus() async {
    final watched = await _sermonService.isWatched(widget.sermon.id);
    setState(() {
      _isWatched = watched;
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    final notes = await _sermonService.getNotesForSermon(widget.sermon.id);
    setState(() {
      _notes = notes;
      _isLoadingNotes = false;
    });
  }

  Future<void> _saveNote() async {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;

    final note = SermonNote(
      id: 'note_${DateTime.now().millisecondsSinceEpoch}',
      sermonId: widget.sermon.id,
      sermonTitle: widget.sermon.title,
      noteText: text,
      createdAt: DateTime.now(),
    );

    await _sermonService.saveNote(note);
    _noteController.clear();
    await _loadNotes();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Notiță salvată!',
            style: GoogleFonts.inter(color: lightGrey),
          ),
          backgroundColor: navy,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _deleteNote(String noteId) async {
    await _sermonService.deleteNote(noteId);
    await _loadNotes();
  }

  Future<void> _openYouTube() async {
    final Uri uri = Uri.parse(widget.sermon.youtubeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      await _sermonService.markAsWatched(widget.sermon.id);
      setState(() {
        _isWatched = true;
      });
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
              // Header
              _buildHeader(context),

              // Conținut
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagine mare
                      _buildSermonImage(),

                      const SizedBox(height: 20),

                      // Info predică
                      _buildSermonInfo(),

                      const SizedBox(height: 20),

                      // Buton YouTube
                      _buildYouTubeButton(),

                      const SizedBox(height: 32),

                      // Secțiune AI rezumat (placeholder viitor)
                      _buildAiSummaryPlaceholder(),

                      const SizedBox(height: 32),

                      // Secțiune notițe
                      _buildNotesSection(),

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
              'Predică',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: lightGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSermonImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 220,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                widget.sermon.imageUrl,
                fit: BoxFit.cover,
              ),
              // Gradient subtil
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.4),
                    ],
                  ),
                ),
              ),
              // Badge vizionat
              if (_isWatched)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF06D6A0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          'Vizionat',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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

  Widget _buildSermonInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titlu
          Text(
            widget.sermon.title,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: lightGrey,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 12),

          // Data și speaker
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: beige.withValues(alpha: 0.8)),
              const SizedBox(width: 6),
              Text(
                widget.sermon.date,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: beige.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.person_outline, size: 14, color: beige.withValues(alpha: 0.8)),
              const SizedBox(width: 6),
              Text(
                widget.sermon.speaker,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: beige.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),

          // Descriere
          if (widget.sermon.description != null) ...[
            const SizedBox(height: 16),
            Text(
              widget.sermon.description!,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: beige,
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildYouTubeButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: _openYouTube,
          icon: const Icon(Icons.play_arrow, size: 28),
          label: Text(
            'Urmărește pe YouTube',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF0000),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildAiSummaryPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: navy.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: navy.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.auto_awesome,
              size: 32,
              color: beige.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'Rezumat AI',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: beige.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'În curând - rezumat generat automat',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: beige.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titlu secțiune
          Text(
            'Notițele mele',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: lightGrey,
            ),
          ),

          const SizedBox(height: 12),

          // Input notiță nouă
          Container(
            decoration: BoxDecoration(
              color: navy.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: navy.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _noteController,
                  maxLines: 4,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: lightGrey,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Scrie o notiță despre această predică...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14,
                      color: beige.withValues(alpha: 0.4),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    filled: false,
                  ),
                ),
                // Buton salvare
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: _saveNote,
                      icon: const Icon(Icons.save, size: 18),
                      label: Text(
                        'Salvează notiță',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: navy,
                        foregroundColor: lightGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Lista notițe salvate
          if (_isLoadingNotes)
            const Center(
              child: CircularProgressIndicator(color: navy),
            )
          else if (_notes.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Nicio notiță încă. Scrie prima ta notiță!',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: beige.withValues(alpha: 0.5),
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return _buildNoteCard(note);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(SermonNote note) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: navy.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: navy.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text notiță
            Text(
              note.noteText,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: lightGrey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            // Data + buton ștergere
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
                  onTap: () => _deleteNote(note.id),
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
