import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/event_item.dart';
import 'widgets/blurred_background.dart';

class EventDetailPage extends StatelessWidget {
  final EventItem event;

  const EventDetailPage({
    super.key,
    required this.event,
  });

  Future<void> _launchRegistration() async {
    final Uri url = Uri.parse(event.registrationLink);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Afișăm eroare dacă nu se poate deschide
      debugPrint('Nu s-a putut deschide: ${event.registrationLink}');
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
              // Header cu buton înapoi
              _buildHeader(context),
              
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagine eveniment
                      _buildEventImage(),
                      
                      const SizedBox(height: 24),
                      
                      // Conținut detalii
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Titlu
                            Text(
                              event.title,
                              style: GoogleFonts.inter(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFF1EFEC),  // Light Grey
                                height: 1.2,
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Info cards (dată, oră, locație)
                            _buildInfoCard(
                              icon: Icons.calendar_today,
                              title: 'Data',
                              value: event.date,
                            ),
                            
                            const SizedBox(height: 12),
                            
                            _buildInfoCard(
                              icon: Icons.access_time,
                              title: 'Ora',
                              value: event.time,
                            ),
                            
                            const SizedBox(height: 12),
                            
                            _buildInfoCard(
                              icon: Icons.location_on,
                              title: 'Locația',
                              value: event.location,
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // ✅ DESCRIERE (AFIȘATĂ!)
                            Text(
                              'Despre eveniment',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFF1EFEC),  // Light Grey
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            
                            Text(
                              event.description,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: const Color(0xFFD4C9BE),  // Beige
                                height: 1.6,
                              ),
                            ),
                            
                            // Cost (dacă există)
                            if (event.cost != null) ...[
                              const SizedBox(height: 24),
                              _buildInfoCard(
                                icon: Icons.payments,
                                title: 'Cost',
                                value: event.cost!,
                              ),
                            ],
                            
                            // Ce să aduci (dacă există)
                            if (event.whatToBring != null && event.whatToBring!.isNotEmpty) ...[
                              const SizedBox(height: 32),
                              Text(
                                'Ce să aduci',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFF1EFEC),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...event.whatToBring!.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF123458),  // Navy
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: const Color(0xFFD4C9BE),  // Beige
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                            
                            const SizedBox(height: 32),
                            
                            // ✅ BUTON ÎNREGISTRARE (Link Google Forms)
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _launchRegistration,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF123458),  // Navy
                                  foregroundColor: const Color(0xFFF1EFEC),  // Light Grey
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.edit_note, size: 24),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Completează formularul',
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Info despre link
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF123458).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF123458).withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    color: Color(0xFF123458),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Vei fi redirecționat către Google Forms pentru înregistrare',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: const Color(0xFFD4C9BE),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 40),
                          ],
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
              color: const Color(0xFF123458).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFFF1EFEC),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          
          const SizedBox(width: 12),
          
          Text(
            'Detalii Eveniment',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF1EFEC),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventImage() {
    return Container(
      height: 300,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF123458),
            const Color(0xFF123458).withOpacity(0.7),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.image,
          size: 64,
          color: Color(0xFFD4C9BE),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF123458).withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF123458).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF123458),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFF1EFEC),
              size: 24,
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFFD4C9BE),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color(0xFFF1EFEC),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}