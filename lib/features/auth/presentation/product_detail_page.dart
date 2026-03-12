import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../cart/providers/cart_provider.dart';
import '../domain/product_model.dart';

/// THE EDITORIAL PRODUCT VIEW
/// Redefined with immersive parallax imagery and premium boutique interactions.
class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({super.key});

  final Color luxuryGold = const Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Safety check for arguments passed via GoRouter/Navigator
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildParallaxHeader(context, product),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBrandHeader(product),
                      const SizedBox(height: 10),
                      _buildEditorialTitle(product),
                      const SizedBox(height: 40),
                      _buildPriceSection(product),
                      const SizedBox(height: 40),
                      _buildDescriptionSection(product),
                      const SizedBox(height: 50),
                      _buildBoutiqueSpecifications(product),
                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildBackAction(context),
          _buildBottomAcquisitionBar(context, ref, product),
        ],
      ),
    );
  }

  Widget _buildParallaxHeader(BuildContext context, Product product) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.6,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'product_${product.productId}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                product.imagePath,
                fit: BoxFit.cover,
              ).animate().scale(
                duration: 20.seconds,
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.2, 1.2),
              ),
              // High-fashion gradient overlay for text readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.4),
                      Colors.transparent,
                      Colors.black,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandHeader(Product product) {
    return const Text(
      "PRIVATE COLLECTION • 2026",
      style: TextStyle(
        color: Colors.white24,
        fontSize: 8,
        letterSpacing: 5,
        fontWeight: FontWeight.w900,
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildEditorialTitle(Product product) {
    return Text(
      product.title.toUpperCase(),
      style: TextStyle(
        color: luxuryGold,
        fontSize: 34,
        fontWeight: FontWeight.w100,
        letterSpacing: -1,
        height: 1.0,
      ),
    ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1);
  }

  Widget _buildPriceSection(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "\$${product.totalPayableAmount.toStringAsFixed(2)}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w200,
            letterSpacing: 2,
          ),
        ),
        const Text(
          "INCLUDES 3% GST & HANDCRAFTING CHARGES",
          style: TextStyle(color: Colors.white12, fontSize: 8, letterSpacing: 2),
        ),
      ],
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildBoutiqueSpecifications(Product product) {
    return Column(
      children: [
        _specRow("PURITY", "${product.purity}K FINE GOLD"),
        const Divider(color: Colors.white10),
        _specRow("WEIGHT", "${product.weight}G"),
        const Divider(color: Colors.white10),
        _specRow("MAKING", "\$${product.makingCharges}"),
      ],
    ).animate().fadeIn(delay: 800.ms);
  }

  Widget _specRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white24, fontSize: 9, letterSpacing: 3)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildBottomAcquisitionBar(BuildContext context, WidgetRef ref, Product product) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(30),
            color: Colors.black.withValues(alpha: 0.8),
            child: GestureDetector(
              onTap: () {
                ref.read(cartProvider.notifier).addItem(product);
                _showSuccessNotification(context);
              },
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: luxuryGold,
                  boxShadow: [
                    BoxShadow(color: luxuryGold.withValues(alpha: 0.2), blurRadius: 40)
                  ],
                ),
                child: const Center(
                  child: Text("ACQUIRE PIECE",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 6, fontSize: 11)),
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().slideY(begin: 1.0, duration: 800.ms, curve: Curves.easeOutQuart);
  }

  void _showSuccessNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(30),
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: luxuryGold, size: 18),
            const SizedBox(width: 15),
            const Text("PIECE SECURED IN BAG",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 9)),
          ],
        ),
      ),
    );
  }

  Widget _buildBackAction(BuildContext context) {
    return Positioned(
      top: 50,
      left: 20,
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildDescriptionSection(Product product) {
    return const Text(
      "A masterpiece of artisanal precision, this piece represents the pinnacle of the 2026 legacy collection. Each facet is hand-finished to ensure a reflection of absolute purity.",
      style: TextStyle(color: Colors.white60, fontSize: 12, height: 1.8, letterSpacing: 0.5, fontWeight: FontWeight.w300),
    ).animate().fadeIn(delay: 700.ms);
  }
}