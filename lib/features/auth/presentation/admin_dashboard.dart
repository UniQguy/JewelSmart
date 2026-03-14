import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/router/app_routes.dart';
import '../../auth/data/auth_service.dart';

/// THE COMMAND CENTER (ADMIN DASHBOARD)
/// Engineered as a live, high-clearance executive terminal wired directly to the Firestore mainframe.
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
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

                      _buildSectionLabel("LIVE EXECUTIVE OVERVIEW"),
                      const SizedBox(height: 10),
                      _buildLiveKPIGrid(), // Now strictly connected to Cloud Data

                      const SizedBox(height: 40),

                      _buildSectionLabel("VAULT OPERATIONS"),
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
              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseAuth.instance.currentUser != null
                      ? FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots()
                      : const Stream.empty(),
                  builder: (context, snapshot) {
                    String name = "AUTHENTICATING...";
                    if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
                      name = snapshot.data!.get('name') ?? "ADMIN";
                    }
                    return Text("$name (ADMIN)".toUpperCase(), style: TextStyle(color: luxuryGold, fontSize: 16, letterSpacing: 4, fontWeight: FontWeight.w900));
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
                  await AuthService().signOut();
                  if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
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

  /// CRITICAL UPDATE: Rips out the hardcoded stats and calculates real values from Firestore
  Widget _buildLiveKPIGrid() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('purchases').snapshots(),
        builder: (context, snapshot) {
          double totalRevenue = 0.0;
          int pendingOrders = 0;

          if (snapshot.hasData) {
            for (var doc in snapshot.data!.docs) {
              final data = doc.data() as Map<String, dynamic>;
              final status = (data['status'] as String?)?.toUpperCase() ?? '';
              final amount = (data['amountPaid'] ?? 0.0) as num;

              if (status == 'SECURED' || status == 'DELIVERED') {
                totalRevenue += amount.toDouble();
              } else if (status == 'PROCESSING') {
                pendingOrders++;
              }
            }
          }

          // Format revenue to look premium (e.g., $1.4K, $2.5M)
          String formattedRevenue = "\$0.00";
          if (totalRevenue >= 1000000) {
            formattedRevenue = "\$${(totalRevenue / 1000000).toStringAsFixed(1)}M";
          } else if (totalRevenue >= 1000) {
            formattedRevenue = "\$${(totalRevenue / 1000).toStringAsFixed(1)}K";
          } else {
            formattedRevenue = "\$${totalRevenue.toStringAsFixed(0)}";
          }

          return AnimationLimiter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1.1,
                children: [
                  _buildGlassMetricCard("TOTAL VAULT VALUE", formattedRevenue, Icons.account_balance_wallet_outlined, isLoading: !snapshot.hasData),
                  _buildGlassMetricCard("PENDING ORDERS", "$pendingOrders", Icons.inventory_2_outlined, isLoading: !snapshot.hasData),
                  _buildStreamMetricCard("ACTIVE ACCOUNTS", 'users', Icons.people_outline), // Streams user count
                  _buildStreamMetricCard("TOTAL ASSETS", 'products', Icons.diamond_outlined), // Streams product count
                ],
              ),
            ),
          );
        }
    );
  }

  // Helper to quickly count documents in a collection for KPIs
  Widget _buildStreamMetricCard(String label, String collectionPath, IconData icon) {
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

          return _buildGlassMetricCard(label, value, icon, isLoading: isLoading);
        }
    );
  }

  Widget _buildGlassMetricCard(String label, String value, IconData icon, {bool isLoading = false}) {
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
                    isLoading
                        ? SizedBox(height: 15, width: 15, child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1.5))
                        : Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 2, fontWeight: FontWeight.w300)),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          // HIGHLIGHTED ACTION: ADD PRODUCT
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.addProduct),
            child: Container(
              margin: const EdgeInsets.only(bottom: 25),
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
                        Icon(Icons.add_box_outlined, color: luxuryGold, size: 28),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("ADD NEW COLLECTION", style: TextStyle(color: luxuryGold, fontSize: 10, letterSpacing: 4, fontWeight: FontWeight.w900)),
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

          // Standard Actions
          _buildActionTile(context, "MANAGE USERS & ROLES", Icons.admin_panel_settings_outlined, null),
          _buildActionTile(context, "VIEW ACTIVE ORDERS", Icons.assignment_outlined, null),
          _buildActionTile(context, "GLOBAL SYSTEM SETTINGS", Icons.settings_applications_outlined, null),
        ],
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, String label, IconData icon, String? routeName) {
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
            leading: Icon(icon, color: Colors.white54, size: 20),
            title: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 4, fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 12),
            onTap: routeName != null ? () => Navigator.pushNamed(context, routeName) : () {
              // Placeholder for future modules
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.black.withValues(alpha: 0.9),
                  content: Text("MODULE ENCRYPTED: $label", style: const TextStyle(color: Colors.white, fontSize: 8, letterSpacing: 2)),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}