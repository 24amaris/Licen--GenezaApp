import 'dart:ui';
import 'package:flutter/material.dart';

/// Widget pentru fundal blurat în toată aplicația
class BlurredBackground extends StatelessWidget {
  final Widget child;
  final double blurAmount;

  const BlurredBackground({
    super.key,
    required this.child,
    this.blurAmount = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Imaginea de fundal
        Positioned.fill(
          child: Image.asset(
            'assets/images/fundal.jpeg',
            fit: BoxFit.cover,
          ),
        ),
        
        // Blur overlay
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: blurAmount,
              sigmaY: blurAmount,
            ),
            child: Container(
              color: Colors.black.withOpacity(0.5), // Overlay semi-transparent
            ),
          ),
        ),
        
        // Conținutul (deasupra fundalului blurat)
        Positioned.fill(
          child: child,
        ),
      ],
    );
  }
}