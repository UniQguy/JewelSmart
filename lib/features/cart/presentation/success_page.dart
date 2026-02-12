import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/router/app_routes.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> with SingleTickerProviderStateMixin {
  final Color luxuryGold = const Color(0xFFD4AF37);
  late AnimationController _controller;
  late Animation<double> _checkmarkAnimation;
  late Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _checkmarkAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );

    _contentFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. BLURRED SCENERY
          Positioned.fill(
            child: Image.asset('assets/images/login_bg.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(color: Colors.black.withOpacity(0.6)),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 2. ANIMATED GOLDEN CHECKMARK
                ScaleTransition(
                  scale: _checkmarkAnimation,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: luxuryGold, width: 3),
                      boxShadow: [BoxShadow(color: luxuryGold.withOpacity(0.5), blurRadius: 30)],
                    ),
                    child: Icon(Icons.check_rounded, color: luxuryGold, size: 60),
                  ),
                ),

                const SizedBox(height: 40),

                // 3. STAGGERED CONTENT
                FadeTransition(
                  opacity: _contentFade,
                  child: Column(
                    children: [
                      const Text("PURCHASE COMPLETE",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 6)),
                      const SizedBox(height: 10),
                      Text("Your legacy has been secured.",
                          style: TextStyle(color: luxuryGold.withOpacity(0.8), fontSize: 12, letterSpacing: 2)),

                      const SizedBox(height: 60),

                      // ORDER DETAILS CARD
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          children: [
                            _detailRow("Order ID", "#JS-99281"),
                            const Divider(color: Colors.white10, height: 30),
                            _detailRow("Estimated Delivery", "Feb 18, 2026"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 50),

                      // BACK TO HOME BUTTON
                      GestureDetector(
                        onTap: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          decoration: BoxDecoration(
                            border: Border.all(color: luxuryGold),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text("CONTINUE EXPLORING",
                              style: TextStyle(color: luxuryGold, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}