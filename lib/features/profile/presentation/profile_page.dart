import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  final Color luxuryGold = const Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 80),

            // 1. ARCHITECTURAL AVATAR (User Table: name) [cite: 3]
            _buildProfileHeader(),

            const SizedBox(height: 40),

            // 2. DYNAMIC ORDER TRACKER (State Chart Diagram: Order Status)
            _buildOrderTrackingSection("InProgress"), // Matches dynamic state [cite: 221, 226]

            const SizedBox(height: 50),

            // 3. STAGGERED VAULT MENU (Use Case: View Purchase History) [cite: 18, 35]
            _buildVaultMenu(context),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  // --- NEW: Order Tracking Component Based on State Chart Diagram  ---
  Widget _buildOrderTrackingSection(String currentStatus) {
    // Exact states from the Order/Repair State Chart
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
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ORDER #JS2026", style: TextStyle(color: luxuryGold, fontSize: 10, letterSpacing: 1)),
                    Text(currentStatus.toUpperCase(),
                        style: const TextStyle(color: Colors.white60, fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 25),
                // Custom Stepper implementation for luxury UI
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(statuses.length, (index) {
                    bool isPassed = index <= currentIndex;
                    return Expanded(
                      child: Row(
                        children: [
                          Container(
                            height: 6, width: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isPassed ? luxuryGold : Colors.white10,
                              boxShadow: isPassed ? [BoxShadow(color: luxuryGold.withOpacity(0.4), blurRadius: 4)] : [],
                            ),
                          ),
                          if (index != statuses.length - 1)
                            Expanded(
                              child: Container(
                                height: 0.5,
                                color: isPassed ? luxuryGold.withOpacity(0.5) : Colors.white10,
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
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 130, width: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: luxuryGold.withOpacity(0.15), blurRadius: 50, spreadRadius: 5)],
              ),
            ),
            Container(
              height: 110, width: 110,
              decoration: BoxDecoration(
                border: Border.all(color: luxuryGold.withOpacity(0.5), width: 0.8),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const CircleAvatar(
                backgroundColor: Colors.white10,
                backgroundImage: AssetImage('assets/images/login_bg.jpg'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        const Text("PRASHANT", // User Name from User Table [cite: 3]
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w100, letterSpacing: 10)),
        const SizedBox(height: 10),
        Text("EMERALD ELITE MEMBER",
            style: TextStyle(color: luxuryGold, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 4)),
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
              _vaultItem(Icons.history_edu_outlined, "ACQUISITION HISTORY"), // Linked to View Purchase History [cite: 18, 35]
              _vaultItem(Icons.favorite_border_rounded, "CURATED WISHLIST"),
              _vaultItem(Icons.location_on_outlined, "SECURE ADDRESSES"),
              _vaultItem(Icons.verified_user_outlined, "CERTIFICATES & AUTHENTICITY"),
              _vaultItem(Icons.settings_outlined, "VAULT SETTINGS"),
              const SizedBox(height: 25),
              _vaultItem(Icons.logout_rounded, "EXIT GALLERY", isLast: true), // Linked to Logout Use Case [cite: 18]
            ],
          ),
        ),
      ),
    );
  }

  Widget _vaultItem(IconData icon, String label, {bool isLast = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        border: Border.all(color: Colors.white10, width: 0.5),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: Icon(icon, color: isLast ? Colors.redAccent.withOpacity(0.5) : luxuryGold, size: 18),
            title: Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 4, fontWeight: FontWeight.w300)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white10, size: 12),
            onTap: () {},
          ),
        ),
      ),
    );
  }
}