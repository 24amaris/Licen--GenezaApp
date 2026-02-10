import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/blurred_background.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  // Paleta de culori
  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);
  static const Color deepBlack = Color(0xFF030303);

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

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titlu
                      Text(
                        'Contact',
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: lightGrey,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Descriere
                      Text(
                        'Biserica Geneza Oradea este un loc în care oamenii îl pot întâlni '
                        'pe Isus și se pot implica în comunitate. Orice persoană e binevenită!',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: beige,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Email
                      _buildContactCard(
                        icon: Icons.email_outlined,
                        title: 'Email',
                        value: 'contact@geneza.ro',
                        onTap: () => _launchEmail(),
                      ),

                      const SizedBox(height: 16),

                      // Program
                      _buildContactCard(
                        icon: Icons.access_time,
                        title: 'Program',
                        value: 'Duminica: 10:00 / 18:00',
                        onTap: null,
                      ),

                      const SizedBox(height: 16),

                      // Locație
                      _buildContactCard(
                        icon: Icons.location_on_outlined,
                        title: 'Adresa',
                        value: 'Corneliu Coposu ..., Oradea, Bihor, România',
                        onTap: () => _launchMaps(),
                      ),

                      const SizedBox(height: 40),

                      // Cum ajungi
                      Text(
                        'Cum ajungi la noi',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: lightGrey,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Transport options
                      Row(
                        children: [
                          Expanded(
                            child: _buildTransportCard(
                              icon: Icons.directions_car,
                              label: 'Cu mașina',
                              onTap: () => _launchUrl(
                                'https://www.google.com/maps/dir//Biserica+Geneza+Oradea,+Strada+Corneliu+Coposu+7,+Oradea+410445/@47.0741698,21.9229428,17z/data=!4m5!4m4!1m0!1m2!1m1!1s0x47464901646a3b8f:0x987557d1fd66704c?entry=ml&utm_campaign=ml-dr&coh=230964',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTransportCard(
                              icon: Icons.tram,
                              label: 'Cu tramvai',
                              onTap: () => _launchUrl(
                                'https://www.google.com/maps/dir/47.917789,25.7328206/Strada+Corneliu+Coposu+7,+Oradea+410445/@47.3402703,22.7813744,8z/data=!3m1!4b1!4m10!4m9!1m1!4e1!1m5!1m1!1s0x47464901646a3b8f:0x987557d1fd66704c!2m2!1d21.922938!2d47.0741649!3e3?entry=ttu',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTransportCard(
                              icon: Icons.directions_walk,
                              label: 'Pe jos',
                              onTap: () => _launchUrl(
                                'https://www.google.com/maps/dir/47.917789,25.7328206/Strada+Corneliu+Coposu+7,+Oradea+410445/@47.6108828,22.5087581,8z/data=!3m1!4b1!4m10!4m9!1m1!4e1!1m5!1m1!1s0x47464901646a3b8f:0x987557d1fd66704c!2m2!1d21.922938!2d47.0741649!3e2?entry=ttu',
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Social Media
                      Text(
                        'Urmărește-ne pe social media:',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: lightGrey,
                        ),
                      ),

                      const SizedBox(height: 20),

                      _buildSocialButtons(),

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

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: navy.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: navy.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: navy,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: lightGrey, size: 24),
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
                      color: beige,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: lightGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: beige.withOpacity(0.6),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportCard({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: navy,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: lightGrey, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: lightGrey,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}


  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSocialButton(
          icon: Icons.camera_alt,
          label: 'Instagram',
          onTap: () => _launchUrl('https://www.instagram.com/geneza.oradea/'),
        ),
        _buildSocialButton(
          icon: Icons.facebook,
          label: 'Facebook',
          onTap: () =>
              _launchUrl('https://www.facebook.com/GenezaOradea/?locale=ro_RO'),
        ),
        _buildSocialButton(
          icon: Icons.play_arrow,
          label: 'YouTube',
          onTap: () => _launchUrl('https://www.youtube.com/c/GenezaOradea'),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: navy,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: lightGrey, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: lightGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'contact@geneza.ro',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _launchMaps() async {
    final Uri mapsUri = Uri.parse('https://maps.app.goo.gl/ydtJ13nct5DYTxSy6');
    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
