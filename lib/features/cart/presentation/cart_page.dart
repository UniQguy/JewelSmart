import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  final Color luxuryGold = const Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    // Watching the live state of the cart
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildEditorialAppBar(context),
      body: cartItems.isEmpty
          ? _buildEmptyState()
          : Stack(
        children: [
          // 1. DYNAMIC LIST OF SELECTIONS
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(25, 20, 25, 180),
            physics: const BouncingScrollPhysics(),
            itemCount: cartItems.length,
            itemBuilder: (context, index) => _buildLuxuryCartItem(cartItems[index], index),
          ),

          // 2. FIXED ARCHITECTURAL GLASS BOTTOM BAR
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildGlassCheckoutBar(cartItems.length),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildEditorialAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('YOUR SELECTIONS',
          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w300, letterSpacing: 6)),
      centerTitle: true,
    );
  }

  Widget _buildLuxuryCartItem(String itemName, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          // Item Image
          Container(
            width: 120,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Item Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(itemName.toUpperCase(),
                      style: TextStyle(color: luxuryGold, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 2)),
                  const SizedBox(height: 5),
                  const Text("ESTATE COLLECTION • 22K",
                      style: TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 1)),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("\$4,500",
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w100)),
                      GestureDetector(
                        onTap: () {
                          // Update Riverpod State to remove item
                          ref.read(cartProvider.notifier).update((state) {
                            final list = [...state];
                            list.removeAt(index);
                            return list;
                          });
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("THE BAG IS EMPTY",
              style: TextStyle(color: luxuryGold.withOpacity(0.3), letterSpacing: 8, fontSize: 10, fontWeight: FontWeight.w100)),
          const SizedBox(height: 30),
          _buildMinimalBtn("RETURN TO GALLERY", () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _buildGlassCheckoutBar(int count) {
    double total = count * 4500.0;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 25, 30, 50),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            border: const Border(top: BorderSide(color: Colors.white10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("SUBTOTAL",
                      style: TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 3)),
                  Text("\$${total.toStringAsFixed(0)}",
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w100)),
                ],
              ),
              const SizedBox(height: 25),
              // THE ARCHITECTURAL ACTION BUTTON
              GestureDetector(
                onTap: () {
                  // Checkout functionality to be added next
                },
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: luxuryGold,
                    borderRadius: BorderRadius.zero, // Intentional sharp edges
                  ),
                  child: const Center(
                    child: Text("PROCEED TO SECURE CHECKOUT",
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

  // CORRECTED HELPER METHOD
  Widget _buildMinimalBtn(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white10),
        ),
        child: Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 2)),
      ),
    );
  }
}