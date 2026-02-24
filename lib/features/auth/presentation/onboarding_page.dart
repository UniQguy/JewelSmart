import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/router/app_routes.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  final Color luxuryGold = const Color(0xFFD4AF37);
  int _currentPage = 0;

  final List<Map<String, String>> _stories = [
    {
      "title": "CRAFTED BY\nMASTERS",
      "subtitle": "Discover the heritage of precision. Every piece is a story of legacy and gold.",
    },
    {
      "title": "ETHEREAL\nSELECTIONS",
      "subtitle": "Curated for the modern elite. Rare emeralds meet the finest 22K gold frames.",
    },
    {
      "title": "THE VIRTUAL\nEXPERIENCE",
      "subtitle": "Try on your future treasures with our AI-powered augmentation technology.",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. CINEMATIC BACKGROUND
          Positioned.fill(
            child: Image.asset('assets/images/login_bg.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.4), Colors.black],
                ),
              ),
            ),
          ),

          // 2. STORY SLIDER
          PageView.builder(
            controller: _pageController,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            itemCount: _stories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimationLimiter(
                      key: ValueKey(index),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 1000),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(child: widget),
                          ),
                          children: [
                            Text(_stories[index]["title"]!,
                                style: TextStyle(color: luxuryGold, fontSize: 44, fontWeight: FontWeight.w100, height: 1.0, letterSpacing: -2)),
                            const SizedBox(height: 25),
                            Text(_stories[index]["subtitle"]!,
                                style: const TextStyle(color: Colors.white54, fontSize: 13, height: 1.8, letterSpacing: 1.5)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // 3. ARCHITECTURAL NAVIGATION
          Positioned(
            bottom: 60,
            left: 40,
            right: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Page Indicator
                Row(
                  children: List.generate(_stories.length, (index) =>
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 2,
                        width: _currentPage == index ? 40 : 15,
                        margin: const EdgeInsets.only(right: 8),
                        color: _currentPage == index ? luxuryGold : Colors.white24,
                      )
                  ),
                ),

                // Action Button
                GestureDetector(
                  onTap: () {
                    if (_currentPage < _stories.length - 1) {
                      _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeOutQuint);
                    } else {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    decoration: BoxDecoration(border: Border.all(color: luxuryGold.withOpacity(0.4))),
                    child: Text(_currentPage == _stories.length - 1 ? "ENTER GALLERY" : "NEXT",
                        style: TextStyle(color: luxuryGold, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 4)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}