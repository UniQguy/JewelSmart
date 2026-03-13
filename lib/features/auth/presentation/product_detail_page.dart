import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../cart/providers/cart_provider.dart';
import '../domain/product_model.dart';

/// THE EDITORIAL PRODUCT VIEW
/// Engineered for 3D spatial depth, immersive parallax, and premium boutique interactions.
class ProductDetailPage extends ConsumerStatefulWidget {
  const ProductDetailPage({super.key});

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  final Color luxuryGold = const Color(0xFFD4AF37);
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (mounted) setState(() => _scrollOffset = _scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Safety check for arguments passed via Navigator
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Ambient back-glow to simulate 3D space
          _buildAmbientBackdrop(),

          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              _buildParallaxHeader(context, product),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBrandHeader(),
                      const SizedBox(height: 10),
                      _buildEditorialTitle(product),
                      const SizedBox(height: 40),
                      _buildPriceSection(product),
                      const SizedBox(height: 40),
                      _buildDescriptionSection(),
                      const SizedBox(height: 50),
                      _buildBoutiqueSpecifications(product),
                      const SizedBox(height: 150), // Buffer for the acquisition bar
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

  Widget _buildAmbientBackdrop() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.5),
            radius: 1.2,
            colors: [
              luxuryGold.withOpacity(0.08),
              Colors.black,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParallaxHeader(BuildContext context, Product product) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.65,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      stretch: true, // Enables the 3D pull-to-stretch effect
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // The 3D Hero Pop
            Hero(
              tag: 'product_image_${product.productId}',
              flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
                return RotationTransition(
                  turns: animation.drive(Tween<double>(begin: 0.0, end: 0.02).chain(CurveTween(curve: Curves.easeOut))),
                  child: toHeroContext.widget,
                );
              },
              child: Image.asset(
                product.imagePath,
                fit: BoxFit.cover,
                alignment: Alignment(0, (_scrollOffset * 0.001).clamp(-1.0, 1.0)), // Dynamic Parallax
              ),
            ),
            // Volumetric Lighting Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
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

  Widget _buildBrandHeader() {
    return const Text(
      "PRIVATE COLLECTION • 2026",
      style: TextStyle(
        color: Colors.white24,
        fontSize: 8,
        letterSpacing: 5,
        fontWeight: FontWeight.w900,
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 200.ms);
  }

  Widget _buildEditorialTitle(Product product) {
    return Text(
      product.title.toUpperCase(),
      style: TextStyle(
        color: luxuryGold,
        fontSize: 34,
        fontWeight: FontWeight.w100,
        letterSpacing: 2,
        height: 1.1,
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 300.ms).slideX(begin: -0.05, end: 0);
  }

  Widget _buildPriceSection(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "\$${product.totalPayableAmount.toStringAsFixed(2)}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "INCLUDES 3% GST & HANDCRAFTING CHARGES",
          style: TextStyle(color: Colors.white24, fontSize: 7, letterSpacing: 2, fontWeight: FontWeight.bold),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 400.ms);
  }

  Widget _buildDescriptionSection() {
    return const Text(
      "A masterpiece of artisanal precision, this piece represents the pinnacle of the 2026 legacy collection. Each facet is hand-finished to ensure a reflection of absolute purity. Engineered to catch the light from every dimension.",
      style: TextStyle(color: Colors.white60, fontSize: 11, height: 1.8, letterSpacing: 0.5, fontWeight: FontWeight.w300),
    ).animate().fadeIn(duration: 800.ms, delay: 500.ms);
  }

  Widget _buildBoutiqueSpecifications(Product product) {
    return Column(
      children: [
        _specRow("PURITY", "${product.purity}K FINE GOLD"),
        _divider(),
        _specRow("WEIGHT", "${product.weight}G"),
        _divider(),
        _specRow("MAKING", "\$${product.makingCharges}"),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 600.ms);
  }

  Widget _divider() {
    return Divider(color: Colors.white.withOpacity(0.05), height: 1);
  }

  Widget _specRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.w500)),
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
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 40), // Extra bottom padding for iOS home indicator
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
            ),
            child: GestureDetector(
              onTap: () {
                ref.read(cartProvider.notifier).addItem(product);
                _showSuccessNotification(context);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: luxuryGold.withOpacity(0.8), width: 0.5),
                  boxShadow: [
                    BoxShadow(color: luxuryGold.withOpacity(0.1), blurRadius: 30, spreadRadius: -10)
                  ],
                ),
                child: Center(
                  child: Text(
                    "ACQUIRE PIECE",
                    style: TextStyle(color: luxuryGold, fontWeight: FontWeight.w900, letterSpacing: 8, fontSize: 9),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().slideY(begin: 1.0, end: 0.0, duration: 800.ms, curve: Curves.easeOutExpo);
  }

  void _showSuccessNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 120, left: 20, right: 20),
        duration: const Duration(seconds: 3),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(0), // High fashion square
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                border: Border.all(color: luxuryGold.withOpacity(0.5), width: 0.5),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: luxuryGold, size: 18),
                  const SizedBox(width: 15),
                  const Text(
                    "PIECE SECURED IN VAULT",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 3, fontSize: 8),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackAction(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10, // Dynamic top padding
      left: 20,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 14),
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.2),
              padding: const EdgeInsets.all(12),
            ),
          ),
        ),
      ),
    );
  }
}