import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/router/app_routes.dart';
import 'widgets/product_shimmer.dart';
import 'widgets/luxury_product_card.dart'; // Ensure you created this widget file

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final Color luxuryGold = const Color(0xFFD4AF37);
  late AnimationController _heroController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // 2026 Cinematic Slow-Zoom
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);

    // Simulate high-end data fetching
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _buildLuxuryAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. PARALLAX HERO SECTION
            _buildEditorialHero(),

            const Padding(
              padding: EdgeInsets.fromLTRB(25, 40, 25, 20),
              child: Text("CURATED COLLECTIONS",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 8 // Editorial spacing
                  )),
            ),

            _buildCategoryList(),

            const Padding(
              padding: EdgeInsets.fromLTRB(25, 40, 25, 20),
              child: Text("NEW ARRIVALS",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 8
                  )),
            ),

            // 2. REFINED PRODUCT GRID
            _buildProductGrid(),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildLuxuryAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Text('JEWEL SMART',
              style: TextStyle(
                  color: luxuryGold,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: 12 // Signature branding
              )),
        ),
      ),
      actions: [
        IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 20),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.search)
        ),
        IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart)
        ),
      ],
    );
  }

  Widget _buildEditorialHero() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7, // Increased height for drama
      child: Stack(
        children: [
          ScaleTransition(
            scale: Tween(begin: 1.0, end: 1.1).animate(_heroController),
            child: Image.asset('assets/images/login_bg.jpg', fit: BoxFit.cover, height: double.infinity, width: double.infinity),
          ),
          // Triple-Layer Gradient for depth
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                  Colors.black,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("SPRING 2026", style: TextStyle(color: Colors.white54, letterSpacing: 4, fontSize: 10)),
                const SizedBox(height: 15),
                Text("ETHEREAL\nRADIANCE",
                    style: TextStyle(
                        color: luxuryGold,
                        fontSize: 48,
                        fontWeight: FontWeight.w100,
                        height: 0.9,
                        letterSpacing: -1
                    )),
                const SizedBox(height: 25),
                _buildLuxuryActionBtn("EXPLORE PIECES"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    final categories = ["NECKLACES", "RINGS", "BRACELETS", "EARRINGS"];
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white10),
            ),
            child: Center(
              child: Text(categories[index],
                  style: const TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000), // Slower, more elegant fade
      child: GridView.builder(
        key: ValueKey<bool>(_isLoading),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 25),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65, // Taller cards for elegance
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return _isLoading
              ? const ProductShimmer()
              : LuxuryProductCard(
            title: "Emerald Legacy",
            price: "\$4,500",
            onTap: () => Navigator.pushNamed(context, AppRoutes.productDetail),
          );
        },
      ),
    );
  }

  Widget _buildLuxuryActionBtn(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: luxuryGold.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(2), // Sharp corners for luxury feel
      ),
      child: Text(text, style: TextStyle(color: luxuryGold, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 3)),
    );
  }
}