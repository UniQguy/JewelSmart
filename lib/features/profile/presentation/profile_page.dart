import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../auth/domain/repositories/mock_purchase_repository.dart';
import '../../auth/domain/purchase_model.dart';
import '../../../core/router/app_routes.dart';
import '../../auth/presentation/edit_profile_screen.dart';
import '../../auth/data/auth_service.dart'; // REQUIRED for proper logout

/// THE IDENTITY (PROFILE)
/// Engineered for 3D spatial depth and real-time Firestore data integration.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  final Color luxuryGold = const Color(0xFFD4AF37);
  final MockPurchaseRepository _purchaseRepository = MockPurchaseRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _buildAmbientGlow(),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 80),

                // 1. DYNAMIC ARCHITECTURAL AVATAR
                // Listens to Firestore in real-time for name and role changes
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseAuth.instance.currentUser != null
                      ? FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots()
                      : const Stream.empty(),
                  builder: (context, snapshot) {
                    String name = "MEMBER";
                    String role = "CUSTOMER";

                    if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
                      final data = snapshot.data!.data() as Map<String, dynamic>;
                      name = data['name'] ?? "MEMBER";
                      role = data['role'] ?? "CUSTOMER";
                    }

                    return _buildProfileHeader(context, name, role);
                  },
                ),

                const SizedBox(height: 40),

                // 2. DYNAMIC ORDER TRACKER
                _buildOrderTrackingSection("InProgress"),

                const SizedBox(height: 50),

                // 3. STAGGERED VAULT MENU
                _buildVaultMenu(context),

                // 150px buffer ensures the last item clears the MainWrapper's Glass Dock
                const SizedBox(height: 150),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmbientGlow() {
    return Positioned(
      top: -100,
      right: -50,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: luxuryGold.withValues(alpha: 0.03),
          boxShadow: [
            BoxShadow(color: luxuryGold.withValues(alpha: 0.04), blurRadius: 100, spreadRadius: 40)
          ],
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 8.seconds),
    );
  }

  Widget _buildOrderTrackingSection(String currentStatus) {
    final List<String> statuses = ["Created", "Accepted", "InProgress", "Completed", "Delivered"];
    int currentIndex = statuses.indexOf(currentStatus);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("REPAIR & CUSTOM ORDERS",
              style: TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.02),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 5)
                    ]
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("ORDER #JS2026", style: TextStyle(color: luxuryGold, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
                        Text(currentStatus.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 8, letterSpacing: 3, fontWeight: FontWeight.w900)),
                      ],
                    ),
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(statuses.length, (index) {
                        bool isPassed = index <= currentIndex;
                        bool isActive = index == currentIndex;
                        return Expanded(
                          child: Row(
                            children: [
                              Container(
                                height: isActive ? 8 : 6,
                                width: isActive ? 8 : 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isPassed ? luxuryGold : Colors.white10,
                                  boxShadow: isPassed ? [BoxShadow(color: luxuryGold.withValues(alpha: 0.6), blurRadius: 10, spreadRadius: 1)] : [],
                                ),
                              ).animate(target: isActive ? 1 : 0).shimmer(duration: 2.seconds, color: Colors.white),
                              if (index != statuses.length - 1)
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: isPassed ? luxuryGold.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.05),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String name, String role) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 130, width: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: luxuryGold.withValues(alpha: 0.1), blurRadius: 40, spreadRadius: 10)],
              ),
            ),
            Container(
              height: 110, width: 110,
              decoration: BoxDecoration(
                border: Border.all(color: luxuryGold.withValues(alpha: 0.8), width: 0.5),
                shape: BoxShape.circle,
                color: Colors.black, // Dark background for the initial
              ),
              padding: const EdgeInsets.all(4),
              child: Center(
                // Auto-generates the Avatar based on the first letter of their name
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'X',
                  style: TextStyle(color: luxuryGold, fontSize: 40, fontWeight: FontWeight.w200),
                ),
              ),
            ).animate().scale(duration: 800.ms, curve: Curves.easeOutBack),
          ],
        ),
        const SizedBox(height: 25),
        Text(name.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w100, letterSpacing: 10))
            .animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 10),
        Text("${role.toUpperCase()} MEMBER",
            style: TextStyle(color: luxuryGold, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 5))
            .animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildVaultMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: AnimationLimiter(
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 600),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 30.0,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              _vaultItem(
                  Icons.history_edu_outlined,
                  "ACQUISITION HISTORY",
                  onTap: () => _openPurchaseHistory(context)
              ),
              _vaultItem(Icons.manage_accounts_outlined, "EDIT IDENTITY PROFILE", onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
              }),
              _vaultItem(Icons.favorite_border_rounded, "CURATED WISHLIST", onTap: () {}),
              _vaultItem(Icons.location_on_outlined, "SECURE ADDRESSES", onTap: () {}),
              _vaultItem(Icons.settings_outlined, "VAULT SETTINGS", onTap: () {}),
              const SizedBox(height: 35),
              _vaultItem(
                  Icons.logout_rounded,
                  "EXIT GALLERY",
                  isLast: true,
                  onTap: () async {
                    // CRITICAL UPDATE: Properly terminates the Firebase Session
                    await AuthService().signOut();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vaultItem(IconData icon, String label, {bool isLast = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.01),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              leading: Icon(icon, color: isLast ? Colors.redAccent.withValues(alpha: 0.6) : luxuryGold, size: 18),
              title: Text(label,
                  style: const TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 4, fontWeight: FontWeight.w400)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 12),
            ),
          ),
        ),
      ),
    );
  }

  void _openPurchaseHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.85,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
                border: Border(top: BorderSide(color: luxuryGold.withValues(alpha: 0.5), width: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(width: 40, height: 2, color: Colors.white24),
                  ),
                  const SizedBox(height: 30),
                  Text("THE ARCHIVE", style: TextStyle(color: luxuryGold, fontSize: 18, letterSpacing: 8, fontWeight: FontWeight.w100)),
                  const SizedBox(height: 10),
                  const Text("YOUR PAST ACQUISITIONS", style: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 4)),
                  const SizedBox(height: 40),
                  Expanded(
                    child: FutureBuilder<List<PurchaseRecord>>(
                      future: _purchaseRepository.getPurchaseHistory('user_123'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1));
                        } else if (snapshot.hasError) {
                          return Center(child: Text("FAILED TO DECRYPT ARCHIVE", style: TextStyle(color: Colors.redAccent.withValues(alpha: 0.8), fontSize: 10, letterSpacing: 2)));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("NO PAST ACQUISITIONS SECURED", style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 4)));
                        }

                        final purchases = snapshot.data!;
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: purchases.length,
                          itemBuilder: (context, index) {
                            final purchase = purchases[index];
                            return _buildHistoryCard(purchase).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideY(begin: 0.2, end: 0);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryCard(PurchaseRecord purchase) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("ID: ${purchase.orderId.toUpperCase()}", style: const TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 2)),
              Text(purchase.purchaseDate.toString().substring(0, 10), style: TextStyle(color: luxuryGold, fontSize: 8, letterSpacing: 2)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("TOTAL VALUE SECURED", style: TextStyle(color: Colors.white70, fontSize: 8, letterSpacing: 3, fontWeight: FontWeight.bold)),
              Text("\$${purchase.amountPaid.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w200, letterSpacing: 1)),
            ],
          ),
        ],
      ),
    );
  }
}