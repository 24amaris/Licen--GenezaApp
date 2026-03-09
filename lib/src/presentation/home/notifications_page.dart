import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/widgets/blurred_background.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Paleta de culori
  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);

  // Setări notificări
  bool _dailyVerse = true;
  bool _dailyReading = false;
  bool _otherNotifications = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  // ✅ ÎNCARCĂ SETĂRILE SALVATE
  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dailyVerse = prefs.getBool('notif_dailyVerse') ?? true;
      _dailyReading = prefs.getBool('notif_dailyReading') ?? false;
      _otherNotifications = prefs.getBool('notif_other') ?? true;
    });
  }

  // ✅ SALVEAZĂ SETĂRILE
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_dailyVerse', _dailyVerse);
    await prefs.setBool('notif_dailyReading', _dailyReading);
    await prefs.setBool('notif_other', _otherNotifications);
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notificări',
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: lightGrey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Alege ce notificări vrei să primești',
                        style: GoogleFonts.inter(fontSize: 16, color: beige),
                      ),
                      const SizedBox(height: 40),
                      
                      // Versetul zilei
                      _buildNotificationCard(
                        title: 'Versetul zilei',
                        description: 'Primește versetul zilei în fiecare dimineață',
                        icon: Icons.menu_book,
                        value: _dailyVerse,
                        onChanged: (value) async {
                          setState(() => _dailyVerse = value);
                          await _saveSettings();  // ✅ SALVEAZĂ AUTO
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Citirea zilnică
                      _buildNotificationCard(
                        title: 'Citirea zilnică',
                        description: 'Notificare pentru planul de citire biblică',
                        icon: Icons.auto_stories,
                        value: _dailyReading,
                        onChanged: (value) async {
                          setState(() => _dailyReading = value);
                          await _saveSettings();  // ✅ SALVEAZĂ AUTO
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Alte notificări
                      _buildNotificationCard(
                        title: 'Alte notificări',
                        description: 'Evenimente, anunțuri și alte actualizări',
                        icon: Icons.notifications_active,
                        value: _otherNotifications,
                        onChanged: (value) async {
                          setState(() => _otherNotifications = value);
                          await _saveSettings();  // ✅ SALVEAZĂ AUTO
                        },
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: navy.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: navy.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: beige, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Poți schimba setările oricând din această pagină',
                                style: GoogleFonts.inter(fontSize: 12, color: beige),
                              ),
                            ),
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
              color: navy.withValues(alpha: 0.2),
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

  Widget _buildNotificationCard({
    required String title,
    required String description,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: navy.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: navy.withValues(alpha: 0.3)),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: lightGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(fontSize: 12, color: beige),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: navy,
            activeTrackColor: lightGrey,
          ),
        ],
      ),
    );
  }
}