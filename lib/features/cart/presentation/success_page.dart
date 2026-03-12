import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/router/app_routes.dart';
import '../providers/cart_provider.dart';
import '../providers/inventory_provider.dart';
import '../../auth/domain/product_model.dart';

/// THE LEGACY CONFIRMATION (SUCCESS)
/// Redefined as a premium unboxing experience with atomic inventory finalization.
class SuccessPage extends ConsumerStatefulWidget {
  const SuccessPage({super.key});

  @override
  ConsumerState<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends ConsumerState<SuccessPage> with TickerProviderStateMixin {
  final Color luxuryGold = const Color(0xFFD4AF37);

  @override
  void initState() {
    super.initState();
    // Logic Sync: Finalize the acquisition as soon as the vault opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _finalizeAcquisition();
    });
  }

  void _finalizeAcquisition() {
    final cartItems = ref.read(cartProvider);

    // Atomic Inventory Update
    for (var item in cartItems) {
      ref.read(inventoryProvider.notifier).stockOut(
          item.product.productId,
          item.quantity
      );
    }

    // Clear the Vault for future acquisitions
    ref.read(cartProvider.notifier).clearCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildCinematicBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAnimatedVaultIcon(),
                const SizedBox(height: 40),
                _buildSuccessMessage(),
                const SizedBox(height: 60),
                _buildAcquisitionSummary(),
                const SizedBox(height: 80),
                _buildReturnAction(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCinematicBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              luxuryGold.withValues(alpha: 0.08),
              Colors.black,
            ],
          ),
        ),
      ).animate().fadeIn(duration: 2.seconds),
    );
  }

  Widget _buildAnimatedVaultIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: luxuryGold, width: 1),
      ),
      child: Icon(Icons.check, color: luxuryGold, size: 50),
    ).animate()
        .scale(duration: 800.ms, curve: Curves.elasticOut)
        .shimmer(delay: 1.seconds, duration: 2.seconds, color: Colors.white24);
  }

  Widget _buildSuccessMessage() {
    return Column(
      children: [
        const Text("ACQUISITION SECURED",
            style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 8, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Text("WELCOME TO\nTHE LEGACY",
            textAlign: TextAlign.center,
            style: TextStyle(color: luxuryGold, fontSize: 40, fontWeight: FontWeight.w100, height: 1.0, letterSpacing: -2)),
      ],
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2);
  }

  Widget _buildAcquisitionSummary() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          _summaryRow("STATUS", "AUTHENTICATED"),
          const SizedBox(height: 15),
          _summaryRow("VAULT ID", "JS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}"),
          const SizedBox(height: 15),
          _summaryRow("LOGISTICS", "PRIVATE COURIER"),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms);
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 4)),
        Text(value, style: const TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)),
      ],
    );
  }

  Widget _buildReturnAction() {
    return GestureDetector(
      onTap: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(color: luxuryGold.withValues(alpha: 0.5)),
        ),
        child: Text("RETURN TO GALLERY",
            style: TextStyle(color: luxuryGold, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 4)),
      ),
    ).animate().fadeIn(delay: 1200.ms);
  }
}