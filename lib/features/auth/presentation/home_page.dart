import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// 100% Correct Relative Imports
import '../../../core/router/app_routes.dart';
import '../domain/product_model.dart';
import 'widgets/luxury_product_card.dart';
import '../domain/product_model.dart';

final List<Product> mockProducts = [
  Product(
    id: "1",
    title: "EMERALD HEIRLOOM",
    price: 12500,
    description: "A timeless masterpiece.",
    category: "RINGS",
    imageUrl: "assets/products/ring_1.jpg", // Ensure paths are correct
    createdAt: DateTime.now(),
  ),
];
/// THE DISCOVERY STUDIO (HOME)
/// Stripped of local navigation to integrate seamlessly with MainWrapper's 3D Shell.
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
      // CRITICAL: Transparent background lets MainWrapper's 3D depth show through
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
          _buildSectionLabel("CURATED COLLECTIONS"),
          _buildDynamicCategoryBar(),
          const SizedBox(height: 50),
          _buildSectionLabel("THE 2026 EXHIBIT"),
          _buildStaggeredGallery(),
          // Added 120px padding to ensure the last items clear the MainWrapper's Glass Dock
          const SizedBox(height: 120),
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
            // FIXED: Removed the local Search icon.
            // Navigation should occur strictly through the MainWrapper's floating dock
            // to preserve the 3D spatial illusion and prevent the "white screen glitch".
          ),
        ),
      ),
    );
  }

  Widget _buildPerspectiveHero() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
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
                  width: double.infinity
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
                  Colors.transparent // Fades to transparent to merge with MainWrapper
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            left: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("COLLECTION • 2026", style: TextStyle(color: luxuryGold, letterSpacing: 8, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                const Text("ETHEREAL\nRADIANCE", style: TextStyle(color: Colors.white, fontSize: 62, fontWeight: FontWeight.w100, height: 0.85, letterSpacing: -2)),
                const SizedBox(height: 35),
                _buildCinematicButton("EXPLORE THE VAULT"),
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

  Widget _buildStaggeredGallery() {
    return AnimationLimiter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 30,
            crossAxisSpacing: 25,
            childAspectRatio: 0.58, // Synced to prevent UI overflow
          ),
          itemCount: mockProducts.length,
          itemBuilder: (context, index) {
            final product = mockProducts[index];
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 1000),
              columnCount: 2,
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