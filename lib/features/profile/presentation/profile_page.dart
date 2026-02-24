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

            // 1. ARCHITECTURAL AVATAR
            _buildProfileHeader(),

            const SizedBox(height: 40),

            // 2. DYNAMIC LOYALTY PROGRESS BAR
            _buildLoyaltyProgress(),

            const SizedBox(height: 50),

            // 3. STAGGERED VAULT MENU
            _buildVaultMenu(context),

            const SizedBox(height: 120), // Space for Floating Dock
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Ambient Sparkle Glow
            Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: luxuryGold.withOpacity(0.15),
                    blurRadius: 50,
                    spreadRadius: 5,
                  )
                ],
              ),
            ),
            Container(
              height: 110,
              width: 110,
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
        const Text("PRASHANT",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w100, letterSpacing: 10)),
        const SizedBox(height: 10),
        Text("EMERALD ELITE MEMBER",
            style: TextStyle(color: luxuryGold, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 4)),
      ],
    );
  }

  Widget _buildLoyaltyProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("TIER PROGRESS",
                  style: TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 3, fontWeight: FontWeight.bold)),
              Text("75% TO SAPPHIRE",
                  style: TextStyle(color: luxuryGold, fontSize: 8, letterSpacing: 2, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15),
          // Liquid Progress Bar
          Stack(
            children: [
              Container(
                height: 2,
                width: double.infinity,
                color: Colors.white.withOpacity(0.05),
              ),
              AnimatedContainer(
                duration: const Duration(seconds: 2),
                height: 2,
                width: 250, // This would be dynamic based on points
                decoration: BoxDecoration(
                  color: luxuryGold,
                  boxShadow: [
                    BoxShadow(color: luxuryGold.withOpacity(0.5), blurRadius: 10, spreadRadius: 1)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
              _vaultItem(Icons.history_edu_outlined, "ACQUISITION HISTORY"), // Linked to Purchase History [cite: 93]
              _vaultItem(Icons.favorite_border_rounded, "CURATED WISHLIST"),
              _vaultItem(Icons.location_on_outlined, "SECURE ADDRESSES"),
              _vaultItem(Icons.verified_user_outlined, "CERTIFICATES & AUTHENTICITY"),
              _vaultItem(Icons.settings_outlined, "VAULT SETTINGS"),
              const SizedBox(height: 25),
              _vaultItem(Icons.logout_rounded, "EXIT GALLERY", isLast: true),
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