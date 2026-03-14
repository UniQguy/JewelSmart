import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // CRITICAL: Added for Haptic Feedback
import 'package:flutter_animate/flutter_animate.dart';

import '../domain/purchase_model.dart';

/// THE CERTIFICATE OF AUTHENTICITY (ORDER DETAIL)
/// Engineered as a highly secure, spatial glassmorphic authenticity document.
/// FIXED: Web Scaling, INR (₹) Currency, and Haptic Physics applied.
class OrderDetailScreen extends StatelessWidget {
  final PurchaseRecord purchase;

  const OrderDetailScreen({super.key, required this.purchase});

  final Color luxuryGold = const Color(0xFFD4AF37);

  // Function to simulate secure PDF generation/download
  void _generateInvoice(BuildContext context) {
    HapticFeedback.mediumImpact(); // Tactile confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600), // Web Scaler for Notifications
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    border: Border.all(color: luxuryGold.withValues(alpha: 0.5), width: 0.5),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 15, height: 15,
                        child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1.5),
                      ),
                      const SizedBox(width: 15),
                      const Text(
                        "MINTING SECURE LEGACY DOCUMENT...",
                        style: TextStyle(color: Colors.white, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.bold),
                      ),
                    ],
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
    return Scaffold(
      backgroundColor: Colors.black, // Deep spatial foundation
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 1. Cinematic 3D Background
          _buildAmbientBackground(),

          // 2. Main Ledger Interface
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildHeader(context),
                const SizedBox(height: 30),

                // 3. The Certificate of Authenticity (Web Scaled)
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800), // Magazine Column Layout
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 120),
                        child: _buildCertificateTerminal(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 4. Floating Action Bar
          _buildBottomActionPanel(context),
        ],
      ),
    );
  }

  Widget _buildAmbientBackground() {
    return Positioned.fill(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.2),
                radius: 1.5,
                colors: [
                  luxuryGold.withValues(alpha: 0.12),
                  Colors.black,
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 8.seconds),

          // Subtle Cryptographic Watermark
          Center(
            child: Icon(Icons.diamond_outlined, color: Colors.white.withValues(alpha: 0.01), size: 400),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800), // Align header with document
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 14),
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      Navigator.maybePop(context);
                    },
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
                  Text("DOCUMENT VIEW", style: TextStyle(color: luxuryGold, fontSize: 14, letterSpacing: 4, fontWeight: FontWeight.w900)),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildCertificateTerminal() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          padding: const EdgeInsets.all(3), // Outer border spacing
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            border: Border.all(color: luxuryGold.withValues(alpha: 0.3), width: 0.5),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 40, spreadRadius: 10)
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(35),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 0.5), // Inner Certificate Border
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Digital Gold Seal
                _buildDigitalSeal(),
                const SizedBox(height: 30),

                // 2. Certificate Title
                Text(
                  "CERTIFICATE OF\nAUTHENTICITY",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: luxuryGold, fontSize: 14, letterSpacing: 8, fontWeight: FontWeight.w900, height: 1.5),
                ),
                const SizedBox(height: 15),
                Text(
                  "PROVENANCE: SECURED VAULT",
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 7, letterSpacing: 6, fontWeight: FontWeight.bold),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  child: Divider(color: luxuryGold.withValues(alpha: 0.2), height: 1),
                ),

                // 3. The Artifact
                Text(
                  "SECURED ARTIFACT",
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 7, letterSpacing: 6, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Text(
                  purchase.productName.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 3, fontWeight: FontWeight.w100, height: 1.2),
                ),
                const SizedBox(height: 30),

                // 4. Verification Data
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
                  ),
                  child: Column(
                    children: [
                      // FIXED: Displaying INR instead of Dollars
                      _buildDetailRow("ACQUISITION VALUE", "₹${purchase.amountPaid.toStringAsFixed(2)}", isGold: true),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
                      ),
                      _buildDetailRow("DATE SEALED", "${purchase.purchaseDate.day.toString().padLeft(2, '0')}/${purchase.purchaseDate.month.toString().padLeft(2, '0')}/${purchase.purchaseDate.year}"),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
                      ),
                      _buildDetailRow("ASSET STATUS", purchase.status.toUpperCase()),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 5. Cryptographic Block
                _buildCryptographicBlock(),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildDigitalSeal() {
    return Container(
      width: 70, height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: luxuryGold.withValues(alpha: 0.5), width: 1),
        gradient: RadialGradient(
          colors: [
            luxuryGold.withValues(alpha: 0.2),
            Colors.transparent,
          ],
        ),
        boxShadow: [
          BoxShadow(color: luxuryGold.withValues(alpha: 0.1), blurRadius: 20, spreadRadius: 5)
        ],
      ),
      child: Center(
        child: Icon(Icons.verified_user_outlined, color: luxuryGold, size: 28)
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .shimmer(duration: 3.seconds, color: Colors.white),
      ),
    );
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
                fontSize: isGold ? 14 : 10,
                letterSpacing: 2,
                fontWeight: isGold ? FontWeight.w300 : FontWeight.w600
            )
        ),
      ],
    );
  }

  Widget _buildCryptographicBlock() {
    return Column(
      children: [
        Icon(Icons.qr_code_2_rounded, color: Colors.white.withValues(alpha: 0.1), size: 50),
        const SizedBox(height: 15),
        Text("CRYPTOGRAPHIC HASH ID", style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 6, letterSpacing: 4, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(
          purchase.orderId.toUpperCase(),
          style: const TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 2, fontFamily: 'monospace'),
        ),
      ],
    );
  }

  Widget _buildBottomActionPanel(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800), // Web Scaler Constraint
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
                            "DOWNLOAD DIGITAL CERTIFICATE",
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
        ),
      ),
    ).animate().slideY(begin: 1.0, end: 0.0, duration: 800.ms, delay: 400.ms, curve: Curves.easeOutQuart);
  }
}