import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/cart_provider.dart';
import '../../../core/router/app_routes.dart';

/// THE PRIVATE VAULT (CART)
/// Engineered to float seamlessly within the MainWrapper's 3D spatial shell.
/// FIXED: Implemented a sleek, horizontal sticky bottom bar to maximize vault visibility.
class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  final Color luxuryGold = const Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalAmount = ref.watch(cartTotalProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: _buildVaultAppBar(context),
      body: cartItems.isEmpty
          ? _buildEmptyVault(context)
          : Stack(
        children: [
          // 1. Ambient Vault Glow
          _buildAmbientGlow(),

          // 2. Liquid Scroll List (Web Scaled)
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800), // Protects UI on wide monitors
              child: AnimationLimiter(
                child: ListView.builder(
                  // FIXED: Reduced bottom padding drastically since the checkout panel is now sleek
                  padding: const EdgeInsets.fromLTRB(25, 120, 25, 200),
                  physics: const BouncingScrollPhysics(),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 800),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _buildVaultItem(context, ref, item),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // 3. Sleek Horizontal Checkout Panel
          _buildBoutiqueCheckoutPanel(context, totalAmount),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildVaultAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(90),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: AppBar(
            backgroundColor: Colors.black.withValues(alpha: 0.4),
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: const Text(
                "THE VAULT",
                style: TextStyle(color: Colors.white, fontSize: 11, letterSpacing: 10, fontWeight: FontWeight.w900)
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmbientGlow() {
    return Positioned(
      top: 100,
      left: -100,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: luxuryGold.withValues(alpha: 0.03),
          boxShadow: [
            BoxShadow(color: luxuryGold.withValues(alpha: 0.05), blurRadius: 100, spreadRadius: 40)
          ],
        ),
      ),
    ).animate().fadeIn(duration: 2.seconds).shimmer(duration: 5.seconds);
  }

  Widget _buildVaultItem(BuildContext context, WidgetRef ref, dynamic item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 5)
        ],
      ),
      child: Row(
        children: [
          // High-Resolution Network Preview with Cloudinary Fallback
          Hero(
            tag: 'vault_item_${item.product.id}',
            child: Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.white10, width: 0.5),
              ),
              child: item.product.imageUrl.isEmpty
                  ? Center(child: Icon(Icons.diamond_outlined, color: luxuryGold.withValues(alpha: 0.2)))
                  : Image.network(
                item.product.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: 15, height: 15,
                      child: CircularProgressIndicator(color: luxuryGold.withValues(alpha: 0.5), strokeWidth: 1.5),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image_outlined, color: Colors.white10),
              ),
            ),
          ),
          const SizedBox(width: 25),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    item.product.title.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 3, fontWeight: FontWeight.w900)
                ),
                const SizedBox(height: 8),
                Text(
                    "₹${item.product.totalPayableAmount.toStringAsFixed(2)}",
                    style: TextStyle(color: luxuryGold, fontSize: 12, letterSpacing: 1, fontWeight: FontWeight.w300)
                ),
              ],
            ),
          ),
          // Precision Quantity Controls
          Row(
            children: [
              _quantityAction(Icons.remove, () => ref.read(cartProvider.notifier).decrementQuantity(item.product.id)),
              SizedBox(
                width: 30,
                child: Center(
                  child: Text(
                      "${item.quantity}",
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              _quantityAction(Icons.add, () => ref.read(cartProvider.notifier).addItem(item.product)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quantityAction(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          color: Colors.white.withValues(alpha: 0.02),
        ),
        child: Icon(icon, color: Colors.white54, size: 12),
      ),
    );
  }

  // FIXED: Completely rebuilt as a sleek, horizontal docked bar
  Widget _buildBoutiqueCheckoutPanel(BuildContext context, double total) {
    final double gstAmount = total * 0.03; // 3% Indian Jewelry GST
    final double finalAmount = total + gstAmount;

    return Positioned(
      bottom: 90, // Docks perfectly just above the MainWrapper's bottom navigation bar
      left: 0,
      right: 0,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.85),
                    border: Border(top: BorderSide(color: luxuryGold.withValues(alpha: 0.3), width: 0.5)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.9), blurRadius: 30, spreadRadius: 10)
                    ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // LEFT: Tight Price Audit
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("TOTAL (INC. 3% GST)", style: TextStyle(color: Colors.white38, fontSize: 7, letterSpacing: 3, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text("₹${finalAmount.toStringAsFixed(2)}", style: TextStyle(color: luxuryGold, fontSize: 20, fontWeight: FontWeight.w300, letterSpacing: 1)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    // RIGHT: CTA Button
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: _buildSecureAction(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 1.0, end: 0, curve: Curves.easeOutQuart);
  }

  Widget _buildSecureAction(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.checkout),
      child: Container(
        decoration: BoxDecoration(
            color: luxuryGold.withValues(alpha: 0.9),
            boxShadow: [
              BoxShadow(color: luxuryGold.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 2)
            ]
        ),
        child: const Center(
          child: Text(
              "SECURE ACCESS",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 3, fontSize: 9)
          ),
        ),
      ),
    ).animate().shimmer(delay: 1.seconds, duration: 2.seconds, color: Colors.white38);
  }

  Widget _buildEmptyVault(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, color: luxuryGold.withValues(alpha: 0.2), size: 60)
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 2.seconds),
          const SizedBox(height: 40),
          const Text(
              "THE VAULT IS SECURED\nAND AWAITING ACQUISITIONS",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, letterSpacing: 6, fontSize: 8, height: 1.8, fontWeight: FontWeight.bold)
          ),
        ],
      ),
    ).animate().fadeIn(duration: 1.seconds);
  }
}