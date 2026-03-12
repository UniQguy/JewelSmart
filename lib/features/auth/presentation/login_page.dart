import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/router/app_routes.dart';
import '../data/auth_service.dart';

/// THE PRIVATE VAULT ENTRANCE
/// Redefined with a global luxury aesthetic and editorial UI patterns.
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
      // Extends behind the status bar for a seamless "edge-to-edge" look
      extendBodyBehindAppBar: true,
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
                  const SizedBox(height: 80),
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
          // High-Performance cinematic loader
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
          .scale(
          begin: const Offset(1.1, 1.1),
          end: const Offset(1.3, 1.3),
          duration: 30.seconds,
          curve: Curves.easeInOut
      ),
    );
  }

  Widget _buildGlassOverlay() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40), // Deeper blur for premium feel
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.3),
              Colors.black.withValues(alpha: 0.7),
              Colors.black,
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
        const Text("ESTABLISHED • 2026",
            style: TextStyle(
                color: Colors.white24,
                fontSize: 9,
                letterSpacing: 6,
                fontWeight: FontWeight.bold
            )).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 15),
        Text("ENTER THE\nPRIVATE VAULT",
            style: TextStyle(
                color: luxuryGold,
                fontSize: 50,
                fontWeight: FontWeight.w100,
                height: 0.9,
                letterSpacing: -2
            )).animate().fadeIn(duration: 1200.ms).slideX(begin: -0.1),
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
            prefixIcon: Icon(icon, color: luxuryGold.withValues(alpha: 0.4), size: 18),
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
        if (_emailController.text.isEmpty || _passController.text.isEmpty) return;

        setState(() => _isLoading = true);
        final user = await _authService.signInWithEmail(_emailController.text, _passController.text);

        if (user == null) {
          setState(() => _isLoading = false);
          // Show specifically why it failed using our new AuthService logic
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.red.withValues(alpha: 0.8),
                  content: Text(_authService.errorMessage,
                      style: const TextStyle(fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold))
              )
          );
        }
        // If successful, AuthWrapper will automatically transition
      },
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: luxuryGold,
          boxShadow: [
            BoxShadow(color: luxuryGold.withValues(alpha: 0.2), blurRadius: 40, offset: const Offset(0, 10))
          ],
        ),
        child: const Center(
          child: Text("AUTHENTICATE ACCESS",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 5, fontSize: 11)),
        ),
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildSocialDiscovery() {
    return Center(
      child: Column(
        children: [
          const Text("OR DISCOVER VIA",
              style: TextStyle(color: Colors.white12, fontSize: 8, letterSpacing: 5)),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: () async {
              setState(() => _isLoading = true);
              final user = await _authService.signInWithGoogle();
              if (user == null) {
                setState(() => _isLoading = false);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.02),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/google_icon.png', width: 18),
                  const SizedBox(width: 20),
                  const Text("GOOGLE IDENTITY",
                      style: TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 3, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
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
              TextSpan(text: "JOIN THE LEGACY",
                  style: TextStyle(color: luxuryGold, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlobalLoader() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        color: Colors.black.withValues(alpha: 0.8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: luxuryGold, strokeWidth: 1),
              const SizedBox(height: 20),
              const Text("VERIFYING IDENTITY",
                  style: TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 5)),
            ],
          ).animate().scale(duration: 400.ms, curve: Curves.easeOut),
        ),
      ),
    );
  }
}