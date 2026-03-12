import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/router/app_routes.dart';
import '../data/auth_service.dart';

/// THE PRIVATE LEGACY ENTRANCE
/// Redefined as a high-caliber user acquisition interface.
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final Color luxuryGold = const Color(0xFFD4AF37);
  final AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                  const SizedBox(height: 60),
                  _buildBackButton(),
                  const SizedBox(height: 40),
                  _buildBrandHeroText(),
                  const SizedBox(height: 60),
                  _buildEditorialField("FULL LEGAL NAME", Icons.person_outline_rounded, _nameController),
                  const SizedBox(height: 30),
                  _buildEditorialField("MEMBER IDENTIFICATION", Icons.alternate_email_rounded, _emailController),
                  const SizedBox(height: 30),
                  _buildEditorialField("VAULT SECURITY KEY", Icons.lock_person_outlined, _passController, isPass: true),
                  const SizedBox(height: 60),
                  _buildPrimaryAction(),
                  const SizedBox(height: 40),
                  _buildSocialDiscovery(),
                  const SizedBox(height: 60),
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
          .scale(
          begin: const Offset(1.2, 1.2),
          end: const Offset(1.4, 1.4),
          duration: 25.seconds,
          curve: Curves.easeInOut
      ),
    );
  }

  Widget _buildGlassOverlay() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Colors.black.withValues(alpha: 0.9),
              Colors.black.withValues(alpha: 0.5),
              Colors.black.withValues(alpha: 0.8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
      onPressed: () => Navigator.pop(context),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildBrandHeroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("COLLECTION • 2026",
            style: TextStyle(
                color: Colors.white24,
                fontSize: 10,
                letterSpacing: 5,
                fontWeight: FontWeight.bold
            )),
        const SizedBox(height: 15),
        Text("JOIN THE\nPRIVATE LEGACY",
            style: TextStyle(
                color: luxuryGold,
                fontSize: 52,
                fontWeight: FontWeight.w100,
                height: 0.9,
                letterSpacing: -3
            )).animate().fadeIn(duration: 1200.ms).slideX(begin: -0.2),
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
        if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("COMPLETE YOUR IDENTITY PROFILE"))
          );
          return;
        }

        setState(() => _isLoading = true);
        // Requirement Sync: Passing the name to AuthService for Firestore Root Document
        final user = await _authService.signUpWithEmail(
            _emailController.text,
            _passController.text,
            _nameController.text
        );

        setState(() => _isLoading = false);

        if (user != null) {
          // Success: AuthWrapper will handle routing to HomePage
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_authService.errorMessage))
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: luxuryGold,
          boxShadow: [
            BoxShadow(color: luxuryGold.withValues(alpha: 0.3), blurRadius: 40, spreadRadius: 5)
          ],
        ),
        child: const Center(
          child: Text("CREATE IDENTITY",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 5, fontSize: 11)),
        ),
      ),
    ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildSocialDiscovery() {
    return Center(
      child: Column(
        children: [
          const Text("OR REGISTER VIA", style: TextStyle(color: Colors.white12, fontSize: 9, letterSpacing: 4)),
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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.02),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/google_icon.png', width: 20),
                  const SizedBox(width: 20),
                  const Text("GOOGLE IDENTITY",
                      style: TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 3, fontWeight: FontWeight.bold)),
                ],
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
        onTap: () => Navigator.pop(context),
        child: RichText(
          text: TextSpan(
            text: "ALREADY A MEMBER? ",
            style: const TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 3),
            children: [
              TextSpan(text: "ACCESS THE VAULT",
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
        color: Colors.black.withValues(alpha: 0.9),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: luxuryGold, strokeWidth: 1),
              const SizedBox(height: 20),
              const Text("ESTABLISHING IDENTITY",
                  style: TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 5)),
            ],
          ).animate().scale(duration: 400.ms, curve: Curves.easeOut),
        ),
      ),
    );
  }
}