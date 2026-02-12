import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/router/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final Color luxuryGold = const Color(0xFFD4AF37);
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
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
      resizeToAvoidBottomInset: false,
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

          // 2. CENTERED CONTENT
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SHIMMERING TITLE: Liquid Gold
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
                        'JEWEL SMART',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 32,
                          letterSpacing: 10,
                          shadows: [Shadow(color: Colors.black54, blurRadius: 10)],
                        ),
                      ),
                    );
                  },
                ),
                const Text('AUTHENTIC LUXURY',
                    style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 5)
                ),

                const SizedBox(height: 50),

                // THE LIQUID GLASS BOX
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: LiquidBorderPainter(_animationController.value, luxuryGold),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 40,
                                spreadRadius: 10
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08), // Crystal Layer
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withOpacity(0.1)),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildCrystalInput("USERNAME", Icons.person_outline),
                                  const SizedBox(height: 25),
                                  _buildCrystalInput("PASSWORD", Icons.lock_outline, isPass: true),

                                  const SizedBox(height: 20),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _linkButton("Forgot Password?", () {
                                        // TODO: Add forgot password logic
                                      }),

                                      GestureDetector(
                                        onTap: () => Navigator.pushNamed(context, AppRoutes.signup),
                                        child: const Text(
                                          "New User?",
                                          style: TextStyle(
                                            color: Colors.white30,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 40),

                                  // LOG IN BUTTON: Navigates to MAIN WRAPPER
                                  GestureDetector(
                                    onTap: () {
                                      // POINTING TO MAIN ROUTE (With Nav Bar)
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        AppRoutes.main,
                                            (route) => false,
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [luxuryGold, const Color(0xFFF9E4B7), luxuryGold],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                              color: luxuryGold.withOpacity(0.3),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10)
                                          )
                                        ],
                                      ),
                                      child: const Center(
                                        child: Text('LOG IN',
                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 4)
                                        ),
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
        ],
      ),
    );
  }

  Widget _buildCrystalInput(String label, IconData icon, {bool isPass = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
        TextField(
          obscureText: isPass,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          cursorColor: luxuryGold,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: luxuryGold.withOpacity(0.8), size: 20),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: luxuryGold, width: 2)),
          ),
        ),
      ],
    );
  }

  Widget _linkButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(text, style: const TextStyle(color: Colors.white30, fontSize: 10, fontWeight: FontWeight.w300)),
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