import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/router/app_routes.dart';
import '../providers/product_provider.dart';
import 'widgets/luxury_product_card.dart';

/// THE DISCOVERY STUDIO (HOME V6: THE MASTERPIECE)
/// Engineered for jaw-dropping spatial depth, magnetic scroll physics,
/// and a simulated "auto-playing" cinematic scroll scene.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with TickerProviderStateMixin {
  final Color luxuryGold = const Color(0xFFD4AF37);
  final ScrollController _scrollController = ScrollController();

  late AnimationController _sparkleController;
  late AnimationController _simulatedVideoController;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();

    // Controls the ambient background glow and lattice rotation
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Controls the "Auto-Playing Video" pan effect
    _simulatedVideoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);

    _scrollController.addListener(() {
      if (mounted) setState(() => _scrollOffset = _scrollController.offset);
    });
  }

  @override
  void dispose() {
    _sparkleController.dispose();
    _simulatedVideoController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. The Deep 3D Animated Background
          _buildDynamicBackground(),

          // 2. The Main Scroll Cascade
          _buildMainExhibition(),

          // 3. The Magnetic Scaling Header
          _buildMagneticBrandHeader(),
        ],
      ),
    );
  }

  // --- 1. THE DEEP 3D BACKGROUND ---
  Widget _buildDynamicBackground() {
    return Positioned.fill(
      child: Stack(
        children: [
          // Radial Glow
          AnimatedBuilder(
            animation: _sparkleController,
            builder: (context, child) {
              return Positioned(
                top: -150,
                right: -100 + (math.sin(_sparkleController.value * math.pi * 2) * 50),
                child: Container(
                  width: 500, height: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: luxuryGold.withValues(alpha: 0.03),
                    boxShadow: [BoxShadow(color: luxuryGold.withValues(alpha: 0.06), blurRadius: 150, spreadRadius: 80)],
                  ),
                ),
              );
            },
          ),
          // Geometric Diamond Lattice (Makes the negative space feel ultra-premium)
          AnimatedBuilder(
              animation: _sparkleController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _DiamondLatticePainter(
                    color: Colors.white.withValues(alpha: 0.015),
                    rotation: _sparkleController.value * math.pi * 2,
                  ),
                );
              }
          ),
        ],
      ),
    );
  }

  // --- 2. THE MAGNETIC HEADER ---
  Widget _buildMagneticBrandHeader() {
    final double progress = (_scrollOffset / 250).clamp(0.0, 1.0);
    final double scale = 1.0 + (progress * 1.5);
    final double opacity = 1.0 - progress;
    final double blurAmount = progress * 10;

    if (opacity <= 0.01) return const SizedBox.shrink();

    return Positioned(
      top: 0, left: 0, right: 0,
      child: IgnorePointer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: Transform.scale(
                scale: scale,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
                    child: Opacity(
                      opacity: opacity,
                      child: Text(
                          'JEWEL SMART',
                          style: TextStyle(
                              color: luxuryGold,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              letterSpacing: 18,
                              shadows: [Shadow(color: Colors.black.withValues(alpha: 0.8), blurRadius: 20)]
                          )
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- 3. THE MAIN EXHIBITION CASCADE ---
  Widget _buildMainExhibition() {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Massive Top Hero
          _buildPerspectiveHero(),

          const SizedBox(height: 20),

          // Constrained Web Scaler for internal content
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDynamicCategoryBar(),

                  const SizedBox(height: 80),

                  // THE AUTOPLAY "VIDEO" SCENE
                  _buildSimulatedVideoScene(),

                  const SizedBox(height: 80),

                  // ASYMMETRICAL EDITORIAL BLOCK
                  _buildAsymmetricalEditorial(),

                  const SizedBox(height: 80),

                  _buildSectionLabel("THE CURATED EXHIBIT"),

                  // Live Responsive Database Grid
                  _buildStaggeredGallery(),

                  const SizedBox(height: 60),

                  _buildGlobalFooter(),

                  const SizedBox(height: 120), // Navigation Dock Buffer
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. THE PERSPECTIVE HERO (login_bg.jpg) ---
  Widget _buildPerspectiveHero() {
    final screenHeight = MediaQuery.of(context).size.height;
    final heroHeight = screenHeight > 1000 ? 800.0 : screenHeight * 0.85;

    final double parallaxOffset = _scrollOffset * 0.35;
    final double scaleGrowth = 1.05 + (_scrollOffset * 0.0005);

    return SizedBox(
      height: heroHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // The Image Layer
          ClipRect(
            child: Transform.translate(
              offset: Offset(0, parallaxOffset),
              child: Transform.scale(
                scale: scaleGrowth,
                child: Image.asset(
                  'assets/images/login_bg.jpg',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
                ),
              ),
            ),
          ),

          // Depth Gradients
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.95),
                  ],
                  stops: const [0.0, 0.4, 1.0]
              ),
            ),
          ),

          // Typography
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 30, bottom: 80),
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("COLLECTION • 2026", style: TextStyle(color: luxuryGold, letterSpacing: 8, fontSize: 10, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    const Text("ETHEREAL\nRADIANCE", style: TextStyle(color: Colors.white, fontSize: 62, fontWeight: FontWeight.w100, height: 0.85, letterSpacing: -2)),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pushNamed(context, AppRoutes.category, arguments: "ALL EXHIBITS");
                      },
                      child: _buildCinematicButton("EXPLORE THE VAULT"),
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

  // --- 5. THE SIMULATED VIDEO SCENE (new1.jpeg) ---
  Widget _buildSimulatedVideoScene() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onTap: () {
          // FIXED: Wired to route to the exhibits when tapped
          HapticFeedback.lightImpact();
          Navigator.pushNamed(context, AppRoutes.category, arguments: "ALL EXHIBITS");
        },
        child: Container(
          height: 500,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 0.5),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.8), blurRadius: 60, spreadRadius: 10)],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // The Auto-Panning Engine
              ClipRect(
                child: AnimatedBuilder(
                    animation: _simulatedVideoController,
                    builder: (context, child) {
                      final double panOffset = math.sin(_simulatedVideoController.value * math.pi) * 30;
                      return Transform.translate(
                        offset: Offset(panOffset, 0),
                        child: Transform.scale(
                          scale: 1.15,
                          child: Image.asset(
                            'assets/images/new1.jpeg',
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
                          ),
                        ),
                      );
                    }
                ),
              ),

              // Vignette to pop text
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.0,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
                  ),
                ),
              ),

              // Overlay Typography
              Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("THE BRIDAL CAMPAIGN", style: TextStyle(color: luxuryGold, fontSize: 8, letterSpacing: 8, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    const Text("FOREVER BEGINS", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 42, letterSpacing: 2, fontWeight: FontWeight.w100, height: 1.1)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 1000.ms).slideY(begin: 0.1, end: 0);
  }

  // --- 6. THE ASYMMETRICAL EDITORIAL (new2.jpeg) ---
  Widget _buildAsymmetricalEditorial() {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: isDesktop
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 2, child: _buildEditorialTypography("ARTISANAL\nMASTERY", "Masculine bold lines meeting delicate precision. View the exclusive high jewelry collection for men.", alignRight: true)),
          Expanded(flex: 3, child: _buildEditorialImage('assets/images/new2.jpeg', 600)),
        ],
      )
          : Stack(
        children: [
          // Image anchors the back
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 60),
            child: _buildEditorialImage('assets/images/new2.jpeg', 450),
          ),
          // Glassmorphic typography overlaps on the Z-axis
          Positioned(
            bottom: 0, left: 0, right: 30,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  padding: const EdgeInsets.all(35),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    border: Border(left: BorderSide(color: luxuryGold, width: 2)),
                  ),
                  child: _buildEditorialTypography("ARTISANAL\nMASTERY", "Masculine bold lines meeting delicate precision. Discover the collection."),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideX(begin: 0.05, end: 0);
  }

  Widget _buildEditorialImage(String path, double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.8), blurRadius: 50, spreadRadius: 10)],
        image: DecorationImage(
          image: AssetImage(path),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }

  Widget _buildEditorialTypography(String title, String body, {bool alignRight = false}) {
    return Column(
      crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text("THE BESPOKE EXPERIENCE", style: TextStyle(color: luxuryGold, fontSize: 8, letterSpacing: 6, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Text(title, textAlign: alignRight ? TextAlign.right : TextAlign.left, style: const TextStyle(color: Colors.white, fontSize: 38, letterSpacing: -1, fontWeight: FontWeight.w100, height: 1.0)),
        const SizedBox(height: 25),
        Text(body, textAlign: alignRight ? TextAlign.right : TextAlign.left, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11, height: 1.8, letterSpacing: 1, fontWeight: FontWeight.w300)),
        const SizedBox(height: 40),
        GestureDetector(
          onTap: () {
            // FIXED: Fully operational routing
            HapticFeedback.selectionClick();
            Navigator.pushNamed(context, AppRoutes.category, arguments: "ALL EXHIBITS");
          },
          behavior: HitTestBehavior.opaque, // Ensures the entire row is clickable
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (alignRight) Icon(Icons.arrow_back_ios_new_rounded, color: luxuryGold, size: 10),
              if (alignRight) const SizedBox(width: 15),
              const Text("DISCOVER COLLECTION", style: TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 4, fontWeight: FontWeight.bold)),
              if (!alignRight) const SizedBox(width: 15),
              if (!alignRight) Icon(Icons.arrow_forward_ios_rounded, color: luxuryGold, size: 10),
            ],
          ),
        )
      ],
    );
  }

  // --- 7. DYNAMIC CATEGORY BAR ---
  Widget _buildDynamicCategoryBar() {
    final categories = ["NECKLACES", "RINGS", "BRACELETS", "EARRINGS"];
    return SizedBox(
      height: 55,
      child: AnimationLimiter(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          physics: const BouncingScrollPhysics(),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 800),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.pushNamed(context, AppRoutes.category, arguments: categories[index]);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.02),
                        border: Border.all(color: luxuryGold.withValues(alpha: 0.3), width: 0.5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(categories[index], style: const TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 4, fontWeight: FontWeight.w900)),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // --- 8. THE Z-AXIS GALLERY ---
  Widget _buildStaggeredGallery() {
    final productsAsyncValue = ref.watch(productStreamProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = 2;
    if (screenWidth >= 1200) crossAxisCount = 5;
    else if (screenWidth >= 900) crossAxisCount = 4;
    else if (screenWidth >= 600) crossAxisCount = 3;

    return productsAsyncValue.when(
      data: (products) {
        if (products.isEmpty) {
          return const Padding(padding: EdgeInsets.symmetric(vertical: 80), child: Center(child: Text("THE VAULT IS CURRENTLY EMPTY", style: TextStyle(color: Colors.white38, letterSpacing: 4, fontSize: 10, fontWeight: FontWeight.bold))));
        }

        return AnimationLimiter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 35,
                crossAxisSpacing: 25,
                childAspectRatio: 0.55,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Transform.translate(
                  offset: Offset(0, index.isEven ? 0 : 40),
                  child: AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 1000),
                    columnCount: crossAxisCount,
                    child: SlideAnimation(
                      verticalOffset: 50,
                      child: FadeInAnimation(
                        child: LuxuryProductCard(
                          product: product,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.productDetail, arguments: product),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      loading: () => Center(child: Padding(padding: const EdgeInsets.all(80.0), child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1.5))),
      error: (error, stack) => Center(child: Padding(padding: const EdgeInsets.all(80.0), child: Text("FAILED TO CONNECT TO VAULT", textAlign: TextAlign.center, style: TextStyle(color: Colors.redAccent.withValues(alpha: 0.8), fontSize: 9, letterSpacing: 2)))),
    );
  }

  // --- UTILS ---
  Widget _buildGlobalFooter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.diamond_outlined, color: luxuryGold.withValues(alpha: 0.3), size: 40),
          const SizedBox(height: 30),
          Text("MAISON JEWELSMART", style: TextStyle(color: luxuryGold, fontSize: 12, letterSpacing: 10, fontWeight: FontWeight.w900)),
          const SizedBox(height: 20),
          Text("CRAFTING ETERNITY SINCE 2026", style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 7, letterSpacing: 5, fontWeight: FontWeight.bold)),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _footerLink("CLIENT CARE"), _footerLink("LEGAL"), _footerLink("BOUTIQUES"),
            ],
          ),
          const SizedBox(height: 40),
          Text("© 2026 JEWELSMART. ALL RIGHTS RESERVED.", style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 6, letterSpacing: 2)),
        ],
      ),
    );
  }

  Widget _footerLink(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(
        onTap: () => HapticFeedback.selectionClick(),
        child: Text(text, style: const TextStyle(color: Colors.white54, fontSize: 8, letterSpacing: 3, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(label, style: const TextStyle(color: Colors.white24, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 6)),
      ),
    );
  }

  Widget _buildCinematicButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 20),
      decoration: BoxDecoration(border: Border.all(color: luxuryGold.withValues(alpha: 0.8), width: 0.5), color: Colors.white.withValues(alpha: 0.02)),
      child: Text(text, style: TextStyle(color: luxuryGold, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 5)),
    );
  }
}

/// CUSTOM PAINTER: Draws a rotating, high-end geometric diamond lattice in the background
class _DiamondLatticePainter extends CustomPainter {
  final Color color;
  final double rotation;
  _DiamondLatticePainter({required this.color, required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotation);
    canvas.translate(-size.width / 2, -size.height / 2);

    const double step = 80;
    for (double i = -size.width; i < size.width * 2; i += step) {
      canvas.drawLine(Offset(i, -size.height), Offset(i + size.height, size.height * 2), paint);
      canvas.drawLine(Offset(i, size.height * 2), Offset(i + size.height, -size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DiamondLatticePainter oldDelegate) => oldDelegate.rotation != rotation;
}