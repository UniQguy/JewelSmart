import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // CRITICAL: Added for Haptic Feedback
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/router/app_routes.dart';
import '../data/auth_service.dart';

/// THE PRIVATE VAULT ENTRANCE (LOGIN)
/// Engineered with volumetric lighting, spatial depth, and production-grade authentication flow.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Color luxuryGold = const Color(0xFFD4AF37);
  final AuthService _authService = AuthService();

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  // Focus Nodes for production-grade keyboard routing
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  // 3D Terminal Physics
  Offset _terminalTilt = Offset.zero;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  // Abstracted login logic for use by both the button and keyboard "Done" action
  Future<void> _handleLogin() async {
    HapticFeedback.mediumImpact(); // Tactile confirmation
    FocusScope.of(context).unfocus();

    if (_emailController.text.trim().isEmpty || _passController.text.trim().isEmpty) {
      _showErrorSnackBar("CREDENTIALS REQUIRED");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _authService.signInWithEmail(
          _emailController.text.trim(),
          _passController.text.trim()
      ).timeout(const Duration(seconds: 15));

      if (user == null) {
        if (mounted) setState(() => _isLoading = false);
        _showErrorSnackBar(_authService.errorMessage);
      } else {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.authWrapper, (route) => false);
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      _showErrorSnackBar("CONNECTION TIMEOUT: CHECK INTERNET");
    }
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
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500), // Web scaling protection
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: AutofillGroup( // CRITICAL: Enables Password Managers
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        _buildBrandHeroText(),
                        const SizedBox(height: 60),

                        // The Interactive 3D Authentication Terminal
                        _buildInteractiveTerminal(),

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
        // Fallback color in case the asset is missing
        errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
      ).animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
          begin: const Offset(1.05, 1.05),
          end: const Offset(1.15, 1.15),
          duration: 40.seconds,
          curve: Curves.easeInOutSine
      ),
    );
  }

  Widget _buildVolumetricLighting() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.2),
            radius: 1.5,
            colors: [
              luxuryGold.withValues(alpha: 0.15),
              Colors.black.withValues(alpha: 0.8),
              Colors.black,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandHeroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
            "ESTABLISHED • 2026",
            style: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 8, fontWeight: FontWeight.w900)
        ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideX(begin: -0.1, end: 0),
        const SizedBox(height: 20),
        Text(
            "ENTER THE\nPRIVATE VAULT",
            style: TextStyle(
                color: luxuryGold,
                fontSize: 48,
                fontWeight: FontWeight.w100,
                height: 1.05,
                letterSpacing: -2,
                shadows: [Shadow(color: luxuryGold.withValues(alpha: 0.3), blurRadius: 30)]
            )
        ).animate().fadeIn(duration: 1000.ms, delay: 400.ms).slideX(begin: -0.05, end: 0),
      ],
    );
  }

  Widget _buildInteractiveTerminal() {
    return GestureDetector(
      onPanUpdate: (details) => setState(() => _terminalTilt += details.delta),
      onPanEnd: (_) => setState(() => _terminalTilt = Offset.zero),
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(-_terminalTilt.dy * 0.002)
          ..rotateY(_terminalTilt.dx * 0.002),
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.02),
                border: Border.all(
                    color: luxuryGold.withValues(alpha: _terminalTilt == Offset.zero ? 0.3 : 0.6),
                    width: 0.5
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 40, spreadRadius: 10),
                  if (_terminalTilt != Offset.zero)
                    BoxShadow(color: luxuryGold.withValues(alpha: 0.05), blurRadius: 40, spreadRadius: 5)
                ],
              ),
              child: Column(
                children: [
                  _buildEditorialField(
                    "MEMBER IDENTIFICATION",
                    Icons.alternate_email_rounded,
                    _emailController,
                    focusNode: _emailFocus,
                    nextFocus: _passFocus,
                    hints: const [AutofillHints.email],
                    inputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 35),
                  _buildEditorialField(
                    "VAULT SECURITY KEY",
                    Icons.lock_person_outlined,
                    _passController,
                    isPass: true,
                    focusNode: _passFocus,
                    hints: const [AutofillHints.password],
                    onDone: _handleLogin,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 600.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildEditorialField(
      String label,
      IconData icon,
      TextEditingController controller, {
        bool isPass = false,
        FocusNode? focusNode,
        FocusNode? nextFocus,
        Iterable<String>? hints,
        TextInputType? inputType,
        VoidCallback? onDone,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 7, letterSpacing: 5, fontWeight: FontWeight.w900)
        ),
        TextField(
          controller: controller,
          focusNode: focusNode,
          autofillHints: hints,
          keyboardType: inputType,
          obscureText: isPass && !_isPasswordVisible,
          textInputAction: onDone != null ? TextInputAction.done : TextInputAction.next,
          onSubmitted: (_) {
            if (nextFocus != null) FocusScope.of(context).requestFocus(nextFocus);
            if (onDone != null) onDone();
          },
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
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() => _isPasswordVisible = !_isPasswordVisible);
              },
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
      onTap: _handleLogin,
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
                "AUTHENTICATE ACCESS",
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
    HapticFeedback.heavyImpact(); // Alert user to error
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
              "OR DISCOVER VIA",
              style: TextStyle(color: Colors.white24, fontSize: 7, letterSpacing: 6, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: () async {
              HapticFeedback.mediumImpact();
              setState(() => _isLoading = true);
              try {
                final user = await _authService.signInWithGoogle().timeout(const Duration(seconds: 15));
                if (user == null && mounted) {
                  setState(() => _isLoading = false);
                  _showErrorSnackBar("GOOGLE AUTHENTICATION FAILED");
                } else if (user != null && mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.authWrapper, (route) => false);
                }
              } catch(e) {
                if (mounted) setState(() => _isLoading = false);
                _showErrorSnackBar("CONNECTION TIMEOUT");
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
                  // Fallback icon applied gracefully in case of missing asset
                  Image.asset('assets/images/google_icon.png', width: 16, errorBuilder: (c, e, s) => Icon(Icons.public, color: luxuryGold, size: 16)),
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
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.pushNamed(context, AppRoutes.signup);
        },
        behavior: HitTestBehavior.opaque,
        child: RichText(
          text: TextSpan(
            text: "NOT A MEMBER?  ",
            style: const TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                  text: "JOIN THE LEGACY",
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
                    "VERIFYING IDENTITY",
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