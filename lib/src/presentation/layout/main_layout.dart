import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home_screen.dart';
import '../home/calendar_page.dart';
import '../home/donate_page.dart';
import '../home/sermon_series_page.dart';
import '../notes/notes_page.dart';
import '../home/widgets/profile_drawer.dart';
import '../home/widgets/blurred_background.dart';

class MainLayout extends StatefulWidget {
  // expose a helper so that children can notify the layout to switch
  // tabs (e.g. when a page inside the body wants to "go back" to home)
  const MainLayout({super.key});

  /// Return the state object for the nearest ancestor [MainLayout].
  ///
  /// We expose this public static method because most of the page widgets
  /// live in different files and would otherwise have no way to access the
  /// private `_MainLayoutState` class.  Consumers can call
  /// `MainLayout.of(context)?.setIndex(...)` to change the current tab.
  static _MainLayoutState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MainLayoutState>();
  }

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

  // we no longer keep a constant list: some pages need callbacks to
  // communicate with the layout (e.g. the sermon series page uses
  // `MainLayout.of(context)?.setIndex(0)` when its back button is
  // pressed).  Build the current page dynamically instead.

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
            // Only hide the global header on the "Predici" tab (index 1),
            // which has its own header with back button. All other tabs
            // should show the logo/appbar.
            if (_currentIndex != 1) _buildAppBar(),

            // Pagina curentă – build on demand so we can pass callbacks if
            // necessary.
            Expanded(
              child: _buildCurrentPage(),
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
                    icon: Icons.mic_none_outlined,
                    activeIcon: Icons.mic,
                    label: 'Predici',
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

  /// Programmatically change the current bottom-navigation index.
  ///
  /// This can be used by any descendant to make the layout behave as
  /// though the user tapped a tab.  The public helper `MainLayout.of`
  /// exposes access to this method.
  void setIndex(int newIndex) {
    if (newIndex != _currentIndex) {
      setState(() {
        _currentIndex = newIndex;
      });
    }
  }

  /// Chooses the widget for the current tab index.  This allows us to
  /// inject callbacks into pages that need to communicate with the
  /// surrounding layout.
  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        // the series page has a back arrow that should jump to home when
        // the layout can't pop; there is no route coverage for this when
        // used as a bottom-nav tab.
        return const SermonSeriesPage();
      case 2:
        return const CalendarPage();
      case 3:
        return const NotesPage();
      case 4:
        return const DonatePage();
      default:
        return const SizedBox.shrink();
    }
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