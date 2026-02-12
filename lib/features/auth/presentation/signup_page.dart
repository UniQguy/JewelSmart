import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/router/app_routes.dart'; // Ensure this matches your project structure

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with SingleTickerProviderStateMixin {
  final Color luxuryGold = const Color(0xFFD4AF37);
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Synchronized animation with the Login Page for brand consistency
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Prevents UI from breaking when entering details
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // 1. DEEP BLUR BACKGROUND
          Positioned.fill(
            child: Image.asset('assets/images/login_bg.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
          ),

          // 2. SCROLLABLE CENTERED CONTENT
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SHIMMERING TITLE
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [luxuryGold, Colors.white, luxuryGold],
                          stops: [
                            _animationController.value - 0.2,
                            _animationController.value,
                            _animationController.value + 0.2
                          ],
                        ).createShader(bounds),
                        child: const Text(
                          'CREATE ACCOUNT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 26,
                            letterSpacing: 6,
                          ),
                        ),
                      );
                    },
                  ),
                  const Text('JOIN THE LEGACY',
                      style: TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 4)
                  ),

                  const SizedBox(height: 40),

                  // THE LIQUID GLASS BOX
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: LiquidBorderPainter(_animationController.value, luxuryGold),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.88,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 40)
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                              child: Container(
                                padding: const EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08), // Crystal Layer
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildCrystalInput("FULL NAME", Icons.person_outline),
                                    const SizedBox(height: 20),
                                    _buildCrystalInput("EMAIL ADDRESS", Icons.alternate_email),
                                    const SizedBox(height: 20),
                                    _buildCrystalInput("PASSWORD", Icons.lock_outline, isPass: true),
                                    const SizedBox(height: 20),
                                    _buildCrystalInput("CONFIRM PASSWORD", Icons.verified_user_outlined, isPass: true),

                                    const SizedBox(height: 35),

                                    // SIGN UP BUTTON
                                    GestureDetector(
                                      onTap: () {
                                        // TODO: Add registration logic
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [luxuryGold, const Color(0xFFF9E4B7), luxuryGold],
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: luxuryGold.withOpacity(0.3),
                                              blurRadius: 15,
                                              offset: const Offset(0, 8),
                                            )
                                          ],
                                        ),
                                        child: const Center(
                                          child: Text('REGISTER',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 3)
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    // UPDATED NAVIGATION LINK
                                    GestureDetector(
                                      onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                                      child: RichText(
                                        text: TextSpan(
                                          text: "Already a member? ",
                                          style: const TextStyle(color: Colors.white38, fontSize: 11),
                                          children: [
                                            TextSpan(
                                              text: "Log In",
                                              style: TextStyle(color: luxuryGold, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrystalInput(String label, IconData icon, {bool isPass = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 2)),
        TextField(
          obscureText: isPass,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          cursorColor: luxuryGold,
          decoration: InputDecoration(
            isDense: true,
            prefixIcon: Icon(icon, color: luxuryGold.withOpacity(0.7), size: 16),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: luxuryGold, width: 1.5)),
          ),
        ),
      ],
    );
  }
}

class LiquidBorderPainter extends CustomPainter {
  final double progress;
  final Color gold;
  LiquidBorderPainter(this.progress, this.gold);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..shader = SweepGradient(
        colors: [Colors.transparent, gold, Colors.white, gold, Colors.transparent],
        stops: const [0.0, 0.4, 0.5, 0.6, 1.0],
        transform: GradientRotation(progress * 2 * 3.14159),
      ).createShader(rect);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(20)), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}