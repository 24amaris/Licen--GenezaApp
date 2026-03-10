import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/event_item.dart';  // ✅ CORECT - 3 puncte (home/widgets/)

class EventCard extends StatelessWidget {
  final EventItem event;
  final VoidCallback onDetailsPressed;

  const EventCard({
    super.key,
    required this.event,
    required this.onDetailsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // ============ IMAGINE FULL (toată cardul) ============
            Positioned.fill(
              child: event.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: event.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF123458),
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => _buildImagePlaceholder(),
                    )
                  : _buildImagePlaceholder(),
            ),

            // ============ GRADIENT OVERLAY (pentru text vizibil) ============
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.4),  // Top - semi-transparent
                      Colors.transparent,              // Middle - transparent
                      Colors.transparent,              // Middle - transparent
                      Colors.black.withOpacity(0.8),  // Bottom - mai închis
                    ],
                    stops: const [0.0, 0.3, 0.6, 1.0],
                  ),
                ),
              ),
            ),

            // ============ BUTON MIC – stânga jos ============
            Positioned(
              bottom: 16,
              left: 16,
              child: ElevatedButton.icon(
                onPressed: onDetailsPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.25),
                  foregroundColor: const Color(0xFFF1EFEC),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward, size: 14),
                label: Text(
                  'Vezi detalii',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF123458),  // Navy
            const Color(0xFF123458).withOpacity(0.7),
          ],
        ),
      ),
    
    );
  }
}