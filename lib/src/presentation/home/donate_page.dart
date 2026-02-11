import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/blurred_background.dart';

class DonatePage extends StatefulWidget {
  final bool isStandalone;

  const DonatePage({super.key, this.isStandalone = false});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  static const Color lightGrey = Color(0xFFF1EFEC);
  static const Color beige = Color(0xFFD4C9BE);
  static const Color navy = Color(0xFF123458);

  final TextEditingController _customAmountController = TextEditingController();
  int? _selectedAmount;

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  void _selectAmount(int amount) {
    setState(() {
      _selectedAmount = amount;
      _customAmountController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = _buildContent();

    if (widget.isStandalone) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: BlurredBackground(
          blurAmount: 15.0,
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(child: content),
              ],
            ),
          ),
        ),
      );
    }

    // Tab mode - no Scaffold/BlurredBackground/header
    return content;
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Donează',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: lightGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Susține lucrarea bisericii prin donația ta',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: beige,
            ),
          ),
          const SizedBox(height: 32),

          // Sume predefinite
          _buildAmountButtons(),

          const SizedBox(height: 24),

          // Sumă personalizată
          _buildCustomAmount(),

          const SizedBox(height: 32),

          // Info donație
          _buildDonationInfo(),

          const SizedBox(height: 32),

          // Buton Apple Pay
          _buildApplePayButton(context),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildAmountButtons() {
    final amounts = [50, 100, 200, 500];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: amounts.map((amount) {
        final isSelected = _selectedAmount == amount;
        return OutlinedButton(
          onPressed: () => _selectAmount(amount),
          style: OutlinedButton.styleFrom(
            foregroundColor: isSelected ? lightGrey : lightGrey,
            backgroundColor: isSelected ? navy : Colors.transparent,
            side: BorderSide(color: navy, width: 2),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            '$amount RON',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCustomAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sau introdu o sumă personalizată:',
          style: GoogleFonts.inter(fontSize: 14, color: beige),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _customAmountController,
          keyboardType: TextInputType.number,
          style: GoogleFonts.inter(color: lightGrey),
          onChanged: (_) {
            if (_selectedAmount != null) {
              setState(() => _selectedAmount = null);
            }
          },
          decoration: InputDecoration(
            hintText: '0',
            suffix: Text('RON', style: GoogleFonts.inter(color: beige)),
            hintStyle: GoogleFonts.inter(color: beige.withValues(alpha: 0.5)),
            filled: true,
            fillColor: navy.withValues(alpha: 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: navy),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: navy.withValues(alpha: 0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: navy, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDonationInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: navy.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: navy.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.volunteer_activism, color: lightGrey, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Mulțumim pentru generozitatea ta!',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: lightGrey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Donația ta ne ajută să continuăm lucrarea în comunitate și să răspândim Evanghelia.',
            style: GoogleFonts.inter(fontSize: 14, color: beige, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildApplePayButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Integrarea Apple Pay va fi disponibilă în curând',
                style: GoogleFonts.inter(color: lightGrey),
              ),
              backgroundColor: navy,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        icon: const Icon(Icons.apple, size: 28),
        label: Text(
          'Donează cu Apple Pay',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
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
          const SizedBox(width: 12),
          Text(
            'Donează',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: lightGrey,
            ),
          ),
        ],
      ),
    );
  }
}
