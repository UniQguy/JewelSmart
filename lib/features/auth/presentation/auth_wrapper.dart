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
/// Optimized for seamless role-based routing, spatial continuity, and cinematic crossfading.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    const Color luxuryGold = Color(0xFFD4AF37);

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        Widget nextScreen;

        // 1. SESSION INITIALIZING: Cinematic Entry
        if (snapshot.connectionState == ConnectionState.waiting) {
          nextScreen = _cinematicLoader(luxuryGold, key: const ValueKey('loader_auth'));
        }

        // 2. AUTHENTICATED STATE: Optimized Role-Check
        else if (snapshot.hasData && snapshot.data != null) {
          final User user = snapshot.data!;

          nextScreen = StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .snapshots(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return _cinematicLoader(luxuryGold, key: const ValueKey('loader_doc'));
              }

              // Default to 'customer'
              String role = 'customer';
              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                final data = userSnapshot.data!.data() as Map<String, dynamic>;
                role = (data['role'] ?? 'customer').toString().toLowerCase();
              }

              // High-Caliber Routing Logic (Secured with ValueKeys for smooth transitions)
              switch (role) {
                case "admin":
                  return const AdminDashboard(key: ValueKey('admin_dash'));
                case "staff":
                  return const StaffDashboard(key: ValueKey('staff_dash'));
                default:
                  return const MainWrapper(key: ValueKey('customer_dash'));
              }
            },
          );
        }

        // 3. UNAUTHENTICATED: The Private Vault Entrance
        else {
          nextScreen = const LoginPage(key: ValueKey('login_page'));
        }

        // 4. THE LIQUID TRANSITION ENGINE
        // Eliminates UI flickering and creates a premium fade between auth states.
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 1200),
          switchInCurve: Curves.easeOutExpo,
          switchOutCurve: Curves.easeInExpo,
          child: nextScreen,
        );
      },
    );
  }

  /// LUXURY INITIALIZER
  /// Replaces the default loader with a premium, spatially deep transition.
  Widget _cinematicLoader(Color color, {required Key key}) {
    return Scaffold(
      key: key,
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