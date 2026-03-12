import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/cart_provider.dart';
import '../../../core/router/app_routes.dart';
import '../../auth/domain/product_model.dart';

/// THE PRIVATE VAULT (CART)
/// Redefined as a minimalist editorial ledger with premium glassmorphism.
class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  final Color luxuryGold = const Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalAmount = ref.watch(cartTotalProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildVaultAppBar(context),
      body: cartItems.isEmpty
          ? _buildEmptyVault(context)
          : Stack(
        children: [
          AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 280),
              physics: const BouncingScrollPhysics(),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 600),
                  child: SlideAnimation(
                    verticalOffset: 30.0,
                    child: FadeInAnimation(
                      child: _buildVaultItem(context, ref, item),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildBoutiqueCheckoutPanel(context, totalAmount),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildVaultAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 14),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text("THE VAULT",
          style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 8, fontWeight: FontWeight.w200)),
    );
  }

  Widget _buildVaultItem(BuildContext context, WidgetRef ref, dynamic item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        border: Border.all(color: Colors.white10, width: 0.5),
      ),
      child: Row(
        children: [
          // High-Resolution Preview
          Container(
            width: 80,
            height: 80,
            color: Colors.white.withValues(alpha: 0.05),
            child: Image.asset(item.product.imagePath, fit: BoxFit.cover),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.title.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text("\$${item.product.totalPayableAmount.toStringAsFixed(2)}",
                    style: TextStyle(color: luxuryGold, fontSize: 10, letterSpacing: 1)),
              ],
            ),
          ),
          // Quantity Controls
          Row(
            children: [
              _quantityAction(Icons.remove, () => ref.read(cartProvider.notifier).decrementQuantity(item.product.productId)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text("${item.quantity}",
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w200)),
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
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(border: Border.all(color: Colors.white10)),
        child: Icon(icon, color: Colors.white38, size: 12),
      ),
    );
  }

  Widget _buildBoutiqueCheckoutPanel(BuildContext context, double total) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(35),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.8),
              border: const Border(top: BorderSide(color: Colors.white10, width: 0.5)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _priceRow("SUBTOTAL", "\$${total.toStringAsFixed(2)}", isSmall: true),
                const SizedBox(height: 10),
                _priceRow("ESTIMATED TAX", "\$${(total * 0.03).toStringAsFixed(2)}", isSmall: true),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(color: Colors.white10),
                ),
                _priceRow("TOTAL ACQUISITION", "\$${(total * 1.03).toStringAsFixed(2)}", isSmall: false),
                const SizedBox(height: 35),
                _buildSecureAction(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value, {required bool isSmall}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: isSmall ? Colors.white24 : Colors.white60, fontSize: 8, letterSpacing: 4)),
        Text(value, style: TextStyle(
            color: isSmall ? Colors.white70 : luxuryGold,
            fontSize: isSmall ? 12 : 22,
            fontWeight: isSmall ? FontWeight.w300 : FontWeight.w100,
            letterSpacing: 1
        )),
      ],
    );
  }

  Widget _buildSecureAction(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.checkout),
      child: Container(
        width: double.infinity,
        height: 70,
        color: luxuryGold,
        child: const Center(
          child: Text("SECURE ACCESS",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 5, fontSize: 11)),
        ),
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildEmptyVault(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, color: Colors.white.withValues(alpha: 0.05), size: 80),
          const SizedBox(height: 30),
          const Text("THE VAULT IS CURRENTLY EMPTY",
              style: TextStyle(color: Colors.white24, letterSpacing: 5, fontSize: 9)),
          const SizedBox(height: 40),
          _buildCinematicButton(context, "CONTINUE DISCOVERY"),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildCinematicButton(BuildContext context, String text) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        decoration: BoxDecoration(border: Border.all(color: luxuryGold.withValues(alpha: 0.5))),
        child: Text(text, style: TextStyle(color: luxuryGold, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 3)),
      ),
    );
  }
}