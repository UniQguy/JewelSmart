import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Core Imports
import '../../../core/router/app_routes.dart';
import '../providers/cart_provider.dart';
import '../providers/inventory_provider.dart';
import '../../auth/domain/product_model.dart';

/// THE LEGACY CONFIRMATION (SUCCESS)
/// Engineered as a premium, cinematic unboxing experience with atomic inventory finalization.
class SuccessPage extends ConsumerStatefulWidget {
  const SuccessPage({super.key});

  @override
  ConsumerState<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends ConsumerState<SuccessPage> with TickerProviderStateMixin {
  final Color luxuryGold = const Color(0xFFD4AF37);
  late String _vaultId;

  @override
  void initState() {
    super.initState();
    // Generate a unique, high-end looking ID for the receipt
    _vaultId = "JS-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}";

    // Logic Sync: Finalize the acquisition as soon as the vault opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _finalizeAcquisition();
    });
  }

  void _finalizeAcquisition() {
    // 1. Capture the current cart state before clearing it
    final cartItems = ref.read(cartProvider);

    // 2. Atomic Inventory Update: Deduct stock for all items
    for (var item in cartItems) {
      ref.read(inventoryProvider.notifier).stockOut(
          item.product.productId,
          item.quantity
      );
    }

    // TODO: In a real app, this is where you would call the MockPurchaseRepository
    // to save this transaction to the user's Profile history.

    // 3. Clear the Vault for future acquisitions
    ref.read(cartProvider.notifier).clearCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Deep Spatial Glow
          _buildCinematicBackground(),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAnimatedVaultIcon(),
                const SizedBox(height: 50),
                _buildSuccessMessage(),
                const SizedBox(height: 70),
                _buildAcquisitionSummary(),
                const SizedBox(height: 90),
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
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  luxuryGold.withOpacity(0.08),
                  Colors.black,
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 10.seconds),

          // Particle Dust Effect Simulation
          Positioned.fill(
            child: CustomPaint(
              painter: _DustPainter(color: luxuryGold.withOpacity(0.1)),
            ),
          ).animate().fadeIn(duration: 3.seconds),
        ],
      ),
    );
  }

  Widget _buildAnimatedVaultIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: luxuryGold, width: 0.5),
          boxShadow: [
            BoxShadow(color: luxuryGold.withOpacity(0.1), blurRadius: 40, spreadRadius: 10)
          ]
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Inner spinning ring
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border(top: BorderSide(color: luxuryGold.withOpacity(0.5), width: 2)),
            ),
          ).animate(onPlay: (c) => c.repeat()).rotate(duration: 4.seconds),

          // Center Checkmark
          Icon(Icons.check_rounded, color: luxuryGold, size: 50)
              .animate()
              .scale(delay: 400.ms, duration: 800.ms, curve: Curves.elasticOut)
              .shimmer(delay: 1.seconds, duration: 2.seconds, color: Colors.white),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildSuccessMessage() {
    return Column(
      children: [
        const Text(
            "ACQUISITION SECURED",
            style: TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 10, fontWeight: FontWeight.w900)
        ),
        const SizedBox(height: 20),
        Text(
            "WELCOME TO\nTHE LEGACY",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: luxuryGold,
                fontSize: 48,
                fontWeight: FontWeight.w100,
                height: 1.0,
                letterSpacing: -2,
                shadows: [Shadow(color: luxuryGold.withOpacity(0.2), blurRadius: 20)]
            )
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 600.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildAcquisitionSummary() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 320,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 35),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            border: Border.all(color: Colors.white.withOpacity(0.05), width: 0.5),
          ),
          child: Column(
            children: [
              _summaryRow("STATUS", "AUTHENTICATED"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Divider(color: Colors.white.withOpacity(0.05), height: 1),
              ),
              _summaryRow("VAULT ID", _vaultId),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Divider(color: Colors.white.withOpacity(0.05), height: 1),
              ),
              _summaryRow("LOGISTICS", "PRIVATE COURIER"),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 1000.ms);
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 5, fontWeight: FontWeight.bold)
        ),
        Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: 2)
        ),
      ],
    );
  }

  Widget _buildReturnAction() {
    return GestureDetector(
      // CRITICAL FIX: Route back to the MainWrapper (Splash -> Wrapper logic) instead of standalone Home
      onTap: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.splash, (route) => false),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 22),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.02),
          border: Border.all(color: luxuryGold.withOpacity(0.6), width: 0.5),
        ),
        child: Text(
            "RETURN TO STUDIO",
            style: TextStyle(color: luxuryGold, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 6)
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 1400.ms);
  }
}

/// A simple painter to simulate floating ambient dust particles
class _DustPainter extends CustomPainter {
  final Color color;
  _DustPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    // Drawing a few static dots to simulate catching the light
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.3), 1.5, paint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.5), 1.0, paint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.8), 2.0, paint);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.7), 1.2, paint);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.2), 1.8, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}