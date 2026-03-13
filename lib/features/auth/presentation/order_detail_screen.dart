import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// CRITICAL FIX: Ensure this imports the updated 'PurchaseRecord' model we built
import '../domain/purchase_model.dart';

/// THE ACQUISITION LEDGER (ORDER DETAIL)
/// Engineered as a highly secure, spatial glassmorphic invoice interface.
class OrderDetailScreen extends StatelessWidget {
  // FIXED: Changed from Purchase to PurchaseRecord
  final PurchaseRecord purchase;

  const OrderDetailScreen({super.key, required this.purchase});

  final Color luxuryGold = const Color(0xFFD4AF37);

  // Function to simulate secure PDF generation
  void _generateInvoice(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(color: luxuryGold.withValues(alpha: 0.5), width: 0.5),
              ),
              child: const Text(
                "PREPARING SECURE LEGACY INVOICE...",
                style: TextStyle(color: Colors.white, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Crucial for spatial depth
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 1. Cinematic 3D Background
          _buildAmbientBackground(),

          // 2. Main Ledger Interface
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildHeader(context),
                const SizedBox(height: 40),

                // Frosted Glass Invoice Details
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: _buildLedgerTerminal(),
                  ),
                ),
              ],
            ),
          ),

          // 3. Floating Action Bar
          _buildBottomActionPanel(context),
        ],
      ),
    );
  }

  Widget _buildAmbientBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.4),
            radius: 1.5,
            colors: [
              luxuryGold.withValues(alpha: 0.12),
              Colors.black,
            ],
          ),
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 8.seconds),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 14),
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("ARCHIVE RECORD", style: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 6, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              // FIXED: Changed purchase.id to purchase.orderId
              Text(purchase.orderId.toUpperCase(), style: TextStyle(color: luxuryGold, fontSize: 14, letterSpacing: 4, fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildLedgerTerminal() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0), // High-fashion square edges
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          padding: const EdgeInsets.all(35),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 0.5),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 40, spreadRadius: 10)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FIXED: Changed purchase.title to purchase.productName
              Text(
                purchase.productName.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2, fontWeight: FontWeight.w100),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: luxuryGold.withValues(alpha: 0.1),
                  border: Border.all(color: luxuryGold.withValues(alpha: 0.5), width: 0.5),
                ),
                child: Text(
                  "STATUS: ${purchase.status}",
                  style: TextStyle(color: luxuryGold, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 35),
                child: Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
              ),
              // FIXED: Changed purchase.totalAmount to purchase.amountPaid
              _buildDetailRow("ACQUISITION VALUE", "\$${purchase.amountPaid.toStringAsFixed(2)}", isGold: true),
              const SizedBox(height: 25),
              // FIXED: Changed purchase.date to purchase.purchaseDate
              _buildDetailRow("DATE SECURED", "${purchase.purchaseDate.day.toString().padLeft(2, '0')}/${purchase.purchaseDate.month.toString().padLeft(2, '0')}/${purchase.purchaseDate.year}"),
              const SizedBox(height: 25),
              _buildDetailRow("AUTHENTICATION", "VERIFIED"),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildDetailRow(String label, String value, {bool isGold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.bold)),
        Text(
            value,
            style: TextStyle(
                color: isGold ? luxuryGold : Colors.white70,
                fontSize: isGold ? 16 : 10,
                letterSpacing: 2,
                fontWeight: isGold ? FontWeight.w300 : FontWeight.w600
            )
        ),
      ],
    );
  }

  Widget _buildBottomActionPanel(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 45), // Extra padding for iOS home bar
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
            ),
            child: GestureDetector(
              onTap: () => _generateInvoice(context),
              child: Container(
                width: double.infinity,
                height: 65,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: luxuryGold, width: 0.5),
                    boxShadow: [
                      BoxShadow(color: luxuryGold.withValues(alpha: 0.05), blurRadius: 20, spreadRadius: 2)
                    ]
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                        "DOWNLOAD LEGACY INVOICE",
                        style: TextStyle(color: luxuryGold, fontWeight: FontWeight.w900, letterSpacing: 5, fontSize: 9)
                    ),
                    // Sweeping light effect
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white.withValues(alpha: 0.0), Colors.white.withValues(alpha: 0.2), Colors.white.withValues(alpha: 0.0)],
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
            ),
          ),
        ),
      ),
    ).animate().slideY(begin: 1.0, end: 0.0, duration: 800.ms, delay: 400.ms, curve: Curves.easeOutQuart);
  }
}