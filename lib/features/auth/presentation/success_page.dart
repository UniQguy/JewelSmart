import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/router/app_routes.dart';

// FIXED PATHS: Navigating from features/auth/presentation to features/cart/providers
import '../../cart/providers/cart_provider.dart';
import '../../cart/providers/inventory_provider.dart';

class SuccessPage extends ConsumerStatefulWidget {
  const SuccessPage({super.key});

  @override
  ConsumerState<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends ConsumerState<SuccessPage> {
  final Color luxuryGold = const Color(0xFFD4AF37);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _finalizeTransaction();
    });
  }

  void _finalizeTransaction() {
    final cartItems = ref.read(cartProvider);

    for (var item in cartItems) {
      ref.read(inventoryProvider.notifier).stockOut(
          item.product.productId,
          item.quantity
      );
    }

    // Procedure Sync: Fulfills the "Clear Cart" step
    ref.read(cartProvider.notifier).clearCart();
  }

  @override
  Widget build(BuildContext context) {
    // UI Logic Sync: Replaced deprecated withOpacity with withValues for current Flutter standards
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: luxuryGold.withValues(alpha: 0.05),
                boxShadow: [
                  BoxShadow(color: luxuryGold.withValues(alpha: 0.1), blurRadius: 100, spreadRadius: 50)
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: AnimationLimiter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 800),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: luxuryGold.withValues(alpha: 0.5), width: 1),
                      ),
                      child: Icon(Icons.auto_awesome_outlined, color: luxuryGold, size: 60),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "ACQUISITION\nCOMPLETE",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: luxuryGold, fontSize: 32, fontWeight: FontWeight.w100, height: 1.1, letterSpacing: 2),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Your treasures have been secured. Our master jewelers are now preparing your order for a journey of elegance.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.6, fontWeight: FontWeight.w300, letterSpacing: 1),
                    ),
                    const SizedBox(height: 60),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false);
                      },
                      child: Container(
                        width: double.infinity, height: 60,
                        decoration: BoxDecoration(border: Border.all(color: Colors.white10)),
                        child: const Center(
                          child: Text("CONTINUE EXPLORING", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 4)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}