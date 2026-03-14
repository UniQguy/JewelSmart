import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // CRITICAL: Added for Haptic Feedback
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/router/app_routes.dart';
import '../../auth/data/auth_service.dart';
import '../../admin/presentation/generate_invoice_screen.dart';

/// THE ARTISAN TERMINAL (STAFF DASHBOARD)
/// Engineered for live inventory control, spatial web scaling, and real-time Firestore synchronization.
class StaffDashboard extends StatefulWidget {
  const StaffDashboard({super.key});

  @override
  State<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {
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

          // 2. Main Operational Interface (Web Scaled)
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800), // Web Scaler matching Admin Dashboard
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

                          _buildSectionLabel("LIVE CURRENT OPERATIONS"),
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
              // LIVE IDENTITY: Streams the logged-in staff member's real name
              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseAuth.instance.currentUser != null
                      ? FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots()
                      : const Stream.empty(),
                  builder: (context, snapshot) {
                    String name = "AUTHENTICATING...";
                    if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
                      name = snapshot.data!.get('name') ?? "ARTISAN";
                    }
                    return Text("$name (STAFF)".toUpperCase(), style: TextStyle(color: luxuryGold, fontSize: 16, letterSpacing: 4, fontWeight: FontWeight.w900));
                  }
              ),
            ],
          ),
          ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 16),
                onPressed: () async {
                  HapticFeedback.heavyImpact();
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
              Expanded(child: _buildStreamMetricCard("TOTAL STOCK", 'products', Icons.diamond_outlined)),
              const SizedBox(width: 20),
              Expanded(
                child: _buildStreamMetricCard(
                    "PENDING REPAIRS",
                    'repairs',
                    Icons.build_circle_outlined,
                    isAlert: true,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.pushNamed(context, AppRoutes.repairManagement);
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreamMetricCard(String label, String collectionPath, IconData icon, {bool isAlert = false, VoidCallback? onTap}) {
    return StreamBuilder<AggregateQuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(collectionPath).count().get().asStream(),
        builder: (context, snapshot) {
          String value = "0";
          bool isLoading = true;

          if (snapshot.hasData) {
            value = snapshot.data!.count.toString();
            isLoading = false;
          } else if (snapshot.hasError) {
            value = "ERR";
            isLoading = false;
          }

          return GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.02),
                border: Border.all(color: isAlert ? Colors.orangeAccent.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.05), width: 0.5),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 5)],
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
                            if (onTap != null) const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 10),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 7, letterSpacing: 3, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        isLoading
                            ? SizedBox(height: 15, width: 15, child: CircularProgressIndicator(color: isAlert ? Colors.orangeAccent : luxuryGold, strokeWidth: 1.5))
                            : Text(value, style: TextStyle(color: isAlert ? Colors.orangeAccent : Colors.white, fontSize: 24, letterSpacing: 2, fontWeight: FontWeight.w300)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  Widget _buildInventoryActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          // HIGHLIGHTED ACTION 1: ADD PRODUCT
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.pushNamed(context, AppRoutes.addProduct);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: luxuryGold.withValues(alpha: 0.1),
                border: Border.all(color: luxuryGold.withValues(alpha: 0.5), width: 0.5),
                boxShadow: [BoxShadow(color: luxuryGold.withValues(alpha: 0.1), blurRadius: 20, spreadRadius: 5)],
              ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Row(
                      children: [
                        Icon(Icons.add_photo_alternate_outlined, color: luxuryGold, size: 28),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("INTRODUCE NEW COLLECTION", style: TextStyle(color: luxuryGold, fontSize: 10, letterSpacing: 4, fontWeight: FontWeight.w900)),
                              const SizedBox(height: 4),
                              const Text("Upload a new 3D asset to the global vault", style: TextStyle(color: Colors.white54, fontSize: 8, letterSpacing: 2)),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded, color: luxuryGold.withValues(alpha: 0.5), size: 14),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(duration: 800.ms, delay: 400.ms),

          // HIGHLIGHTED ACTION 2: THE MASTER KEY (Manage Inventory)
          // Replaces the old dead placeholders with visual live management
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              // Routes Staff to the storefront so they can long-press and adjust stock.
              Navigator.pushNamed(context, AppRoutes.category, arguments: "ALL EXHIBITS");
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 25),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 0.5),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 5)],
              ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Row(
                      children: [
                        const Icon(Icons.display_settings_outlined, color: Colors.white, size: 28),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("MANAGE INVENTORY", style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 4, fontWeight: FontWeight.w900)),
                              const SizedBox(height: 4),
                              Text("Long-press items in the vault to update live stock", style: TextStyle(color: luxuryGold.withValues(alpha: 0.8), fontSize: 8, letterSpacing: 2)),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withValues(alpha: 0.3), size: 14),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(duration: 800.ms, delay: 500.ms),

          // INVOICE LOGISTICS
          _buildActionTile(context, "GENERATE CLIENT INVOICE", Icons.receipt_long_outlined, Colors.white54, destination: const GenerateInvoiceScreen()),
        ],
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, String label, IconData icon, Color color, {Widget? destination}) {
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
              HapticFeedback.selectionClick();
              if (destination != null) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
              }
            },
          ),
        ),
      ),
    );
  }
}