import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../core/router/app_routes.dart';
import '../domain/product_model.dart';
import '../providers/product_provider.dart';
import 'widgets/luxury_product_card.dart';

/// THE DISCOVERY STUDIO (HOME)
/// Engineered with Responsive Web Scaling and a live Firestore data stream.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with TickerProviderStateMixin {
  final Color luxuryGold = const Color(0xFFD4AF37);
  final ScrollController _scrollController = ScrollController();

  late AnimationController _sparkleController;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);

    _scrollController.addListener(() {
      if (mounted) setState(() => _scrollOffset = _scrollController.offset);
    });
  }

  @override
  void dispose() {
    _sparkleController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: _buildLiquidAppBar(),
      body: Stack(
        children: [
          _buildAmbientGlow(),
          _buildMainExhibition(),
        ],
      ),
    );
  }

  Widget _buildMainExhibition() {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildPerspectiveHero(),
          const SizedBox(height: 40),

          // WEB SCALER: Constraining the width of the content on ultra-wide screens
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel("CURATED COLLECTIONS"),
                  _buildDynamicCategoryBar(),
                  const SizedBox(height: 50),
                  _buildSectionLabel("THE 2026 EXHIBIT"),

                  // The Live Responsive Database Grid
                  _buildStaggeredGallery(),

                  const SizedBox(height: 120), // Padding for the Navigation Dock
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildLiquidAppBar() {
    double opacity = (_scrollOffset / 300).clamp(0.0, 1.0);
    return PreferredSize(
      preferredSize: const Size.fromHeight(90),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15 * opacity, sigmaY: 15 * opacity),
          child: AppBar(
            backgroundColor: Colors.black.withValues(alpha: opacity * 0.7),
            elevation: 0,
            centerTitle: true,
            title: Text(
                'JEWEL SMART',
                style: TextStyle(
                    color: luxuryGold,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    letterSpacing: 18 * (1 - opacity).clamp(0.5, 1.0)
                )
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPerspectiveHero() {
    final screenHeight = MediaQuery.of(context).size.height;
    // Cap the hero height on massive desktop monitors to preserve aspect ratio
    final heroHeight = screenHeight > 1000 ? 800.0 : screenHeight * 0.85;

    return SizedBox(
      height: heroHeight,
      width: double.infinity,
      child: Stack(
        children: [
          Transform.translate(
            offset: Offset(0, _scrollOffset * 0.4),
            child: Transform.scale(
              scale: 1.2,
              child: Image.asset(
                'assets/images/login_bg.jpg',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.1),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                  Colors.transparent
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            left: MediaQuery.of(context).size.width > 1400 ? (MediaQuery.of(context).size.width - 1400) / 2 + 30 : 30, // Responsive alignment
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("COLLECTION • 2026", style: TextStyle(color: luxuryGold, letterSpacing: 8, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                const Text("ETHEREAL\nRADIANCE", style: TextStyle(color: Colors.white, fontSize: 62, fontWeight: FontWeight.w100, height: 0.85, letterSpacing: -2)),
                const SizedBox(height: 35),
                // FIXED: Wired the hero button to push to the 'All Exhibits' category
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.category, arguments: "ALL EXHIBITS"),
                  child: _buildCinematicButton("EXPLORE THE VAULT"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicCategoryBar() {
    final categories = ["NECKLACES", "RINGS", "BRACELETS", "EARRINGS"];
    return SizedBox(
      height: 60,
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
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.category,
                      arguments: categories[index],
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.03),
                        border: Border.all(
                            color: luxuryGold.withValues(alpha: 0.3),
                            width: 0.5
                        ),
                      ),
                      child: Center(
                        child: Text(
                          categories[index],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              letterSpacing: 4,
                              fontWeight: FontWeight.w900
                          ),
                        ),
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

  // CRITICAL UPDATE: Responsive Column Scaling based on Screen Width
  Widget _buildStaggeredGallery() {
    final productsAsyncValue = ref.watch(productStreamProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    // INTELLIGENT SCALING: Mobile = 2, Tablet = 3, Small Desktop = 4, Ultrawide = 5
    int crossAxisCount = 2;
    if (screenWidth >= 1200) {
      crossAxisCount = 5;
    } else if (screenWidth >= 900) {
      crossAxisCount = 4;
    } else if (screenWidth >= 600) {
      crossAxisCount = 3;
    }

    return productsAsyncValue.when(
      data: (products) {
        if (products.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                "THE VAULT IS CURRENTLY EMPTY",
                style: TextStyle(color: Colors.white38, letterSpacing: 4, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        return AnimationLimiter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount, // Applied responsive columns
                mainAxisSpacing: 30,
                crossAxisSpacing: 25,
                childAspectRatio: 0.58,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return AnimationConfiguration.staggeredGrid(
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
                );
              },
            ),
          ),
        );
      },
      loading: () => Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1.5),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Text(
            "FAILED TO CONNECT TO VAULT SECURE CHANNEL",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.redAccent.withValues(alpha: 0.8), fontSize: 9, letterSpacing: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildAmbientGlow() {
    return AnimatedBuilder(
      animation: _sparkleController,
      builder: (context, child) {
        return Positioned(
          top: -150 + (100 * _sparkleController.value),
          right: -100 + (50 * _sparkleController.value),
          child: Container(
            width: 400, height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: luxuryGold.withValues(alpha: 0.02),
              boxShadow: [
                BoxShadow(color: luxuryGold.withValues(alpha: 0.05), blurRadius: 150, spreadRadius: 60)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
            label,
            style: const TextStyle(color: Colors.white24, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 6)
        ),
      ),
    );
  }

  Widget _buildCinematicButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 20),
      decoration: BoxDecoration(
          border: Border.all(color: luxuryGold.withValues(alpha: 0.6), width: 0.5),
          color: Colors.white.withValues(alpha: 0.02)
      ),
      child: Text(text, style: TextStyle(color: luxuryGold, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 5)),
    );
  }
}