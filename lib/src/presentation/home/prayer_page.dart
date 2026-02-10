import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/blurred_background.dart';

class PrayerPage extends StatefulWidget {
  const PrayerPage({super.key});

  @override
  State<PrayerPage> createState() => _PrayerPageState();
}

class _PrayerPageState extends State<PrayerPage> {
  // Paleta de culori
  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);
  static const Color deepBlack = Color(0xFF030303);

  final TextEditingController _prayerController = TextEditingController();
  bool _shareWithOthers = false;
  
  // Mock data pentru rugăciuni împărtășite
  final List<Map<String, dynamic>> _sharedPrayers = [
    {'text': 'Rugați-vă pentru sănătatea mamei mele', 'prayed': false},
    {'text': 'Susțineți-mă în rugăciune pentru noul job', 'prayed': false},
    {'text': 'Rugăciune pentru familia mea', 'prayed': false},
  ];

  @override
  void dispose() {
    _prayerController.dispose();
    super.dispose();
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
                        'Rugăciune',
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: lightGrey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildPrayerRequestCard(),
                      const SizedBox(height: 40),
                      Text(
                        'Rugăciuni împărtășite',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: lightGrey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._sharedPrayers.asMap().entries.map((entry) {
                        return _buildPrayerCard(entry.value, entry.key);
                      }),
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

  Widget _buildPrayerRequestCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: navy.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: navy.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nevoia ta de rugăciune',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: lightGrey,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _prayerController,
            maxLines: 4,
            style: GoogleFonts.inter(color: lightGrey),
            decoration: InputDecoration(
              hintText: 'Scrie nevoia ta de rugăciune...',
              hintStyle: GoogleFonts.inter(color: beige.withOpacity(0.5)),
              filled: true,
              fillColor: deepBlack.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: _shareWithOthers,
                onChanged: (value) => setState(() => _shareWithOthers = value ?? false),
                activeColor: navy,
                checkColor: lightGrey,
              ),
              Expanded(
                child: Text(
                  'Împărtășește cu comunitatea',
                  style: GoogleFonts.inter(fontSize: 14, color: lightGrey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: navy.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.lock_outline, color: beige, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Datele tale rămân private. Doar motivul va fi împărtășit.',
                    style: GoogleFonts.inter(fontSize: 12, color: beige),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_prayerController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Rugăciunea ta a fost trimisă', style: GoogleFonts.inter()),
                      backgroundColor: navy,
                    ),
                  );
                  _prayerController.clear();
                  setState(() => _shareWithOthers = false);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: lightGrey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Trimite', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerCard(Map<String, dynamic> prayer, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: navy.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: navy.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              prayer['text'],
              style: GoogleFonts.inter(fontSize: 14, color: lightGrey),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () => setState(() => _sharedPrayers[index]['prayed'] = !prayer['prayed']),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: prayer['prayed'] ? navy : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: navy, width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.waving_hand, size: 16, color: prayer['prayed'] ? lightGrey : beige),
                  const SizedBox(width: 6),
                  Text(
                    prayer['prayed'] ? 'Rugat' : 'M-am rugat',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: prayer['prayed'] ? lightGrey : beige,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
}