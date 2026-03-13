import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/router/app_routes.dart';

/// THE GRAND OVERTURE
/// Engineered with volumetric lighting and cinematic particle effects.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Color luxuryGold = const Color(0xFFD4AF37);

  @override
  void initState() {
    super.initState();
    // Transition to AuthWrapper after the cinematic sequence concludes
    Timer(const Duration(milliseconds: 4500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.authWrapper);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Deep Volumetric Aura
          _buildBackgroundAura(),

          // 2. Cinematic Particle Effect
          Positioned.fill(
            child: CustomPaint(
              painter: _SparklePainter(color: luxuryGold),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 3.seconds),

          // 3. Main Exhibition Text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Brand Logo Sequence
                Column(
                  children: [
                    Text(
                      "JEWEL SMART",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: luxuryGold,
                          fontSize: 24, // Reduced slightly to ensure single-line fit
                          fontWeight: FontWeight.w900,
                          letterSpacing: 12, // Optimized spacing to prevent line wrapping
                          shadows: [Shadow(color: luxuryGold.withValues(alpha: 0.4), blurRadius: 40)]
                      ),
                    ).animate().fadeIn(duration: 1.5.seconds).scale(begin: const Offset(0.95, 0.95), end: const Offset(1.0, 1.0), duration: 2.seconds, curve: Curves.easeOutQuart),

                    const SizedBox(height: 12),

                    Text(
                      "ESTATE COLLECTIONS • 2026",
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 9,
                          letterSpacing: 6,
                          fontWeight: FontWeight.bold
                      ),
                    ).animate().fadeIn(delay: 800.ms, duration: 1.seconds).slideY(begin: -0.2, end: 0),
                  ],
                ),

                const SizedBox(height: 140),

                // Academic Guidance Credit
                Column(
                  children: [
                    Container(
                      width: 50,
                      height: 0.5,
                      color: luxuryGold.withValues(alpha: 0.4),
                    ).animate().scaleX(delay: 1.2.seconds, duration: 800.ms, curve: Curves.easeInOutExpo),

                    const SizedBox(height: 20),

                    Text(
                      "GUIDED BY",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.3),
                        fontSize: 7,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "PROF. RUCHIKA RAMI",
                      style: TextStyle(
                        color: luxuryGold.withValues(alpha: 0.8),
                        fontSize: 10,
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 1.5.seconds, duration: 1.seconds),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundAura() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              luxuryGold.withValues(alpha: 0.12),
              Colors.black,
            ],
          ),
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 8.seconds),
    );
  }
}

class _SparklePainter extends CustomPainter {
  final Color color;
  _SparklePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: 0.15);

    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.25), 1.5, paint);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.15), 1.0, paint);
    canvas.drawCircle(Offset(size.width * 0.50, size.height * 0.10), 2.0, paint);
    canvas.drawCircle(Offset(size.width * 0.20, size.height * 0.75), 1.2, paint);
    canvas.drawCircle(Offset(size.width * 0.80, size.height * 0.80), 1.8, paint);
    canvas.drawCircle(Offset(size.width * 0.40, size.height * 0.60), 0.8, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}