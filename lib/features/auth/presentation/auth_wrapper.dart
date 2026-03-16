import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Editorial Dashboards & Global Shell
import '../../main_wrapper.dart';
import 'login_page.dart';
import 'staff_dashboard.dart';
import 'admin_dashboard.dart';
import '../providers/user_profile_provider.dart';

/// WORLD-CLASS AUTHENTICATION GATEKEEPER
/// Optimized for seamless role-based routing, spatial continuity, and cinematic crossfading.
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color luxuryGold = Color(0xFFD4AF37);

    // Read global states instantly
    final authState = ref.watch(authStateProvider);
    final userProfile = ref.watch(userProfileProvider);

    Widget nextScreen;

    // 1. SESSION INITIALIZING: Cinematic Entry
    if (authState.isLoading || userProfile.isLoading) {
      nextScreen = _cinematicLoader(luxuryGold, key: const ValueKey('loader_auth'));
    }
    // 2. UNAUTHENTICATED: The Private Vault Entrance
    else if (authState.value == null) {
      nextScreen = const LoginPage(key: ValueKey('login_page'));
    }
    // 3. AUTHENTICATED STATE: Optimized Role-Check
    else {
      String role = 'customer';
      if (userProfile.value != null) {
        role = (userProfile.value!['role'] ?? 'customer').toString().toLowerCase();
      }

      // High-Caliber Routing Logic (Secured with ValueKeys for smooth transitions)
      switch (role) {
        case "admin":
          nextScreen = const AdminDashboard(key: ValueKey('admin_dash'));
          break;
        case "staff":
          nextScreen = const StaffDashboard(key: ValueKey('staff_dash'));
          break;
        default:
          nextScreen = const MainWrapper(key: ValueKey('customer_dash'));
      }
    }

    // 4. THE LIQUID TRANSITION ENGINE
    // Eliminates UI flickering and creates a premium fade between auth states.
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1200),
      switchInCurve: Curves.easeOutExpo,
      switchOutCurve: Curves.easeInExpo,
      child: nextScreen,
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