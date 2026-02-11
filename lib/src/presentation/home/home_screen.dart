import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import '../../models/event_item.dart';
import '../../models/sermon_item.dart';
import '../../services/event_service.dart';
import '../../services/sermon_service.dart';
import 'widgets/event_card.dart';
import 'event_detail_page.dart';
import 'about_page.dart';
import 'identity_page.dart';
import 'verse_page.dart';
import 'prayer_page.dart';
import '../home/donate_page.dart';
import 'sermon_series_page.dart';
import 'sermon_list_page.dart';
import 'sermon_detail_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);

  final PageController _pageController = PageController();
  final PageController _latestSermonsController = PageController();
  final EventService _eventService = EventService();
  final SermonService _sermonService = SermonService();

  int _currentPage = 0;
  int _currentLatestSermonPage = 0;
  Timer? _timer;
  Timer? _latestSermonTimer;
  List<EventItem> _events = [];
  List<SermonSeries> _sermonSeries = [];
  List<SermonItem> _latestSermons = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _loadSermonData();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _latestSermonTimer?.cancel();
    _pageController.dispose();
    _latestSermonsController.dispose();
    super.dispose();
  }

  void _loadEvents() {
    setState(() {
      _events = _eventService.getImportantEvents();
    });
  }

  void _loadSermonData() {
    final series = _sermonService.getAllSeries();
    // Colectăm toate predicile și le sortăm invers (cele mai recente primele)
    final allSermons = <SermonItem>[];
    for (final s in series) {
      allSermons.addAll(s.sermons);
    }

    setState(() {
      _sermonSeries = series;
      _latestSermons = allSermons;
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_events.isEmpty) return;
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

    _latestSermonTimer = Timer.periodic(const Duration(seconds: 12), (timer) {
      if (_latestSermons.isEmpty) return;
      if (_currentLatestSermonPage < _latestSermons.length - 1) {
        _currentLatestSermonPage++;
      } else {
        _currentLatestSermonPage = 0;
      }
      if (_latestSermonsController.hasClients) {
        _latestSermonsController.animateToPage(
          _currentLatestSermonPage,
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
          child: CircularProgressIndicator(color: navy),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),

          // Carusel de evenimente
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
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
                          builder: (context) => EventDetailPage(event: _events[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          _buildDots(_currentPage, _events.length),

          const SizedBox(height: 40),

          // Butoane funcționalități
          _buildFeatureButtons(context),

          const SizedBox(height: 40),

          // Butoane biserică
          _buildChurchInfoButtons(context),

          const SizedBox(height: 40),

          // Seriile de predici (grid pătrate)
          _buildSeriesGrid(context),

          const SizedBox(height: 32),

          // Ultimele predici (carusel)
          _buildLatestSermonsSection(context),

          const SizedBox(height: 40),

          // Social media
          _buildSocialMediaSection(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ===== DOTS =====
  Widget _buildDots(int current, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (i) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: current == i ? 24 : 8,
          height: 6,
          decoration: BoxDecoration(
            color: current == i ? navy : beige,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  // ===== FEATURE BUTTONS =====
  Widget _buildFeatureButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildFeatureButton(
              icon: Icons.menu_book,
              label: 'Versetul zilei',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VersePage())),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildFeatureButton(
              icon: Icons.people,
              label: 'Rugăciune',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrayerPage())),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildFeatureButton(
              icon: Icons.volunteer_activism,
              label: 'Donează',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DonatePage(isStandalone: true))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButton({
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
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: lightGrey, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: lightGrey),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: lightGrey),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ===== CHURCH INFO BUTTONS =====
  Widget _buildChurchInfoButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildOutlinedButton('Ești nou aici?', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutPage()));
          }),
          const SizedBox(height: 16),
          _buildOutlinedButton('Identitate, viziune și misiune', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const IdentityPage()));
          }),
        ],
      ),
    );
  }

  Widget _buildOutlinedButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: lightGrey,
          side: const BorderSide(color: navy, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ===== SERIES GRID (pătrate, 2 pe rând) =====
  Widget _buildSeriesGrid(BuildContext context) {
    if (_sermonSeries.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Seriile de predici',
            style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: lightGrey),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: _sermonSeries.length,
            itemBuilder: (context, index) {
              return _buildSeriesSquareCard(context, _sermonSeries[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSeriesSquareCard(BuildContext context, SermonSeries series) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SermonListPage(series: series)),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(series.imageUrl, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.75),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      series.title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: lightGrey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${series.sermons.length} predici',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: beige.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== ULTIMELE PREDICI (carusel ca la evenimente) =====
  Widget _buildLatestSermonsSection(BuildContext context) {
    if (_latestSermons.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        // Titlu + buton "Vezi toate"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                'Ultimele predici',
                style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: lightGrey),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SermonSeriesPage()),
                  );
                },
                child: Text(
                  'Vezi toate',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 161, 161, 161),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Carusel predici
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _latestSermonsController,
            onPageChanged: (index) => setState(() => _currentLatestSermonPage = index),
            itemCount: _latestSermons.length,
            itemBuilder: (context, index) {
              final sermon = _latestSermons[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildLatestSermonCard(context, sermon),
              );
            },
          ),
        ),

        const SizedBox(height: 10),
        _buildDots(_currentLatestSermonPage, _latestSermons.length),
      ],
    );
  }

  Widget _buildLatestSermonCard(BuildContext context, SermonItem sermon) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SermonDetailPage(sermon: sermon)),
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(sermon.imageUrl, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.1),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                    ],
                    stops: const [0.0, 0.3, 1.0],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sermon.title,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: lightGrey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${sermon.date}  •  ${sermon.speaker}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: beige.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== SOCIAL MEDIA =====
  Widget _buildSocialMediaSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSocialIcon(icon: Icons.camera_alt, url: 'https://www.instagram.com/geneza.oradea/'),
          _buildSocialIcon(icon: Icons.facebook, url: 'https://www.facebook.com/GenezaOradea/?locale=ro_RO'),
          _buildSocialIcon(icon: Icons.play_arrow, url: 'https://www.youtube.com/c/GenezaOradea'),
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
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: lightGrey, width: 1),
        ),
        child: Icon(icon, color: lightGrey, size: 32),
      ),
    );
  }
}
