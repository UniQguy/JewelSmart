import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cart/providers/cart_provider.dart';

class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({super.key});

  final Color luxuryGold = const Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. CINEMATIC SCROLLING AREA
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildParallaxHeader(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEditorialTitle(),
                      const SizedBox(height: 40),
                      _buildDescriptionSection(),
                      const SizedBox(height: 40),
                      _buildSpecifications(),
                      const SizedBox(height: 150), // Buffer for glass bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 2. FIXED GLASS ACTION BAR
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildGlassActionBtn(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildParallaxHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.65,
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/login_bg.jpg', fit: BoxFit.cover),
            // Multi-stage gradient for luxury depth
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

  Widget _buildEditorialTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("COLLECTION 2026",
            style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 5, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Text("EMERALD\nLEGACY SET",
            style: TextStyle(color: luxuryGold, fontSize: 38, fontWeight: FontWeight.w100, height: 1.0, letterSpacing: -1)),
        const SizedBox(height: 15),
        const Text("\$4,500",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1)),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("THE ARTISTRY",
            style: TextStyle(color: luxuryGold, fontSize: 10, letterSpacing: 3, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        const Text(
          "A masterpiece of timeless elegance. This set features hand-selected deep-sea emeralds, precision-cut to capture every fracture of light, encased in a 22K brushed gold frame. Designed for the modern legacy.",
          style: TextStyle(color: Colors.white60, fontSize: 14, height: 1.8, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }

  Widget _buildSpecifications() {
    return Row(
      children: [
        _specItem("METAL", "22K GOLD"),
        const SizedBox(width: 40),
        _specItem("STONE", "EMERALD"),
        const SizedBox(width: 40),
        _specItem("WEIGHT", "14.2G"),
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

  Widget _buildGlassActionBtn(BuildContext context, WidgetRef ref) {
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
              ref.read(cartProvider.notifier).update((state) => [...state, "Emerald Legacy"]);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: luxuryGold,
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
                borderRadius: BorderRadius.circular(4), // Sharp, architectural edges
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