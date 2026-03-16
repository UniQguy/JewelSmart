import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:printing/printing.dart'; // NEW: For displaying the PDF

import '../../auth/data/invoice_service.dart';

/// THE INVOICE GENERATOR TERMINAL
/// Engineered for Staff to mint official financial PDF records for secured artifacts.
class GenerateInvoiceScreen extends StatefulWidget {
  const GenerateInvoiceScreen({super.key});

  @override
  State<GenerateInvoiceScreen> createState() => _GenerateInvoiceScreenState();
}

class _GenerateInvoiceScreenState extends State<GenerateInvoiceScreen> {
  final Color luxuryGold = const Color(0xFFD4AF37);
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _mintInvoice(String orderId, String userId, num amountPaid, String artifactName) async {
    HapticFeedback.mediumImpact();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildProcessingOverlay(),
    );

    try {
      // 1. Call the Engine to generate the actual PDF bytes
      final pdfBytes = await InvoiceService.generateInvoiceDocument(
        orderId: orderId,
        userId: userId,
        artifactName: artifactName,
        baseTotal: amountPaid.toDouble(),
      );

      // 2. Update the correct 'orders' collection
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'invoiceGenerated': true,
      });

      if (mounted) {
        Navigator.pop(context); // Remove overlay

        // 3. Open the Native PDF Viewer / Print Dialog
        await Printing.layoutPdf(
          onLayout: (format) async => pdfBytes,
          name: 'JewelSmart_Invoice_$orderId.pdf',
        );

        _showNotification("OFFICIAL INVOICE MINTED & READY", isError: false);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Remove overlay
        debugPrint("Minting Error: $e");
        _showNotification("MINTING FAILED. CHECK LOGS.", isError: true);
      }
    }
  }

  void _showNotification(String message, {required bool isError}) {
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
                    color: isError ? Colors.redAccent.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
                    border: Border.all(color: isError ? Colors.redAccent.withValues(alpha: 0.5) : luxuryGold.withValues(alpha: 0.5), width: 0.5),
                  ),
                  child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.bold)),
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
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _buildLiquidAppBar(context),
      body: Stack(
        children: [
          _buildAmbientGlow(),
          SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLiquidSearchBar(),
                    Expanded(child: _buildPendingInvoiceStream()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildLiquidAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(90),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: AppBar(
            backgroundColor: Colors.black.withValues(alpha: 0.5),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 14),
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.maybePop(context);
              },
            ),
            title: Text('FINANCIAL RECORDS', style: TextStyle(color: luxuryGold, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 10)),
          ),
        ),
      ),
    );
  }

  Widget _buildAmbientGlow() {
    return Positioned(
      top: -50,
      left: -100,
      child: Container(
        width: 400, height: 400,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: luxuryGold.withValues(alpha: 0.03),
          boxShadow: [BoxShadow(color: luxuryGold.withValues(alpha: 0.05), blurRadius: 120, spreadRadius: 40)],
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 8.seconds),
    );
  }

  Widget _buildLiquidSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 0.5),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
              style: const TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.w300),
              cursorColor: luxuryGold,
              decoration: InputDecoration(
                hintText: "SEARCH HASH IDs OR ARTIFACTS...",
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 9, letterSpacing: 5, fontWeight: FontWeight.bold),
                prefixIcon: Icon(Icons.search_rounded, color: luxuryGold.withValues(alpha: 0.6), size: 18),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
        ),
      ),
    ).animate().slideY(begin: -0.2, end: 0, duration: 600.ms, curve: Curves.easeOutQuart);
  }

  Widget _buildPendingInvoiceStream() {
    return StreamBuilder<QuerySnapshot>(
      // FIXED: Changed 'purchases' to 'orders' to match the database schema
      stream: FirebaseFirestore.instance.collection('orders')
          .where('status', isEqualTo: 'SECURED')
          .where('invoiceGenerated', isEqualTo: null)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1.5));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("NO PENDING INVOICES", style: TextStyle(color: Colors.white38, letterSpacing: 6, fontSize: 8)));
        }

        final orders = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final artifactName = (data['productName'] ?? data['title'] ?? '').toString().toLowerCase();
          final hashId = doc.id.toLowerCase();
          return artifactName.contains(_searchQuery) || hashId.contains(_searchQuery);
        }).toList();

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 100),
            physics: const BouncingScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final doc = orders[index];
              final data = doc.data() as Map<String, dynamic>;

              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 600),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: _buildInvoiceTile(doc.id, data),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildInvoiceTile(String orderId, Map<String, dynamic> data) {
    // Looked for 'title' as a fallback based on your database screenshot
    final artifactName = data['productName'] ?? data['title'] ?? 'UNKNOWN ARTIFACT';
    final amountPaid = (data['amountPaid'] ?? data['totalAmount'] ?? 0.0) as num;
    final userId = data['userId'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 5)],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("SECURED ASSET", style: TextStyle(color: luxuryGold, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 4)),
                    const Icon(Icons.receipt_long_outlined, color: Colors.white24, size: 16),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
                ),
                Text(artifactName, style: const TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 3, fontWeight: FontWeight.w200)),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("BASE VALUE", style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 6, letterSpacing: 2, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text("₹${amountPaid.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white60, fontSize: 12, letterSpacing: 1, fontWeight: FontWeight.w300)),
                      ],
                    ),
                    GestureDetector(
                      // Pass artifactName so we can put it in the PDF
                      onTap: () => _mintInvoice(orderId, userId, amountPaid, artifactName),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: luxuryGold.withValues(alpha: 0.1),
                          border: Border.all(color: luxuryGold.withValues(alpha: 0.5), width: 0.5),
                        ),
                        child: Text("MINT INVOICE", style: TextStyle(color: luxuryGold, fontSize: 8, letterSpacing: 2, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProcessingOverlay() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.8),
            border: Border.all(color: luxuryGold.withValues(alpha: 0.3), width: 0.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 40, height: 40,
                child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1.5),
              ),
              const SizedBox(height: 30),
              Text(
                "CRYPTOGRAPHICALLY SEALING RECORD...",
                style: TextStyle(color: luxuryGold, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.bold, decoration: TextDecoration.none),
              ),
            ],
          ),
        ),
      ),
    );
  }
}