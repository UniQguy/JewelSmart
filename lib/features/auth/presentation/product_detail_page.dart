import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cart/providers/cart_provider.dart';
import '../domain/product_model.dart';

class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({super.key});

  final Color luxuryGold = const Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildParallaxHeader(context, product),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEditorialTitle(product),
                      const SizedBox(height: 40),
                      _buildDescriptionSection(product),
                      const SizedBox(height: 40),
                      _buildSpecifications(product),
                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildGlassActionBtn(context, ref, product),
          ),
        ],
      ),
    );
  }

  Widget _buildParallaxHeader(BuildContext context, Product product) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.65,
      backgroundColor: Colors.black,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.4),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'product_image_${product.productId}',
              child: Image.asset(product.imagePath, fit: BoxFit.cover),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.black.withOpacity(0.9),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditorialTitle(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("COLLECTION 2026",
            style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 5, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Text(product.title.replaceAll(' ', '\n'),
            style: TextStyle(color: luxuryGold, fontSize: 38, fontWeight: FontWeight.w100, height: 1.0, letterSpacing: -1)),
        const SizedBox(height: 15),
        Text(product.formattedPrice,
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1)),
      ],
    );
  }

  Widget _buildDescriptionSection(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("THE ARTISTRY",
            style: TextStyle(color: luxuryGold, fontSize: 10, letterSpacing: 3, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Text(
          product.description,
          style: const TextStyle(color: Colors.white60, fontSize: 14, height: 1.8, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }

  Widget _buildSpecifications(Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _specItem("METAL", product.purity),
        _specItem("STONE", product.stone),
        _specItem("WEIGHT", "${product.weight}G"),
      ],
    );
  }

  Widget _specItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 2)),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildGlassActionBtn(BuildContext context, WidgetRef ref, Product product) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 45),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            border: const Border(top: BorderSide(color: Colors.white10)),
          ),
          child: GestureDetector(
            onTap: () {
              // FIXED: Now uses the specialized addItem method from CartNotifier
              // This fixes the 'update' isn't defined error
              ref.read(cartProvider.notifier).addItem(product);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: luxuryGold,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  content: const Text("ITEM SECURED IN BAG",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 10)),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: luxuryGold,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(color: luxuryGold.withOpacity(0.2), blurRadius: 20, spreadRadius: 2)
                ],
              ),
              child: const Center(
                child: Text("ACQUIRE PIECE",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 4, fontSize: 12)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}