import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:video_player/video_player.dart';

import '../../../core/router/app_routes.dart';
import '../providers/product_provider.dart';
import 'widgets/luxury_product_card.dart';

/// THE DISCOVERY STUDIO (HOME FINAL: THE APEX EDITORIAL)
/// Engineered with Flawless Magnetic Typography, Perfect Cloudinary
/// Video Scaling, and a Minimalist Production-Grade Footer.
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
  late AnimationController _breathingHeroController;

  final List<VideoPlayerController> _videoControllers = [];

  // 🔴 CLOUDINARY INTEGRATION POINT 🔴
  // URLs injected.
  // Note: Appending 'q_auto,f_auto,w_500' before the file name compresses
  // the video for mobile so all 3 play instantly without freezing the hardware decoder.
  final List<String> _videoPaths = [
    'https://res.cloudinary.com/dtmpvbon0/video/upload/q_auto,f_auto,w_500/v1773574265/example_tpp8ee.mp4',
    'https://res.cloudinary.com/dtmpvbon0/video/upload/q_auto,f_auto,w_500/v1773574295/example2_l3djjz.mp4',
    'https://res.cloudinary.com/dtmpvbon0/video/upload/q_auto,f_auto,w_500/v1773574293/example3_hvjjjr.mp4',
  ];

  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();

    _sparkleController = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
    _simulatedVideoController = AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat(reverse: true);
    _breathingHeroController = AnimationController(vsync: this, duration: const Duration(seconds: 25))..repeat(reverse: true);

    _scrollController.addListener(() {
      if (mounted) setState(() => _scrollOffset = _scrollController.offset);
    });

    // Parallel Network Loading for Cloudinary URLs
    for (var path in _videoPaths) {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(path),
        // mixWithOthers ensures your muted autoplay videos don't stop the user's background music on iOS/Android
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      _videoControllers.add(controller);

      controller.initialize().then((_) {
        controller.setVolume(0.0);
        controller.setLooping(true);
        controller.play();
        if (mounted) setState(() {});
      }).catchError((error) {
        debugPrint("Video Load Error for $path: $error");
      });
    }
  }

  @override
  void dispose() {
    _sparkleController.dispose();
    _simulatedVideoController.dispose();
    _breathingHeroController.dispose();
    _scrollController.dispose();
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildDynamicBackground(),
          _buildMainExhibition(),

          // The original Unbound Magnetic Header (Fades and scales out)
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
          AnimatedBuilder(
            animation: _sparkleController,
            builder: (context, child) {
              return Positioned(
                top: -150,
                right: -100 + (math.sin(_sparkleController.value * math.pi * 2) * 80),
                child: Container(
                  width: 600, height: 600,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: luxuryGold.withValues(alpha: 0.03),
                    boxShadow: [BoxShadow(color: luxuryGold.withValues(alpha: 0.04), blurRadius: 200, spreadRadius: 100)],
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
              animation: _sparkleController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _DiamondLatticePainter(
                    color: Colors.white.withValues(alpha: 0.012),
                    rotation: _sparkleController.value * math.pi * 2,
                  ),
                );
              }
          ),
        ],
      ),
    );
  }

  // --- 2. THE UNBOUND MAGNETIC HEADER ---
  Widget _buildMagneticBrandHeader() {
    final double progress = (_scrollOffset / 200).clamp(0.0, 1.0);
    final double opacity = 1.0 - progress;
    final double scale = 1.0 + (progress * 0.6);
    final double letterSpacing = 18 + (progress * 30);

    if (opacity <= 0.01) return const SizedBox.shrink();

    return Positioned(
      top: 0, left: 0, right: 0,
      child: IgnorePointer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'JEWEL SMART',
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: luxuryGold,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: letterSpacing,
                        shadows: [Shadow(color: Colors.black.withValues(alpha: 0.8 * opacity), blurRadius: 30)],
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

  // --- THE SPOTLIGHT SHROUD ---
  Widget _buildSpotlightShroud() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
            stops: [0.0, 0.20, 0.80, 1.0],
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
          _buildPerspectiveHero(),
          const SizedBox(height: 40),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDynamicCategoryBar(),
                  const SizedBox(height: 100),

                  _buildCinematicCampaignScene(),
                  const SizedBox(height: 120),

                  _buildAsymmetricalEditorial(),
                  const SizedBox(height: 120),

                  _buildSectionLabel("THE HIGH JEWELRY EXHIBIT"),
                  _buildStaggeredGallery(),
                  const SizedBox(height: 150),

                  // 3-VIDEO RESPONSIVE GALLERY (Perfectly Fitted)
                  _buildSectionLabel("THE ATELIER ARCHIVES"),
                  _buildPerfectTripleVideoGallery(),
                  const SizedBox(height: 120),

                  // SLEEK PREMIUM FOOTER
                  _buildSleekPremiumFooter(),
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
    final heroHeight = screenHeight > 1000 ? 850.0 : screenHeight * 0.85;

    final double imageParallax = _scrollOffset * 0.4;
    final double textParallax = _scrollOffset * 0.6;

    return SizedBox(
      height: heroHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRect(
            child: AnimatedBuilder(
                animation: _breathingHeroController,
                builder: (context, child) {
                  final double breatheScale = 1.15 + (_breathingHeroController.value * 0.15);
                  return Transform.translate(
                    offset: Offset(0, imageParallax),
                    child: Transform.scale(
                      scale: breatheScale,
                      child: Image.asset(
                        'assets/images/login_bg.jpg',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
                      ),
                    ),
                  );
                }
            ),
          ),
          _buildSpotlightShroud(),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 35, bottom: 100),
                alignment: Alignment.bottomLeft,
                child: Transform.translate(
                  offset: Offset(0, -textParallax),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("COLLECTION • MMXVI", style: TextStyle(color: luxuryGold, letterSpacing: 8, fontSize: 9, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text("ETHEREAL\nRADIANCE", style: TextStyle(color: Colors.white, fontSize: 62, fontWeight: FontWeight.w100, height: 0.9, letterSpacing: -2)),
                      ),
                      const SizedBox(height: 45),
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
          ),
        ],
      ),
    );
  }

  // --- 5. THE CINEMATIC CAMPAIGN SCENE ---
  Widget _buildCinematicCampaignScene() {
    final double imageParallax = ((_scrollOffset - 800) * 0.3).clamp(-150.0, 150.0);
    final double textParallax = ((_scrollOffset - 800) * 0.5).clamp(-150.0, 150.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.pushNamed(context, AppRoutes.category, arguments: "ALL EXHIBITS");
        },
        child: SizedBox(
          height: 550,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRect(
                child: AnimatedBuilder(
                    animation: _simulatedVideoController,
                    builder: (context, child) {
                      final double panOffset = math.sin(_simulatedVideoController.value * math.pi) * 20;
                      return Transform.translate(
                        offset: Offset(panOffset, imageParallax),
                        child: Transform.scale(
                          scale: 1.35,
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

              _buildSpotlightShroud(),

              Padding(
                padding: const EdgeInsets.all(40),
                child: Transform.translate(
                  offset: Offset(0, textParallax * 0.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("THE BRIDAL CAMPAIGN", style: TextStyle(color: luxuryGold, fontSize: 8, letterSpacing: 10, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text("FOREVER BEGINS", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 44, letterSpacing: 2, fontWeight: FontWeight.w100, height: 1.1)),
                      ),
                      const SizedBox(height: 25),
                      Container(height: 1, width: 40, color: luxuryGold.withValues(alpha: 0.4)),
                      const SizedBox(height: 25),
                      const Text("Discover rings forged from legacy,\ndesigned to bind eternity.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white60, fontSize: 10, letterSpacing: 2, height: 1.6, fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 1000.ms).slideY(begin: 0.1, end: 0);
  }

  // --- 6. TRUE ASYMMETRICAL EDITORIAL LOOKBOOK ---
  Widget _buildAsymmetricalEditorial() {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: isDesktop
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 2, child: _buildEditorialTypography("ARTISANAL\nMASTERY", "Masculine bold lines meeting delicate precision. View the exclusive high jewelry collection.", alignRight: true)),
          Expanded(flex: 3, child: _buildEditorialImage('assets/images/new2.jpeg', 650)),
        ],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildEditorialImage('assets/images/new2.jpeg', 500),

          Transform.translate(
            offset: const Offset(0, -50),
            child: Align(
              alignment: Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Container(
                      padding: const EdgeInsets.all(35),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        border: Border(
                          top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 0.5),
                          left: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 0.5),
                          right: BorderSide(color: luxuryGold, width: 3),
                        ),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.8), blurRadius: 40, spreadRadius: -10)],
                      ),
                      child: _buildEditorialTypography("ARTISANAL\nMASTERY", "Masculine bold lines meeting delicate precision. Discover the collection."),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideX(begin: 0.05, end: 0);
  }

  Widget _buildEditorialImage(String path, double height) {
    final double safeParallax = ((_scrollOffset - 1500) * 0.25).clamp(-100.0, 100.0);

    return Container(
      height: height,
      decoration: const BoxDecoration(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRect(
            child: AnimatedBuilder(
                animation: _breathingHeroController,
                builder: (context, child) {
                  final double breatheScale = 1.15 + (_breathingHeroController.value * 0.1);
                  return Transform.translate(
                    offset: Offset(0, safeParallax),
                    child: Transform.scale(
                      scale: breatheScale,
                      child: Image.asset(
                        path,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
                      ),
                    ),
                  );
                }
            ),
          ),
          _buildSpotlightShroud(),
        ],
      ),
    );
  }

  Widget _buildEditorialTypography(String title, String body, {bool alignRight = false}) {
    return Column(
      crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text("THE BESPOKE EXPERIENCE", style: TextStyle(color: luxuryGold, fontSize: 8, letterSpacing: 8, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(title, textAlign: alignRight ? TextAlign.right : TextAlign.left, style: const TextStyle(color: Colors.white, fontSize: 38, letterSpacing: -1.5, fontWeight: FontWeight.w100, height: 1.05)),
        ),
        const SizedBox(height: 25),
        Text(body, textAlign: alignRight ? TextAlign.right : TextAlign.left, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11, height: 1.8, letterSpacing: 1.5, fontWeight: FontWeight.w300)),
        const SizedBox(height: 45),
        GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.pushNamed(context, AppRoutes.category, arguments: "ALL EXHIBITS");
          },
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (alignRight) Icon(Icons.arrow_back_ios_new_rounded, color: luxuryGold, size: 10),
              if (alignRight) const SizedBox(width: 15),
              const Text("DISCOVER COLLECTION", style: TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 5, fontWeight: FontWeight.bold)),
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
                      padding: const EdgeInsets.symmetric(horizontal: 40),
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
                mainAxisSpacing: 40,
                crossAxisSpacing: 30,
                childAspectRatio: 0.55,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Transform.translate(
                  offset: Offset(0, index.isEven ? 0 : 50),
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

  // --- 9. PERFECTLY SCALED 3-GRID VIDEO GALLERY ---
  Widget _buildPerfectTripleVideoGallery() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: LayoutBuilder(
          builder: (context, constraints) {
            double containerHeight = (constraints.maxWidth / 3) * (16 / 9);
            if (containerHeight > 350) containerHeight = 350;

            return SizedBox(
              height: containerHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_videoControllers.length, (index) {
                  if (index >= _videoControllers.length) return const Expanded(child: SizedBox());

                  final controller = _videoControllers[index];

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index != 2 ? 8.0 : 0.0,
                        left: index != 0 ? 8.0 : 0.0,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          color: Colors.white.withValues(alpha: 0.03),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              if (controller.value.isInitialized)
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width: controller.value.size.width,
                                    height: controller.value.size.height,
                                    child: VideoPlayer(controller),
                                  ),
                                )
                              else
                                Center(child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1.5)),

                              // Subtle vignette for premium feel
                              Container(
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5)],
                                    radius: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }
      ),
    ).animate().fadeIn(duration: 1000.ms);
  }

  // --- 10. SLEEK & MINIMAL PREMIUM FOOTER ---
  Widget _buildSleekPremiumFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 120, left: 20, right: 20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 1)),
        color: Colors.black, // Solid grounding color
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.diamond_outlined, color: luxuryGold.withValues(alpha: 0.8), size: 30),
          const SizedBox(height: 25),

          Text("MAISON JEWELSMART", style: TextStyle(color: Colors.white, fontSize: 13, letterSpacing: 10, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),

          Text("CRAFTING ETERNITY SINCE 2026", style: TextStyle(color: luxuryGold.withValues(alpha: 0.6), fontSize: 7, letterSpacing: 6, fontWeight: FontWeight.bold)),
          const SizedBox(height: 45),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _footerLink("CLIENT CARE"),
              _footerDivider(),
              _footerLink("LEGAL"),
              _footerDivider(),
              _footerLink("BOUTIQUES"),
            ],
          ),
          const SizedBox(height: 40),

          Text("© 2026 JEWELSMART MAISON. ALL RIGHTS RESERVED.", style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 6, letterSpacing: 3)),
        ],
      ),
    );
  }

  Widget _footerLink(String text) {
    return GestureDetector(
      onTap: () => HapticFeedback.selectionClick(),
      child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 8, letterSpacing: 3, fontWeight: FontWeight.bold)),
    );
  }

  Widget _footerDivider() {
    return Container(
        height: 10,
        width: 1,
        color: luxuryGold.withValues(alpha: 0.4),
        margin: const EdgeInsets.symmetric(horizontal: 20)
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
      width: 250,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: luxuryGold.withValues(alpha: 0.8), width: 0.5),
        color: Colors.black.withValues(alpha: 0.4),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(text, style: TextStyle(color: luxuryGold, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 5)),
          Positioned.fill(
            child: AnimatedBuilder(
                animation: _sparkleController,
                builder: (context, child) {
                  final double sweep = (math.sin(_sparkleController.value * math.pi * 4) + 1) / 2;
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, luxuryGold.withValues(alpha: 0.15), Colors.transparent],
                        stops: [sweep - 0.2, sweep, sweep + 0.2],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  );
                }
            ),
          ),
        ],
      ),
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