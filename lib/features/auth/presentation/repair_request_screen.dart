import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// THE CARE & RESTORATION REQUEST
/// Customer-facing interface to submit artifacts for maintenance or repair.
class RepairRequestScreen extends StatefulWidget {
  const RepairRequestScreen({super.key});

  @override
  State<RepairRequestScreen> createState() => _RepairRequestScreenState();
}

class _RepairRequestScreenState extends State<RepairRequestScreen> {
  final Color luxuryGold = const Color(0xFFD4AF37);

  final TextEditingController _artifactController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _artifactController.dispose();
    _issueController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (_artifactController.text.trim().isEmpty || _issueController.text.trim().isEmpty) {
      _showNotification("PLEASE COMPLETE ALL FIELDS", isError: true);
      return;
    }

    setState(() => _isSubmitting = true);
    HapticFeedback.heavyImpact();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("UNAUTHORIZED VAULT ACCESS");

      // Fetch the actual user name
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final userName = userDoc.exists ? (userDoc.data()?['name'] ?? 'VIP CLIENT') : 'VIP CLIENT';

      // Push to the master Repairs ledger
      await FirebaseFirestore.instance.collection('repairs').add({
        'userId': user.uid,
        'customerName': userName,
        'itemDescription': _artifactController.text.trim(),
        'issue': _issueController.text.trim(),
        'status': 'PENDING',
        'estimatedCost': 0.0,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        _showNotification("RESTORATION PROTOCOL INITIATED", isError: false);
        Navigator.pop(context); // Return to profile
      }
    } catch (e) {
      debugPrint("Repair Request Failed: $e");
      if (mounted) _showNotification("TRANSMISSION FAILED. TRY AGAIN.", isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
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
                    color: isError ? Colors.redAccent.withValues(alpha: 0.1) : luxuryGold.withValues(alpha: 0.1),
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
          _buildAmbientBackground(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("INITIATE PROTOCOL", style: TextStyle(color: Colors.white24, fontSize: 8, letterSpacing: 8, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text("ATELIER CARE", style: TextStyle(color: luxuryGold, fontSize: 24, letterSpacing: 4, fontWeight: FontWeight.w100)),
                      const SizedBox(height: 40),

                      _buildInputField("ARTIFACT DESCRIPTION", "e.g., 2026 Emerald Ring", _artifactController, 1),
                      const SizedBox(height: 30),
                      _buildInputField("RESTORATION REQUIRED", "Describe the damage or care needed...", _issueController, 4),

                      const SizedBox(height: 60),

                      _buildSubmitButton(),
                    ],
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, end: 0),
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 14),
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.maybePop(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmbientBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.6),
            radius: 1.5,
            colors: [luxuryGold.withValues(alpha: 0.08), Colors.black],
          ),
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 8.seconds),
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController controller, int maxLines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 8, letterSpacing: 4, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              style: const TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.w300),
              cursorColor: luxuryGold,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 10, letterSpacing: 2),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.02),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 0.5)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: luxuryGold, width: 1)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: luxuryGold, width: 0.5),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          backgroundColor: luxuryGold.withValues(alpha: 0.05),
        ),
        onPressed: _isSubmitting ? null : _submitRequest,
        child: _isSubmitting
            ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: luxuryGold, strokeWidth: 1.5))
            : const Text("SUBMIT TO ATELIER", style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 6, fontWeight: FontWeight.bold)),
      ),
    );
  }
}