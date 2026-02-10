import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                  ? Image.asset(
                      event.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildImagePlaceholder();
                      },
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

            // ============ CONȚINUT (doar buton) ============
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onDetailsPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF123458),  // ✅ Navy
                    foregroundColor: const Color(0xFFF1EFEC),  // Light Grey
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Vezi Detalii',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 20),
                    ],
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