import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/router/app_routes.dart';
import '../data/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Color luxuryGold = const Color(0xFFD4AF37);
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildCinematicBackground(),
          _buildGlassOverlay(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  _buildBrandHeroText(),
                  const SizedBox(height: 80),
                  _buildEditorialField("MEMBER IDENTIFICATION", Icons.alternate_email_rounded, _emailController),
                  const SizedBox(height: 35),
                  _buildEditorialField("VAULT SECURITY KEY", Icons.lock_person_outlined, _passController, isPass: true),
                  const SizedBox(height: 60),
                  _buildPrimaryAction(),
                  const SizedBox(height: 40),
                  _buildSocialDiscovery(),
                  const SizedBox(height: 80),
                  _buildBottomNavigation(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          if (_isLoading) _buildGlobalLoader(),
        ],
      ),
    );
  }

  Widget _buildCinematicBackground() {
    return Positioned.fill(
      child: Image.asset(
        'assets/images/login_bg.jpg',
        fit: BoxFit.cover,
      ).animate(onPlay: (c) => c.repeat())
          .scale(begin: const Offset(1.1, 1.1), end: const Offset(1.2, 1.2), duration: 20.seconds, curve: Curves.easeInOut)
          .shimmer(delay: 2.seconds, duration: 4.seconds, color: luxuryGold.withOpacity(0.1)),
    );
  }

  Widget _buildGlassOverlay() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.4),
              Colors.black.withOpacity(0.9),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandHeroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("ESTABLISHED 2026",
            style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 5, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Text("ENTER THE\nPRIVATE VAULT",
            style: TextStyle(color: luxuryGold, fontSize: 52, fontWeight: FontWeight.w100, height: 0.9, letterSpacing: -3))
            .animate().fadeIn(duration: 1200.ms).slideX(begin: -0.2),
      ],
    );
  }

  Widget _buildEditorialField(String label, IconData icon, TextEditingController controller, {bool isPass = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.w900)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: isPass && !_isPasswordVisible,
          style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 1, fontWeight: FontWeight.w200),
          cursorColor: luxuryGold,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: luxuryGold.withOpacity(0.4), size: 18),
            suffixIcon: isPass ? IconButton(
              icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white10, size: 16),
              onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
            ) : null,
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10, width: 0.5)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: luxuryGold, width: 1)),
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryAction() {
    return GestureDetector(
      onTap: () async {
        setState(() => _isLoading = true);
        final user = await _authService.signInWithEmail(_emailController.text, _passController.text);

        // Note: AuthWrapper handles navigation automatically
        if (user == null) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("VAULT ACCESS DENIED")));
        }
      },
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: luxuryGold,
          boxShadow: [BoxShadow(color: luxuryGold.withOpacity(0.3), blurRadius: 40, spreadRadius: 5)],
        ),
        child: const Center(
          child: Text("AUTHENTICATE ACCESS",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 5, fontSize: 11)),
        ),
      ),
    ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildSocialDiscovery() {
    return Center(
      child: Column(
        children: [
          const Text("OR DISCOVER VIA", style: TextStyle(color: Colors.white12, fontSize: 9, letterSpacing: 4)),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: () async {
              setState(() => _isLoading = true); // Triggers cinematic loader
              final user = await _authService.signInWithGoogle();

              // AuthWrapper handles redirection once the Firestore sync is complete
              if (user == null) {
                setState(() => _isLoading = false);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("GOOGLE AUTHENTICATION CANCELED")));
              }
            },
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.02),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/google_icon.png', width: 20),
                      const SizedBox(width: 20),
                      const Text("GOOGLE IDENTITY", style: TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 3, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms);
  }

  Widget _buildBottomNavigation() {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, AppRoutes.signup),
        child: RichText(
          text: TextSpan(
            text: "NOT A MEMBER? ",
            style: const TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 3),
            children: [
              TextSpan(text: "JOIN THE LEGACY", style: TextStyle(color: luxuryGold, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlobalLoader() {
    return Container(
      color: Colors.black.withOpacity(0.9),
      child: Center(
        child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1)
            .animate(onPlay: (c) => c.repeat())
            .scale(duration: 1.seconds, begin: const Offset(1, 1), end: const Offset(1.5, 1.5)),
      ),
    );
  }
}