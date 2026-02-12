import 'dart:ui';
import 'package:flutter/material.dart';

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
            _buildProfileHeader(),
            const SizedBox(height: 50),
            _buildGalleryMenu(context),
            const SizedBox(height: 120), // Space for Nav Bar
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        // Architectural Avatar
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(color: luxuryGold, width: 0.5),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(4),
          child: const CircleAvatar(
            backgroundColor: Colors.white10,
            backgroundImage: AssetImage('assets/images/login_bg.jpg'),
          ),
        ),
        const SizedBox(height: 20),
        const Text("PRASHANT",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w100, letterSpacing: 6)),
        const SizedBox(height: 8),
        Text("ELITE MEMBER",
            style: TextStyle(color: luxuryGold, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 3)),
      ],
    );
  }

  Widget _buildGalleryMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          _menuItem(Icons.history_edu_outlined, "ACQUISITION HISTORY"),
          _menuItem(Icons.favorite_border_rounded, "CURATED WISHLIST"),
          _menuItem(Icons.location_on_outlined, "SECURE ADDRESSES"),
          _menuItem(Icons.settings_outlined, "GALLERY SETTINGS"),
          const SizedBox(height: 20),
          _menuItem(Icons.logout_rounded, "EXIT GALLERY", isLast: true),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, {bool isLast = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        leading: Icon(icon, color: luxuryGold, size: 18),
        title: Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 3, fontWeight: FontWeight.w300)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white10, size: 12),
        onTap: () {},
      ),
    );
  }
}