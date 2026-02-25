import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/cart_provider.dart';
import '../../../core/router/app_routes.dart';
import '../../auth/domain/product_model.dart'; // REQUIRED for Data Dictionary alignment

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  final Color luxuryGold = const Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. SYSTEM CHECK: Listening to the state of CartItem list
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildVaultAppBar(context),
      body: cartItems.isEmpty
          ? _buildEmptyVault(context)
          : Stack(
        children: [
          AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 250),
              physics: const BouncingScrollPhysics(),
              itemCount: cartItems.length,
              // FIX: cartItems[index] is now a CartItem
              itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 600),
                child: SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: _buildVaultItem(ref, cartItems[index], index),
                  ),
                ),
              ),
            ),
          ),

          // 2. BILLING CONTROLLER: Displays Final Amount & Tax
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildGlassCheckoutBar(context, ref),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildVaultAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
      title: const Text('THE VAULT',
          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w300, letterSpacing: 8)),
    );
  }

  // FIX: parameter type changed to CartItem to resolve type mismatch
  Widget _buildVaultItem(WidgetRef ref, CartItem cartItem, int index) {
    final product = cartItem.product;

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02), // Updated from withOpacity
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(product.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title.toUpperCase(),
                      style: TextStyle(color: luxuryGold, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 2)),
                  const SizedBox(height: 5),
                  // Metadata from Jewelry_Product Table
                  Text("${product.purity} ${product.category} • ${product.weight}G",
                      style: const TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 1)),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Displays quantity and price
                      Text("${cartItem.quantity}x ${product.formattedPrice}",
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w100)),
                      GestureDetector(
                        onTap: () {
                          // FIX: Uses dedicated removeItem method
                          ref.read(cartProvider.notifier).removeItem(product.productId);
                        },
                        child: const Text("REMOVE",
                            style: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 2, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCheckoutBar(BuildContext context, WidgetRef ref) {
    // Logic Sync: Uses the automated providers for total calculations
    final totalAmount = ref.watch(cartTotalProvider);
    final items = ref.watch(cartProvider);

    // Calculate raw subtotal without GST (based on your 3% model)
    double subtotal = items.fold(0, (sum, item) =>
    sum + ((item.product.basePrice + item.product.makingCharges) * item.quantity));

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 25, 30, 50),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.8),
            border: const Border(top: BorderSide(color: Colors.white10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _priceRow("SUBTOTAL", "\$${subtotal.toStringAsFixed(2)}", isSmall: true),
              const SizedBox(height: 10),
              _priceRow("GST (3%)", "\$${(totalAmount - subtotal).toStringAsFixed(2)}", isSmall: true),
              const SizedBox(height: 15),
              _priceRow("TOTAL PAYABLE", "\$${totalAmount.toStringAsFixed(2)}", isSmall: false),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.success),
                child: Container(
                  width: double.infinity, height: 60,
                  color: luxuryGold,
                  child: const Center(
                    child: Text("ACQUIRE PIECES",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 3, fontSize: 10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value, {required bool isSmall}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: isSmall ? Colors.white38 : Colors.white60, fontSize: 9, letterSpacing: 4)),
        Text(value, style: TextStyle(color: Colors.white, fontSize: isSmall ? 14 : 24, fontWeight: isSmall ? FontWeight.w300 : FontWeight.w100)),
      ],
    );
  }

  Widget _buildEmptyVault(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, color: luxuryGold.withValues(alpha: 0.1), size: 60),
          const SizedBox(height: 25),
          Text("THE VAULT IS EMPTY", style: TextStyle(color: luxuryGold.withValues(alpha: 0.3), letterSpacing: 8, fontSize: 10)),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              decoration: BoxDecoration(border: Border.all(color: Colors.white10)),
              child: const Text("RETURN TO GALLERY", style: TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 3)),
            ),
          ),
        ],
      ),
    );
  }
}