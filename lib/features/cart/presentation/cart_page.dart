import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/cart_provider.dart';
import '../../../core/router/app_routes.dart';

/// THE PRIVATE VAULT (CART)
/// Engineered to float seamlessly within the MainWrapper's 3D spatial shell.
class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  final Color luxuryGold = const Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalAmount = ref.watch(cartTotalProvider);

    return Scaffold(
      // CRITICAL: Transparent background lets MainWrapper's 3D depth show through
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: _buildVaultAppBar(context),
      body: cartItems.isEmpty
          ? _buildEmptyVault(context)
          : Stack(
        children: [
          // 1. Ambient Vault Glow
          _buildAmbientGlow(),

          // 2. Liquid Scroll List
          AnimationLimiter(
            child: ListView.builder(
              // Massive bottom padding so the last item scrolls past the floating checkout & global dock
              padding: const EdgeInsets.fromLTRB(25, 120, 25, 380),
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

          // 3. Floating Checkout Panel (Elevated above MainWrapper Dock)
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
            backgroundColor: Colors.black.withOpacity(0.4),
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false, // Removed back button as this is a root tab
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
          color: luxuryGold.withOpacity(0.03),
          boxShadow: [
            BoxShadow(color: luxuryGold.withOpacity(0.05), blurRadius: 100, spreadRadius: 40)
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
        color: Colors.white.withOpacity(0.02),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 0.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, spreadRadius: 5)
        ],
      ),
      child: Row(
        children: [
          // High-Resolution Preview with subtle scale
          Hero(
            tag: 'vault_item_${item.product.productId}',
            child: Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.white10, width: 0.5),
                image: DecorationImage(
                  image: AssetImage(item.product.imagePath),
                  fit: BoxFit.cover,
                ),
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
                    "\$${item.product.totalPayableAmount.toStringAsFixed(2)}",
                    style: TextStyle(color: luxuryGold, fontSize: 12, letterSpacing: 1, fontWeight: FontWeight.w300)
                ),
              ],
            ),
          ),
          // Precision Quantity Controls
          Row(
            children: [
              _quantityAction(Icons.remove, () => ref.read(cartProvider.notifier).decrementQuantity(item.product.productId)),
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
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          color: Colors.white.withOpacity(0.02),
        ),
        child: Icon(icon, color: Colors.white54, size: 12),
      ),
    );
  }

  Widget _buildBoutiqueCheckoutPanel(BuildContext context, double total) {
    return Positioned(
      bottom: 120, // CRITICAL: Floats above the MainWrapper's Navigation Dock
      left: 20,
      right: 20,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            padding: const EdgeInsets.all(35),
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5), // More transparent to show background depth
                border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.5),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 30, spreadRadius: 10)
                ]
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _priceRow("SUBTOTAL", "\$${total.toStringAsFixed(2)}", isSmall: true),
                const SizedBox(height: 12),
                _priceRow("ESTIMATED TAX", "\$${(total * 0.03).toStringAsFixed(2)}", isSmall: true),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Divider(color: Colors.white.withOpacity(0.1), height: 1),
                ),
                _priceRow("TOTAL ACQUISITION", "\$${(total * 1.03).toStringAsFixed(2)}", isSmall: false),
                const SizedBox(height: 35),
                _buildSecureAction(context),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuart);
  }

  Widget _priceRow(String label, String value, {required bool isSmall}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            label,
            style: TextStyle(color: isSmall ? Colors.white38 : Colors.white70, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.bold)
        ),
        Text(
            value,
            style: TextStyle(
                color: isSmall ? Colors.white : luxuryGold,
                fontSize: isSmall ? 12 : 24,
                fontWeight: isSmall ? FontWeight.w400 : FontWeight.w200,
                letterSpacing: 2
            )
        ),
      ],
    );
  }

  Widget _buildSecureAction(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.checkout),
      child: Container(
        width: double.infinity,
        height: 65,
        decoration: BoxDecoration(
            color: luxuryGold.withOpacity(0.9),
            boxShadow: [
              BoxShadow(color: luxuryGold.withOpacity(0.2), blurRadius: 20, spreadRadius: 2)
            ]
        ),
        child: const Center(
          child: Text(
              "SECURE ACCESS",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 6, fontSize: 10)
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
          Icon(Icons.inventory_2_outlined, color: luxuryGold.withOpacity(0.2), size: 60)
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