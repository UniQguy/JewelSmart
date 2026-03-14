import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // CRITICAL: Added for Haptic Feedback
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../auth/domain/purchase_model.dart';
import '../../auth/presentation/order_detail_screen.dart';

/// THE ENCRYPTED ARCHIVE (ACQUISITION HISTORY)
/// Engineered as a high-security spatial ledger for VIP clients.
/// FIXED: Web Scaling and INR (₹) Currency Applied.
class AcquisitionHistoryPage extends StatefulWidget {
  const AcquisitionHistoryPage({super.key});

  @override
  State<AcquisitionHistoryPage> createState() => _AcquisitionHistoryPageState();
}

class _AcquisitionHistoryPageState extends State<AcquisitionHistoryPage> with TickerProviderStateMixin {
  final Color luxuryGold = const Color(0xFFD4AF37);
  late AnimationController _ambientController;

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Connects to the live Firestore Database for the current user
    final currentUser = FirebaseAuth.instance.currentUser;
    final archiveStream = currentUser != null
        ? FirebaseFirestore.instance
        .collection('purchases')
        .where('userId', isEqualTo: currentUser.uid)
        .orderBy('purchaseDate', descending: true)
        .snapshots()
        : const Stream.empty();

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _buildSecurityAppBar(context),
      body: Stack(
        children: [
          // 1. Deep Spatial Security Grid
          _buildAmbientSecurityBackground(),

          // 2. The Live Data Ledger (Web Scaled)
          SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800), // Web Scaler
                child: StreamBuilder<QuerySnapshot>(
                  stream: archiveStream as Stream<QuerySnapshot>?,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildProcessingState();
                    }

                    if (snapshot.hasError) {
                      return _buildErrorState();
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return _buildEmptyVault();
                    }

                    // Map live Firestore documents to the PurchaseRecord model
                    final history = snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return PurchaseRecord(
                        orderId: doc.id,
                        productName: data['productName'] ?? 'UNKNOWN ARTIFACT',
                        status: data['status'] ?? 'PROCESSING',
                        purchaseDate: (data['purchaseDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
                        amountPaid: (data['amountPaid'] ?? 0.0).toDouble(),
                      );
                    }).toList();

                    return _buildAnimatedLedger(history);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildSecurityAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(90),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: AppBar(
            backgroundColor: Colors.black.withValues(alpha: 0.6),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 14),
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.maybePop(context); // Safe routing
              },
            ),
            title: Column(
              children: [
                Text(
                  "THE ARCHIVE",
                  style: TextStyle(color: luxuryGold, fontSize: 11, letterSpacing: 10, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 2),
                Text(
                  "ENCRYPTED LEDGER",
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 6, letterSpacing: 6, fontWeight: FontWeight.bold),
                ),
              ],
            ).animate().fadeIn(duration: 800.ms),
          ),
        ),
      ),
    );
  }

  Widget _buildAmbientSecurityBackground() {
    return Positioned.fill(
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _ambientController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_ambientController.value * 0.1),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.6),
                      radius: 1.5,
                      colors: [
                        luxuryGold.withValues(alpha: 0.05),
                        Colors.black,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // Subtle tech grid to imply a secure digital vault
          CustomPaint(
            size: Size.infinite,
            painter: _ArchiveGridPainter(color: Colors.white.withValues(alpha: 0.01)),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50, height: 50,
            child: CircularProgressIndicator(color: luxuryGold.withValues(alpha: 0.5), strokeWidth: 1),
          ).animate(onPlay: (c) => c.repeat()).rotate(duration: 2.seconds),
          const SizedBox(height: 30),
          const Text(
            "DECRYPTING LEDGER...",
            style: TextStyle(color: Colors.white38, letterSpacing: 6, fontSize: 8, fontWeight: FontWeight.bold),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 1.seconds),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.gpp_bad_outlined, color: Colors.redAccent.withValues(alpha: 0.5), size: 50),
          const SizedBox(height: 20),
          const Text(
            "SECURITY CLEARANCE FAILED",
            style: TextStyle(color: Colors.redAccent, letterSpacing: 4, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyVault() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: luxuryGold.withValues(alpha: 0.2), width: 0.5),
                ),
              ).animate(onPlay: (c) => c.repeat()).rotate(duration: 8.seconds),
              Icon(Icons.diamond_outlined, color: luxuryGold.withValues(alpha: 0.4), size: 40)
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 2.seconds),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            "NO ACQUISITIONS FOUND",
            style: TextStyle(color: Colors.white38, letterSpacing: 8, fontSize: 9, fontWeight: FontWeight.w900),
          ).animate().fadeIn(duration: 1.seconds),
        ],
      ),
    );
  }

  Widget _buildAnimatedLedger(List<PurchaseRecord> history) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(25, 30, 25, 100),
        physics: const BouncingScrollPhysics(),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 800),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildLedgerCard(context, item),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLedgerCard(BuildContext context, PurchaseRecord item) {
    // Determines styling based on order status
    final isSecured = item.status.toUpperCase() == 'SECURED' || item.status.toUpperCase() == 'DELIVERED';
    final statusColor = isSecured ? luxuryGold : Colors.white54;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailScreen(purchase: item)));
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        child: Stack(
          children: [
            // The Glassmorphic Base
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.02),
                    border: Border(
                      top: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
                      right: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
                      bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
                      left: BorderSide(color: statusColor.withValues(alpha: 0.8), width: 2),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 5)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: Status and Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 6, height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: statusColor,
                                  boxShadow: [BoxShadow(color: statusColor.withValues(alpha: 0.5), blurRadius: 5)],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(item.status.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 4)),
                            ],
                          ),
                          Text(
                            item.purchaseDate.toString().substring(0, 10),
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 8, letterSpacing: 2),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
                      ),

                      // Item Details
                      Text(
                        item.productName.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 3, fontWeight: FontWeight.w200),
                      ),
                      const SizedBox(height: 15),

                      // Footer Row: Hash ID and Value
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("HASH ID", style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 6, letterSpacing: 2, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(
                                item.orderId.toUpperCase(),
                                style: const TextStyle(color: Colors.white60, fontSize: 9, letterSpacing: 1, fontFamily: 'monospace'), // Monospace for technical feel
                              ),
                            ],
                          ),
                          // FIXED: INR Currency
                          Text(
                            "₹${item.amountPaid.toStringAsFixed(2)}",
                            style: TextStyle(color: luxuryGold, fontSize: 16, fontWeight: FontWeight.w300, letterSpacing: 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Draws a subtle, high-tech security grid in the background
class _ArchiveGridPainter extends CustomPainter {
  final Color color;
  _ArchiveGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    const double spacing = 50.0;

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