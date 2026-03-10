import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../../services/verse_service.dart';
import 'widgets/blurred_background.dart';

class VersePage extends StatefulWidget {
  const VersePage({super.key});

  @override
  State<VersePage> createState() => _VersePageState();
}

class _VersePageState extends State<VersePage> {
  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);

  final VerseService _verseService = VerseService();
  final GlobalKey _verseCardKey = GlobalKey();

  DailyVerse? _verse;
  bool _loading = true;
  bool _downloading = false;

  @override
  void initState() {
    super.initState();
    _loadVerse();
  }

  Future<void> _loadVerse() async {
    final verse = await _verseService.getTodaysVerse();
    if (mounted) {
      setState(() {
        _verse = verse;
        _loading = false;
      });
    }
  }

  String get _verseText =>
      _verse?.text ??
      '"Căci atât de mult a iubit Dumnezeu lumea, că a dat pe singurul Lui Fiu, '
          'pentru ca oricine crede în El să nu piară, ci să aibă viață veșnică."';

  String get _verseReference => _verse?.reference ?? 'Ioan 3:16';

  /// Captează cardul ca imagine și îl salvează, apoi deschide share/descărcare
  Future<void> _downloadVerse() async {
    setState(() => _downloading = true);
    try {
      // Captează widget-ul ca imagine
      final boundary = _verseCardKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      // Salvează în fișier temporar
      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/verset_zilei.png');
      await file.writeAsBytes(pngBytes);

      // Deschide share sheet — utilizatorul poate salva sau trimite
      await Share.shareXFiles(
        [XFile(file.path)],
        text: '$_verseText\n\n$_verseReference',
        subject: 'Versetul zilei - Geneza Oradea',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Eroare la descărcare: $e',
                style: GoogleFonts.inter()),
            backgroundColor: navy,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _downloading = false);
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
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(color: lightGrey))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              'Versetul zilei',
                              style: GoogleFonts.inter(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: lightGrey,
                              ),
                            ),
                            const SizedBox(height: 60),

                            // Card verset — învelit în RepaintBoundary pentru captură
                            RepaintBoundary(
                              key: _verseCardKey,
                              child: Container(
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
                                      _verseText,
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
                                      _verseReference,
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: beige,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Indicator dacă vine din Firebase sau e implicit
                            if (_verse == null) ...[
                              const SizedBox(height: 12),
                              Text(
                                'Versetul pentru azi nu a fost setat încă.',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: beige.withOpacity(0.7),
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],

                            const SizedBox(height: 40),

                            // Butoane
                            Row(
                              children: [
                                // Buton Share (text)
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      Share.share(
                                        '$_verseText\n\n$_verseReference',
                                        subject:
                                            'Versetul zilei - Geneza Oradea',
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: lightGrey,
                                      side: BorderSide(color: navy, width: 2),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
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

                                // Buton Descarcă (imagine)
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed:
                                        _downloading ? null : _downloadVerse,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: lightGrey,
                                      side: BorderSide(color: navy, width: 2),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                    ),
                                    icon: _downloading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                                color: lightGrey,
                                                strokeWidth: 2),
                                          )
                                        : const Icon(Icons.download),
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
