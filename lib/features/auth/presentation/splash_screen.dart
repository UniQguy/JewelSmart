import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
// Ensure this path matches your project
import '../../../core/router/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  final Color luxuryGold = const Color(0xFFD4AF37);

  late AnimationController _fadeController;
  late Animation<double> _logoFade;
  late Animation<double> _guideFade;

  @override
  void initState() {
    super.initState();

    // Cinematic Fade Sequence
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _logoFade = CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    _guideFade = CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
    );

    _fadeController.forward();

    // Transition to AuthWrapper (where your login logic lives)
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, AppRoutes.authWrapper);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Subtle Ambient Background
          _buildBackgroundAura(),

          // 2. Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Brand Logo with Letter Spacing
                FadeTransition(
                  opacity: _logoFade,
                  child: Column(
                    children: [
                      Text(
                        "JEWEL SMART",
                        style: TextStyle(
                          color: luxuryGold,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "ESTATE COLLECTIONS • 2026",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 9,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 120),

                // 3. Academic Guidance Credit
                FadeTransition(
                  opacity: _guideFade,
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 0.5,
                        color: luxuryGold.withOpacity(0.4),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "GUIDED BY",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 7,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "PROF. RUCHIKA RAMI",
                        style: TextStyle(
                          color: luxuryGold.withOpacity(0.7),
                          fontSize: 10,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
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
            radius: 0.8,
            colors: [
              luxuryGold.withOpacity(0.05),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}