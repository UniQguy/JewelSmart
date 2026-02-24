import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/router/app_routes.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  final Color luxuryGold = const Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. BACKGROUND GLOW
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: luxuryGold.withOpacity(0.05),
                boxShadow: [
                  BoxShadow(
                    color: luxuryGold.withOpacity(0.1),
                    blurRadius: 100,
                    spreadRadius: 50,
                  )
                ],
              ),
            ),
          ),

          // 2. CONTENT AREA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: AnimationLimiter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 800),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: [
                    // THE ICON MOMENT
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: luxuryGold.withOpacity(0.5), width: 1),
                      ),
                      child: Icon(
                        Icons.auto_awesome_outlined,
                        color: luxuryGold,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // EDITORIAL SUCCESS TEXT
                    Text(
                      "ACQUISITION\nCOMPLETE",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: luxuryGold,
                        fontSize: 32,
                        fontWeight: FontWeight.w100,
                        height: 1.1,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Your treasures have been secured. Our master jewelers are now preparing your order for a journey of elegance.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                        height: 1.6,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 60),

                    // ARCHITECTURAL ACTION BUTTON
                    GestureDetector(
                      onTap: () {
                        // Return to Home by replacing the entire stack
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.main,
                                (route) => false
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white10),
                        ),
                        child: const Center(
                          child: Text(
                            "CONTINUE EXPLORING",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}