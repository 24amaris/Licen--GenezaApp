import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/blurred_background.dart';
import '../layout/main_layout.dart';

class HomeGroupsPage extends StatefulWidget {
  const HomeGroupsPage({super.key});

  @override
  State<HomeGroupsPage> createState() => _HomeGroupsPageState();
}

class _HomeGroupsPageState extends State<HomeGroupsPage> {
  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);

  // Lista de grupuri de casă
  final List<Map<String, String>> groups = [
    {'name': 'Grup de tineri 2 - Familie Cirdei', 'description': 'Tineri impreună cu familia Cirdei'},
    {'name': 'Grup de tineri 2 - Familie Cordoș', 'description': 'Tineri impreună cu familia Cordoș'},
    {'name': 'Buhas (Seniorii bisericii)', 'description': 'Grup pentru seniorii bisericii'},
    {'name': 'Familie Coras', 'description': 'Grup familia Coras'},
    {'name': 'Familistii (Familie Alexandru)', 'description': 'Familii impreună cu familia Alexandru'},
    {'name': 'Familie Reilean (Familii tinere)', 'description': 'Familii tinere - Familie Reilean'},
    {'name': 'Familie Mateas (Familii tinere)', 'description': 'Familii tinere - Familie Mateas'},
  ];

  String? _selectedGroup;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _churchController = TextEditingController();
  final TextEditingController _motivationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _churchController.dispose();
    _motivationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_selectedGroup == null ||
        _nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _churchController.text.isEmpty ||
        _motivationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completează toate câmpurile')),
      );
      return;
    }

    // TODO: Implementare salvare formular în Firebase/backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Formular trimis cu succes!')),
    );

    // Resetează form
    setState(() {
      _selectedGroup = null;
      _nameController.clear();
      _phoneController.clear();
      _churchController.clear();
      _motivationController.clear();
    });
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
                      // Titlu grupuri
                      Text(
                        'Alege grupul de casă',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: beige,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Dropdown grupuri
                      Container(
                        decoration: BoxDecoration(
                          color: navy.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: navy.withValues(alpha: 0.3)),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedGroup,
                          hint: Text(
                            'Selectează un grup',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: beige.withValues(alpha: 0.4),
                            ),
                          ),
                          isExpanded: true,
                          underline: const SizedBox(),
                          dropdownColor: navy,
                          items: groups.map((group) {
                            return DropdownMenuItem<String>(
                              value: group['name'],
                              child: Text(
                                group['name']!,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: lightGrey,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGroup = value;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Motivație
                      if (_selectedGroup != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'De ce vrei să te implici în acest grup?',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: beige,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: navy.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(14),
                                border:
                                    Border.all(color: navy.withValues(alpha: 0.3)),
                              ),
                              child: TextField(
                                controller: _motivationController,
                                maxLines: 5,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: lightGrey,
                                  height: 1.6,
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      'Descrie-ți motivația și ce vrei să aduci în grup...',
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: beige.withValues(alpha: 0.4),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(16),
                                  filled: false,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),

                      // Datele personale
                      Text(
                        'Datele tale',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: beige,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Nume
                      Text(
                        'Nume',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: beige,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: navy.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: navy.withValues(alpha: 0.3)),
                        ),
                        child: TextField(
                          controller: _nameController,
                          style: GoogleFonts.inter(fontSize: 14, color: lightGrey),
                          decoration: InputDecoration(
                            hintText: 'Introdu numele tău',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 14,
                              color: beige.withValues(alpha: 0.4),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                            filled: false,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Telefon
                      Text(
                        'Telefon',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: beige,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: navy.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: navy.withValues(alpha: 0.3)),
                        ),
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: GoogleFonts.inter(fontSize: 14, color: lightGrey),
                          decoration: InputDecoration(
                            hintText: 'Introdu numărul tău',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 14,
                              color: beige.withValues(alpha: 0.4),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                            filled: false,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Biserica
                      Text(
                        'Biserica de proveniență',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: beige,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: navy.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: navy.withValues(alpha: 0.3)),
                        ),
                        child: TextField(
                          controller: _churchController,
                          style: GoogleFonts.inter(fontSize: 14, color: lightGrey),
                          decoration: InputDecoration(
                            hintText: 'Introdu Biserica ta',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 14,
                              color: beige.withValues(alpha: 0.4),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                            filled: false,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Buton trimite
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: _submitForm,
                          icon: const Icon(Icons.send, size: 20),
                          label: Text(
                            'Trimite formular',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: navy,
                            foregroundColor: lightGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: navy.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: lightGrey),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  MainLayout.of(context)?.setIndex(0);
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Grupele de casă',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: lightGrey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
