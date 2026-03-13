import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/router/app_routes.dart';

/// THE COMMAND CENTER (ADMIN DASHBOARD)
/// Engineered as a high-clearance executive terminal with spatial metrics.
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

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

          // 2. Main Executive Interface
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

                      _buildSectionLabel("EXECUTIVE OVERVIEW"),
                      const SizedBox(height: 10),
                      _buildKPIGrid(),

                      const SizedBox(height: 40),

                      _buildSectionLabel("SYSTEM ADMINISTRATION"),
                      const SizedBox(height: 10),
                      _buildActionList(context),

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
      top: -150,
      right: -100,
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
              const Text("SECURE TERMINAL", style: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 6, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text("PRASHANT (ADMIN)", style: TextStyle(color: luxuryGold, fontSize: 16, letterSpacing: 4, fontWeight: FontWeight.w900)),
            ],
          ),
          ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 16),
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false),
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

  Widget _buildKPIGrid() {
    final kpis = [
      {"label": "TOTAL REVENUE", "value": "\$1.4M", "icon": Icons.account_balance_wallet_outlined},
      {"label": "ACTIVE USERS", "value": "1,248", "icon": Icons.people_outline},
      {"label": "PENDING ORDERS", "value": "34", "icon": Icons.inventory_2_outlined},
      {"label": "REPAIR QUEUE", "value": "12", "icon": Icons.build_circle_outlined},
    ];

    return AnimationLimiter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1.1,
          ),
          itemCount: kpis.length,
          itemBuilder: (context, index) {
            final kpi = kpis[index];
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 600),
              columnCount: 2,
              child: SlideAnimation(
                verticalOffset: 40.0,
                child: FadeInAnimation(
                  child: _buildGlassMetricCard(
                      kpi["label"] as String,
                      kpi["value"] as String,
                      kpi["icon"] as IconData
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGlassMetricCard(String label, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: luxuryGold.withValues(alpha: 0.6), size: 22),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 3, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 2, fontWeight: FontWeight.w300)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionList(BuildContext context) {
    final actions = [
      {"label": "MANAGE USERS & ROLES", "icon": Icons.admin_panel_settings_outlined, "route": ""},
      {"label": "INVENTORY & VAULT CONTROL", "icon": Icons.diamond_outlined, "route": ""},
      {"label": "GENERATE ANALYTICAL REPORTS", "icon": Icons.insert_chart_outlined, "route": ""},
      {"label": "GLOBAL SYSTEM SETTINGS", "icon": Icons.settings_applications_outlined, "route": ""},
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
            children: actions.map((action) => _buildActionTile(action["label"] as String, action["icon"] as IconData)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile(String label, IconData icon) {
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
            leading: Icon(icon, color: luxuryGold, size: 20),
            title: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 4, fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 12),
            onTap: () {
              // Future Routing Logic for Admin Sub-pages
            },
          ),
        ),
      ),
    );
  }
}