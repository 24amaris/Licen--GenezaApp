import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/sermon_item.dart';
import '../../services/sermon_service.dart';
import 'sermon_list_page.dart';
import 'widgets/blurred_background.dart';

class SermonSeriesPage extends StatelessWidget {
  const SermonSeriesPage({super.key});

  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);

  @override
  Widget build(BuildContext context) {
    final sermonService = SermonService();
    final allSeries = sermonService.getAllSeries();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlurredBackground(
        blurAmount: 15.0,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              // Lista de serii
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: allSeries.length,
                  itemBuilder: (context, index) {
                    return _buildSeriesCard(context, allSeries[index]);
                  },
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
            'Predici',
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

  Widget _buildSeriesCard(BuildContext context, SermonSeries series) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SermonListPage(series: series),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Imagine fundal
                Image.asset(
                  series.imageUrl,
                  fit: BoxFit.cover,
                ),

                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.2),
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),

                // Conținut
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        series.title,
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: lightGrey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        series.description,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: beige,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.play_circle_outline,
                            size: 16,
                            color: beige.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${series.sermons.length} predici',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: beige.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
