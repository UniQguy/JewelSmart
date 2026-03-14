import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/router/app_routes.dart';
import '../../auth/presentation/widgets/luxury_product_card.dart';
import '../providers/wishlist_provider.dart';

/// THE CURATED COLLECTION (WISHLIST)
/// Engineered as a responsive, spatial gallery of the user's saved assets.
class WishlistPage extends ConsumerWidget {
  const WishlistPage({super.key});

  final Color luxuryGold = const Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Connect to the Live Curation Engine
    final wishlistItems = ref.watch(wishlistProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _buildLiquidAppBar(context),
      body: Stack(
        children: [
          // 1. Cinematic Ambient Aura
          _buildAmbientGlow(),

          // 2. Main Gallery Interface
          SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400), // Web Scaler
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(wishlistItems.length),

                    Expanded(
                      child: wishlistItems.isEmpty
                          ? _buildEmptyState()
                          : _buildResponsiveGrid(context, wishlistItems),
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

  PreferredSizeWidget _buildLiquidAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(90),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: AppBar(
            backgroundColor: Colors.black.withValues(alpha: 0.5),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 14),
              onPressed: () => Navigator.maybePop(context),
            ),
            title: Text(
                'PRIVATE CURATION',
                style: TextStyle(color: luxuryGold, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 10)
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmbientGlow() {
    return Positioned(
      top: 100,
      right: -100,
      child: Container(
        width: 300, height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: luxuryGold.withValues(alpha: 0.03),
          boxShadow: [
            BoxShadow(color: luxuryGold.withValues(alpha: 0.05), blurRadius: 100, spreadRadius: 40)
          ],
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 8.seconds),
    );
  }

  Widget _buildHeader(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
              "SAVED ARTIFACTS",
              style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w300, letterSpacing: 8)
          ),
          Text(
              "$count PIECES",
              style: TextStyle(color: luxuryGold, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 3)
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildResponsiveGrid(BuildContext context, List<dynamic> products) {
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

    return AnimationLimiter(
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 100),
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.58,
          crossAxisSpacing: 25,
          mainAxisSpacing: 30,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 800),
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
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border_rounded, color: luxuryGold.withValues(alpha: 0.15), size: 60)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 2.seconds),
          const SizedBox(height: 30),
          const Text(
            "YOUR WISHLIST IS EMPTY",
            style: TextStyle(color: Colors.white38, letterSpacing: 6, fontSize: 8, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          const Text(
            "Discover and save artifacts to your private collection.",
            style: TextStyle(color: Colors.white24, letterSpacing: 2, fontSize: 8),
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}