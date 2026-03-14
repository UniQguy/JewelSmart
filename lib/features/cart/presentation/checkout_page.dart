import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/router/app_routes.dart';
import '../providers/cart_provider.dart';

/// THE SECURITY PROTOCOL (CHECKOUT)
/// Engineered as a high-caliber authentication interface with biometric-style 3D processing.
/// FULLY WIRED: Writes directly to Firestore and clears the local Cart.
class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> with TickerProviderStateMixin {
  final Color luxuryGold = const Color(0xFFD4AF37);
  bool _isProcessing = false;
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  // CRITICAL FIX: The Phantom Checkout Bug is resolved.
  // This function now securely transacts with the live Firestore database.
  Future<void> _handlePayment() async {
    final cartItems = ref.read(cartProvider);
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (cartItems.isEmpty || userId == null) {
      _showErrorNotification("VAULT IS EMPTY OR IDENTITY UNVERIFIED");
      return;
    }

    HapticFeedback.heavyImpact(); // Tactile authorization
    setState(() => _isProcessing = true);
    _scanController.repeat(reverse: true);

    try {
      // 1. Initialize a Firestore Batch to process the entire cart securely
      final batch = FirebaseFirestore.instance.batch();

      for (var item in cartItems) {
        final docRef = FirebaseFirestore.instance.collection('purchases').doc();

        // Exact Indian Market Math: Calculate the final price including the 3% GST
        final double itemBaseTotal = item.product.totalPayableAmount * item.quantity;
        final double itemFinalTotal = itemBaseTotal + (itemBaseTotal * 0.03);

        batch.set(docRef, {
          'userId': userId,
          'productId': item.product.id,
          'productName': item.product.title, // Exact map to the Admin/Staff dashboards
          'quantity': item.quantity,
          'amountPaid': itemFinalTotal,      // The exact Rupee value processed
          'status': 'PROCESSING',            // Initial Logistics State
          'purchaseDate': FieldValue.serverTimestamp(),
        });
      }

      // 2. Commit the payload to the Cloud Matrix
      await batch.commit();

      // 3. Clear the Cart securely using the Riverpod Provider
      ref.read(cartProvider.notifier).clearCart();

      // 4. Immersive Security Delay (UX)
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        _scanController.stop();
        HapticFeedback.lightImpact();
        Navigator.pushReplacementNamed(context, AppRoutes.success);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        _scanController.stop();
        _showErrorNotification("SECURE GATEWAY REJECTED. TRY AGAIN.");
      }
    }
  }

  void _showErrorNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5), width: 0.5),
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = ref.watch(cartTotalProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Deep Spatial Background
          _buildSecurityBackground(),

          // 2. Main Interface (Web Scaled)
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildBackButton(),
                      const SizedBox(height: 40),
                      _buildBrandHeroText(),
                      const SizedBox(height: 60),
                      _buildSummaryLedger(totalAmount),
                      const SizedBox(height: 60),
                      _buildSecureAction(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 3. Cinematic Processing Overlay
          if (_isProcessing) _buildProcessingOverlay(),
        ],
      ),
    );
  }

  Widget _buildSecurityBackground() {
    return Positioned.fill(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.3),
                radius: 1.2,
                colors: [
                  luxuryGold.withValues(alpha: 0.08),
                  Colors.black,
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 8.seconds),

          // Faint security grid
          CustomPaint(
            size: Size.infinite,
            painter: _SecurityGridPainter(color: Colors.white.withValues(alpha: 0.02)),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 14),
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.pop(context);
          },
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            padding: const EdgeInsets.all(16),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildBrandHeroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
            "SECURITY PROTOCOL",
            style: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 8, fontWeight: FontWeight.w900)
        ),
        const SizedBox(height: 20),
        Text(
            "FINALIZE THE\nACQUISITION",
            style: TextStyle(
                color: luxuryGold,
                fontSize: 42,
                fontWeight: FontWeight.w100,
                height: 1.1,
                letterSpacing: -1,
                shadows: [Shadow(color: luxuryGold.withValues(alpha: 0.2), blurRadius: 20)]
            )
        ),
      ],
    ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.1, end: 0);
  }

  // Real Indian Tax Logic (3% GST) + Rupee Currency
  Widget _buildSummaryLedger(double total) {
    final double gstAmount = total * 0.03;
    final double finalAmount = total + gstAmount;

    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(35),
          decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 30, spreadRadius: 10)
              ]
          ),
          child: Column(
            children: [
              _ledgerRow("ACQUISITION VALUE", "₹${total.toStringAsFixed(2)}"),
              const SizedBox(height: 25),
              _ledgerRow("ESTIMATED GST (3%)", "₹${gstAmount.toStringAsFixed(2)}"),
              const SizedBox(height: 25),
              _ledgerRow("SECURITY & INSURANCE", "INCLUDED"),
              const SizedBox(height: 25),
              _ledgerRow("BOUTIQUE DELIVERY", "INCLUDED"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 35),
                child: Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
              ),
              _ledgerRow("TOTAL SECURED", "₹${finalAmount.toStringAsFixed(2)}", isGold: true),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _ledgerRow(String label, String value, {bool isGold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            label,
            style: TextStyle(color: isGold ? Colors.white60 : Colors.white38, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.bold)
        ),
        Text(
            value,
            style: TextStyle(
                color: isGold ? luxuryGold : Colors.white,
                fontSize: isGold ? 24 : 12,
                fontWeight: isGold ? FontWeight.w300 : FontWeight.w500,
                letterSpacing: 2
            )
        ),
      ],
    );
  }

  Widget _buildSecureAction() {
    return GestureDetector(
      onTap: _handlePayment,
      child: Container(
        width: double.infinity,
        height: 75,
        decoration: BoxDecoration(
            color: luxuryGold.withValues(alpha: 0.9),
            border: Border.all(color: luxuryGold, width: 1),
            boxShadow: [
              BoxShadow(color: luxuryGold.withValues(alpha: 0.15), blurRadius: 30, spreadRadius: 5)
            ]
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Text(
                "AUTHENTICATE & PURCHASE",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 5, fontSize: 10)
            ),
            // Sweeping light effect across the button
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white.withValues(alpha: 0.0), Colors.white.withValues(alpha: 0.4), Colors.white.withValues(alpha: 0.0)],
                    stops: const [0.0, 0.5, 1.0],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: false))
                  .slideX(begin: -2.0, end: 2.0, duration: 3.seconds, curve: Curves.easeInOutSine),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 600.ms);
  }

  Widget _buildProcessingOverlay() {
    return Positioned.fill(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30 * value, sigmaY: 30 * value),
            child: Container(
              color: Colors.black.withValues(alpha: 0.85 * value),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Biometric / Radar Scan Simulation
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: luxuryGold.withValues(alpha: 0.2), width: 1),
                            ),
                          ),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: luxuryGold.withValues(alpha: 0.5), width: 0.5),
                            ),
                          ),
                          Icon(Icons.fingerprint_rounded, color: luxuryGold.withValues(alpha: 0.8), size: 40)
                              .animate(onPlay: (c) => c.repeat(reverse: true))
                              .shimmer(duration: 2.seconds, color: Colors.white),

                          // Rotating Scanning Ring
                          AnimatedBuilder(
                            animation: _scanController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _scanController.value * 2 * 3.14159,
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border(
                                      top: BorderSide(color: luxuryGold, width: 2),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Text(
                        "VERIFYING SECURE\nPAYMENT GATEWAY",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white60, fontSize: 9, letterSpacing: 6, fontWeight: FontWeight.w900, height: 1.5)
                    ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 1.seconds),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Custom Painter to draw a faint security grid in the background
class _SecurityGridPainter extends CustomPainter {
  final Color color;
  _SecurityGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    const double spacing = 40.0;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}