import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/router/app_routes.dart';
import '../data/auth_service.dart';

/// THE PRIVATE LEGACY ENTRANCE
/// Engineered as a high-caliber user acquisition interface with 3D spatial depth.
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
          // 1. Cinematic 3D Background
          _buildCinematicBackground(),
          _buildVolumetricLighting(),

          // 2. Main Interface
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildBackButton(),
                  const SizedBox(height: 30),
                  _buildBrandHeroText(),
                  const SizedBox(height: 50),

                  // The Glassmorphic Registration Terminal
                  _buildRegistrationTerminal(),

                  const SizedBox(height: 40),
                  _buildPrimaryAction(),
                  const SizedBox(height: 50),
                  _buildSocialDiscovery(),
                  const SizedBox(height: 60),
                  _buildBottomNavigation(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // 3. High-Performance cinematic loader
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
      ).animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
          begin: const Offset(1.1, 1.1),
          end: const Offset(1.2, 1.2),
          duration: 35.seconds,
          curve: Curves.easeInOutSine
      ),
    );
  }

  Widget _buildVolumetricLighting() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.5, 0.0),
            radius: 1.5,
            colors: [
              luxuryGold.withValues(alpha: 0.12),
              Colors.black.withValues(alpha: 0.85),
              Colors.black,
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 14),
          onPressed: () => Navigator.pop(context),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            padding: const EdgeInsets.all(16),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildBrandHeroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
            "COLLECTION • 2026",
            style: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 8, fontWeight: FontWeight.w900)
        ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideX(begin: -0.1, end: 0),
        const SizedBox(height: 20),
        Text(
            "JOIN THE\nPRIVATE LEGACY",
            style: TextStyle(
                color: luxuryGold,
                fontSize: 46,
                fontWeight: FontWeight.w100,
                height: 1.05,
                letterSpacing: -2,
                shadows: [Shadow(color: luxuryGold.withValues(alpha: 0.3), blurRadius: 30)]
            )
        ).animate().fadeIn(duration: 1000.ms, delay: 400.ms).slideX(begin: -0.05, end: 0),
      ],
    );
  }

  Widget _buildRegistrationTerminal() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 0.5),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 40, spreadRadius: 10)
            ],
          ),
          child: Column(
            children: [
              _buildEditorialField("FULL LEGAL NAME", Icons.person_outline_rounded, _nameController),
              const SizedBox(height: 30),
              _buildEditorialField("MEMBER IDENTIFICATION", Icons.alternate_email_rounded, _emailController),
              const SizedBox(height: 30),
              _buildEditorialField("VAULT SECURITY KEY", Icons.lock_person_outlined, _passController, isPass: true),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 600.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildEditorialField(String label, IconData icon, TextEditingController controller, {bool isPass = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 7, letterSpacing: 5, fontWeight: FontWeight.w900)
        ),
        TextField(
          controller: controller,
          obscureText: isPass && !_isPasswordVisible,
          style: const TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 2, fontWeight: FontWeight.w300),
          cursorColor: luxuryGold,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(icon, color: luxuryGold.withValues(alpha: 0.6), size: 18),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: isPass ? IconButton(
              icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white24, size: 16),
              onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
            ) : null,
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 0.5)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: luxuryGold, width: 1)),
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryAction() {
    return GestureDetector(
      onTap: () async {
        // 1. Validation check with trimming
        if (_nameController.text.trim().isEmpty ||
            _emailController.text.trim().isEmpty ||
            _passController.text.trim().isEmpty) {
          _showErrorSnackBar("COMPLETE YOUR IDENTITY PROFILE");
          return;
        }

        setState(() => _isLoading = true);

        try {
          // 2. Attempt Signup with a timeout safety net
          final user = await _authService.signUpWithEmail(
              _emailController.text.trim(),
              _passController.text.trim(),
              _nameController.text.trim()
          ).timeout(const Duration(seconds: 15));

          if (user == null) {
            if (mounted) setState(() => _isLoading = false);
            _showErrorSnackBar(_authService.errorMessage);
          } else {
            // SUCCESS: Force navigation to break the loading state
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.authWrapper, (route) => false);
            }
          }
        } catch (e) {
          // Catch timeout or unexpected errors
          if (mounted) setState(() => _isLoading = false);
          _showErrorSnackBar("CONNECTION TIMEOUT: CHECK INTERNET");
        }
      },
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: luxuryGold.withValues(alpha: 0.9),
          border: Border.all(color: luxuryGold, width: 1),
          boxShadow: [
            BoxShadow(color: luxuryGold.withValues(alpha: 0.2), blurRadius: 30, offset: const Offset(0, 10))
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Text(
                "CREATE IDENTITY",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 5, fontSize: 10)
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white.withValues(alpha: 0.0), Colors.white.withValues(alpha: 0.4), Colors.white.withValues(alpha: 0.0)],
                    stops: const [0.0, 0.5, 1.0],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: false))
                  .slideX(begin: -2.0, end: 2.0, duration: 3.seconds, curve: Curves.easeInOutSine),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 800.ms);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.1),
                border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5), width: 0.5),
              ),
              child: Text(
                message.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 8, letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialDiscovery() {
    return Center(
      child: Column(
        children: [
          const Text(
              "OR REGISTER VIA",
              style: TextStyle(color: Colors.white24, fontSize: 7, letterSpacing: 6, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: () async {
              setState(() => _isLoading = true);
              final user = await _authService.signInWithGoogle();
              if (user == null && mounted) {
                setState(() => _isLoading = false);
              } else if (user != null && mounted) {
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.authWrapper, (route) => false);
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.02),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/google_icon.png', width: 16),
                  const SizedBox(width: 20),
                  const Text(
                      "GOOGLE IDENTITY",
                      style: TextStyle(color: Colors.white70, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.w900)
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 1000.ms);
  }

  Widget _buildBottomNavigation() {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        behavior: HitTestBehavior.opaque,
        child: RichText(
          text: TextSpan(
            text: "ALREADY A MEMBER?  ",
            style: const TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                  text: "ACCESS THE VAULT",
                  style: TextStyle(color: luxuryGold, fontWeight: FontWeight.w900)
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 1200.ms);
  }

  Widget _buildGlobalLoader() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          color: Colors.black.withValues(alpha: 0.85),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(color: luxuryGold.withValues(alpha: 0.2), strokeWidth: 1, value: 1.0),
                      CircularProgressIndicator(color: luxuryGold, strokeWidth: 1.5),
                    ],
                  ),
                ).animate(onPlay: (c) => c.repeat())
                    .scale(duration: 1.5.seconds, begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), curve: Curves.easeInOutSine),

                const SizedBox(height: 40),

                const Text(
                    "ESTABLISHING IDENTITY",
                    style: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 6, fontWeight: FontWeight.w900)
                ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 1.seconds),
              ],
            ),
          ),
        ),
      ),
    );
  }
}