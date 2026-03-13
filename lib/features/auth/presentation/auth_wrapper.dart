import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Editorial Dashboards & Global Shell
import '../../main_wrapper.dart';
import 'login_page.dart';
import 'staff_dashboard.dart';
import 'admin_dashboard.dart';

/// WORLD-CLASS AUTHENTICATION GATEKEEPER
/// Optimized for seamless role-based routing and uninterrupted 3D spatial continuity.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    const Color luxuryGold = Color(0xFFD4AF37);

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1. SESSION INITIALIZING: Cinematic Entry
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _cinematicLoader(luxuryGold);
        }

        // 2. AUTHENTICATED STATE: Optimized Role-Check
        if (snapshot.hasData && snapshot.data != null) {
          final User user = snapshot.data!;

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .snapshots(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return _cinematicLoader(luxuryGold);
              }

              // Default to 'customer'
              String role = 'customer';
              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                final data = userSnapshot.data!.data() as Map<String, dynamic>;
                // FIXED: Normalize to lowercase to match your Firestore entries exactly
                role = (data['role'] ?? 'customer').toString().toLowerCase();
              }

              // High-Caliber Routing Logic
              switch (role) {
                case "admin":
                  return const AdminDashboard();
                case "staff":
                  return const StaffDashboard();
                default:
                  return const MainWrapper();
              }
            },
          );
        }

        // 3. UNAUTHENTICATED: The Private Vault Entrance
        return const LoginPage();
      },
    );
  }

  /// LUXURY INITIALIZER
  /// Replaces the default loader with a premium, spatially deep transition.
  Widget _cinematicLoader(Color color) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    color.withValues(alpha: 0.08),
                    Colors.black,
                  ],
                ),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 6.seconds),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 45,
                  height: 45,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: color.withValues(alpha: 0.2),
                        strokeWidth: 1,
                        value: 1.0,
                      ),
                      CircularProgressIndicator(
                        color: color,
                        strokeWidth: 1.5,
                      ),
                    ],
                  ),
                ).animate(onPlay: (c) => c.repeat())
                    .scale(duration: 1.5.seconds, begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), curve: Curves.easeInOutSine),

                const SizedBox(height: 40),

                const Text(
                  "INITIALIZING SECURE ACCESS",
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 8,
                    letterSpacing: 6,
                    fontWeight: FontWeight.w900,
                  ),
                ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 1.seconds),
              ],
            ),
          ),
        ],
      ),
    );
  }
}