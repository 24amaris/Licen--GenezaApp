import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/sermon_item.dart';
import '../../services/sermon_service.dart';
import '../home/widgets/blurred_background.dart';

class NoteDetailPage extends StatefulWidget {
  final SermonNote note;

  const NoteDetailPage({super.key, required this.note});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);

  final SermonService _sermonService = SermonService();
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _noteFocus = FocusNode();
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.sermonTitle);
    _noteController = TextEditingController(text: widget.note.noteText);
    _titleFocus.addListener(_onTitleFocusChange);
    _noteFocus.addListener(_onNoteFocusChange);
  }

  @override
  void dispose() {
    _autoSave();
    _titleFocus.removeListener(_onTitleFocusChange);
    _noteFocus.removeListener(_onNoteFocusChange);
    _titleController.dispose();
    _noteController.dispose();
    _titleFocus.dispose();
    _noteFocus.dispose();
    super.dispose();
  }

  void _onTitleFocusChange() {
    if (!_titleFocus.hasFocus) _autoSave();
  }

  void _onNoteFocusChange() {
    if (!_noteFocus.hasFocus) _autoSave();
  }

  void _autoSave() {
    final newTitle = _titleController.text.trim();
    final newText = _noteController.text.trim();
    if (newTitle.isEmpty || newText.isEmpty) return;
    if (newTitle == widget.note.sermonTitle && newText == widget.note.noteText) return;

    _sermonService.updateNote(widget.note.id, newText, newTitle: newTitle);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) _autoSave();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlurredBackground(
          blurAmount: 15.0,
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    behavior: HitTestBehavior.translucent,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Titlu editabil
                          Container(
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
                                TextField(
                                  controller: _titleController,
                                  focusNode: _titleFocus,
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: lightGrey,
                                    height: 1.3,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Titlu...',
                                    hintStyle: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: beige.withValues(alpha: 0.4),
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                    filled: false,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 14, color: beige.withValues(alpha: 0.6)),
                                    const SizedBox(width: 6),
                                    Text(
                                      _formatDate(widget.note.createdAt),
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: beige.withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Text notiță
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: navy.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: navy.withValues(alpha: 0.25),
                              ),
                            ),
                            child: TextField(
                              controller: _noteController,
                              focusNode: _noteFocus,
                              maxLines: null,
                              minLines: 15,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: lightGrey,
                                height: 1.7,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Scrie aici...',
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: beige.withValues(alpha: 0.4),
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                filled: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
            'Notiță',
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

  String _formatDate(DateTime date) {
    final months = [
      'Ian', 'Feb', 'Mar', 'Apr', 'Mai', 'Iun',
      'Iul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

