import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // CRITICAL: Added for Haptic Feedback
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'widgets/luxury_product_card.dart';
import '../../../core/router/app_routes.dart';
import '../domain/product_model.dart';
import '../providers/product_provider.dart';

/// THE CURATED EXHIBIT (CATEGORY PAGE)
/// Engineered with 3D spatial depth, sliver parallax, cinematic staggering, and responsive web scaling.
class CategoryPage extends ConsumerWidget {
  final String categoryName;
  const CategoryPage({super.key, required this.categoryName});

  final Color luxuryGold = const Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // CRITICAL: Connect to the Live Firestore Stream
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

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Cinematic 3D Background Aura
          _buildAmbientBackground(),

          // 2. Liquid Scroll Layer (Secured with Web Scaler)
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400), // Magazine layout constraint
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  // HIGH-FASHION PARALLAX HEADER
                  _buildSliverHeader(context),

                  // Handle the Stream States (Data, Loading, Error) within the Slivers
                  productsAsyncValue.when(
                    data: (products) {
                      // FILTER LOGIC: Matches category field against live Cloud Data
                      final filteredProducts = categoryName.toUpperCase() == 'ALL EXHIBITS'
                          ? products
                          : products
                          .where((p) => p.category.toUpperCase() == categoryName.toUpperCase())
                          .toList();

                      if (filteredProducts.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: _buildEmptyCollection(),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.fromLTRB(25, 40, 25, 120),
                        sliver: AnimationLimiter(
                          child: SliverGrid(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount, // Dynamic scaling applied
                              mainAxisSpacing: 30,
                              crossAxisSpacing: 25,
                              childAspectRatio: 0.58,
                            ),
                            delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                final product = filteredProducts[index];
                                return AnimationConfiguration.staggeredGrid(
                                  position: index,
                                  duration: const Duration(milliseconds: 800),
                                  columnCount: crossAxisCount,
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: LuxuryProductCard(
                                        product: product,
                                        onTap: () => Navigator.pushNamed(
                                          context,
                                          AppRoutes.productDetail,
                                          arguments: product,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: filteredProducts.length,
                            ),
                          ),
                        ),
                      );
                    },
                    loading: () => SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1.5),
                      ),
                    ),
                    error: (error, stack) => SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          "CONNECTION LOST",
                          style: TextStyle(
                            color: Colors.redAccent.withValues(alpha: 0.8),
                            fontSize: 10,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmbientBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.6),
            radius: 1.5,
            colors: [
              luxuryGold.withValues(alpha: 0.08),
              Colors.black,
            ],
          ),
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 8.seconds),
    );
  }

  Widget _buildEmptyCollection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.diamond_outlined, color: luxuryGold.withValues(alpha: 0.15), size: 60)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 2.seconds),
          const SizedBox(height: 30),
          const Text(
            "COLLECTION COMING SOON",
            style: TextStyle(
              color: Colors.white38,
              letterSpacing: 8,
              fontSize: 8,
              fontWeight: FontWeight.w900,
            ),
          ).animate().fadeIn(duration: 1.seconds),
        ],
      ),
    );
  }

  Widget _buildSliverHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      stretch: true, // Enables the 3D pull-to-stretch effect
      leading: Padding(
        padding: const EdgeInsets.only(left: 10, top: 10),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 14),
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.maybePop(context);
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 0.2),
              ),
            ),
          ),
        ),
      ).animate().fadeIn(duration: 800.ms),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
        title: ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
              ),
              child: Text(
                categoryName.toUpperCase(),
                style: TextStyle(
                  color: luxuryGold,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 10,
                  shadows: [Shadow(color: Colors.black.withValues(alpha: 0.8), blurRadius: 10)],
                ),
              ),
            ),
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/login_bg.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 20.seconds),

            // Volumetric shadow gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.5),
                    Colors.transparent,
                    Colors.black,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}