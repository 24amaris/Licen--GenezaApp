import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/sermon_item.dart';
import '../../services/sermon_service.dart';
import 'sermon_detail_page.dart';
import 'widgets/blurred_background.dart';

class SermonListPage extends StatefulWidget {
  final SermonSeries series;

  const SermonListPage({super.key, required this.series});

  @override
  State<SermonListPage> createState() => _SermonListPageState();
}

class _SermonListPageState extends State<SermonListPage> {
  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);

  final SermonService _sermonService = SermonService();
  Set<String> _watchedIds = {};

  @override
  void initState() {
    super.initState();
    _loadWatchedStatus();
  }

  Future<void> _loadWatchedStatus() async {
    final ids = await _sermonService.getWatchedIds();
    setState(() {
      _watchedIds = ids;
    });
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSeriesHeader(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Predici din serie',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: lightGrey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: widget.series.sermons.length,
                        itemBuilder: (context, index) {
                          return _buildSermonCard(
                            context,
                            widget.series.sermons[index],
                            index + 1,
                          );
                        },
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
    // same padding tweak as in series page – keep horizontal spacing but
    // pull the row a little closer to the top edge.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              widget.series.title,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: lightGrey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeriesHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 180,
              width: double.infinity,
              child: Image.asset(
                widget.series.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.series.description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: beige,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.play_circle_outline, size: 16, color: navy),
              const SizedBox(width: 4),
              Text(
                '${widget.series.sermons.length} predici',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: navy,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSermonCard(BuildContext context, SermonItem sermon, int number) {
    final isWatched = _watchedIds.contains(sermon.id);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SermonDetailPage(sermon: sermon),
            ),
          );
          // Reîncarcă starea vizionat când se întoarce
          _loadWatchedStatus();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: navy.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: navy.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            children: [
              // Imagine predică cu badge vizionat
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        sermon.imageUrl,
                        fit: BoxFit.cover,
                      ),
                      if (isWatched)
                        Container(
                          color: Colors.black.withValues(alpha: 0.4),
                          child: const Center(
                            child: Icon(
                              Icons.check_circle,
                              color: Color(0xFF06D6A0),
                              size: 28,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Info predică
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: navy,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '$number',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: lightGrey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              sermon.title,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: lightGrey,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: beige.withValues(alpha: 0.7)),
                          const SizedBox(width: 4),
                          Text(
                            sermon.date,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: beige.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (isWatched) ...[
                            const Icon(Icons.check_circle, size: 12, color: Color(0xFF06D6A0)),
                            const SizedBox(width: 4),
                            Text(
                              'Vizionat',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF06D6A0),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ] else ...[
                            Icon(Icons.person_outline, size: 12, color: beige.withValues(alpha: 0.7)),
                            const SizedBox(width: 4),
                            Text(
                              sermon.speaker,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: beige.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Iconă play
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  isWatched ? Icons.replay_circle_filled : Icons.play_circle_fill,
                  color: isWatched ? const Color(0xFF06D6A0) : navy,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
