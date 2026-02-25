import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/router/app_routes.dart';
import '../providers/cart_provider.dart';
import '../providers/inventory_provider.dart';
// REQUIRED: Resolves property access for CartItem and Product
import '../../auth/domain/product_model.dart';

class SuccessPage extends ConsumerStatefulWidget {
  const SuccessPage({super.key});

  @override
  ConsumerState<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends ConsumerState<SuccessPage> with SingleTickerProviderStateMixin {
  final Color luxuryGold = const Color(0xFFD4AF37);
  late AnimationController _controller;
  late Animation<double> _checkmarkAnimation;
  late Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _finalizeAcquisition();
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _checkmarkAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );

    _contentFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  // Procedure Sync: Fulfills the "Update Stock" and "Clear Cart" Sequence steps
  void _finalizeAcquisition() {
    final cartItems = ref.read(cartProvider);

    for (var item in cartItems) {
      // Logic Sync: item is now a CartItem, providing access to .product and .quantity
      ref.read(inventoryProvider.notifier).stockOut(
          item.product.productId,
          item.quantity
      );
    }

    // FIXED: Must use the notifier's clearCart() method for StateNotifierProvider
    ref.read(cartProvider.notifier).clearCart();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/login_bg.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(color: Colors.black.withOpacity(0.6)),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _checkmarkAnimation,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: luxuryGold, width: 3),
                      boxShadow: [BoxShadow(color: luxuryGold.withOpacity(0.5), blurRadius: 30)],
                    ),
                    child: Icon(Icons.check_rounded, color: luxuryGold, size: 60),
                  ),
                ),
                const SizedBox(height: 40),
                FadeTransition(
                  opacity: _contentFade,
                  child: Column(
                    children: [
                      const Text("ACQUISITION COMPLETE",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 6)),
                      const SizedBox(height: 10),
                      Text("Your legacy has been secured in our vault.",
                          style: TextStyle(color: luxuryGold.withOpacity(0.8), fontSize: 12, letterSpacing: 2)),
                      const SizedBox(height: 60),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          children: [
                            _detailRow("Transaction ID", "#TXN-99421"),
                            const Divider(color: Colors.white10, height: 30),
                            _detailRow("Status", "SUCCESSFUL"),
                            const Divider(color: Colors.white10, height: 30),
                            _detailRow("Mode", "UPI / DIGITAL"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      GestureDetector(
                        onTap: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          decoration: BoxDecoration(
                            border: Border.all(color: luxuryGold),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text("RETURN TO GALLERY",
                              style: TextStyle(color: luxuryGold, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 1)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}