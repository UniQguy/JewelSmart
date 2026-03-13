import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/router/app_routes.dart';
import '../../auth/data/auth_service.dart'; // CRITICAL: Added for secure session termination

/// THE ARTISAN TERMINAL (STAFF DASHBOARD)
/// Engineered for inventory control and repair management with a spatial glassmorphic UI.
class StaffDashboard extends StatelessWidget {
  const StaffDashboard({super.key});

  final Color luxuryGold = const Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Base canvas
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 1. Cinematic 3D Background Aura
          _buildAmbientGlow(),

          // 2. Main Operational Interface
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      _buildHeader(context),
                      const SizedBox(height: 35),

                      _buildSectionLabel("CURRENT OPERATIONS"),
                      const SizedBox(height: 10),
                      _buildOperationalMetrics(context),

                      const SizedBox(height: 40),

                      _buildSectionLabel("VAULT INVENTORY CONTROL"),
                      const SizedBox(height: 10),
                      _buildInventoryActions(context),

                      const SizedBox(height: 80), // Bottom buffer
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

  Widget _buildAmbientGlow() {
    return Positioned(
      bottom: -150,
      left: -100,
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: luxuryGold.withValues(alpha: 0.04),
          boxShadow: [
            BoxShadow(color: luxuryGold.withValues(alpha: 0.05), blurRadius: 120, spreadRadius: 40)
          ],
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 8.seconds),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("STAFF CONTROL PANEL", style: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 6, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text("ARTISAN DESK", style: TextStyle(color: luxuryGold, fontSize: 16, letterSpacing: 4, fontWeight: FontWeight.w900)),
            ],
          ),
          ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 16),
                onPressed: () async {
                  // SECURE SESSION TERMINATION
                  await AuthService().signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                  }
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 6)
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildOperationalMetrics(BuildContext context) {
    return AnimationLimiter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 600),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 40.0,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              Expanded(
                child: _buildGlassMetricCard(
                    "TOTAL STOCK",
                    "842",
                    Icons.diamond_outlined,
                    onTap: () {}
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildGlassMetricCard(
                  "PENDING REPAIRS",
                  "12",
                  Icons.build_circle_outlined,
                  isAlert: true,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.repairManagement),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassMetricCard(String label, String value, IconData icon, {bool isAlert = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.02),
          border: Border.all(color: isAlert ? Colors.orangeAccent.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.05), width: 0.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 5)
          ],
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(icon, color: isAlert ? Colors.orangeAccent : luxuryGold.withValues(alpha: 0.6), size: 22),
                      const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 10),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Text(label, style: const TextStyle(color: Colors.white38, fontSize: 7, letterSpacing: 3, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(value, style: TextStyle(color: isAlert ? Colors.orangeAccent : Colors.white, fontSize: 24, letterSpacing: 2, fontWeight: FontWeight.w300)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInventoryActions(BuildContext context) {
    final actions = [
      // CRITICAL UPDATE: Added routing parameter for introducing new products
      {"label": "INTRODUCE NEW COLLECTION", "icon": Icons.add_photo_alternate_outlined, "color": luxuryGold, "route": AppRoutes.addProduct},
      {"label": "PROCESS INCOMING STOCK", "icon": Icons.add_circle_outline, "color": Colors.white54, "route": ""},
      {"label": "RECORD STOCK OUT", "icon": Icons.remove_circle_outline, "color": Colors.white54, "route": ""},
      {"label": "GENERATE CLIENT INVOICE", "icon": Icons.receipt_long_outlined, "color": Colors.white54, "route": ""},
    ];

    return AnimationLimiter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 600),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 30.0,
              child: FadeInAnimation(child: widget),
            ),
            children: actions.map((action) => _buildActionTile(
                context,
                action["label"] as String,
                action["icon"] as IconData,
                action["color"] as Color,
                action["route"] as String
            )).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, String label, IconData icon, Color color, String route) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.01),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            leading: Icon(icon, color: color, size: 20),
            title: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 4, fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 12),
            onTap: () {
              if (route.isNotEmpty) {
                Navigator.pushNamed(context, route);
              }
            },
          ),
        ),
      ),
    );
  }
}