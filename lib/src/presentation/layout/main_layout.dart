import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home_screen.dart';
import '../home/calendar_page.dart';
import '../home/bible_page.dart';
import '../home/widgets/profile_drawer.dart';
import '../home/widgets/blurred_background.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // Paleta 4 culori
  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);
  static const Color deepBlack = Color(0xFF030303);

  // Lista de pagini
  final List<Widget> _pages = const [
    HomeScreen(),
    BiblePage(),  // Biblia
    CalendarPage(),  // Calendar
    HomeScreen(),  // Placeholder Notițe
    HomeScreen(),  // Placeholder Donează
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      
      // Drawer (profil)
      endDrawer: const ProfileDrawer(),
      
      // Body cu fundal blurat
      body: BlurredBackground(
        blurAmount: 15.0,
        child: Column(
          children: [
            // Header transparent
            _buildAppBar(),
            
            // Pagina curentă
            Expanded(
              child: _pages[_currentIndex],
            ),
            
            // Footer transparent
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  // ============ HEADER ============
  Widget _buildAppBar() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(
        top: 30,
        left: 16,
        right: 8,
        bottom: 0,
      ),
      child: Row(
        children: [
          // Logo
          Image.asset(
            'assets/images/logo.png',
            width: 100,
            height: 100,
          ),
          const SizedBox(width: 12),
          const Spacer(),
          
          // Buton profil
          Builder(
            builder: (context) => IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromARGB(255, 255, 255, 255),  // ✅ Navy
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Color.fromARGB(255, 255, 255, 255),  // ✅ Navy
                  size: 24,
                ),
              ),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============ FOOTER ============
  Widget _buildBottomNav() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: deepBlack.withValues(alpha: 0.3),  // ✅ Black semi-transparent
            border: Border(
              top: BorderSide(
                color: lightGrey.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Acasă',
                    index: 0,
                  ),
                  _buildNavItem(
                    icon: Icons.library_books_outlined,
                    activeIcon: Icons.my_library_books,
                    label: 'Biblia',
                    index: 1,
                  ),
                  _buildNavItem(
                    icon: Icons.calendar_month_outlined,
                    activeIcon: Icons.calendar_month,
                    label: 'Calendar',
                    index: 2,
                  ),
                  _buildNavItem(
                    icon: Icons.note_outlined,
                    activeIcon: Icons.note,
                    label: 'Notițe',
                    index: 3,
                  ),
                  _buildNavItem(
                    icon: Icons.volunteer_activism_outlined,
                    activeIcon: Icons.volunteer_activism,
                    label: 'Donează',
                    index: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;
    
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 28,
              color: isActive 
                ? navy  // ✅ Navy când activ
                : beige.withValues(alpha: 0.6),  // ✅ Beige transparent când inactiv
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive 
                  ? navy  // ✅ Navy când activ
                  : beige.withValues(alpha: 0.6),  // ✅ Beige transparent când inactiv
              ),
            ),
          ],
        ),
      ),
    );
  }
}