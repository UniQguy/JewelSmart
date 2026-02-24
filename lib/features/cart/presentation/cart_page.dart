import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/cart_provider.dart';
import '../../../core/router/app_routes.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  final Color luxuryGold = const Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching the live state of the cart vault
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildVaultAppBar(context),
      body: cartItems.isEmpty
          ? _buildEmptyVault(context)
          : Stack(
        children: [
          // 1. DYNAMIC LIST OF ACQUISITIONS
          AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 200),
              physics: const BouncingScrollPhysics(),
              itemCount: cartItems.length,
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

          // 2. ARCHITECTURAL GLASS CHECKOUT BAR
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildGlassCheckoutBar(context, cartItems.length),
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
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('THE VAULT',
          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w300, letterSpacing: 8)),
    );
  }

  Widget _buildVaultItem(WidgetRef ref, String itemName, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          // Item Visual
          Container(
            width: 120,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Item Details [cite: 110, 111]
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
                          // Riverpod State Removal
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

  Widget _buildGlassCheckoutBar(BuildContext context, int count) {
    double total = count * 4500.0;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
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
                      style: TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 4)),
                  Text("\$${total.toStringAsFixed(0)}",
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w100)),
                ],
              ),
              const SizedBox(height: 25),
              // THE ARCHITECTURAL ACTION BUTTON
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.success),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: luxuryGold,
                    borderRadius: BorderRadius.zero,
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

  Widget _buildEmptyVault(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, color: luxuryGold.withOpacity(0.1), size: 60),
          const SizedBox(height: 25),
          Text("THE VAULT IS EMPTY",
              style: TextStyle(color: luxuryGold.withOpacity(0.3), letterSpacing: 8, fontSize: 10, fontWeight: FontWeight.w100)),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              decoration: BoxDecoration(border: Border.all(color: Colors.white10)),
              child: const Text("RETURN TO GALLERY",
                  style: TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 3)),
            ),
          ),
        ],
      ),
    );
  }
}