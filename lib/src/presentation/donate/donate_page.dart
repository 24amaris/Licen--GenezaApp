// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../home/widgets/blurred_background.dart';

// class DonatePage extends StatelessWidget {
//   const DonatePage({super.key});

//   // Paleta de culori
//   static const Color lightGrey = Color(0xFFF1EFEC);
//   static const Color beige = Color(0xFFD4C9BE);
//   static const Color navy = Color(0xFF123458);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: BlurredBackground(
//         blurAmount: 15.0,
//         child: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(context),
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Donează',
//                         style: GoogleFonts.inter(
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                           color: lightGrey,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'Susține lucrarea bisericii prin donația ta',
//                         style: GoogleFonts.inter(
//                           fontSize: 16,
//                           color: beige,
//                         ),
//                       ),
//                       const SizedBox(height: 40),
                      
//                       // Sume predefinite
//                       _buildAmountButtons(),
                      
//                       const SizedBox(height: 24),
                      
//                       // Sau sumă personalizată
//                       _buildCustomAmount(),
                      
//                       const SizedBox(height: 40),
                      
//                       // Info donație
//                       _buildDonationInfo(),
                      
//                       const SizedBox(height: 40),
                      
//                       // Buton Apple Pay
//                       _buildApplePayButton(context),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAmountButtons() {
//     final amounts = [50, 100, 200, 500];
//     return Wrap(
//       spacing: 12,
//       runSpacing: 12,
//       children: amounts.map((amount) {
//         return OutlinedButton(
//           onPressed: () {},
//           style: OutlinedButton.styleFrom(
//             foregroundColor: lightGrey,
//             side: BorderSide(color: navy, width: 2),
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           ),
//           child: Text(
//             '$amount RON',
//             style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildCustomAmount() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Sau introdu o sumă personalizată:',
//           style: GoogleFonts.inter(fontSize: 14, color: beige),
//         ),
//         const SizedBox(height: 12),
//         TextField(
//           keyboardType: TextInputType.number,
//           style: GoogleFonts.inter(color: lightGrey),
//           decoration: InputDecoration(
//             hintText: '0',
//             suffix: Text('RON', style: GoogleFonts.inter(color: beige)),
//             hintStyle: GoogleFonts.inter(color: beige.withOpacity(0.5)),
//             filled: true,
//             fillColor: navy.withOpacity(0.2),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: navy),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDonationInfo() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: navy.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: navy.withOpacity(0.3)),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Icon(Icons.volunteer_activism, color: lightGrey, size: 24),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   'Mulțumim pentru generozitatea ta!',
//                   style: GoogleFonts.inter(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: lightGrey,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'Donația ta ne ajută să continuăm lucrarea în comunitate și să răspândim Evanghelia.',
//             style: GoogleFonts.inter(fontSize: 14, color: beige, height: 1.5),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildApplePayButton(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 60,
//       child: ElevatedButton.icon(
//         onPressed: () {
//           // TODO: Implementează Apple Pay
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 'Integrarea Apple Pay va fi disponibilă în curând',
//                 style: GoogleFonts.inter(),
//               ),
//               backgroundColor: navy,
//             ),
//           );
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.black,
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         icon: const Icon(Icons.apple, size: 28),
//         label: Text(
//           'Donează cu Apple Pay',
//           style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: navy.withOpacity(0.2),
//               shape: BoxShape.circle,
//             ),
//             child: IconButton(
//               icon: const Icon(Icons.arrow_back, color: lightGrey),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }