import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

// World-Class Routing & Feature Imports
import '../../../core/router/app_routes.dart';
import '../../profile/presentation/profile_page.dart';
import '../../cart/presentation/cart_page.dart';
import '../domain/product_model.dart';
import 'category_page.dart';
import 'widgets/luxury_product_card.dart';

/// THE EDITORIAL DISCOVERY HUB
/// Redefined with a global luxury aesthetic, parallax motion, and refined spacing.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final Color luxuryGold = const Color(0xFFD4AF37);
  final ScrollController _scrollController = ScrollController();

  late AnimationController _sparkleController;
  double _scrollOffset = 0.0;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
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
      backgroundColor: Colors.black,
      extendBody: true, // Allows content to flow behind glass navigation
      body: Stack(
        children: [
          _buildAmbientSparkleBackground(),
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildLuxuryAppBar(),
              _buildHeroParallaxSection(),
              _buildSectionLabel("THE 2026 COLLECTIONS"),
              _buildHorizontalCategoryScroll(),
              _buildSectionLabel("FEATURED ACQUISITIONS"),
              _buildStaggeredProductGrid(),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          _buildGlassBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildLuxuryAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.black.withValues(alpha: _scrollOffset > 50 ? 0.9 : 0.0),
      floating: true,
      pinned: true,
      elevation: 0,
      centerTitle: true,
      title: const Text("JEWELSMART",
          style: TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 8, fontWeight: FontWeight.w200)),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildHeroParallaxSection() {
    return SliverToBoxAdapter(
      child: Container(
        height: 500,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Colors.white10),
        child: Stack(
          children: [
            // Parallax Background Image
            Transform.translate(
              offset: Offset(0, _scrollOffset * 0.4),
              child: Container(
                height: 700,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/login_bg.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                ),
              ),
            ),
            // Editorial Text
            Positioned(
              bottom: 40,
              left: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("EDITORIAL", style: TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 5)),
                  const SizedBox(height: 10),
                  Text("THE ART OF\nPRECISION",
                      style: TextStyle(color: luxuryGold, fontSize: 32, fontWeight: FontWeight.w100, height: 1.1)),
                  const SizedBox(height: 20),
                  _buildCinematicButton("DISCOVER"),
                ],
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaggeredProductGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.7,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 800),
              columnCount: 2,
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: LuxuryProductCard(
                    product: mockProducts[index % mockProducts.length],
                  ),
                ),
              ),
            );
          },
          childCount: 4,
        ),
      ),
    );
  }

  Widget _buildGlassBottomNavigation() {
    return Positioned(
      bottom: 30,
      left: 30,
      right: 30,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              border: Border.all(color: Colors.white10),
              borderRadius: BorderRadius.circular(0), // High-fashion square edges
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_outlined, 0),
                _buildNavItem(Icons.search, 1),
                _buildNavItem(Icons.auto_awesome_outlined, 2), // AR Try-On
                _buildNavItem(Icons.person_outline, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? luxuryGold : Colors.white38, size: 20),
          if (isSelected)
            Container(
              margin: const EdgeInsets.top(4),
              width: 4,
              height: 4,
              decoration: BoxDecoration(color: luxuryGold, shape: BoxShape.circle),
            ).animate().scale(),
        ],
      ),
    );
  }

  Widget _buildAmbientSparkleBackground() {
    return AnimatedBuilder(
      animation: _sparkleController,
      builder: (context, child) {
        return Positioned(
          top: -200 + (_sparkleController.value * 50),
          right: -200,
          child: Container(
            width: 600,
            height: 600,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: luxuryGold.withValues(alpha: 0.01),
              boxShadow: [
                BoxShadow(color: luxuryGold.withValues(alpha: 0.03), blurRadius: 150, spreadRadius: 50)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionLabel(String label) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 30, top: 40, bottom: 20),
        child: Text(label,
            style: const TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 5, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHorizontalCategoryScroll() {
    final categories = ["RINGS", "NECKLACES", "BRACELETS", "WATCHES"];
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Center(
                child: Text(categories[index],
                    style: const TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 3)),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCinematicButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      decoration: BoxDecoration(
        border: Border.all(color: luxuryGold.withValues(alpha: 0.5), width: 0.5),
        color: Colors.white.withValues(alpha: 0.02),
      ),
      child: Text(text,
          style: TextStyle(color: luxuryGold, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 4)),
    );
  }
}