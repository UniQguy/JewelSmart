import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Editorial Dashboards
import 'home_page.dart';
import 'login_page.dart';
import 'staff_dashboard.dart';
import 'admin_dashboard.dart';

/// WORLD-CLASS AUTHENTICATION GATEKEEPER
/// Optimized to eliminate latency and implement role-based routing with elegance.
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
            // We use snapshots() instead of get() to react instantly to role changes
            // without manual refreshing.
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .snapshots(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return _cinematicLoader(luxuryGold);
              }

              // Default to 'Customer' if document hasn't propagated yet
              String role = 'Customer';
              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                final data = userSnapshot.data!.data() as Map<String, dynamic>;
                role = data['role'] ?? 'Customer';
              }

              // High-Caliber Routing Logic
              switch (role) {
                case "Admin":
                  return const AdminDashboard();
                case "Staff":
                  return const StaffDashboard();
                default:
                  return const HomePage();
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
  /// Replaces the "childish" default loader with a premium editorial transition.
  Widget _cinematicLoader(Color color) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Minimalist geometric loader
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: color,
                strokeWidth: 1, // Ultra-thin line for a refined look
              ),
            ).animate(onPlay: (c) => c.repeat())
                .scale(duration: 1.seconds, begin: const Offset(1, 1), end: const Offset(1.2, 1.2), curve: Curves.easeInOut),

            const SizedBox(height: 30),

            const Text(
              "INITIALIZING SECURE ACCESS",
              style: TextStyle(
                color: Colors.white24,
                fontSize: 8,
                letterSpacing: 4,
                fontWeight: FontWeight.w900,
              ),
            ).animate().fadeIn(duration: 800.ms),
          ],
        ),
      ),
    );
  }
}