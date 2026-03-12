import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/router/app_routes.dart';
import '../providers/cart_provider.dart';

/// THE SECURITY PROTOCOL (CHECKOUT)
/// Redefined as a high-caliber authentication and payment interface.
class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final Color luxuryGold = const Color(0xFFD4AF37);
  bool _isProcessing = false;

  void _handlePayment() async {
    setState(() => _isProcessing = true);

    // World-Class Security Simulation: Bio-metric & Gateway check
    await Future.delayed(const Duration(seconds: 4));

    if (mounted) {
      // Transition to Success Page triggers the final Root Document update
      Navigator.pushReplacementNamed(context, AppRoutes.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = ref.watch(cartTotalProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildSecurityBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  _buildBackButton(),
                  const SizedBox(height: 60),
                  _buildBrandHeroText(),
                  const SizedBox(height: 80),
                  _buildSummaryLedger(totalAmount),
                  const Spacer(),
                  _buildSecureAction(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          if (_isProcessing) _buildProcessingOverlay(),
        ],
      ),
    );
  }

  Widget _buildSecurityBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              luxuryGold.withValues(alpha: 0.05),
              Colors.black,
            ],
          ),
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 10.seconds),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _buildBrandHeroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("SECURITY PROTOCOL",
            style: TextStyle(color: Colors.white24, fontSize: 9, letterSpacing: 6, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Text("FINALIZE THE\nACQUISITION",
            style: TextStyle(color: luxuryGold, fontSize: 44, fontWeight: FontWeight.w100, height: 1.0, letterSpacing: -2)),
      ],
    ).animate().fadeIn(duration: 800.ms);
  }

  Widget _buildSummaryLedger(double total) {
    return Column(
      children: [
        _ledgerRow("ACQUISITION VALUE", "\$${total.toStringAsFixed(2)}"),
        const SizedBox(height: 20),
        _ledgerRow("SECURITY & INSURANCE", "INCLUDED"),
        const SizedBox(height: 20),
        _ledgerRow("BOUTIQUE DELIVERY", "INCLUDED"),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Divider(color: Colors.white10),
        ),
        _ledgerRow("TOTAL SECURED", "\$${total.toStringAsFixed(2)}", isGold: true),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _ledgerRow(String label, String value, {bool isGold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 4)),
        Text(value, style: TextStyle(
            color: isGold ? luxuryGold : Colors.white70,
            fontSize: isGold ? 22 : 12,
            fontWeight: isGold ? FontWeight.w100 : FontWeight.w300,
            letterSpacing: 1
        )),
      ],
    );
  }

  Widget _buildSecureAction() {
    return GestureDetector(
      onTap: _handlePayment,
      child: Container(
        width: double.infinity,
        height: 70,
        color: luxuryGold,
        child: const Center(
          child: Text("AUTHENTICATE & PURCHASE",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 5, fontSize: 11)),
        ),
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildProcessingOverlay() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
      child: Container(
        color: Colors.black.withValues(alpha: 0.9),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1),
              ).animate(onPlay: (c) => c.repeat()).rotate(duration: 4.seconds),
              const SizedBox(height: 40),
              const Text("VERIFYING SECURE PAYMENT GATEWAY",
                  style: TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 5, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
      ),
    );
  }
}