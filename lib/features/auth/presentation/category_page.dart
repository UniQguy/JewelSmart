import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'widgets/luxury_product_card.dart';
import '../../../core/router/app_routes.dart';
import '../domain/product_model.dart';

class CategoryPage extends StatelessWidget {
  final String categoryName;
  const CategoryPage({super.key, required this.categoryName});

  final Color luxuryGold = const Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    // Filter the global mock list by category
    final filteredProducts = mockProducts
        .where((p) => p.category == categoryName.toUpperCase())
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. HEADER
          _buildSliverHeader(context),

          // 2. CONDITIONALLY RENDER GRID OR EMPTY STATE
          filteredProducts.isEmpty
              ? SliverFillRemaining( // Fills the screen properly for empty states
            hasScrollBody: false,
            child: _buildEmptyCollection(),
          )
              : SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            sliver: AnimationLimiter(
              child: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.65,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final product = filteredProducts[index];
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 700),
                      columnCount: 2,
                      child: ScaleAnimation(
                        scale: 0.9,
                        child: FadeInAnimation(
                          child: LuxuryProductCard(
                            title: product.title,
                            price: product.price,
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
          ),

          // 3. BOTTOM BUFFER
          const SliverToBoxAdapter(
            child: SizedBox(height: 120),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCollection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.diamond_outlined, color: luxuryGold.withOpacity(0.1), size: 40),
          const SizedBox(height: 20),
          Text(
            "COLLECTION COMING SOON",
            style: TextStyle(
                color: luxuryGold.withOpacity(0.3),
                letterSpacing: 8,
                fontSize: 10,
                fontWeight: FontWeight.w300
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      backgroundColor: Colors.black,
      elevation: 0,
      pinned: true, // Keeps a small bar visible when scrolling
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          categoryName.toUpperCase(),
          style: TextStyle(
            color: luxuryGold,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 10,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/login_bg.jpg', fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.9)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}