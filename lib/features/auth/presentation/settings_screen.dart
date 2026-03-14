import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// THE GLOBAL PREFERENCES TERMINAL (SETTINGS)
/// Engineered as a unified, spatial interface for Vault configuration.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Color luxuryGold = const Color(0xFFD4AF37);

  // Local State for interactive toggles
  bool _biometricsEnabled = true;
  bool _pushNotifications = true;
  bool _emailUpdates = false;
  bool _locationTracking = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _buildLiquidAppBar(context),
      body: Stack(
        children: [
          // 1. Cinematic 3D Background Aura
          _buildAmbientGlow(),

          // 2. Main Interface (Web Scaled)
          SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(25, 20, 25, 100),
                  children: [
                    _buildSectionHeader("SECURITY PROTOCOLS"),
                    _buildSettingsBlock([
                      _buildToggleRow("BIOMETRIC AUTHENTICATION", "Require FaceID/TouchID for Vault Access", _biometricsEnabled, (val) => setState(() => _biometricsEnabled = val)),
                      _buildDivider(),
                      _buildActionRow("CHANGE SECURITY KEY", "Update your encryption password", Icons.password_rounded),
                    ]),

                    const SizedBox(height: 40),

                    _buildSectionHeader("COMMUNICATION CHANNELS"),
                    _buildSettingsBlock([
                      _buildToggleRow("PUSH NOTIFICATIONS", "Live logistics & acquisition updates", _pushNotifications, (val) => setState(() => _pushNotifications = val)),
                      _buildDivider(),
                      _buildToggleRow("EXCLUSIVE EMAIL LEDGER", "Curated collections and editorial news", _emailUpdates, (val) => setState(() => _emailUpdates = val)),
                    ]),

                    const SizedBox(height: 40),

                    _buildSectionHeader("SYSTEM PREFERENCES"),
                    _buildSettingsBlock([
                      _buildToggleRow("SPATIAL LOCATION", "Optimize boutique delivery routing", _locationTracking, (val) => setState(() => _locationTracking = val)),
                      _buildDivider(),
                      // Hardcoded for aesthetic purposes
                      _buildInfoRow("BASE CURRENCY", "INDIAN RUPEE (₹)"),
                      _buildDivider(),
                      _buildInfoRow("INTERFACE THEME", "OBSIDIAN (LOCKED)"),
                      _buildDivider(),
                      _buildActionRow("CLEAR LOCAL CACHE", "Free up device memory", Icons.cleaning_services_rounded),
                    ]),

                    const SizedBox(height: 60),
                    Center(
                      child: Text(
                        "JEWELSMART OS v1.0.0",
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 8, letterSpacing: 6, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildLiquidAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(90),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: AppBar(
            backgroundColor: Colors.black.withValues(alpha: 0.5),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 14),
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.maybePop(context);
              },
            ),
            title: Text('SYSTEM PREFERENCES', style: TextStyle(color: luxuryGold, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 10)),
          ),
        ),
      ),
    );
  }

  Widget _buildAmbientGlow() {
    return Positioned(
      top: -100,
      left: -50,
      child: Container(
        width: 400, height: 400,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: luxuryGold.withValues(alpha: 0.03),
          boxShadow: [BoxShadow(color: luxuryGold.withValues(alpha: 0.05), blurRadius: 120, spreadRadius: 40)],
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 8.seconds),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 5),
      child: Text(
        title,
        style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 6),
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildSettingsBlock(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 5)],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Column(children: children),
        ),
      ),
    ).animate().slideY(begin: 0.1, end: 0, duration: 600.ms, curve: Curves.easeOutQuart);
  }

  Widget _buildToggleRow(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 3, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 8, letterSpacing: 1)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (val) {
              HapticFeedback.lightImpact();
              onChanged(val);
            },
            activeColor: Colors.black,
            activeTrackColor: luxuryGold,
            inactiveThumbColor: Colors.white54,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(String title, String subtitle, IconData icon) {
    return InkWell(
      onTap: () => HapticFeedback.selectionClick(),
      highlightColor: luxuryGold.withValues(alpha: 0.1),
      splashColor: luxuryGold.withValues(alpha: 0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 3, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 8, letterSpacing: 1)),
                ],
              ),
            ),
            Icon(icon, color: Colors.white.withValues(alpha: 0.3), size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 3, fontWeight: FontWeight.w600)),
          Text(value, style: TextStyle(color: luxuryGold, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.white.withValues(alpha: 0.05), height: 1, indent: 25, endIndent: 25);
  }
}