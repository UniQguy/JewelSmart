import 'package:flutter/material.dart';
import 'dart:async'; // Required for Timer or Future.delayed

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // This timer holds the splash screen for 3 seconds, then moves to Login
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // We use pushReplacementNamed so the user can't go back to the splash
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1A1A1A), // Dark elegant background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.diamond_outlined,
              size: 80,
              color: Color(0xFFD4AF37),
            ),
            SizedBox(height: 20),
            Text(
              'JEWEL SMART',
              style: TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}