import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/router/app_routes.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final Color luxuryGold = const Color(0xFFD4AF37);
  bool _isProcessing = false;

  void _handlePayment() async {
    setState(() => _isProcessing = true);

    // Simulating Payment Gateway processing [cite: 69]
    await Future.delayed(const Duration(seconds: 4));

    if (mounted) {
      // Navigates to Success Page which triggers "Generate Invoice" [cite: 68]
      Navigator.pushReplacementNamed(context, AppRoutes.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. DYNAMIC SECURITY OVERLAY
          _buildSecurityBackground(),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  _buildHeader(),
                  const Spacer(),
                  _buildPaymentSummary(),
                  const SizedBox(height: 50),
                  _buildActionButton(),
                  const SizedBox(height: 50),
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
      child: Opacity(
        opacity: 0.1,
        child: Image.asset('assets/images/login_bg.jpg', fit: BoxFit.cover)
            .animate(onPlay: (c) => c.repeat())
            .shimmer(duration: 3.seconds, color: luxuryGold),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(height: 30),
        Text("SECURE\nACQUISITION", // International brand terminology
            style: TextStyle(color: luxuryGold, fontSize: 42, fontWeight: FontWeight.w100, height: 1.0, letterSpacing: -2)),
      ],
    );
  }

  Widget _buildPaymentSummary() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          _summaryRow("ESTATE TOTAL", "\$12,500"),
          const SizedBox(height: 15),
          _summaryRow("INSURANCE & TAX", "\$1,250"), // Reflects "Calculate Price" logic [cite: 52]
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: Colors.white10),
          ),
          _summaryRow("FINAL AMOUNT", "\$13,750", isTotal: true),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 3)),
        Text(value, style: TextStyle(
            color: isTotal ? luxuryGold : Colors.white,
            fontSize: isTotal ? 24 : 14,
            fontWeight: isTotal ? FontWeight.w100 : FontWeight.bold
        )),
      ],
    );
  }

  Widget _buildActionButton() {
    return GestureDetector(
      onTap: _handlePayment,
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: luxuryGold,
          boxShadow: [BoxShadow(color: luxuryGold.withOpacity(0.2), blurRadius: 40)],
        ),
        child: const Center(
          child: Text("AUTHENTICATE & PURCHASE",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 4, fontSize: 11)),
        ),
      ),
    );
  }

  Widget _buildProcessingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.9),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1),
            ).animate(onPlay: (c) => c.repeat()).rotate(duration: 2.seconds),
            const SizedBox(height: 40),
            Text("CONNECTING TO BANKING VAULT...",
                style: TextStyle(color: luxuryGold, fontSize: 9, letterSpacing: 5, fontWeight: FontWeight.w300)),
          ],
        ),
      ),
    );
  }
}