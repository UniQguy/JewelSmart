import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/router/app_routes.dart';
import '../../auth/presentation/edit_profile_screen.dart';
import '../../auth/presentation/acquisition_history_page.dart';
import '../../wishlist/presentation/wishlist_page.dart';
import '../../auth/data/auth_service.dart';
import '../../auth/presentation/settings_screen.dart';

/// THE VIP CLIENT DOSSIER (PROFILE)
/// Engineered with an interactive 3D Black Card identity, live address routing, and real-time logistics tracking.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  final Color luxuryGold = const Color(0xFFD4AF37);

  // 3D Card Physics
  Offset _cardTilt = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Allows MainWrapper's deep spatial background
      extendBodyBehindAppBar: true,
      appBar: _buildLiquidAppBar(),
      body: Stack(
        children: [
          _buildAmbientGlow(),

          // Real-time Firestore Stream for User Identity
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseAuth.instance.currentUser != null
                ? FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots()
                : const Stream.empty(),
            builder: (context, snapshot) {
              String name = "AUTHENTICATING...";
              String role = "VIP CLIENT";
              String email = FirebaseAuth.instance.currentUser?.email ?? "secure@vault.com";
              String memberSince = "2026";
              String address = "DELIVERY COORDINATES NOT SECURED"; // Default fallback

              if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
                final data = snapshot.data!.data() as Map<String, dynamic>;
                name = data['name'] ?? "VIP CLIENT";
                role = data['role'] ?? "MEMBER";
                // Pulls address directly from the document
                if (data['address'] != null && data['address'].toString().trim().isNotEmpty) {
                  address = data['address'];
                }
              }

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800), // Web Scaler
                    child: AnimationLimiter(
                      child: Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 800),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(child: widget),
                          ),
                          children: [
                            const SizedBox(height: 120),

                            // 1. THE INTERACTIVE 3D BLACK CARD (Now Includes Address)
                            _buildInteractiveBlackCard(name, role, email, memberSince, address),

                            const SizedBox(height: 40),

                            // 2. LIVE VAULT LOGISTICS (Now wired to real Firestore Purchases)
                            _buildSectionHeader("ACTIVE ACQUISITIONS"),
                            _buildLiveVaultLogistics(),

                            const SizedBox(height: 40),

                            // 3. SECURE PREFERENCES MENU
                            _buildSectionHeader("SECURITY & PREFERENCES"),
                            _buildVaultMenu(context),

                            const SizedBox(height: 50),
                            _buildLogoutAction(),
                            const SizedBox(height: 150), // Dock buffer
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildLiquidAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(90),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: AppBar(
            backgroundColor: Colors.black.withValues(alpha: 0.5),
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
                'CLIENT DOSSIER',
                style: TextStyle(color: luxuryGold, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 10)
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmbientGlow() {
    return Positioned(
      top: -100,
      right: -50,
      child: Container(
        width: 350,
        height: 350,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: luxuryGold.withValues(alpha: 0.03),
          boxShadow: [
            BoxShadow(color: luxuryGold.withValues(alpha: 0.05), blurRadius: 120, spreadRadius: 40)
          ],
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 8.seconds),
    );
  }

  // --- THE 3D INTERACTIVE BLACK CARD ---
  Widget _buildInteractiveBlackCard(String name, String role, String email, String date, String address) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _cardTilt += details.delta;
          });
        },
        onPanEnd: (_) {
          setState(() {
            _cardTilt = Offset.zero;
          });
        },
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // 3D Perspective effect
            ..rotateX(-_cardTilt.dy * 0.005)
            ..rotateY(_cardTilt.dx * 0.005),
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15), // High-end slight curve
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: double.infinity,
                height: 240, // Slightly taller to accommodate address
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.08),
                      Colors.black.withValues(alpha: 0.9),
                    ],
                  ),
                  border: Border.all(
                      color: luxuryGold.withValues(alpha: _cardTilt == Offset.zero ? 0.3 : 0.8),
                      width: 0.5
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.8), blurRadius: 30, spreadRadius: 10),
                    if (_cardTilt != Offset.zero)
                      BoxShadow(color: luxuryGold.withValues(alpha: 0.1), blurRadius: 50, spreadRadius: 5)
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // TOP ROW: Chip and Logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: luxuryGold.withValues(alpha: 0.5), width: 1),
                              gradient: LinearGradient(
                                colors: [luxuryGold.withValues(alpha: 0.1), luxuryGold.withValues(alpha: 0.3)],
                              )
                          ),
                          child: Center(child: Icon(Icons.memory, color: luxuryGold.withValues(alpha: 0.5), size: 18)),
                        ),
                        Icon(Icons.diamond_outlined, color: luxuryGold, size: 24),
                      ],
                    ),

                    // MIDDLE ROW: Name, Email & Address
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w200, letterSpacing: 6)),
                        const SizedBox(height: 5),
                        Text(email.toLowerCase(), style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 10, letterSpacing: 2)),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.location_on_outlined, color: luxuryGold.withValues(alpha: 0.8), size: 12),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                address.toUpperCase(),
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 8, letterSpacing: 2, height: 1.4),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // BOTTOM ROW: Clearance and Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("CLEARANCE", style: TextStyle(color: luxuryGold.withValues(alpha: 0.5), fontSize: 7, fontWeight: FontWeight.bold, letterSpacing: 4)),
                            const SizedBox(height: 4),
                            Text(role.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 3)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("ESTABLISHED", style: TextStyle(color: luxuryGold.withValues(alpha: 0.5), fontSize: 7, fontWeight: FontWeight.bold, letterSpacing: 4)),
                            const SizedBox(height: 4),
                            Text(date, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 3)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 30),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 6),
        ),
      ),
    );
  }

  // --- LIVE VAULT LOGISTICS (Connected to Firestore) ---
  Widget _buildLiveVaultLogistics() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) return const SizedBox();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('purchases')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        int processing = 0;
        int inTransit = 0;
        int secured = 0;

        if (snapshot.hasData) {
          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final status = (data['status'] as String?)?.toUpperCase() ?? '';

            if (status == 'PROCESSING') processing++;
            else if (status == 'IN TRANSIT') inTransit++;
            else if (status == 'SECURED' || status == 'DELIVERED') secured++;
          }
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _logisticsNode(Icons.inventory_2_outlined, "PROCESSING", "$processing", isActive: processing > 0),
                _logisticsDivider(),
                _logisticsNode(Icons.flight_takeoff_rounded, "IN TRANSIT", "$inTransit", isActive: inTransit > 0),
                _logisticsDivider(),
                _logisticsNode(Icons.task_alt_rounded, "SECURED", "$secured", isGold: secured > 0),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _logisticsNode(IconData icon, String label, String count, {bool isActive = false, bool isGold = false}) {
    Color baseColor = isGold ? luxuryGold : (isActive ? Colors.white : Colors.white24);
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: baseColor, size: 24),
            if (isActive && !isGold) // Processing/Transit shimmer effect
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white24, width: 0.5)),
              ).animate(onPlay: (c) => c.repeat()).rotate(duration: 4.seconds),
          ],
        ),
        const SizedBox(height: 15),
        Text(count, style: TextStyle(color: baseColor, fontSize: 16, fontWeight: FontWeight.w200)),
        const SizedBox(height: 5),
        Text(label, style: TextStyle(color: baseColor.withValues(alpha: 0.5), fontSize: 7, fontWeight: FontWeight.bold, letterSpacing: 2)),
      ],
    );
  }

  Widget _logisticsDivider() {
    return Container(
      width: 30,
      height: 0.5,
      color: Colors.white.withValues(alpha: 0.1),
    );
  }

  // --- HIGH-END LIST MENU ---
  Widget _buildVaultMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.01),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
        ),
        child: Column(
          children: [
            _vaultItem(Icons.history_edu_outlined, "ACQUISITION HISTORY", onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AcquisitionHistoryPage()));
            }),
            _divider(),
            _vaultItem(Icons.manage_accounts_outlined, "EDIT IDENTITY PROFILE", onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
            }),
            _divider(),
            _vaultItem(Icons.diamond_outlined, "CURATED WISHLIST", onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const WishlistPage()));
            }),
            _divider(),
            _vaultItem(Icons.security_rounded, "VAULT SETTINGS", onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _vaultItem(IconData icon, String label, {required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        highlightColor: luxuryGold.withValues(alpha: 0.1),
        splashColor: luxuryGold.withValues(alpha: 0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 22),
          child: Row(
            children: [
              Icon(icon, color: luxuryGold.withValues(alpha: 0.8), size: 18),
              const SizedBox(width: 20),
              Expanded(
                child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 4, fontWeight: FontWeight.w600)),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withValues(alpha: 0.2), size: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(color: Colors.white.withValues(alpha: 0.05), height: 1, indent: 25, endIndent: 25);
  }

  Widget _buildLogoutAction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onTap: () async {
          await AuthService().signOut();
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.05),
            border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3), width: 0.5),
          ),
          child: const Center(
            child: Text(
              "DISCONNECT FROM VAULT",
              style: TextStyle(color: Colors.redAccent, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 5),
            ),
          ),
        ),
      ),
    );
  }
}