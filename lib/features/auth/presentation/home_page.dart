import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// 100% Correct Relative Imports
import '../../../core/router/app_routes.dart';
import '../../profile/presentation/profile_page.dart';
import '../../cart/presentation/cart_page.dart';
import '../domain/product_model.dart';
import 'category_page.dart';
import 'widgets/luxury_product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final Color luxuryGold = const Color(0xFFD4AF37);
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();

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
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutExpo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: _buildLiquidAppBar(),
      body: Stack(
        children: [
          _buildAmbientGlow(),
          PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _selectedIndex = index),
            physics: const CustomPageViewScrollPhysics(),
            children: [
              _buildMainExhibition(),
              const CategoryPage(categoryName: 'ALL EXHIBITS'),
              const CartPage(),
              const ProfilePage(),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: _buildFloatingBottomNav(),
          ),
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
          _buildDynamicCategoryBar(), // Restored with animations
          const SizedBox(height: 50),
          _buildSectionLabel("THE 2026 EXHIBIT"),
          _buildStaggeredGallery(),
          const SizedBox(height: 180),
        ],
      ),
    );
  }

  // --- RESTORED CATEGORY BAR WITH COOL ANIMATION ---
  Widget _buildDynamicCategoryBar() {
    final categories = ["NECKLACES", "RINGS", "BRACELETS", "EARRINGS"];
    return SizedBox(
      height: 80,
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
              child: FlipAnimation( // The high-end flip effect
                curve: Curves.easeOutExpo,
                child: ScaleAnimation(
                  scale: 0.5,
                  child: FadeInAnimation(
                    child: GestureDetector(
                      // Navigation trigger re-enabled
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.category,
                        arguments: categories[index],
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          border: Border.all(
                              color: luxuryGold.withOpacity(0.3),
                              width: 0.5
                          ),
                        ),
                        child: Center(
                          child: Text(
                            categories[index],
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                letterSpacing: 3,
                                fontWeight: FontWeight.w900
                            ),
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

  // --- REMAINING UI COMPONENTS ---

  Widget _buildFloatingBottomNav() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: luxuryGold.withOpacity(0.2), width: 0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_filled, 0),
              _navItem(Icons.auto_awesome_motion, 1),
              _navItem(Icons.shopping_bag_outlined, 2),
              _navItem(Icons.person_outline, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? luxuryGold.withOpacity(0.1) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isSelected ? luxuryGold : Colors.white24, size: isSelected ? 28 : 22),
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
            backgroundColor: Colors.black.withOpacity(opacity * 0.7),
            elevation: 0,
            centerTitle: true,
            title: Text('JEWEL SMART',
                style: TextStyle(
                    color: luxuryGold,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    letterSpacing: 18 * (1 - opacity).clamp(0.5, 1.0))),
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded, color: Colors.white, size: 20),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
              ),
              const SizedBox(width: 15),
            ],
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
              child: Image.asset('assets/images/login_bg.jpg', fit: BoxFit.cover, height: double.infinity, width: double.infinity),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.1), Colors.transparent, Colors.black.withOpacity(0.8), Colors.black],
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
            childAspectRatio: 0.58,
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
                    title: product.title,
                    price: product.price,
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
              color: luxuryGold.withOpacity(0.02),
              boxShadow: [BoxShadow(color: luxuryGold.withOpacity(0.04), blurRadius: 100, spreadRadius: 50)],
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
        child: Text(label, style: const TextStyle(color: Colors.white24, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 6)),
      ),
    );
  }

  Widget _buildCinematicButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 20),
      decoration: BoxDecoration(
          border: Border.all(color: luxuryGold.withOpacity(0.6), width: 0.5),
          color: Colors.white.withOpacity(0.02)
      ),
      child: Text(text, style: TextStyle(color: luxuryGold, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 5)),
    );
  }
}

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({super.parent});
  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) => CustomPageViewScrollPhysics(parent: buildParent(ancestor));
  @override
  SpringDescription get spring => const SpringDescription(mass: 120, stiffness: 100, damping: 1.2);
}