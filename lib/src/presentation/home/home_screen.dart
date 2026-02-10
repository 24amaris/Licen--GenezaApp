import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import '../../models/event_item.dart';
import '../../services/event_service.dart';
import 'widgets/event_card.dart';
import 'event_detail_page.dart';
import 'about_page.dart';
import 'identity_page.dart';
import 'verse_page.dart';  // ✅ NOU
import 'prayer_page.dart';  // ✅ NOU
import '../home/donate_page.dart';  // ✅ NOU

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  final EventService _eventService = EventService();
  
  int _currentPage = 0;
  Timer? _timer;
  List<EventItem> _events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _loadEvents() {
    setState(() {
      _events = _eventService.getImportantEvents();
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_currentPage < _events.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_events.isEmpty) {
      return Container(
        color: Colors.transparent,
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFF123458)),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          
          const SizedBox(height: 10),
          
          // Carusel de evenimente
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _events.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: EventCard(
                    event: _events[index],
                    onDetailsPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailPage(
                            event: _events[index],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 10),
          
          // Indicator dots
          _buildPageIndicator(),
          
          const SizedBox(height: 40),
          
          // ✅ BUTOANE FUNCȚIONALITĂȚI (NOU!)
          _buildFeatureButtons(context),
          
          const SizedBox(height: 40),
          
          // Butoane informații biserică
          _buildChurchInfoButtons(context),
          
          const SizedBox(height: 40),
          
          // Social media
          _buildSocialMediaSection(),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _events.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 6,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? const Color(0xFF123458)
                : const Color(0xFFD4C9BE),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  // ✅ BUTOANE FUNCȚIONALITĂȚI (NOU!)
  Widget _buildFeatureButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Versetul zilei
          Expanded(
            child: _buildFeatureButton(
              context: context,
              icon: Icons.menu_book,
              label: 'Versetul zilei',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VersePage()),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          
          // Rugăciune
          Expanded(
            child: _buildFeatureButton(
              context: context,
              icon: Icons.people,
              label: 'Rugăciune',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrayerPage()),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          
          // Donează
          Expanded(
            child: _buildFeatureButton(
              context: context,
              icon: Icons.volunteer_activism,
              label: 'Donează',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DonatePage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFF1EFEC),  // Light Grey border
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 36,
              color: const Color(0xFFF1EFEC),  // Light Grey
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFF1EFEC),  // Light Grey
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChurchInfoButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 60,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFF1EFEC),
                side: const BorderSide(color: Color(0xFF123458), width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                'Ești nou aici?',
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IdentityPage()),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFF1EFEC),
                side: const BorderSide(color: Color(0xFF123458), width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                'Identitate, viziune și misiune',
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSocialIcon(
            icon: Icons.camera_alt,
            url: 'https://www.instagram.com/geneza.oradea/',
          ),
          _buildSocialIcon(
            icon: Icons.facebook,
            url: 'https://www.facebook.com/GenezaOradea/?locale=ro_RO',
          ),
          _buildSocialIcon(
            icon: Icons.play_arrow,
            url: 'https://www.youtube.com/c/GenezaOradea',
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon({required IconData icon, required String url}) {
    return InkWell(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1EFEC), width: 1),
        ),
        child: Icon(icon, color: const Color(0xFFF1EFEC), size: 32),
      ),
    );
  }
}